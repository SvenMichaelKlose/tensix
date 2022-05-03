/*
 * tensix operating system project
 * Copyright (C) 2002, 2003, 2004 Sven Klose <pixel@c-base.org>
 *
 * I/O daemon
 *
 * $License$
 */

#include <config.h>
#include <types.h>
#include <error.h>
#include <string.h>
#include <buf.h>
#include <libc.h>
#include <obj.h>
#include <proc.h>
#include <pool.h>
#include <main.h>
#include <iod.h>
#include <machdep.h>
#include <queue.h>
#include <fs.h>
#include <xxx.h>

#ifdef DEBUGLOG_IOD
#define IOD_PRINTK(fmt,val)	printk (fmt, (int) val)
#else
#define IOD_PRINTK(fmt,val)
#endif

#ifdef IOD
struct proc *iod_proc;
u8_t iod_restart;
proc_t iod_polling;
#endif

/* Pool of free channel info records. */
POOL_DECL(iod_chn_pool);

/* List of channels that have new input. */
DEQUEUE_DECL(iod_chn_active);

/* List of inactive channels. */
DEQUEUE_DECL(iod_chn_inactive);

void iod_chn_kill (struct iod_chn *);
int iod_copy_buf (struct iod_chn *);

/* Free pending outgoing buffer of a channel. */
void
iod_free_dstbuf (struct iod_chn  *i_chn)
{
    struct buf  *dstbuf = i_chn->dstbuf;

    if (dstbuf == NULL)
        return;

    BDIRTY(dstbuf);
    bunref (dstbuf);
    i_chn->dstbuf = NULL;
}

/*
 * Create a new channel.
 */
int
iod_chn_create (struct iod_cmd *c)
{
    struct obj  **tmpobj;
    struct iod_chn *ch;
    int err;

#ifndef NO_CHECKS
    ERRCHK(c->param.create.flags & ~IODCHN_ALL, EINVAL);

    /* Polling and autopolling would close once poll was empty. */
    ERRCHK((c->param.create.flags & (IODCHN_POLL | IODCHN_AUTOCLOSE))
	   == (IODCHN_POLL | IODCHN_AUTOCLOSE),
	   EINVAL);

    /* Only streams can be polled. */
    ERRCHK((c->param.create.flags & IODCHN_POLL)
           && OBJ_IS_STREAM(c->param.create.from) == FALSE,
           EINVAL);
#endif

    /* Allocate channel descriptor. */
    ch = pool_alloc (&iod_chn_pool);
    ERRCHK(ch == NULL, ENOMEM);

    /* Initialise channel info. */
    ch->from = (struct obj *) c->param.create.from;
    ch->to = c->param.create.to;
    ch->blk_from = ch->blk_to = 0;
    ch->flags = c->param.create.flags & IODCHN_ALL;
    ch->dstbuf = NULL;
    ch->dstdata = NULL;
    ch->dstrest = 0;
    if (IODCHN_IS_POLLED(ch) || IODCHN_IS_PUSHED(ch)) {
        CLI();
        iod_polling++;
        STI();
    }

    /* Make object belong to iod as well. */
    if (IODCHN_IS_IMMEDIATE(ch) == FALSE) {
        FS_ALLOCOBJHDL(tmpobj, iod_proc);
        ERRCGOTO((void *) tmpobj == NULL, ENOMEM, error1)
        *tmpobj = ch->from;
        OBJ_REF(ch->from);

        FS_ALLOCOBJHDL(tmpobj, iod_proc);
        ERRCGOTO((void *) tmpobj == NULL, ENOMEM, error2)
        *tmpobj = ch->to;
        OBJ_REF(ch->to);
    }

    /* Return unique ID of created channel. */
    c->param.create.id = ch;

    /*
     * Put polled channel on active list immediately. Other channels are
     * put on the active list by the objects.
     */
    DEQUEUE_PUSH(&iod_chn_active, ch);
    IODCHN_SET_ACTIVE(ch);

    STI();

    /* Process channel immediately if required. */
    if (IODCHN_IS_IMMEDIATE(ch)) {
        while (iod_copy_buf (ch) == ENONE);
        if (IODCHN_IS_AUTOCLOSED(ch))
	        iod_chn_kill (ch);
	    return ENONE;
    }

    proc_wakeup (iod_proc);

    IOD_PRINTK("iod: channel %d created.\n", ch);
    return ENONE;

error2:
    FS_DEALLOCOBJHDL(tmpobj, ch->from, iod_proc);
    OBJ_UNREF(ch->from);

error1:
    pool_free (&iod_chn_pool, ch);

    return err;
}

/*
 * Remove a channel.
 *
 * The channel *MUST* sleep.
 */
