/*
 * tensix operating system project
 * Copyright (C) 2002, 2003 Sven Klose <pixel@hugbox.org>
 *
 * Memory pooling
 *
 * $License$
 *
 * About this file:
 *
 * 1. What are pools?
 *
 * Pools hold a fixed number of preferably small data structures in an array
 * to reduce memory loss caused by kalloc(). Records held in a pool must have
 * a doubly-linked list node declaration (DEQUEUE_NODE_DECL()) because they're
 * added to the list of unused records once the pool is created
 * (pool_create()). If an application allocates a record (pool_alloc()) the
 * record is moved to the list of used records and returned to the
 * unused-record-list if the record is free'd (pool_free()). This makes
 * pool allocations/deallocations very fast.
 *
 * 2. Taking records off the pool lists
 *
 * In case you want to place allocated records in own lists, you can
 * use POOL_SALLOC() which won't place the record on the pool's list of
 * used records. You *MUST* free those records with POOL_SFREE().
 */

#include <types.h>
#include <pool.h>
#include <error.h>
#include <main.h>
#include <libc.h>

/* Debugging messages. */
#ifdef DEBUGLOG_POOL
#define POOL_PRINTK(fmt, val)  printk (fmt, (int) val)
#define POOL_PRINTNHEX(fmt, val)  printnhex ((int) fmt, (int) val)
#else
#define POOL_PRINTK(fmt, val)
#define POOL_PRINTNHEX(fmt, val)
#endif

void *
pool_alloc (struct pool *pool)
{
    struct dequeue_node *rec;

    DEQUEUE_POP(&pool->unused, rec);
    if (rec == NULL)
	goto end;

    DEQUEUE_PUSH(&pool->used, rec);

    POOL_PRINTK("pool_alloc: ", 0);
    POOL_PRINTNHEX(ADDR2RAM(rec), 4);
    POOL_PRINTK("\n", 0);

end:
    return (void *) rec;
}

void *
pool_salloc (struct pool *pool)
{
    struct dequeue_node *rec;

    DEQUEUE_POP(&pool->unused, rec);
    if (rec == NULL)
	goto end;

    POOL_PRINTK("pool_alloc: ", 0);
    POOL_PRINTNHEX(ADDR2RAM(rec), 4);
    POOL_PRINTK("\n", 0);

end:
    return (void *) rec;
}

void
pool_free (struct pool *pool, void *rec)
{
    struct dequeue_node *r = rec;

    ASSERT_MEM(pool->area, r, "pool_free");

    POOL_PRINTK("pool_free: ", 0);
    POOL_PRINTNHEX(ADDR2RAM(r), 4);
    POOL_PRINTK("\n", 0);

    DEQUEUE_REMOVE(&pool->used, r);
    DEQUEUE_PUSH(&pool->unused, r);
}

/* Create dequeue from memory block. */
void*
pool_create (struct pool *pool, size_t size, size_t typesize)
{   
    struct dequeue_node *prev = NULL;
    struct dequeue_node *end;
    struct dequeue_node *i;
    struct dequeue_node *pos;
    struct dequeue_hdr  *list = &(pool->unused);

    size *= typesize;

    POOL_PRINTK(">pool_create: ", size);
    POOL_PRINTNHEX((size_t) pool, 8);
    POOL_PRINTK(" ", 0);
    POOL_PRINTNHEX(size, 4);
    POOL_PRINTK(" ", 0);
    POOL_PRINTNHEX(typesize, 4);
    POOL_PRINTK("\n", 0);

    pool->area = pos = i = kmalloc (size);
    if (i == NULL)
        return 0;
    end = (struct dequeue_node *) POINTER_ADD(pos, size);

    list->first = i;
    while (1) {
        i->prev = prev; 
        i->next = POINTER_ADD(i, typesize);
        if (i->next >= end) {
            i->next = 0;
            break;
        }
        prev = i;
        i = POINTER_ADD(i, typesize);
    }
    list->last = i;

    DEQUEUE_WIPE(&(pool->used));

    POOL_PRINTK("<pool_create: ", 0);
    POOL_PRINTNHEX(ADDR2RAM(pos), 4);
    POOL_PRINTK(" ! end: ", 0);
    POOL_PRINTNHEX(ADDR2RAM(end), 4);
    POOL_PRINTK("\n", 0);

    return pos;
}
