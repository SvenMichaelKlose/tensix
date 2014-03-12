/*
 * tensix operating system project
 * Copyright (C) 2002, 2003, 2004 Sven Klose <pixel@hugbox.org>
 *
 * Directory related functions
 *
 * $License$
 */

#include <types.h>
#include <array.h>
#include <dir.h>
#include <mem.h>
#include <obj.h>
#include <libc.h>
#include <namespace.h>
#include <error.h>
#include <main.h>
#include <string.h>
#include <machdep.h>
#include <iod.h>

#include <con.h>
#include <disk.h>
#include <memfs.h>
#include <wrapfs.h>

#include <obj_intern.h>

/*
 * Allocate a new directory entry and add it to the parent object's
 * dirent list.
 */
struct dirent *
dirent_alloc (struct obj *parent)
{
    struct dirent *dirent;

    OBJ_PRINTK("dirent_alloc\n", 0);

    /* Allocate dirent space. */
    dirent = POOL_SALLOC(&dirent_pool);
    ERRNULL(dirent);

    dirent->lock = 0;
    dirent->reclen = 0;
    dirent->nextrec = 0;
    dirent->size = 0;
    bzero (dirent->name, NAME_MAX);
    dirent->state = 0;

    LOCK(dirent->lock);

    /* Add directory to parent object's dirent list. */
    OBJ_ADD_DIRENT(parent, dirent);

    return dirent;
}

void
dirent_free (struct obj *obj)
{
    struct dirent *dirent = obj->dirent;
    struct obj *parent = (struct obj *) obj->parent_id;

    OBJ_PRINTK("dirent_free\n", 0);

    /* XXX: Save dirent ID in object. */

    /* Remove directory entry from local list. */
    OBJ_REMOVE_DIRENT(parent, dirent);

    /* Return dirent to pool. */
    POOL_SFREE(&dirent_pool, dirent);
}

int
obj_dir_open (struct dir *dir)
{
    OBJ_PRINTK("obj_dir_open\n", 0);

    _OBJ_CHKOP(dir->obj, dir_open);

    return OBJ_DIR_OPEN(dir);
}

int
obj_dir_read (struct dirent *dirent, struct dir *dir)
{
    OBJ_PRINTK("obj_dir_read\n", 0);

    _OBJ_CHKOP(dir->obj, dir_read);

    return OBJ_DIR_READ(dirent, dir);
}

int
obj_dir_close (struct dir *dir)
{
    OBJ_PRINTK("obj_dir_close\n", 0);

    _OBJ_CHKOP(dir->obj, dir_close);

    return OBJ_DIR_CLOSE(dir);
}
