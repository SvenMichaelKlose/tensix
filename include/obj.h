/*
 * tensix operating system project
 * Copyright (C) 2002, 2003, 2004, 2005 Sven Klose <pixel@copei.de>
 *
 * File object interface
 *
 * $License$
 */

#ifndef _SYS_OBJ_H
#define _SYS_OBJ_H

#include <types.h>
#include <dir.h>
#include <buf.h>
#include <dirent.h>
#include <queue.h>
#include <array.h>
#include <lock.h>

/* Object types for struct obj_ops/create(). */
#define OBJ_TYPE_FILE  1
#define OBJ_TYPE_DIR   2

/*
 * Object function vector.
 */
/*
 * io: Read and write blocks of a file.
 *
 * This function is required. Mode is one of IO_R or IO_W.
 */
/*
 * create: Create a file.
 *
 * The new object and dirent is already created in vfs_create() before and
 * uses the class/subclass of the parent object. This function must create
 * the according file on the file store.
 * This function must allocate a directory on the file store, too.
 * This function should be undefined if the object subclass is read-only.
 */
/*
 * unlink: Remove a file.
 *
 * The directory entry is removed in dir_dealloc() if its defined.
 * Otherwise, the directory must be removed from the file store in this
 * function.
 */
/*
 * resize: Lengthen or shorten a file.
 *
 * If this function is missing, the object is of a fixed size.
 */
/*
 * dir_*: Read a directory entry.
 *
 * This functions must both be defined or undefined. If they're undefined,
 * directories are not supported by the object class.
 *
 * dir_read() reads the first dirent from an object or the next sibling of
 * a dirent.
 *
 * If the user madified a dirent, dir_write() is the function to have it
 * written back to the underlying file store. If the object class is
 * read-only this function should be missing.
 */
/*
 * lookup: Lookup file in directory by name.
 *
 * This function is optional. If undefined, the generic lookup function
 * will use dir_read() to scan a whole directory.
 */
/*
 * dup: Create a new subclass.
 */
/*
 * get_*: Get object/dirent by ID.
 * This functions must both be defined or undefined. If they're undefined,
 * all objects and dirent remain in memory until the subclass is removed.
 */
struct obj_ops {
    int (*io)         (struct buf *, struct obj *, blk_t, bool mode);
    int (*create)     (struct obj *dir, struct obj *, int type);
    int (*unlink)     (struct obj *parent, struct obj *child);
    int (*resize)     (struct obj *, fsize_t newlen);
    int (*dir_open)   (struct dir *);
    int (*dir_close)  (struct dir *);
    int (*dir_read)   (struct dirent *, struct dir *);
    int (*lookup)     (struct obj **, struct obj *dir, char *name);
    int (*dup)        (struct obj *class, struct obj *);
    int (*get_obj)    (struct obj *, objid_t id);
    int (*get_dirent) (struct dirent *, objid_t id);
    int (*free)   (struct obj *);
};

/*
 * Object type dependent info.
 */
struct obj_class {
    DEQUEUE_NODE_DECL();
    size_t          blksize; /* Block size in bytes. 0 for streams. */
    void            *detail; /* Object type implementation details. */
};

/* Instance of a class. */
struct obj_subclass {
    DEQUEUE_NODE_DECL();
    struct obj_ops  *ops;    /* Object functions. */
    struct obj_class *class;
    void             *detail;
};

/*
 * Object.
 */
struct obj {
    DEQUEUE_NODE_DECL();
    LOCK_DEF(lock)
    struct obj_subclass *subclass; /* General object info. */
    objid_t             parent_id; /* Parent object. */
    blk_t               size;      /* Size of the obj in blocks. */
    objid_t             id;        /* Unique key (within name space). */

    struct dirent       *dirent;   /* Pointer to directory entry or NULL. */

    struct dequeue_hdr  dirents;   /* List if subdirectory objects. */
    LOCK_DEF(lock_dirents)

    struct dequeue_hdr  buffers;   /* Buffers bound to this object. */
    LOCK_DEF(lock_buffers)

