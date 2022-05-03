/*
 * tensix operating system project
 * Copyright (C) 2002, 2003, 2004, 2005 Sven Klose <pixel@c-base.org>
 *
 * File system calls
 *
 * $License$
 */

#include <config.h>
#include <dir.h>
#include <error.h>
#include <libc.h>
#include <obj.h>
#include <namespace.h>
#include <dirent.h>
#include <proc.h>
#include <string.h>
#include <machdep.h>
#include <fs.h>
#include <xxx.h>
#include <buf.h>
#include <main.h>
#include <syncer.h>

#ifdef DEBUGLOG_FS
#define FS_PRINTK(fmt, val)  printk (fmt, (int) val)
#define FS_PRINTNHEX(fmt, val)  printnhex ((int) fmt, (int) val)
#else
#define FS_PRINTK(fmt, val)
#define FS_PRINTNHEX(fmt, val)
#endif

/*
 * Open file.
 */
int
open2 (struct obj **file)
{
#ifndef NO_BOOKKEEPING
    struct obj **p_obj;
#endif

    FS_ALLOCOBJHDL(p_obj, CURRENT_PROC());
    ERRCHK(((void *) p_obj) == NULL, ENOMEM);
    *p_obj = *file;
    OBJ_REF(*file);
    MANUAL_SWITCH();
    FS_PRINTK("<open: %d\n", *file);

    return ENONE;
}

/*
 * Open file.
 */
int
open (struct obj **file, char *name)
{
    int err;

    FS_PRINTK("open '%s'\n", name);
    err = namespace_lookup_path (file, name);
    ERRCODE(err);

    return open2 (file);
}

/*
 * Open file in directory.
 */
int
openr (struct obj **file, struct obj * dir, char *name)
{
    int err;

    FS_PRINTK("open '%s'\n", name);
    err = namespace_lookup (file, dir, name);
    ERRCODE(err);

    return open2 (file);
}

/*
 * Close file
 *
 * Remove object from process' object list.
 */
int
closep (struct obj *obj, struct proc *proc)
{
    struct obj **i_obj;

    FS_PRINTK("close ", 0);
    FS_PRINTNHEX(obj, 8);
    FS_PRINTK(".\n", 0);

#ifndef NO_CHECKS
    if (obj == NULL) {
        FS_PRINTK("<close: NULL object\n", 0);
	return ENONE;
    }
#endif

    ASSERT_MEM(obj_pool.area, obj, "close"); /* Make sure the object is in the object pool. */
    FS_DEALLOCOBJHDL(i_obj, obj, proc);
    OBJ_UNREF(obj);
    MANUAL_SWITCH();

    return ENONE;
}

int
close (struct obj *obj)
{
    return closep (obj, CURRENT_PROC());
}

/*
 * Create a file.
 */
int
create (struct obj **retobj, struct obj *dirobj, int type, char *name)
{
#ifndef NO_BOOKKEEPING
    struct obj **p_obj;
#endif
    int err = 0;

    FS_PRINTK("create '%s'\n", name);
    ASSERT_MEM(obj_pool.area, dirobj, "create(dir)");

#ifndef NO_CHECKS
    /* Check type argument. */
    ERRCHK(type != OBJ_TYPE_FILE && type != OBJ_TYPE_DIR, EINVAL);
#endif

    *retobj = NULL;

    if (OBJ_OPS(dirobj)->create == NULL) {
    	FS_PRINTK("<create: not supported\n", err);
		return ENOTSUP;
    }

    /* Check if element of that name already exists. */
    err = namespace_lookup (retobj, dirobj, name);
    ERRCGOTO(err == ENONE, EEXISTS, error);
    ERRCGOTO(err != ENOTFOUND, err, error);

    if (*retobj != NULL) {
        OBJ_UNREF(*retobj);

        err = EINVAL;
        goto error;
    }

    /* Let vfs create the object and its directory entry. */
    err = obj_create (retobj, dirobj, type, name);
    ERRCGOTO(err, err, error);

    /* Reference object. */
    OBJ_REF(*retobj);

    FS_ALLOCOBJHDL(p_obj, CURRENT_PROC());
    ERRCGOTO((void *) p_obj == NULL, ENOMEM, error);
    *p_obj = *retobj;

error:
    FS_PRINTK("<create: %d\n", err);
    MANUAL_SWITCH();

    return err;
}

