/*
 * tensix operating system project
 * Copyright (C) 2002, 2003, 2004, 2005 Sven Klose <pixel@copei.de>
 *
 * Object-dependent operations. 
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
#include <xxx.h>

#ifndef NO_IO

#include <obj_intern.h>

/*****************************
 * Object operation wrappers *
 *****************************/

#ifdef OBJ_EVENTS
int 
obj_event_wait (struct obj *obj, int event_mask)
{
    /* Check if event mask is valid. */
    ERRCHK(event_mask & ~OBJEVENT_ALL, EINVAL);

    obj->eventq_num++;

    while (1) {
	/* Wait for an event. */
	lock_ref_wait (&obj->lock_event);

	/* Wakeup other process that may be waiting. */
        if (LOCKED(obj->lock_event))
	    lock_unref (&obj->lock_event);

	obj->eventq_cnt--;

        /*
	 * If this is the last process handling the event, mask out the event
	 * flags.
	 */
	if (obj->eventq_cnt == 0 && obj->state & OBJEVENT_ALL & event_mask) {
	    obj->state &= ~OBJEVENT_ALL;
	}

	/* Check if we're waiting for the type of event. */
	if (obj->state & OBJEVENT_ALL & event_mask) {
	    obj->eventq_num--;
	    break;
        }
    }

    return ENONE;
}

/* Wake up processes waiting for events. */
int
obj_event_trigger (struct obj *obj, int event_mask)
{
    /* Check if event mask is valid. */
    ERRCHK(event_mask & ~OBJEVENT_ALL, EINVAL);

    /* Wait for pending events to finish. */
    while (obj->eventq_cnt)
	MANUAL_SWITCH();

    obj->state |= event_mask;
    obj->eventq_cnt = obj->eventq_num;

    /* Wakeup any of the waiting processes. */
    if (LOCKED(obj->lock_event))
        lock_unref (&obj->lock_event);

    return ENONE;
}

#endif /* #ifdef OBJ_EVENTS */

/*
 * Request buffer of object.
 */
int
obj_io (struct buf *buf, struct obj *obj, blk_t blk, bool mode)
{
    int err;

    ASSERT(buf == NULL, "obj_io: no buf");
    ASSERT(obj == NULL, "obj_io: no obj");

    OBJ_PRINTK("obj_io: file '%s': ", obj->dirent->name);
    OBJ_PRINTK("mode %d, ", mode);
    OBJ_PRINTK("blk %d.\n", blk);

    /* Do I/O via object. */
    _OBJ_CHKOP(obj, io);
    err = OBJ_IO(buf, obj, blk, mode);

#ifdef OBJ_EVENTS
    if (err == ENONE && OBJ_WANTS_EVENT(obj)) {
	if (mode == IO_W) {
	    obj_event_trigger (obj, OBJEVENT_WRITE);
	} else {
	    obj_event_trigger (obj, OBJEVENT_READ);
	}
    }
#endif

    /* Extend object size. */
    if (mode == IO_W && !OBJ_IS_STREAM(obj) && blk >= obj->size) {
        obj->size = blk + 1;
        obj->dirent->size = blk * OBJ_BLKSIZE(obj) + buf->len;
    }            

    return err;
}


/*
 * Create a file.
 */
int
obj_create (struct obj **retobj, struct obj *dir, int type, char *name)
{
    struct obj *obj;
    int err;

    ASSERT(dir == NULL, "obj_create: no dir");

    /* Create object in model. */
    obj = obj_suballoc (dir, 0, name);
    ERRNULLC(obj, ENOMEM);
    UNLOCK(obj->dirent->lock);

    /* Have filesystem create and initialise its part of the new object. */
    err = OBJ_CREATE(dir, obj, type);
    ERRGOTO(err, error1);
    UNLOCK(obj->lock);

    *retobj = obj;
    return ENONE;

error1:
    obj_free (obj);
    return err;
}

/*
 * Unlink a file from filesystem and cache.
 */
int
obj_unlink (struct obj *obj)
{
    struct obj *dir = (struct obj *) obj->parent_id;
    int err;

    /* Check if operation is supported by the object. */
    _OBJ_CHKOP(dir, unlink);

#ifdef OBJ_EVENTS
    if (OBJ_WANTS_EVENT(obj))
	obj_event_trigger (obj, OBJEVENT_UNLINK);
#endif

    /* Remove file. */
    err = OBJ_OPS(dir)->unlink (dir, obj);
    ERRCODE(err);

    /* Remove object. */
    dirent_free (obj);
    obj_free (obj);

    return ENONE;
}

/*
 * Resize an object.
 */
int
obj_resize (struct obj *obj, fsize_t newlen)
{
    /* Check if operation is supported by the object. */
    _OBJ_CHKOP(obj, resize);

#ifdef OBJ_EVENTS
    if (OBJ_WANTS_EVENT(obj))
	obj_event_trigger (obj, OBJEVENT_RESIZE);
#endif

    /* Remove file. */
    return OBJ_OPS(obj)->resize (obj, newlen);
}


#endif    /* #ifndef NO_IO */
