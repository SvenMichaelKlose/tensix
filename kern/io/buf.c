/*
 * tensix operating system project
 * Copyright (C) 2002, 2003, 2004 Sven Klose <pixel@hugbox.org>
 *
 * I/O buffers
 *
 * $License$
 */

#include <config.h>
#include <types.h>
#include <dir.h>
#include <buf.h>
#include <mem.h>
#include <obj.h>
#include <lock.h>
#include <array.h>
#include <error.h>
#include <proc.h>
#include <obj.h>
#include <libc.h>
#include <main.h>
#include <string.h>
#include <syncer.h>
#include <machdep.h>
#include <xxx.h>

/* Free buffer list.
 *
 * This list contains a doubly-linked set of unused buffer descriptors.
 * If buffers are in use, they're placed in a list that belongs to the
 * according object.
 */
POOL_DECL(buffer_pool);

int buffers_in_use;

/*
 * Initialise this module.
 */
void
buf_init ()
{
    void   *pool;

    /* Create pool of buffer structures. */
    pool = POOL_CREATE(&buffer_pool, NUM_BUFS, struct buf);
    IASSERT(pool == 0, "buf_init: out of memory.");

    buffers_in_use = 0;

    VERBOSE_BOOT_PRINTK("io: %d bufs, ", (int) NUM_BUFS);
}

/*
 * Remove unused buffers from object.
 */
void
bcleanup (struct obj *obj)
{
    struct buf  *buf;
    register struct dequeue_hdr *objbufs;
    int restart = TRUE;

    /* Return buffer if it's in the object's buffer list. */
    objbufs = OBJ_BUFFERS(obj);
    while (restart != FALSE) {
	restart = FALSE;
        DEQUEUE_FOREACH(objbufs, buf) {
	    if (buf->refcnt != 0 || BUF_IS_DIRTY(buf) != FALSE)
		continue;
            bfree (buf);
            restart = TRUE;
            break;
	}
    }
}

/*
 * Remove unused buffers from all objects.
 */
void
bcleanup_glob ()
{
    struct obj  *i_obj;

    BUF_PRINTK("bcleanup_glob\n", 0);

    DEQUEUE_FOREACH(&obj_pool.used, i_obj)
	bcleanup (i_obj);
}

/*
 * Create a new empty buffer for an object.
 *
 * A data area of the object's block size is also allocated.
 * The created buffer is locked. It does NOT belong to a process.
 */
int
bcreate (struct buf **buf, struct obj *obj, blk_t blk)
{
    struct buf          *b;
    struct dequeue_hdr  *pool = &(buffer_pool.unused);

    /* Allocate new buffer from the free buffer list. */
    DEQUEUE_POP(pool, b);
    if (b == NULL) {
	/* We are out of buffer descriptors. Free unused buffers. */
	bcleanup_glob ();

	/* Try allocation once again. */
        DEQUEUE_POP(pool, b);
        ERRCHK(b == NULL, ENOMEM); /* Out of memory. */
    }

    /* Initialise buffer info. */
    BINIT(b, blk);
    b->obj = obj;
    _BREF(b);

    /* Allocate data area. */
    b->len = OBJ_BUFSIZE(obj);
    b->data = kmalloc (b->len);
    ERRGOTO(b->data == NULL, error); /* Out of memory? */

    /* Lock buffer (it is still invalid). */
    LOCK(b->lock);

    /* Add buffer to obj's buffer list. */
#ifdef BUF_SORT_REUSED
    /* Add new buffer to the end where it's removed fast if not reused. */
    DEQUEUE_PUSH(OBJ_BUFFERS(obj), b);
#else
    /*
     * Add new buffer to front of list. The oldest unused buffers are
     * removed first.
     */
    DEQUEUE_PUSH_FRONT(OBJ_BUFFERS(obj), b);
#endif

    buffers_in_use++;

    /* Return buffer pointer. */
    *buf = b;

    return ENONE;

error:
    /* Free buffer record. */
    DEQUEUE_PUSH(&buffer_pool.unused, b);

    return ENOMEM;
}

void
buf_print_owners (struct dequeue_hdr *list, struct buf *buf)
{
    struct buf  **bi;
    struct proc *pi;
    int safe = PROC_MAX;

    if (buf == NULL)
	panic ("buf_print_owners: no buf");

    DEQUEUE_FOREACH(list, pi) {
	SARRAY_FOREACH(struct buf *, pi->buffers, bi) {
	    if (*bi == buf) {
		printk (pi->name, 0);
		printk ("\n", 0);
	    }
            if (!safe--)
		panic ("buf_print_owners: proclist invalid");
	}
 	/* Process list is circular; break explicitly. */
        if (pi->next == list->first)
   	    break;
    }
}

/*
 * Remove buffer from obj list.
 *
 * NOTICE: Never use this function on buffers that are still in use.
 *
 * The buffer structure and the data area are both freed. The buffer must
 * be removed from process buffer lists before.
 */
