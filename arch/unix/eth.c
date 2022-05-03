/*
 * tensix operating system project
 * Copyright (C) 2004, 2005 Sven Klose <pixel@copei.de>
 *
 * tap device ethernet driver
 *
 * $License$
 */

#include <eth.h>
#include <buf.h>
#include <libc.h>
#include <obj.h>
#include <proc.h>
#include <machdep.h>
#include <string.h>
#include <error.h>
#include "tapdev.h"

int
eth_io (buf, obj, blk, mode)
    struct buf *buf;
    struct obj *obj;
    blk_t      blk;
    bool       mode;
{
    int has_data;

    if (mode == IO_W) {
	    tapdev_send (buf->data, buf->len);
    } else {
	    has_data = tapdev_read (buf->data, OBJ_BUFSIZE(obj));
	    if (!has_data)
	        return ENOIODATA;
    }

    return ENONE;
}

/* Console object operations. */
struct obj_ops eth_obj_ops = {
    eth_io, /* int (*io) (struct buf *, struct obj *, blk_t, bool mode); */
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
eth_init (obj)
    struct obj *obj;
{
    tapdev_init ();

    OBJ_OPS(obj) = &eth_obj_ops;
    OBJ_SET_STREAMED(obj, TRUE);
    DIRENT_SET_NAME(obj_get_dirent (obj), "eth");

    VERBOSE_BOOT_PRINTK("eth: 192.168.0.2/24.\n", 0);
}