void
iod_chn_kill (struct iod_chn *ch)
{
    /* Free pending outgoing buffer first. */
    iod_free_dstbuf (ch);

    if (IODCHN_IS_IMMEDIATE(ch) == FALSE) {
        close (ch->from);
        close (ch->to);
    }

    /* Remove channel descriptor from inactive list. */
    CLI();
    if (IODCHN_IS_POLLED(ch))
	    iod_polling--;
    DEQUEUE_REMOVE(&iod_chn_inactive, ch);
    STI();

    /* Free channel descriptor. */
    pool_free (&iod_chn_pool, ch);
    IOD_PRINTK("iod: channel %d killed.\n", ch);
}

/*Wakeup sleeping channel. */
void
iod_chn_wakeup (struct iod_chn *ch)
{
    CLI();
    if (IODCHN_IS_ACTIVE(ch) == FALSE) {
        DEQUEUE_REMOVE(&iod_chn_inactive, ch);
        DEQUEUE_PUSH(&iod_chn_active, ch);
	    IODCHN_SET_ACTIVE(ch);
    }
    STI();
}

/* Put running channel to slepp. */
void
iod_chn_sleep (struct iod_chn *ch)
{
    CLI();
    if (IODCHN_IS_ACTIVE(ch) != FALSE) {
        DEQUEUE_REMOVE(&iod_chn_active, ch);
        DEQUEUE_PUSH(&iod_chn_inactive, ch);
	    IODCHN_SET_INACTIVE(ch);
    }
    STI();
}

/*
 * Destroy channels connected to particular object.
 */
void
iod_obj_free (struct obj *obj)
{
    struct iod_chn *i_chn;
    bool restart = TRUE;

    while (restart != FALSE) {
        restart = FALSE;
        DEQUEUE_FOREACH(&iod_chn_inactive, i_chn) {
	    if (i_chn->from == obj || i_chn->to == obj) {
	        iod_chn_kill (i_chn);
		    restart = TRUE;
		    break;
 	    }
	}
    }
}

/*
 * Switch interrupt handler to new buffer.
 */
void
iod_intr_cont (struct iod_chn_intr *intr)
{
    intr->buf_current = intr->buf_free;
    intr->buf_free = NULL;
    proc_wakeup (iod_proc);
}

/*
 * Allocate buffer for interrupt handler.
 */
int
iod_intr_prealloc (struct iod_chn *ch)
{
#if 0
    return bref (&ch->from.intr->buf_free, ch->to, 0, IO_CREATE | IO_NOWAIT);
#endif
return 0;
}

/*
 * Process command written to virtual file.
 */
int
iod_obj_io (struct buf *buf, struct obj *obj, blk_t blk, bool mode)
{
    struct iod_cmd *c;

    /* Blocks cannot be read. The file size is 0, so bref() will create
     * empty buffers for us. */
    ERRCHK(mode == IO_R, ENOTSUP);

    /* Execute command. */
    c = buf->data;
    switch (c->type) {
        case IODCMD_CREATE:
            return iod_chn_create (c);

        case IODCMD_DESTROY:
            iod_chn_kill (c->param.destroy.id);
	    return ENONE;
    };

    /* Discard unknown commands. */
    return ENOTSUP;
}

struct obj_ops iod_obj_ops = {
    iod_obj_io,  /* int (*io) (struct buf *, struct obj *, blk_t, bool mode); */
    NULL,  /* int (*create) (struct obj *dir, struct obj *, int type); */
    NULL,  /* int (*unlink) (struct obj *); */
    NULL,  /* int (*resize) (struct obj *, blk_t newlen); */
    NULL,  /* int (*dir_open) (struct dir *); */
    NULL,  /* int (*dir_close) (struct dir *); */
    NULL,  /* int (*dir_read) (struct dirent *, struct dir *); */
    NULL,  /* int (*lookup) (struct obj **, struct obj *dir, char *name); */
    NULL,  /* int (*dup) (struct obj *class, struct obj *); */
    NULL,  /* int (*get_obj) (struct obj *, objid_t id); */
    NULL   /* int (*get_dirent) (struct dirent *, objid_t id); */
};

#ifdef DIAGNOSTICS
struct obj *iod_obj;
#endif

/*
 * Start daemon and create virtual file.
 */
void
iod_obj_init (struct obj *obj)
{
#ifdef DIAGNOSTICS
     iod_obj = obj;
#endif

    OBJ_OPS(obj) = &iod_obj_ops;
    OBJ_SET_STREAMED(obj, TRUE);
    DIRENT_SET_NAME(obj_get_dirent (obj), "iod");
}

/*
 * Transfer buffer to destination object and unreference it.
 */