    refcnt_t            refcnt;    /* Numer of processes and iod channels
				      using the object. */
    u8_t		freshbufs; /* Number of fresh buffers. */
    u8_t		dirtybufs; /* Number of dirty buffers. */

    u8_t                state;     /* OBJ_PERSISTENT */

#ifdef OBJ_EVENTS
    LOCK_DEF(lock_event)
    u8_t		eventq_cnt;
    u8_t		eventq_num;
#endif /* #ifdef OBJ_EVENTS */

    void                *detail;   /* Object implementation details. */
};

/*
 * Object flags.
 */
#define OBJ_PERSISTENT  1
#define OBJ_STREAMED    4
#define OBJ_PASSIVE	8  /* Object must be polled or pushed. */
#define OBJ_DIRENT_UNMAPPED  8
#define OBJ_PARENT_UNMAPPED  16
#define OBJ_CACHED    2

#ifdef OBJ_EVENTS

#define OBJEVENT_READ	1
#define OBJEVENT_WRITE	2
#define OBJEVENT_UNLINK	4
#define OBJEVENT_RESIZE	8
#define OBJEVENT_ALL \
    (OBJEVENT_READ | OBJEVENT_WRITE | OBJEVENT_UNLINK | OBJEVENT_RESIZE)

#define OBJ_WANTS_EVENT(obj)  (obj->eventq_num != 0)

#endif /* #ifdef OBJ_EVENTS */

#define OBJ_SET_FLAG(var, flag, yesno) \
    if (yesno == FALSE)                \
        var &= ~flag;                  \
    else                               \
        var |= flag

/* Check if object is resident in memory. */
#define OBJ_IS_PERSISTENT(obj) (obj->state & OBJ_PERSISTENT)
#define OBJ_SET_PERSISTENT(obj, yesno) \
        OBJ_SET_FLAG((obj)->state, OBJ_PERSISTENT, yesno)

/* Check if an object binds buffers. */
#define OBJ_IS_CACHED(obj) (obj->state & OBJ_CACHED)
#define OBJ_SET_CACHED(obj, yesno) \
        OBJ_SET_FLAG((obj)->state, OBJ_CACHED, yesno)

/* Check if object is streamed. */
#define OBJ_IS_STREAM(obj) (obj->state & OBJ_STREAMED)
#define OBJ_SET_STREAMED(obj, yesno) \
        OBJ_SET_FLAG((obj)->state, OBJ_STREAMED, yesno)

#define OBJ_SUBCLASS(obj) ((obj)->subclass)
#define OBJ_CLASS(obj) (OBJ_SUBCLASS(obj)->class)
#define OBJ_OPS(obj) (OBJ_SUBCLASS(obj)->ops)

#define OBJ_HAS_OP(obj, op)  (OBJ_OPS(obj)->op != NULL)

#define OBJ_IO(buf, obj, blk, mode)  OBJ_OPS(obj)->io (buf, obj, blk, mode)
#define OBJ_CREATE(dir, obj, type)   OBJ_OPS(dir)->create (dir, obj, type)
#define OBJ_UNLINK(obj)              OBJ_OPS(obj)->unlink (obj)
#define OBJ_FREE(obj)                OBJ_OPS(obj)->free (obj)
#define OBJ_TRUNCATE(obj, newlen)    OBJ_OPS(obj)->truncate (obj, newlen)

#define OBJ_DIR_OPEN(dir)    	     OBJ_OPS(dir->obj)->dir_open (dir)
#define OBJ_DIR_CLOSE(dir)           OBJ_OPS(dir->obj)->dir_close (dir)
#define OBJ_DIR_READ(dirent, dir)    OBJ_OPS(dir->obj)->dir_read (dirent, dir)
#define OBJ_LOOKUP(retobj, dir, name)  OBJ_OPS(dir)->lookup (retobj, dir, name)
#define OBJ_DUP(classobj, newobj)      OBJ_OPS(classobj)->dup (classobj, newobj)

#define OBJ_BYTE2BLKSIZE(obj, bsize) \
    ((bsize % OBJ_BLKSIZE(obj)) ? 1 : 0) + bsize / OBJ_BLKSIZE(obj)

