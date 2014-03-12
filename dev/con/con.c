/*
 * tensix operating system project
 * Copyright (C) 2002, 2003 Sven Klose <pixel@hugbox.org>
 *
 * Generic console driver
 *
 * This driver requires the machine-dependent functions con_in () and
 * con_out().
 *
 * $License$
 */

#include <con.h>
#include <buf.h>
#include <libc.h>
#include <obj.h>
#include <proc.h>
#include <machdep.h>
#include <string.h>
#include <error.h>

int
con_io (buf, obj, blk, mode)
    struct buf *buf;
    struct obj *obj;
    blk_t      blk;
    bool       mode;
{
    char *p = buf->data;
    int  len;
    char c;

    if (mode == IO_W) {
        p = buf->data;
	len = buf->len;
	while (len--)
	    con_out (*p++);
    } else {
        len = buf->len;
	while (len--) {
#ifdef MULTITASKING
	    while ((c = con_in ()) == 0)
		MANUAL_SWITCH();
#else
	    c = con_in ();
#endif

	    if (c == 4) { /* EOT */
	        len++;
		break;
	    }

            *p++ = c;
	    if (c == 10) {  /* LF */
		p[-1] = 13;
		break;
	    }
	}
	buf->len -= len;
    }

    return ENONE;
}

/* Console object operations. */
struct obj_ops con_obj_ops = {
    con_io, /* int (*io) (struct buf *, struct obj *, blk_t, bool mode); */
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

/*
 * Initialise console object type.
 */
void
con_init (obj)
    struct obj *obj;
{
#ifdef MULTITASKING
    /* First, initialise the wrapper. */
    con_init_raw ();
#endif

    /* Store pointer to our object ops. */
    OBJ_OPS(obj) = &con_obj_ops;

    /* Make it a stream. */
    OBJ_SET_STREAMED(obj, TRUE);
    OBJ_SET_CACHED(obj, FALSE);
#if 0
    OBJ_BLKSIZE(obj) = 0; /* XXX needed? */
#endif

    /* Set our class file name. */
    DIRENT_SET_NAME(obj_get_dirent (obj), "con");

    VERBOSE_BOOT_PRINTK("con: trivial ASCII.\n", 0);
}
