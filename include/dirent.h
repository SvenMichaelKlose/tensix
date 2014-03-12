/*
 * tensix operating system project
 * Copyright (C) 2002, 2003 Sven Klose <pixel@copei.de>
 *
 * Directory objects
 *
 * $License$
 */

#ifndef _SYS_DIRENT_H
#define _SYS_DIRENT_H

#include <types.h>
#include <queue.h>

struct dirent {
    DEQUEUE_NODE_DECL();         /* global list */
    LOCK_DEF(lock)
    refcnt_t    refcnt;
    objid_t     id;              /* Cached object this belongs to. */
    struct obj  *obj;
    size_t      reclen;          /* XXX Remove! Length of this structure. */
    fsize_t     nextrec;         /* Next record. */
    fsize_t     size;            /* File size in bytes. */
    char        name[NAME_MAX];  /* Null-terminated file name. */
    u8_t        state;
};

#define DIRENT_HAS_OBJ  1

#define DIRENT_RECLEN(name) \
    (strlen (name) + sizeof (struct dirent) - NAME_MAX)

#define DIRENT_REF(obj)  ((dirent)->refcnt++)
#define DIRENT_UNREF(obj)  ((dirent)->refcnt--)

#endif /* #ifndef _SYS_DIRENT_H */