#define OBJ_PUSH(obj, buf)   (OBJ_OPS(obj)->push (obj, buf))

/* Allocate new object. */
#define OBJ_ALLOC(parent)       obj_alloc (parent)

/* Deallocate object. */
#define OBJ_DEALLOC(obj)  SARRAY_ERASE(struct obj, obj_pool, obj)

/* Allocate new object type. */
#define OBJ_CLASS_ALLOC()       SARRAY_ADD(struct obj_class, obj_classes)

/* Deallocate object type. */
#define OBJ_CLASS_DEALLOC(type)  SARRAY_ERASE(struct obj_class, obj_classes, type)

/* Get block size of object. */
#define OBJ_SIZE(obj) ((obj)->size)
#define OBJ_BLKSIZE(obj) (OBJ_CLASS(obj)->blksize)
#define OBJ_BUFSIZE(obj) (OBJ_BLKSIZE(obj) ? OBJ_BLKSIZE(obj) : BUF_STREAMSIZE)

#define OBJ_BUFFERS(obj) (&(obj->buffers))
#define OBJ_DIRENTS(obj) (&(obj->dirents))

#define OBJ_HAS_FRESH(obj)   (obj->freshbufs != 0)
#define OBJ_ADD_FRESH(obj)   (obj->freshbufs++)
#define OBJ_SUB_FRESH(obj)   (obj->freshbufs--)

#define OBJ_GET_TOP(obj)        \
    while (obj->higher != NULL) \
	obj = obj->higher;

#define OBJ_STACK(dest, obj) \
    obj_set_parent (obj, obj_get_parent (dest); \
    dest->higher = obj

#define OBJ_REF(obj)  ((obj)->refcnt++)
#ifdef DIAGNOSTICS
#define OBJ_UNREF(obj)  obj_unref(obj)
extern void obj_unref (struct obj *);
#else
#define OBJ_UNREF(obj)  ((obj)->refcnt--)
#endif

/* Set file name in dirent. */
#define DIRENT_SET_NAME(dirent, newname) strcpy(dirent->name, newname)

/* Object class initialiser. */
typedef void (*obj_init_t) (struct obj *);

extern POOL_DECL(obj_pool);
extern struct obj_class *obj_classes;  /* Object type pool. */

extern int objects_in_use;

/* Initialisation at boot time. */
extern void obj_init ();
extern void obj_class_init (obj_init_t);
extern void obj_classes_init ();

/* Allocation/deallocation. */
extern struct obj *obj_alloc (struct obj *parent);
extern struct obj *obj_suballoc (struct obj *parent, objid_t, char *);
extern struct obj *obj_new_class (struct obj *);
extern int obj_dup (struct obj *src, struct obj *destdir, char *destname);
extern void obj_free (struct obj*);
extern struct dirent *dirent_alloc (struct obj *);
extern void dirent_free (struct obj *);

/* Object creation/duplication/removal. */
extern int obj_create (struct obj **, struct obj *dir, int type, char *name);
extern struct obj *obj_copy ();
extern int obj_unlink (struct obj *);

/* Object operations. */
extern int obj_io (struct buf *, struct obj *, blk_t, bool mode);
extern int obj_dir_open (struct dir *);
extern int obj_dir_read (struct dirent *, struct dir *);
extern int obj_dir_close (struct dir *);

/* Iterating over the object tree. */
extern struct obj *obj_get_parent (struct obj *);
extern struct dirent *obj_get_dirent (struct obj *);
extern struct obj *dirent_get_obj (struct dirent *);

/* Object tree manipulation. */
extern void obj_set_parent (struct obj *, struct obj *parent);
extern void obj_set_dirent (struct obj *, struct dirent *);
extern void dirent_set_obj (struct dirent *, struct obj *);

/* Object events. */
extern int obj_event_wait (struct obj *, int event_mask);
extern int obj_event_trigger (struct obj *, int event_mask);

#endif /* #ifndef _SYS_OBJ_H */
