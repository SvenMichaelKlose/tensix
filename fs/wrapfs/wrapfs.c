/*
 * tensix operating system project
 * Copyright (C) 2003, 2004, 2005 Sven Klose <pixel@copei.de>
 *
 * libc file system
 *
 * $License$
 */

#include <error.h>
#include <dir.h>
#include <obj.h>
#include <libc.h>
#include <string.h>
#include <wrapfs.h>
#include <mem.h>
#include <machdep.h>
#include <proc.h>

int wrapfsw_size (char *path);
int wrapfsw_io (char *path, int offset, void *data, int *len, int mode);
int wrapfsw_create (struct wrapfs_obj **ret, int id, char *path, char *name, int type);
int wrapfsw_unlink (char *path);
int wrapfsw_resize (char *path, int newlen);
int wrapfsw_dir_read (char *name, int *size, void *next);
int wrapfsw_dir_write (struct dirent *dirent, char *path);
int wrapfsw_dir_open (void *dir, char *path);
int wrapfsw_dir_close (void *dir);
void _wrapfs_make_path (char *path, struct wrapfs_obj*);
void _wrapfs_collect_dir (int id);

#define WRAPFS_METAPTR2ID(ptr) \
    (objid_t) (((size_t) ptr - (size_t) wrapfs_objects) \
    / sizeof (struct wrapfs_obj))

void
wrapfs_make_path (char **path, struct wrapfs_obj *w)
{
    while (!(*path = kmalloc (1024))) {
	MANUAL_SWITCH();
        bcleanup_glob();
    }

    _wrapfs_make_path (*path, w);
}

int
wrapfs_io (struct buf* buf, struct obj *obj, blk_t blk, bool mode)
{
    size_t offset = blk * OBJ_BLKSIZE(obj);
    char *path;
    int err;
    if (mode == IO_R)
        buf->len = OBJ_BLKSIZE(obj);

    wrapfs_make_path (&path, &wrapfs_objects[obj->id]);

    err = wrapfsw_io (path, offset, buf->data, (int *) &buf->len, mode);
    free (path);
    return err;
}

int
wrapfs_create (struct obj *dir, struct obj *obj, int type)
{
    struct wrapfs_obj *w;
    char *path;
    int err;

    /* Create path to new file. */
    wrapfs_make_path (&path, &wrapfs_objects[dir->id]);

    err = wrapfsw_create (&w, dir->id, path, obj->dirent->name, type);
    obj->id = WRAPFS_METAPTR2ID(w);
    obj->detail = (void *) w;
    OBJ_SET_PERSISTENT(obj, FALSE);
    w->obj = (void *) obj;
    free (path);
    return err;
}

int
wrapfs_unlink (struct obj *parent, struct obj *obj)
{
    char *path;
    int err;

    wrapfs_make_path (&path, &wrapfs_objects[obj->id]);
    err = wrapfsw_unlink (path);
    free (path);
    return err;
}

int
wrapfs_resize (struct obj *obj, fsize_t newlen)
{
    char *path;
    int err;

    wrapfs_make_path (&path, (struct wrapfs_obj *) obj->id);
    err = wrapfsw_resize (path, newlen);
    free (path);
    return err;
}

/*
 * Open directory.
 */
int
wrapfs_dir_open (struct dir *retdir)
{
    objid_t  id = retdir->obj->id;
    char *path;
    int    err = ENONE;

    /* Make sure the directory is in the cache. */
    _wrapfs_collect_dir (id);
    wrapfs_make_path (&path, &wrapfs_objects[id]);
    wrapfsw_dir_open (&retdir->next, path);

    free (path);
    return err;
}

/*
 * Open directory.
 */
int
wrapfs_dir_close (struct dir *dir)
{
    return wrapfsw_dir_close (&dir->next);
}

/*
 * Read first or next directory.
 */
int
wrapfs_dir_read (struct dirent *retdir, struct dir *dir)
{
    int   err;

    bzero (&retdir->name, NAME_MAX);

    /* Make sure the directory is in the cache. */
    err = wrapfsw_dir_read ((char *) &retdir->name, (int *) &retdir->size, &dir->next);
#if 0
    wrapfs_make_path (&path, &wrapfs_objects[retdir->id]);
    retdir->size = wrapfsw_size (path);
    free (path);
#endif

    return err;
}

/*
 * Lookup object in directory.
 */