/*
 * Unlink object.
 */
int
unlink (char *path)
{
    struct obj  *obj;
    int         err;

    FS_PRINTK("unlink '%s'\n", path);

    /* Get object. */
    err = open (&obj, path);
    ERRCODE(err);

    /* Stop other processes from accessing the object pool. */
    LOCK(obj_pool.lock);

    /* Check if object is in use. */
    if (obj->refcnt != 1)
		err = EBUSY;

    close (obj);

    /* Remove object from vfs. */
    if (err == ENONE)
        err = obj_unlink (obj);

    /* Allow access to object pool again. */
    UNLOCK(obj_pool.lock);

    FS_PRINTK("<unlink\n", 0);

    MANUAL_SWITCH();

    return err;
}

/* Unref directory. */
int
_dir_close (struct dir *dir, struct proc *proc)
{
    struct dir **i_dir;

    OBJ_UNREF(dir->obj);
    freep (dir, proc);
    FS_RMDIRFROMPROC(i_dir, dir, proc);

    return ENONE;
}

/* Open directory. */
int
dir_open (struct dir **dir, struct obj *obj)
{
    struct dir **p_dir;
    int err;

#ifdef DEBUGLOG_FS
    if (obj->dirent)
        printk ("dir_open (\"%s\")\n", (int) obj->dirent->name);
    else
        printk ("dir_open (root dir)\n", 0);
#endif

    *dir = NULL;

    FS_ADDDIR2PROC(p_dir);

    *dir = *p_dir;
    (*dir)->obj = obj;
    (*dir)->next = 0;
    OBJ_REF(obj);

    err = obj_dir_open (*dir);

    if (err != ENONE)
        _dir_close (*p_dir, CURRENT_PROC());

    FS_PRINTK("<dir_open: %d\n", err);
    return err;
}

/* Close directory. */
int
dir_closep (struct dir *dir, struct proc *proc)
{
    int err;

#ifdef DEBUGLOG_FS
    struct obj *obj = dir->obj;
    if (obj->dirent)
        printk ("dir_close (\"%s\")\n", (int) obj->dirent->name);
    else
        printk ("dir_close (root dir)\n", 0);
#endif

    if (OBJ_OPS(dir->obj)->dir_close != NULL) {
        err = obj_dir_close (dir);
        ERRCODE(err);
    }

    _dir_close (dir, proc);

    FS_PRINTK("<dir_close\n", 0);
    return ENONE;
}

/* Close directory. */
int
dir_close (struct dir *dir)
{
    return dir_closep (dir, CURRENT_PROC());
}

/* Duplicate object. */
int
dup (char *src, char *destdir, char *destname)
{
    struct obj  *srcobj;
    struct obj  *dstobj;
    struct obj  *obj;
    int err;

    FS_PRINTK("dup (\"%s\", ", src);
    FS_PRINTK("\"%s\", ", destdir);
    FS_PRINTK("\"%s\")\n", destname);

    err = open (&srcobj, src);
    ERRCODE(err);

    err = open (&dstobj, destdir);
    if (err != ENONE)
	    goto error;

    /* Check if destination object already exists. */
    err = namespace_lookup (&obj, dstobj, destname);
    if (err != ENOTFOUND) {
        ERRGOTO(err, error2);
        ERRCGOTO(obj != NULL, EINVAL, error2);
    }

    err = obj_dup (srcobj, dstobj, destname);

error2:
    close (dstobj);

error:
    close (srcobj);

    FS_PRINTK("<dup: %d\n", err);

    return err;
}

/*
 * Write a buffer via object.
 *
 * The buffer is immediately written via the object.
 * Also undirty buffers are written.
 */
int
bwrite (struct buf *buf)
{
    /* We can only write existing buffers. */
    ERRCHK(buf == NULL, EINVAL);

    ASSERT_MEM(buffer_pool.area, buf, "bwrite");

    /* Mark this buffer as clean and new. */
    if (BUF_IS_DIRTY(buf)) {
        CLI();
        BUF_UNSET_DIRTY(buf);
        buf->obj->dirtybufs--;
#ifdef DIAGNOSTICS
        if (buf->obj->dirtybufs == 0xff)
	    panic ("bwrite: dirtybufs underflow");
#endif
        STI();
    }

    return obj_io (buf, buf->obj, buf->blk, IO_W);
}

