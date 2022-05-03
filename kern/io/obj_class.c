/*
 * tensix operating system project
 * Copyright (C) 2002, 2003, 2004 Sven Klose <pixel@hugbox.org>
 *
 * Object classes
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

#include <con.h>
#include <disk.h>
#include <eth.h>
#include <memfs.h>
#include <wrapfs.h>

#ifndef NO_IO

#include <obj_intern.h>

#if 0
#ifdef DEBUGLOG_OBJ
#define OBJ_PRINTK(fmt, val)  printk (fmt, (int) val)
#define OBJ_PRINTNHEX(fmt, val)  printnhex (fmt, (int) val)
#else
#define OBJ_PRINTK(fmt, val)
#define OBJ_PRINTNHEX(fmt, val)
#endif

#define OBJ_SUBCLASS_AT_INDEX(index) \
    POOL_AT_INDEX(&obj_subclass_pool, struct obj_subclass, index)

#define OBJID_SUBCLASS(id)   ((id & 0xf0000000) >> 28)
#define OBJID_SUBID(id)      (id & 0x0fffffff)

#define OBJ_ADD_DIRENT(obj, dirent) \
	DEQUEUE_PUSH(OBJ_DIRENTS(obj), dirent);
#define OBJ_REMOVE_DIRENT(obj, dirent) \
	DEQUEUE_REMOVE(OBJ_DIRENTS(obj), dirent);

#endif

/* Object class initialisers. */
obj_init_t obj_table[] = {
#include <config_drivers.h>
	NULL
};

struct obj *
obj_new_class (struct obj *parent)
{
    struct obj *obj;
    obj = OBJ_ALLOC(parent);

    OBJ_PRINTK("obj_new_class\n", 0);

    /* Allocate class infos. */
    OBJ_SUBCLASS(obj) = pool_alloc (&obj_subclass_pool);
    OBJ_CLASS(obj) = pool_alloc (&obj_class_pool);
    obj->parent_id = (objid_t) parent;

    return obj;
}

/*
 * Allocate object of new subclass.
 */
int
obj_dup (struct obj *class, struct obj *destdir, char *destname)
{
    struct obj *newobj;
    int err;

    OBJ_PRINTK("obj_dup_class\n", 0);

    /* Create new object. */
    newobj = obj_suballoc (destdir, 0, destname);

    /* Allocate new subclass info. */
    OBJ_SUBCLASS(newobj) = pool_alloc (&obj_subclass_pool);
    OBJ_CLASS(newobj) = OBJ_CLASS(class);

    if (OBJ_HAS_OP(class, dup)) {
        /* Have subclass info filled in by class object. */
        err = OBJ_DUP(class, newobj);
    } else
        err = ENOTSUP;

    UNLOCK(newobj->lock);

    if (err != FALSE)
        obj_free (newobj);
    else
	    OBJ_SET_PERSISTENT(newobj, TRUE);

    return err;
}

/*
 * Initialise particular object class.
 */
INLINE void
obj_class_init (obj_init_t i)
{
    /* Allocate class and subclass record. */
    struct obj  *obj;
    struct dirent  *dirent;
    obj = obj_new_class (namespace_root_obj);
    dirent = (struct dirent *) obj->dirent;

    /* Mark object as being resident, so the syncer won't remove it. */
    obj->state |= OBJ_PERSISTENT;

    /* We should be single tasked. */
    UNLOCK(obj->lock);
    UNLOCK(dirent->lock);

    /* Let object-dependent code initialise the object class. */
    (i) (obj);
}

/*
 * Initialise all object classes.
 */
void
obj_classes_init ()
{
    obj_init_t  *i = obj_table; /* List of object class initialisers. */

    /* Initialise object drivers. */
    while (*i != NULL)
	    obj_class_init (*i++);
}

#endif