int
wrapfs_lookup (struct obj **ret, struct obj* dir, char *name)
{
    struct wrapfs_obj *w;
    struct wrapfs_obj *i;
    objid_t  id;
    char *path;
    fsize_t size;

    _wrapfs_collect_dir (dir->id);

    w = &wrapfs_objects[dir->id];
    *ret = NULL;

    for (i = w->childs; i != NULL; i = i->next) {
	if (strcmp ((void *) &i->name, name) != 0)
	    continue;

        /* Reuse objects already in memory. */
        if (i->obj != NULL) {
	    *ret = (struct obj *) i->obj;
            return ENONE;
        }

        /* Get index of meta object. */
        id = WRAPFS_METAPTR2ID(i);
        *ret = obj_suballoc (dir, id, name);
        wrapfs_make_path (&path, &wrapfs_objects[id]);

        /* Set size in blocks. */
        size = wrapfsw_size (path);
        (*ret)->size = OBJ_BYTE2BLKSIZE(*ret, size);
        (*ret)->dirent->size = size;
        OBJ_SET_PERSISTENT((*ret), FALSE);
	UNLOCK((*ret)->lock);

        free (path);

        return ENONE;
    }

    return ENOTFOUND;
}

int
wrapfs_get_obj (struct obj *obj, objid_t id)
{
#if 0
    _wrapfs_id2obj (&obj, id);
#endif
    return ENONE;
}

int
wrapfs_get_dirent (struct dirent *dirent, objid_t id)
{
    char *path;
    int err;

    wrapfs_make_path (&path, (struct wrapfs_obj *) id);
    err = wrapfsw_dir_read (dirent->name, (int *) &dirent->size, path);

    free (path);
    return err;
}

int
wrapfs_free (struct obj *obj)
{
    struct wrapfs_obj *w = (struct wrapfs_obj *) obj->detail;

#if 0
    if (w == NULL) {
        printk ("XXX: wrapfs_free(): metaobj w/o obj.\n", 0);
        return ENONE;
    }
#endif

    ERRCHK(w == NULL, ENONE)

    if (w->obj)
        w->obj = NULL;

    if (w->prev)
	w->prev->next = w->next;
    if (w->next)
	w->next->prev = w->prev;

    return ENONE;
}

struct obj_ops wrapfs_obj_ops_subclass;

int
wrapfs_dup (struct obj *class, struct obj *newobj)
{
    OBJ_OPS(newobj) = &wrapfs_obj_ops_subclass;
    OBJ_SET_PERSISTENT(newobj, FALSE);

    return ENONE;
}

struct obj_ops wrapfs_obj_ops_class = {
    NULL, /* int (*io) (struct buf *, struct obj *, blk_t, bool mode); */
    NULL, /* int (*create) (struct obj *dir, struct obj *, int type); */
    NULL, /* int (*unlink) (struct obj *); */
    NULL, /* int (*resize) (struct obj *, blk_t newlen); */
    NULL, /* int (*dir_open) (struct dirent *, struct obj *, dir_t); */
    NULL, /* int (*dir_close) (dir_t *); */
    NULL, /* int (*dir_read) (struct dirent *, struct dir *); */
    NULL, /* int (*lookup) (struct obj **, struct obj *dir, char *name); */
    wrapfs_dup, /* int (*dup) (struct obj *class, struct obj *); */
    NULL, /* int (*get_obj) (struct obj *, objid_t id); */
    NULL, /* int (*get_dirent) (struct dirent *, objid_t id); */
    NULL
};

struct obj_ops wrapfs_obj_ops_subclass = {
    wrapfs_io, /* int (*io) (struct buf *, struct obj *, blk_t, bool mode); */
    wrapfs_create, /* int (*create) (struct obj *dir, struct obj *, int type); */
    wrapfs_unlink, /* int (*unlink) (struct obj *); */
    wrapfs_resize, /* int (*resize) (struct obj *, blk_t newlen); */
    wrapfs_dir_open, /* int (*dir_open) (struct dirent *, struct obj *, dir_t); */
    wrapfs_dir_close, /* int (*dir_close) (dir_t *); */
    wrapfs_dir_read, /* int (*dir_read) (struct dirent *, struct dir *); */
    wrapfs_lookup, /* int (*lookup) (struct obj **, struct obj *dir, char *name); */
    NULL, /* int (*dup) (struct obj *class, struct obj *); */
    wrapfs_get_obj, /* int (*get_obj) (struct obj *, objid_t id); */
    wrapfs_get_dirent, /* int (*get_dirent) (struct dirent *, objid_t id); */
    wrapfs_free
};

/*
 * Create wrapfs class object.
 */
void
wrapfs_init (struct obj *obj)
{
    char  *objname = "wrapfs";

    wrapfs_numobjs = 1;

    /* Store pointer to our object ops. */
    OBJ_OPS(obj) = &wrapfs_obj_ops_class;

    /* Set our class file name. */
    DIRENT_SET_NAME(obj_get_dirent (obj), objname);

    OBJ_SET_CACHED(obj, TRUE);
    OBJ_BLKSIZE(obj) = PAGESIZE;

    VERBOSE_BOOT_PRINTK("wrapfs: ok.\n", 0);
}
