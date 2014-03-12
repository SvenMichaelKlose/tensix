/*
 * tensix operating system project
 * Copyright (C) 2002, 2003, 2004, 2005 Sven klose <pixel@copei.de>
 *
 * I/O buffer management
 *
 * $License$
 */

#ifndef _SYS_BUF_H
#define _SYS_BUF_H

#include <types.h>
#include <pool.h>
#include <lock.h>

struct obj;

/*
 * I/O buffer.
 */
struct buf {
    DEQUEUE_NODE_DECL();
    LOCK_DEF(lock)
    void        *data;   /* Buffer content. */
    struct obj  *obj;    /* Object to which buffer belongs. */
    blk_t       blk;     /* Block offset within object. */
    size_t      len;     /* Length of buffer content. */
    refcnt_t    refcnt;  /* Number of references to this buffer. */
    u8_t        state;   /* State. (dirty?) */
#ifdef BUF_SHARE_DATA
    struct buf  *srcbuf; /* Source buffer or NULL. */
#endif
};

#define BUF_DIRTY       1 /* Mark buffer dirty for writeback. */
#define BUF_FRESH       2 /* Unread incoming stream buffer. */
#define BUF_PERSISTENT  4 /* Buffer is not removed before object. */

#define BUF_IS_DIRTY(buf)     ((buf)->state & BUF_DIRTY)
#define BUF_SET_DIRTY(buf)    ((buf)->state |= BUF_DIRTY)
#define BUF_UNSET_DIRTY(buf)  ((buf)->state &= ~BUF_DIRTY)

/* Fresh buffers were written to a file and not read by anyone. */
#define BUF_IS_FRESH(buf)     ((buf)->state & BUF_FRESH)
#define BUF_SET_FRESH(buf)    ((buf)->state |= BUF_FRESH)
#define BUF_UNSET_FRESH(buf)  ((buf)->state &= ~BUF_FRESH)

#define BINIT(buf,block) \
    buf->blk = block;    \
    buf->refcnt = 0;     \
    buf->len = 0;        \
    buf->state = 0

#define _BREF(buf)        ((buf)->refcnt++)
#define _BUNREF(buf)      (buf->refcnt--)

#define IO_R    0
#define IO_W    1

/* Debugging messages. */
#ifdef DEBUGLOG_BUF
#define BUF_PRINTK(fmt, val)  printk (fmt, (int) val)
#define BUF_PRINTNHEX(fmt, val)  printnhex (fmt, (int) val)
#else
#define BUF_PRINTK(fmt, val)
#define BUF_PRINTNHEX(fmt, val)
#endif

extern POOL_DECL(buffer_pool);

extern int buffers_in_use;

extern void buf_init ();

/* Free unused buffers. */
extern void bcleanup_glob ();

/*
 * Functions also used by the syncer daemon.
 */
extern int bfree (struct buf *);

/* Decrement reference count of buffer - other proc than current. */
extern void bunrefp (struct buf *, struct proc *); /* Internal funciton. */

extern int bread (struct buf **buf, struct obj *obj, blk_t blk, bool zero);

extern int bcreate (struct buf **buf, struct obj *obj, blk_t blk);

#endif /* #ifndef _SYS_BUF_H */
