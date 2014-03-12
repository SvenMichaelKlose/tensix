/*
 * tensix operating system project
 * Copyright (C) 2002, 2003, 2004, 2005 Sven Klose <pixel@copei.de>
 *
 * memory file system
 *
 * $License$
 */

#include <memfs.h>
#include <dir.h>
#include <namespace.h>
#include <string.h>
#include <obj.h>
#include <libc.h>
#include <dfs.h>
#include <error.h>

int
memfs_dir_open (struct dir *dir)
{
    struct dirent *first = (struct dirent *) dir->obj->dirents.first;

    if (first != NULL)
        dir->next = first;

    return ENONE;
}

int
memfs_dir (struct dir *dummy)
{
    return ENONE;
}

int
memfs_dir_read (struct dirent *dirent, struct dir *dir)
{
    struct obj     *obj;
    struct dirent  *thisde;
    struct dirent  *objde;

    thisde = (struct dirent *) dir->next;
    if (thisde == NULL)
        return ENOTFOUND;

    obj = thisde->obj;

    objde = obj->dirent;
    strcpy (dirent->name, objde->name);
    dirent->size = objde->size;

    dir->next = objde->next;
  
    return ENONE;
}

int
memfs_lookup (struct obj **ret, struct obj *dir, char *name)
{
    *ret = (struct obj *) NULL;
    return ENONE;
}

int
memfs_free (struct obj *dummy)
{
    return ENONE;
}

/*
 * File I/O
 *
 * Marks all incoming buffers as persistent.
 */
int
memfs_io (struct buf *buf, struct obj *obj, blk_t blk, bool mode)
{
    buf->state |= BUF_PERSISTENT;

    return ENONE;
}

/*
 * Create a file.
 *
 * The file object is already set up so we just need to make it persistent.
 */
int
memfs_create (struct obj *dir, struct obj *obj, int type)
{
    obj->state |= OBJ_PERSISTENT;
    return ENONE;
}

/*
 * Unlink a file.
 *
 * The file object is removed by the vfs and the persistence-flag is
 * cleared automatically. Nothing left to do.
 */
int
memfs_unlink (struct obj *parent, struct obj *child)
{
    return ENONE;
}

/*
 * Shorten or lengthen a file.
 *
 * XXX This belongs to the object component.
 */
int
memfs_truncate (struct obj *obj, fsize_t newlen_bytes)
{
    struct buf *i_buf;
    blk_t      oldlen;
    blk_t      newlen = ROUNDUP(newlen_bytes, OBJ_BLKSIZE(obj));

    oldlen = OBJ_SIZE(obj);

    /*
     * Mark all buffers beyond desired length as free.
     * File grows automatically in bcreate().
     */
    if (oldlen > newlen) {
        DEQUEUE_FOREACH(&(obj->buffers), i_buf) {
	    if (i_buf->blk >= newlen)
	        i_buf->state &= ~BUF_PERSISTENT;
        }
    }

    return ENONE;
}

#define MEMFS_SUBCLASS_DETAIL(obj) \
    ((struct memfs_subclass_detail*) OBJ_SUBCLASS(obj)->detail)

/*
 * Create subclass.
 */
int
memfs_create_subclass (struct obj *class, struct obj *obj)
{
    return ENONE;
}

struct obj_ops memfs_obj_ops = {
    memfs_io,
    memfs_create,
    memfs_unlink,
    memfs_truncate,
    memfs_dir_open,
    memfs_dir,
    memfs_dir_read,
    memfs_lookup,
    NULL, /* memfs_dup, */
    NULL, /* memfs_get_obj, */
    NULL, /* memfs_get_dirent, */
    memfs_free
};

void memfs_init (struct obj *obj)
{
    /* Set our object ops. */
    OBJ_OPS(obj) = &memfs_obj_ops;
    OBJ_BLKSIZE(obj) = PAGESIZE;
    DIRENT_SET_NAME(obj_get_dirent (obj), "memfs");
    OBJ_SET_CACHED(obj, TRUE);

    VERBOSE_BOOT_PRINTK("memfs: ok.\n", 0);
}
