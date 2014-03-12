/*
 * tensix operating system project
 * Copyright (C) 2002, 2003 Sven Klose <pixel@copei.de>
 *
 * Memory pools
 *
 * $License$
 */

#ifndef _SYS_POOL_H
#define _SYS_POOL_H

#include <types.h>
#include <queue.h>
#include <lock.h>

struct pool {
    DEQUEUE_DECL(used);
    DEQUEUE_DECL(unused);
    LOCK_DEF(lock)
    void *area;
};

#define POOL_DECL(name) struct pool name

extern void* pool_create (struct pool *pool, size_t size, size_t typesize);
#define POOL_CREATE(pool, size, type) pool_create (pool, size, sizeof (type))

extern void *pool_alloc (struct pool *pool);
extern void *pool_salloc (struct pool *pool);
extern void pool_free (struct pool* pool, void *rec);

#define POOL_SALLOC(pool)      pool_salloc (pool);

#define POOL_SFREE(pool, rec)  DEQUEUE_PUSH(&(pool)->unused, rec);

#define POOL_AT_INDEX(pool, type, index)  &(((type*) (pool)->area))[index]

#endif /* #ifndef _SYS_POOL_H */
