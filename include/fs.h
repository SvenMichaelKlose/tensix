/*
 * tensix operating system project
 * Copyright (C) 2002, 2003, 2004, 2005 Sven Klose <pixel@copei.de>
 *
 * Filesystem interface
 *
 * $License$
 */

#ifndef _SYS_FS_H
#define _SYS_FS_H

#ifndef NO_BOOKKEEPING
#define FS_ALLOCOBJHDL(tmpptr, proc) \
    tmpptr = SARRAY_ADD(struct obj *, (proc)->objects);

/* Allocate entry in process' dir list. */
#define FS_ADDDIR2PROC(diriter) \
    diriter = SARRAY_ADD(struct dir *, CURRENT_PROC()->dirs); \
    ERRCHK((void *) diriter == NULL, ENOMEM); \
    *diriter = KTMALLOC(struct dir);
    
/* Remove entry from process' list of objects. */
#define FS_DEALLOCOBJHDL(tmpiter, procobj, proc) \
    SARRAY_ERASEQ(struct obj *, (proc)->objects, tmpiter, procobj);
    
/* Remove entry from process' list of directory handles. */
#define FS_RMDIRFROMPROC(tmpiter, procdir, proc) \
    SARRAY_ERASEQ(struct dir *, (proc)->dirs, tmpiter, procdir);
        
#else   
#define FS_ADDOBJ2PROC(ptr, obj)
#define FS_RMOBJFROMPROC(procobj, tmpiter)
#endif

extern int dup (char *src, char *destdir, char *destname);
extern int create (struct obj **, struct obj *dir, int type, char *name);
extern int open (struct obj **, char *pathname);
extern int close (struct obj *obj);
extern int unlink (char *path);
extern int dir_open (struct dir **, struct obj *);
extern int dir_close (struct dir *);

/* Prepare process structure for namespace use. */
extern int fs_init_proc (struct proc *);

#ifndef NO_BOOKKEEPING
/* Free namespace proc infos. */
extern void fs_kill_proc (struct proc *);
#endif

/*
 * Allocate object buffer like bio() and add it to the current process'
 * buffer list. This way the reference counts can be corrected if
 * a process exits.
 */
#define IO_CREATE    1  /* Create non-existent buffers automatically. */
#define IO_NOWAIT    2  /* Don't wait for stream data. */
#define IO_ZERO      3  /* Return empty buffer (don;t read). */
extern int bref (struct buf **, struct obj *, blk_t, u8_t mode);

/* Decrement reference count of buffer. */
extern void bunref (struct buf *);

/* Write buffer back to object immediately. */
extern int bwrite (struct buf *);

/* Write buffer immediately and decrement its reference count. */
extern int bsend (struct buf *); /* bwrite() and bunref(). */

/* Mark buffer as dirty. */
extern void _bdirty (struct buf *); /* Internal function. Don't use. */
#define BDIRTY(buf)      _bdirty (buf);
#define BDUNREF(buf)      _bdirty (buf); bunref (buf)

/* Get address of first byte that follows buffer data. */
#define BUF_END(buf, ofs)      (POINTER_ADD((buf)->len, (buf)->data))

#endif /* #ifndef _SYS_FS_H */
