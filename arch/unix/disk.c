/*
 * tensix operating system project
 * Copyright (C) 2002, 2003, 2004, 2005 Sven Klose <pixel@copei.de>
 *
 * unix platform driver
 * disk image driver.
 *
 * $License$
 */

#include <buf.h>
#include <libc.h>
#include <disk.h>
#include <string.h>

extern void disk_init_raw ();
extern int disk_io_raw (void *data, int len, int blk, int mode);

int
disk_io (buf, obj, blk, mode)
    struct buf *buf;
    struct obj *obj;
    blk_t      blk;
    bool       mode;
{
    /* Translate read/write mode. */
    bool write = (mode & IO_W) ? TRUE : FALSE;

    buf->len = OBJ_BLKSIZE(obj);

    /* Call wrapper. */
    return disk_io_raw (buf->data, OBJ_BLKSIZE(obj), blk, write);
}

struct obj_ops disk_obj_ops = {
    disk_io, /* int (*io) (struct buf *, struct obj *, blk_t, bool mode); */
    NULL, /* int (*create) (struct obj *dir, struct obj *, int type); */
    NULL, /* int (*unlink) (struct obj *); */
    NULL, /* int (*resize) (struct obj *, blk_t newlen); */
    NULL, /* int (*dir_open) (struct dir *); */
    NULL, /* int (*dir_close) (struct dir *); */
    NULL, /* int (*dir_read) (struct dirent *, struct dir *); */
    NULL, /* int (*lookup) (struct obj **, struct obj *dir, char *name); */
    NULL, /* int (*dup) (struct obj *class, struct obj *); */
    NULL, /* int (*get_obj) (struct obj *, objid_t id); */
    NULL  /* int (*get_dirent) (struct dirent *, objid_t id); */
};

void
disk_init (obj)
    struct obj *obj;
{
    /* Store pointer to our object ops. */
    OBJ_OPS(obj) = &disk_obj_ops;

    /* We only handle 256 byte blocks. */
    OBJ_BLKSIZE(obj) = 256;
    obj->size = DISK_BLKS; /* XXX */
    obj->dirent->size = DISK_BLKS * 256;

    /* Save our name. */
    DIRENT_SET_NAME(obj_get_dirent (obj), "disk");

    OBJ_SET_CACHED(obj, TRUE);

    disk_init_raw ();

    VERBOSE_BOOT_PRINTK("disk: image.dsk\n", 0);
}
