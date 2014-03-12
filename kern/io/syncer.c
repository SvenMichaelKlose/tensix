/*
 * tensix operating system project
 * Copyright (C) 2002, 2003 Sven Klose <pixel@hugbox.org>
 *
 * syncer (daemon for delayed writes)
 *
 * $License$
 *
 * About this file:
 *
 * The syncer writes unused dirty buffers back to their origin.
 */

#include <config.h>
#include <types.h>
#include <buf.h>
#include <libc.h>
#include <obj.h>
#include <proc.h>
#include <main.h>
#include <machdep.h>
#include <fs.h>

#ifdef SYNCER
struct proc *syncer_proc;
u8_t syncer_restart;
#endif

#ifdef SYNCER_SLEEP_DELAY
    int syncer_sleep_delay;
#endif

void
sync_bufs (struct obj *obj)
{
    struct buf *i_buf = (struct buf *) OBJ_BUFFERS(obj)->first;
    struct buf *b;

    /* Iterate over object's buffer list. */
    while (i_buf != NULL) {
        /* Save current buffer. */
        b = i_buf;

        /* Step to next buffer. Can't do after bfree(). */
        i_buf = (struct buf *) i_buf->next;

        /* Skip buffers that are not dirty. */
        if (BUF_IS_DIRTY(b) == FALSE)
            continue;

        /* Write out block. Wait until write finished. */
        bwrite (b);

#ifdef SYNCER_SLEEP_DELAY
        syncer_sleep_delay = SYNCER_SLEEP_DELAY;
#endif

#ifdef DEBUGLOG_SYNCER
        printk ("syncer: Wrote buf %d ", b->blk);
        printk ("of file '%s'.\n", (size_t) obj->dirent->name);
#endif

        /* Free uncached buffers immediately. */
        if (OBJ_IS_CACHED(obj) == FALSE)
            bfree (b);
    }
}

/*
 * Write out unused, dirty buffers.
 */
void
syncer ()
{
    struct obj *i_obj;
#ifdef SYNCER_SLEEP_DELAY
    syncer_sleep_delay = SYNCER_SLEEP_DELAY;
#endif

#ifdef SYNCER
    VERBOSE_BOOT_PRINTK("syncer\n", 0);

    /* Run forever in daemon mode. */
    while (1) {
        syncer_restart = FALSE;
#endif

        /* Iterate over pool of used objects. */
        DEQUEUE_FOREACH(&obj_pool.used, i_obj) {
	    /* Write out all dirty buffers of the object. */
	    sync_bufs (i_obj);

#if 0
	    /* Remove object if it's unused and has no dirty buffers. */
	    if (OBJ_IS_PERSISTENT(i_obj) == FALSE && i_obj->refcnt == 0 &&
	        i_obj->dirtybufs == 0)
	        obj_free (i_obj);
#endif
        }

#ifdef SYNCER
        /* Do run through list again, if someone wrote something. */
        if (syncer_restart != FALSE)
	    continue;

#ifdef SYNCER_SLEEP_DELAY
	if (syncer_sleep_delay-- && syncer_restart != FALSE) {
	    MANUAL_SWITCH();
            continue;
	}
#endif
        /* Nothing more to write. Sleep until restarted. */
        sleep ();
    }
#endif
}