/*
 * Write a buffer and unreference it.
 */
int
bsend (struct buf *buf)
{
    int err = bwrite (buf);
    ERRCODE(err);

    bunref (buf);

    return err;
}

/*
 * Allocate buffer for logical file block at index 'blk' in object 'obj'.
 * The buffer size is determined by the object driver and can be read using the
 * OBJ_BUFSIZE() macro.
 */
int
bref (struct buf **buf, struct obj *obj, blk_t blk, u8_t mode)
{
    struct buf  **new;
    int         err;

    BUF_PRINTK("bref '%s'", obj->dirent->name);
    BUF_PRINTK(" '%d'\n", (size_t) blk);

    MANUAL_SWITCH();

#ifndef NO_CHECKS
    ERRCHK(obj == NULL || buf == NULL, EINVAL);

    /* Don't accept unknown flags. */
    ERRCHK(mode & ~(IO_CREATE | IO_NOWAIT | IO_ZERO), EINVAL);
#endif

    /* Return NULL if function fails. */
    *buf = NULL;

    if (OBJ_HAS_OP(obj,io) == FALSE)
		return ENOTSUP;

    /* Handle stream file. */
    if (OBJ_IS_STREAM(obj) != FALSE) {
        /* Create an empty buffer for stream writeback on IO_CREATE. */
        if (mode & IO_CREATE) {
	    	err = bcreate (buf, obj, 0);
            ERRCODE(err);

	    	UNLOCK((*buf)->lock);
	    	goto reg_buf;
		}
		/* Don't wait for incoming blocks if IO_NOWAIT is specified. */
		if ((mode & IO_NOWAIT) && OBJ_HAS_FRESH(obj) == FALSE )
            return ENOIODATA;
    } else {
		/* Don't create buffers that extend the file if IO_CREATE is unset. */
        if (((mode & IO_CREATE) == FALSE) && (blk >= OBJ_SIZE(obj)))
	    	return ENOIODATA;
    }

    /* Read/create the buffer. */
    err = bread (buf, obj, blk, mode & IO_ZERO);
    ERRCODE(err);

    /* Add buffer to process buffer list. */
reg_buf:
#ifndef NO_BOOKKEEPING
#ifndef NO_PROC
    new = SARRAY_ADD(struct buf*, PROC_BUFFERS(CURRENT_PROC()));
    if (new == NULL) {
        bfree (*buf);
	    return ENOMEM;
    }
    *new = *buf;
#endif
#endif

    return ENONE;
}

/*
 * Deallocate a buffer.
 *
 * The buffer's reference count is decremented and its removed
 * from the current process' buffer list.
 *
 * For kernel buffers the _BUNREF() macro must be used.
 */
void
bunrefp (struct buf *buf, struct proc *proc)
{
    struct buf      **i_buf;
    struct buf      **procbufs;

    /* Ignore NULL pointer. */
    if (buf == NULL) {
        BUF_PRINTK("bunref NULL\n", 0);
		return;
    }

    BUF_PRINTK("bunref '%s'\n", buf->obj->dirent->name);

    ASSERT_MEM(buffer_pool.area, buf, "bunref");
    ASSERT(buf->refcnt == 0, "buf_unref): refcnt underflow.\n");
    ASSERT(buf->obj == NULL, "bunref: no obj in buf.");

    /* Lock buffer so we can modify it. */
    LOCK(buf->lock);

#ifdef BUF_SHARE_DATA
    /* Decrement reference count in shared source buffer. */
    if (buf->srcbuf != NULL)
        _BUNREF(buf->srcbuf);
#endif

    /* Decrement reference count. */
    _BUNREF(buf);

#ifndef NO_BOOKKEEPING
    procbufs = PROC_BUFFERS(proc);

    /* Remove buffer from process buffer list. */
    SARRAY_ERASEQ(struct buf*, procbufs, i_buf, buf);
#endif

    UNLOCK(buf->lock);

    /*
     * Kill unreferenced and clean stream buffers right here because
     * they're ignored by blookup() and the syncer.
     */
    if (OBJ_IS_STREAM(buf->obj) != FALSE && buf->refcnt == 0 && (BUF_IS_DIRTY(buf)) == FALSE)
		bfree (buf);

    /* Restart the syncer, so the buffer is written as soon as possible. */
    if (BUF_IS_DIRTY(buf) != FALSE)
        SYNCER_RESTART();

    MANUAL_SWITCH();
}