int
iod_copy_buf (struct iod_chn  *i_chn)
{
    struct obj  *srcobj = i_chn->from;
    struct obj  *dstobj = i_chn->to;
    struct buf  *srcbuf;
    int err;
    fsize_t  srcrest;
    void*    srcdata;
    fsize_t  len;

    IOD_PRINTK("iod: copy blk %d\n", i_chn->blk_from);

    err = bref (&srcbuf, srcobj, i_chn->blk_from++, 0);
    ERRCODE(err);

    if (srcbuf == NULL) {
        if (IODCHN_IS_POLLED(i_chn) != FALSE && err == ENOIODATA)
            return err;

    	IOD_PRINTK("iod: copy blk: no src buf \n", i_chn->blk_from);
        if (OBJ_IS_STREAM(srcobj) == FALSE)
            iod_free_dstbuf (i_chn);
        err = ENOIODATA;
	    return err;
    }

    srcdata = srcbuf->data;
    srcrest = srcbuf->len;
    IOD_PRINTK("iod: copy blk: srcrest %d\n", srcrest);

    while (srcrest != 0) {
    	IOD_PRINTK("iod: copy blk: memcpying\n", i_chn->blk_from);
        /* Prepare destination buffer. */
        if (i_chn->dstrest == 0) {
            iod_free_dstbuf (i_chn);

	        /* Allocate new outgoing buffer. */
            err = bref (&i_chn->dstbuf, dstobj, i_chn->blk_to, IO_CREATE);
            ERRGOTO(err != ENONE, error);
	        i_chn->blk_to++;

            /* Initialise copy parameters. */
	        i_chn->dstdata = i_chn->dstbuf->data;
	        i_chn->dstrest = i_chn->dstbuf->len;
	        i_chn->dstbuf->len = 0;
        }

        len = srcrest > i_chn->dstrest ? i_chn->dstrest : srcrest;
        memcpy (i_chn->dstdata, srcdata, len);
        srcdata += len;
        srcrest -= len;
        i_chn->dstdata += len;
        i_chn->dstrest -= len;
        i_chn->dstbuf->len += len;
    }

error:
    if (i_chn->dstrest == 0)
        iod_free_dstbuf (i_chn);
    bunref (srcbuf);

    return err;
}

/*
 * Process active channels.
 */
void
iod_process_active ()
{
    struct buf	    *dummybuf;
    struct iod_chn  *i_chn;
    int    err;
    bool   restart;

    do {
        int    cnt = 0;
	    restart = FALSE;

        DEQUEUE_FOREACH(&iod_chn_active, i_chn) {
            /* Don't handle immediate copies in the background. */
            if (IODCHN_IS_IMMEDIATE(i_chn))
                continue;

            cnt++;

            if (IODCHN_IS_PUSHED(i_chn)) {
                /* Only push opened objects. */
                if (i_chn->from->refcnt == 0)
                    continue;

                err = bread (&dummybuf, i_chn->from, 0, 0);
                ERRGOTO(err, error);
                continue;
            }

            /* Read waiting buffer. */
            err = iod_copy_buf (i_chn);

            /*
             * Continue if successul. Keep polled channels going except on
             * errors.
             */
            if (err == ENONE ||
                (IODCHN_IS_POLLED(i_chn)
                    && (err == ENONE || err == ENOIODATA))) {
                restart = TRUE;
                continue;
            }

error:
            /* Close channel due to error? */
            if (err && err != ENOIODATA) {
                iod_chn_sleep (i_chn); /* Make channel sleep first. */
                iod_chn_kill (i_chn);
                restart = TRUE;
                break;
            }

            /* Deactivate idle channel. */
            iod_chn_sleep (i_chn);
            restart = TRUE;
            if (IODCHN_IS_AUTOCLOSED(i_chn))
            	iod_chn_kill (i_chn);

            break;
        }

	    IOD_PRINTK("iod: %d active channels.\n", cnt);
    } while (restart != FALSE);
}

/*
 * Background process.
 */
void
iod ()
{
    void *pool;

    iod_proc = CURRENT_PROC();
    iod_polling = 0;

    /* Allocate pool of channel descriptors. */
    pool = POOL_CREATE(&iod_chn_pool, IOD_CHANNELS, struct iod_chn);
    IASSERT(pool == NULL, "no mem for iod chns");

    /* Set up iod file. */
    obj_class_init (iod_obj_init);

    VERBOSE_BOOT_PRINTK("iod\n", 0);

    while (1) {
        iod_restart = FALSE;
        iod_process_active ();

        /* Don't rest when polling. */
	    if (iod_polling != 0)
	        continue;

        if (iod_restart == FALSE)
            sleep ();
    }
}
