/*
 * tensix operating system project
 * Copyright (C) 2002, 2003 Sven Klose <pixel@hugbox.org>
 *
 * Virtual filesystem modeller.
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

#ifndef NO_IO

#include <obj_intern.h>

/*************************************
 * Internal getter/setter functions. *
 *************************************/

/*
 * _obj_get_obj_by_id() and _obj_get_dirent_by_id() require context switching
 * to be turned off before it is checked if an element is already in memory.
 * Both functions create a new element with the requested ID and set a lock
 * on it before turning context switching on again. If the object is requested
 * again, the getter function will wait for the lock to be released when the
 * element is complete. Context switching is always turned on again.
 */

int
_obj_get_obj_by_id (struct obj **retobj, objid_t id, struct obj *child, struct dirent *dirent)
{
    u16_t index;
    u32_t subid;
    struct obj_subclass *sub;
    struct obj          *obj;

    *retobj = NULL;  /* Nothing fetched yet. */

    /* Split up id into subclass and index part. */
    index = OBJID_SUBCLASS(id);
    subid = OBJID_SUBID(id);

    /* Lookup subclass. */
    sub = OBJ_SUBCLASS_AT_INDEX(index);

    /* Return nothing if operation is not supported. */
    if (sub->ops->get_obj == NULL) {
	SWITCH_ON();
	return ENOTSUP;
    }

    /* Create object, set its ID and lock it. */
    obj = OBJ_ALLOC(NULL);
    obj->id = id;
    OBJ_REF(obj);
    LOCK(obj->lock);

    /* Replace ID references by pointers in sibling elements. */
    if (dirent != NULL)
        dirent_set_obj (dirent, obj);
    if (child != NULL)
        obj_set_parent (child, obj);

    SWITCH_ON();

    /* Let object fill in the new element. */
    sub->ops->get_obj (obj, subid);

    /* Unlock object for use. */
    UNLOCK(obj->lock);

    *retobj = obj;
    return TRUE;
}

int
_obj_get_dirent_by_id (struct dirent **retdir, objid_t id, struct obj *obj)
{
    u16_t index;
    u32_t subid;
    struct obj_subclass *sub;
    struct dirent *dirent;

    *retdir = NULL;  /* Nothing fethched yet. */

    /* Split up id into subclass and index part. */
    index = OBJID_SUBCLASS(id);
    subid = OBJID_SUBID(id);

    /* Lookup subclass. */
    sub = OBJ_SUBCLASS_AT_INDEX(index);

    /* Return nothing if operation is not supported. */
    if (sub->ops->get_dirent == FALSE) {
	SWITCH_ON();
	return 0;
    }

    /* Allocate new directory, set its ID and lock it. */
    dirent = POOL_SALLOC(&dirent_pool);
    dirent->id = id;
    DIRENT_REF(dirent);
    LOCK(dirent->lock);

    /* Replace ID reference in object by pointer. */
    if (obj != NULL)
	dirent_set_obj (dirent, obj);

    /* Now the getter can be called again for the same (locked) object. */
    SWITCH_ON();

    /* Have directory entry filled in by the object. */
    sub->ops->get_dirent (*retdir, subid);

    /* Unlock dirent for use. */
    UNLOCK(dirent->lock);

    *retdir = dirent;
    return 0;
}

/********************
 * Element getters. *
 ********************/

/*
 * Locking in getters:
 *
 * To make sure that there's exactly one copy of each element, context
 * switching is turned off until the element is found in memory or a locked
 * element is added. If another process requests the same lock, it'll find
 * it memory and wait on the lock which is released when the element is
 * recovered by the object function (get_object(), get_dirent()).
 */

/* Get pointer to parent object. */
struct obj *
obj_get_parent (struct obj *obj)
{
    struct obj  *retobj;

    SWITCH_OFF();
    if (obj->state & OBJ_PARENT_UNMAPPED) {
        _obj_get_obj_by_id (&retobj, obj->parent_id, obj, NULL);
    } else {
	retobj = (struct obj *) obj->parent_id;
	OBJ_REF(retobj);
	SWITCH_ON();

	/*
	 * Wait if the dirent is under construction
	 * (_obj_get_object_by_id()).
	 */
	LOCK(retobj->lock);
    }

    return retobj;
}

/* Get directory entry of object. */
struct dirent *
obj_get_dirent (struct obj *obj)
{
    struct dirent  *dirent;

    SWITCH_OFF();
    if (obj->dirent != NULL) {
	dirent = obj->dirent;
	DIRENT_REF(dirent);
	SWITCH_ON();

	/*
	 * Wait if the dirent is under construction
	 * (_obj_get_dirent_by_id()).
	 */
	LOCK(dirent->lock);
    } else
        _obj_get_dirent_by_id (&dirent, obj->id, obj);

    return dirent;
}

/* Get object of directory. */
struct obj *
dirent_get_obj (struct dirent *dirent)
{
    struct obj *retobj;

    SWITCH_OFF();
    if (dirent->obj != NULL) {
	retobj = (struct obj *) dirent->obj;
	OBJ_REF(retobj);
        SWITCH_ON();

	/*
	 * Wait if the dirent is under construction
	 * (_obj_get_object_by_id()).
	 */
	LOCK(retobj->lock);
    } else
        _obj_get_obj_by_id (&retobj, dirent->id, NULL, dirent);

    return retobj;
}

/********************
 * Element setters. *
 ********************/

/*
 * NOTE: Element setters are not locked.
 */

/* Set pointer to parent object. */
void
obj_set_parent (struct obj *obj, struct obj *parent)
{
    ASSERT(obj->parent_id != 0, "obj_set_parent: used twice");

    obj->state &= ~OBJ_PARENT_UNMAPPED;
    obj->parent_id = (objid_t) parent;
}

/* Set pointer to parent object. */
void
obj_set_dirent (struct obj *obj, struct dirent *dirent)
{
#if 0
    ASSERT(obj->dirent != NULL, "obj_set_dirent: used twice");
#endif
    if (obj->dirent != NULL) {
 	printk ("obj_set_dirent: used twice", 0);
	*(char*) 0 = 0;
    }

    obj->dirent =  dirent;
}

/* Set pointer to parent object. */
void
dirent_set_obj (struct dirent *dirent, struct obj *obj)
{
    dirent->obj = obj;
}

#endif /* #ifndef NO_IO */