void
bunref (struct buf *buf)
{
    bunrefp (buf, CURRENT_PROC());
}

#ifdef BUF_SHARE_DATA
/*
 * Share buffer.
 *
 * Make new buffer which points to (partial) data of another.
 */
int
bdup (struct buf **ret, struct buf *srcbuf, struct obj *obj, blk_t blk,
      size_t ofs, size_t len)
{
    struct buf  *b;
    size_t      start;
    size_t      end;

    /* Get starting adress of window. */
    start = (size_t) srcbuf->data;
    end = (size_t) srcbuf->len + start;
    start += ofs + len;

#ifndef NO_CHECKS
    /* Check if window is inside the data area. */
    if (start >= end)
		return EINVAL; /* No, error. */
#endif

    /* Create new buffer in object. */
    err = bcreate (ret, obj, blk);
    ERRCHK(err);
    b = *ret;

    /* Update block dimensions and source entry. */
    b->data = (void *) start;
    b->len = len;
    b->srcbuf = srcbuf;

    /* Avoid source buffer to be erased before the duplicate. */
    _BREF(srcbuf);

    UNLOCK(b);

    return ENONE;
}
#endif

#ifdef BUF_JIT_STREAMS
/*
 * Wait for just-in-time stream buffer content to complete.
 */
void
bfreeze (struct buf *buf, size_t maxlen)
{
    HS_LOCK(buf->lock);

    /* Do nothing if the block size is already smaller. */
    if (BUF_BLKSIZE(buf) >= maxlen)
    	/* Set new length to freeze fill-up. */
    	buf->freezelen = maxlen;

    HS_UNLOCK(buf->lock);
}
#endif

#ifndef NO_PROC

/*
 * Prepare process for namespace use.
 */
int
fs_init_proc (struct proc *proc)
{
#ifndef NO_BOOKKEEPING
    /* Allocate list of buffers and objects used by the process. */
    proc->buffers = PTCMALLOC(struct buf*, BUFS_PER_PROC, proc);
    ERRCHK((void *) proc->buffers == NULL, ENOMEM);
    proc->objects = PTCMALLOC(struct obj*, OBJS_PER_PROC, proc);
    ERRCHK((void *) proc->objects == NULL, ENOMEM);
    proc->dirs = PTCMALLOC(struct dir*, DIRS_PER_PROC, proc);
    ERRCHK((void *) proc->dirs == NULL, ENOMEM);
#endif

    /* Determine path working directory (same as parent process or root.) */
    proc->pwd = (proc_context == NULL || proc_current == NULL) ? namespace_root_obj : CURRENT_PROC()->pwd;

    OBJ_REF(proc->pwd);

    return ENONE;
}

#ifndef NO_BOOKKEEPING
/*
 * Remove management info of a process.
 */
void
fs_kill_proc (struct proc *proc)
{
    struct buf **i_buf;
    struct obj **i_obj;
    struct dir **i_dir;

    /* Unreference buffers and objects still open. */
    if ((void *) proc->dirs != NULL)
        SARRAY_FOREACH(struct dir*, proc->dirs, i_dir)
	    dir_closep (*i_dir, proc);
    if ((void *) proc->buffers != NULL)
        SARRAY_FOREACH(struct buf*, proc->buffers, i_buf)
	    bunrefp (*i_buf, proc);
    if ((void *) proc->objects != NULL)
        SARRAY_FOREACH(struct obj*, proc->objects, i_obj)
	    closep (*i_obj, proc);

    /* Free list of buffers and objects. */
    free ((void *) proc->buffers);
    free ((void *) proc->objects);
}
#endif

#endif
