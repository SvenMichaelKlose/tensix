/*
 * tensix operating system project
 * Copyright (C) 2002-2006 Sven Klose <pixel@hugbox.org>
 *
 * File objects
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

int objects_in_use;

/*
 * Initialise this module.
 *
 * This function is called in main(). It allocates object and class pools.
 */
void
obj_init ()
{
    /* Set up object pool. */
    void *pool = POOL_CREATE(&obj_pool, NUM_OBJS, struct obj);
    IASSERT (pool == NULL, "obj_init: no mem for pool.");

    /* Allocate object class pool. */
    pool = POOL_CREATE(&obj_subclass_pool, NUM_OBJSUBCLASSES, struct obj_subclass);
    IASSERT(pool == NULL, "obj_init: no mem for subclasses.");

    /* Allocate object subclass pool. */
    pool = POOL_CREATE(&obj_class_pool, NUM_OBJCLASSES, struct obj_class);
    IASSERT(pool == NULL, "obj_init: no mem for classes.");

    /* Allocate dirent pool. */
    pool = POOL_CREATE(&dirent_pool, NUM_DIRENTS, struct dirent);
    IASSERT(pool == NULL, "obj_init: no mem for dirents.");

    objects_in_use = 0;
    VERBOSE_BOOT_PRINTK(" %d objs, ", (int) NUM_OBJS);
    VERBOSE_BOOT_PRINTK("%d subclasses, ", (int) NUM_OBJSUBCLASSES);
    VERBOSE_BOOT_PRINTK("%d classes, ", (int) NUM_OBJCLASSES);
    VERBOSE_BOOT_PRINTK("%d dirents", (int) NUM_DIRENTS);
}

/**********************************
 * Object allocation/deallocation *
 **********************************/

/*
 * Allocate new object.
 *
 * Please take care that the object is unlocked after initialisation.
 */
struct obj *
obj_alloc (struct obj *parent)
{
    struct obj *obj;
    struct dirent *dirent;

    OBJ_PRINTK("obj_alloc\n", 0);

    /* Allocate object descriptor. */
    obj = pool_alloc (&obj_pool);
    ERRNULL(obj);

    obj->lock = 0;
    LOCK(obj->lock);

    /* Initialise desciptor. */
    if (parent != NULL)
        OBJ_SUBCLASS(obj) = OBJ_SUBCLASS(parent);
    obj->parent_id = (objid_t) parent; /* XXX */
    obj->refcnt = 0;     /* Reference count. */
    obj->size = 0;       /* Size in blocks. */
    obj->dirtybufs = 0;  /* Number of dirty buffers. */
    obj->dirent = NULL;  /* Number of dirty buffers. */
    DEQUEUE_WIPE(OBJ_BUFFERS(obj));  /* Buffer list. */
    DEQUEUE_WIPE(OBJ_DIRENTS(obj));  /* Directory list. */

    /* Allocate a directory entry if there's a parent. */
    if (parent != NULL) {
        dirent = dirent_alloc (parent);
        if (dirent == NULL)
            goto error;
        obj_set_dirent (obj, dirent);
        dirent_set_obj (dirent, obj);
    }

    objects_in_use++;

    return obj;

error:
    UNLOCK(obj->lock);
    pool_free (&obj_pool, obj);

    return NULL;
}

void
obj_free_buffers (struct obj *obj)
{
    struct buf  *buf;
    bool restart;

    /* Remove buffers from object. */
    do {
	    restart = FALSE;

        DEQUEUE_FOREACH(OBJ_BUFFERS(obj), buf) {
            bfree (buf);
            restart = TRUE;
            break;
        }
    } while (restart);
}

/* 
 * Allocate an object.
 *
 * The new object will belong to the same class and subclass like
 * the parent.
 */
struct obj *
obj_suballoc (struct obj *parent, objid_t id, char *name)
{
    struct obj *obj = obj_alloc (parent);
    ERRNULL(obj);

    OBJ_PRINTK("obj_suballoc\n", 0);
    ASSERT(parent == NULL, "obj_suballoc: no obj");

    OBJ_SUBCLASS(obj) = OBJ_SUBCLASS(parent);
    obj->id = id;
    obj->dirent->id = id;
    obj->state = parent->state;
    strcpy (obj->dirent->name, name);

    return obj;
}

/* Free object. */
void
obj_free (struct obj *obj)
{
    OBJ_PRINTK("obj_free\n", 0);

    ASSERT(obj->dirtybufs != 0, "obj_free: dirty buffers");
    ASSERT(OBJ_CLASS(obj) == NULL, "obj_free(): Object without class");
    ASSERT(obj->refcnt != 0, "obj_free: refcnt not 0");

    /* Don't free resident objects. */
    if (OBJ_IS_PERSISTENT(obj) != FALSE)
	    return;

    /* Close all I/O daemon channels containing the object. */
    iod_obj_free (obj);

    obj_free_buffers (obj);

    if (OBJ_OPS(obj)->free != NULL)
	    OBJ_FREE(obj);

    /* Free dirent structure. */
    if (obj->dirent != NULL)
        dirent_free (obj);

    /* Free object structure. */
    pool_free (&obj_pool, obj);

    objects_in_use--;
}

/* Don't call this function directly/ Use macro OBJ_UNREF() instead. */
void
obj_unref (struct obj *obj)
{
    if (obj->refcnt == 0)
	    panic ("obj_unref: underflow");

    obj->refcnt--;

    if (obj->refcnt == 0)
        obj_free (obj);
}

#ifdef DIAGNOSTICS
#endif /* #ifdef DIAGNOSTICS */

#endif    /* #ifndef NO_IO */