int
bfree (struct buf *buf)
{
    struct obj *obj = buf->obj;

    ASSERT(obj == NULL, "bfree: no obj.");
    ASSERT(buf == NULL, "bfree: no buf.");
    ASSERT(BUF_IS_DIRTY(buf), "bfree: buf dirty.");
    ASSERT(buf->refcnt != 0, "bfree: buf in use.");

#ifdef DIAGNOSTICS
    if (buf->refcnt != 0) {
        printk ("bfree: proc %s: ", (size_t) CURRENT_PROC()->name);
        printk ("buf of obj %s also in use by ", (size_t) buf->obj->dirent->name);
        buf_print_owners (&procs_running, buf);
        printk ("\n", 0);
	return EINVAL;
/*
	((char *) 0)[0] = 0;
*/
    }
#endif

    /* We're about to modify the buffer list, so lock it. */
    HS_LOCK(obj->lock_buffers);

    /* Free buffer content. */
#ifdef BUF_SHARE_DATA
    if (buf->srcbuf == NULL)
#endif
        free (buf->data);

    /* Remove buffer from object. */
    DEQUEUE_REMOVE(OBJ_BUFFERS(obj), buf);

    /* Push it on the free buffer list. */
    DEQUEUE_PUSH(&buffer_pool.unused, buf);

    buffers_in_use--;

    HS_UNLOCK(obj->lock_buffers);

    return ENONE;
}

/*
 * Lookup cached buffer from object.
 */
void
blookup (struct buf **buf, struct obj *obj, blk_t blk)
{
    struct buf  *i_buf;
    register struct dequeue_hdr *objbufs;

    /* Lock buffer list. */
    HS_LOCK(obj->lock_buffers);

    /* Search buffer list. */
    objbufs = OBJ_BUFFERS(obj);
    DEQUEUE_FOREACH(objbufs, i_buf) {
	if (OBJ_IS_STREAM(obj) == FALSE) {
	    /* Random-access: Continue, if it's not the right block number. */
            if (i_buf->blk != blk)
	        continue;
	} else {
	    /* Stream: Ignore buffers that are not marked as fresh. */
	    if (BUF_IS_DIRTY(i_buf) != FALSE || BUF_IS_FRESH(i_buf) == FALSE)
                continue;
        }

	/* Reference buffer so it won't be lost after unlock. */
        _BREF(i_buf);
	BUF_UNSET_FRESH(i_buf);

	BUF_PRINTK("blookup(): buffer reused.\n", 0);

#ifdef BUF_SORT_REUSED
	if (OBJ_IS_STREAM(obj) == FALSE) {
	    /* Move reused buffer to the front where it is found faster. */
            DEQUEUE_REMOVE(OBJ_BUFFERS(obj), i_buf);
            DEQUEUE_PUSH_FRONT(OBJ_BUFFERS(obj), i_buf);
	}
#endif

	/* Return pointer to buffer. */
	*buf = i_buf;

	break;
    }

    /* Unlock buffer list. */
    HS_UNLOCK(obj->lock_buffers);
}

/*
 * Lookup/create and read a buffer and/or increment its reference count.
 */
int
bread (struct buf **buf, struct obj *obj, blk_t blk, bool zero)
{
    int    err;
    size_t tmp;

    ASSERT(obj == NULL, "bread: no obj.");
    ASSERT(buf == NULL, "bread: no buf.");
    ASSERT(blk == 65535, "bread: blk must be < 65535.");

    /* Reuse buffers already in memory. */
    blookup (buf, obj, blk);
    if (*buf != NULL)
	return ENONE;

    /* Create new buffer. */
    err = bcreate (buf, obj, blk);
    ERRCODE(err);

    /*
     * Do I/O if buffer is not beyond the object size or if the object is a
     * stream.
     */
    if ((!zero && blk < obj->size) || OBJ_IS_STREAM(obj)) {
        err = obj_io (*buf, obj, blk, IO_R);
        ERRCODE(err);
    }

    /* Mark stream file buffer, so it can be looked up. */
    if (OBJ_IS_STREAM(obj) != FALSE) {
        BUF_SET_FRESH(*buf);
    }

    /* Truncate buffer, matching byte granularity of file length. */
    if (!OBJ_IS_STREAM(obj) && blk == (obj->size - 1) && obj->dirent != NULL) {
        tmp = obj->dirent->size % OBJ_BLKSIZE(obj);
        if (tmp)
            (*buf)->len = tmp;
    }

    /* Unlock buffer for other processes. */
    UNLOCK((*buf)->lock);

    return ENONE;
}

/*
 * Mark a buffer dirty and increment the dirty buffer count in its object.
 */
void
_bdirty (struct buf *buf)
{
#ifdef BUF_SHARE_DATA
    /* Get source buffer. */
    while (buf->srcbuf != NULL)
	buf = buf->srcbuf;
#endif

    HS_LOCK(buf->lock);

    /* Don't mark buffer dirty twice. */
    if (buf->state & BUF_DIRTY)
	return;

    buf->state |= BUF_DIRTY;
    buf->obj->dirtybufs++;

    HS_UNLOCK(buf->lock);
}
