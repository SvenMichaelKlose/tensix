/*
 * tensix operating system project
 * Copyright (c) 2002, 2003, 2004, 2005 Sven Klose <pixel@copei.de>
 *
 * $License$
 */

#ifdef DEBUGLOG_OBJ
#define OBJ_PRINTK(fmt, val)  printk (fmt, (int) val)
#define OBJ_PRINTNHEX(fmt, val)  printnhex (fmt, (int) val)
#else
#define OBJ_PRINTK(fmt, val)
#define OBJ_PRINTNHEX(fmt, val)
#endif

POOL_DECL(obj_pool);
POOL_DECL(obj_class_pool);
POOL_DECL(obj_subclass_pool);
POOL_DECL(dirent_pool);

#define OBJ_SUBCLASS_AT_INDEX(index) \
    POOL_AT_INDEX(&obj_subclass_pool, struct obj_subclass, index)

#define OBJID_SUBCLASS(id)   ((id & 0xf0000000) >> 28)
#define OBJID_SUBID(id)      (id & 0x0fffffff)

#define OBJ_ADD_DIRENT(obj, dirent) \
	DEQUEUE_PUSH(OBJ_DIRENTS(obj), dirent);
#define OBJ_REMOVE_DIRENT(obj, dirent) \
	DEQUEUE_REMOVE(OBJ_DIRENTS(obj), dirent);

/* Check if object supports an operation. */
#define _OBJ_CHKOP(obj, op) \
    if (OBJ_OPS(obj)->op == NULL) \
            return ENOTSUP;
