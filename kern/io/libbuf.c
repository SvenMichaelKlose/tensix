/*
 * tensix operating system project
 * Copyright (C) 2002 Sven Klose <pixel@hugbox.org>
 *
 * I/O buffer management
 *
 * $License$
 *
 * About this file:
 *
 * Buffers are used as data containers for I/O. Buffers always contain
 * content of objects they belong to and represent a block. Block
 * sizes are determined by the object (see struct obj_class).
 * There're never doubles for a block in a file at the same offset).
 * Blocks may not overlap.
 * A buffer, representing a block of a file at a particular block offset
 * can be requested through the bref() function passing it a pointer to
 * the object of the file, its block index, some flags and a pointer to
 * a pointer where the address of the new buffer descriptor is stored in
 * the buffer pool. The new buffer is referenced and needs to be
 * unreferenced using bunref(). In case a process exits, the references
 * are corrected using the process' buffer list of pointers to referenced
 * buffers.
 *
 * Buffer descriptors are held in pool pointed to by buffer pool. Space for
 * buffer data is allocated via malloc().
 *
 * Buffers are kept in memory until their object is removed or memory
 * becomes low.
 *
 * blkatofs() and blkatofsend() are kernel library functions.
 *
 * Functions available to user processes are found at the end of this file.
 */

#include <config.h>
#include <types.h>
#include <buf.h>
#include <mem.h>
#include <obj.h>
#include <lock.h>
#include <array.h>
#include <error.h>
#include <proc.h>
#include <obj.h>
#include <libc.h>
#include <main.h>
#include <string.h>
#include <syncer.h>
#include <machdep.h>
#include <libbuf.h>
#include <xxx.h>
#include <fs.h>

/* Debugging messages. */
#ifdef DEBUGLOG_BUF
#define DEBUGLOG_BUF_PRINTK(msg, arg) printk (msg, (size_t) arg)
#else
#define DEBUGLOG_BUF_PRINTK(msg, arg)
#endif

int
bio_seek_map (struct obj *obj, blk_t start, unsigned int num, unsigned int needed, blk_t preferred, blk_t *blk, struct buf **buf, void **blkofs)
{
    return -1;
}

/*
 * Allocate an obj buffer like bio() but take an offset into the
 * obj. The pointer to the buffer data where the specified obj
 * starts is returned in 'ptr'.
 *
 * If you need the number of bytes available relative to 'ptr' use
 * the BUF_REMSIZ() macro.
 */
int
batofs (struct buf **buf, void **ptr, struct obj *obj, fsize_t ofs, u8_t mode)
{
    int           err;
    int           size = OBJ_BLKSIZE(obj);
    blk_t         blk = ofs / size; /* Logical block number. */

    /* Relative offset inside buffer. */
    ofs = ofs % size;

    /* Get block. */
    err = bref (buf, obj, blk, mode);
    ERRCODE(err);

    /* Get pointer to offset inside buffer. */
    *ptr = POINTER_ADD((*buf)->data, ofs);

    return 0;
}

/*
 * Like batofs() but returns a pointer to the end of the buffer.
 */
int
batofsend (struct buf **buf, void **ptr, void **end, struct obj *obj,
	   fsize_t ofs, u8_t mode)
{
    int err;

    err = batofs (buf, ptr, obj, ofs, mode);
    *end = BUF_END(*buf,ptr);
    return err;
}
