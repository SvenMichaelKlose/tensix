/*
 * tensix operating system project
 * Copyright (C) 2002, 2003, 2004, 2005 Sven Klose <pixel@copei.de>
 *
 * I/O daemon
 *
 * $License$
 */

#ifndef _SYS_IO_H
#define _SYS_IO_H

#include <types.h>

#define IODCMD_CREATE    1
#define IODCMD_DESTROY   2

struct iod_cmd_create {
    struct obj  *from;
    struct obj  *to;
    u8_t   flags;
    void   *id;   /* 0 if unsuccessful. */
};

#define IOD_INIT_CMD_CREATE(iod_cmd, src, dst, flgs) \
	iod_cmd->type = IODCMD_CREATE; \
	iod_cmd->param.create.from = src; \
	iod_cmd->param.create.to = dst;   \
	iod_cmd->param.create.flags = flgs;

struct iod_cmd_destroy {
    void  *id;
};

struct iod_cmd {
    int   type;
    union {
	struct iod_cmd_create   create;
	struct iod_cmd_destroy  destroy;
    } param;
};

struct iod_chn_intr {
    struct buf  *buf_current;
    struct buf  *buf_free;
};

/*
 * I/O channel descriptor.
 */
struct iod_chn {
    DEQUEUE_NODE_DECL();
    struct obj  *from;
    struct obj  *to;
    blk_t	blk_from;
    blk_t	blk_to;

    struct buf  *dstbuf;	/* Helpers for buffer split. */
    void 	*dstdata;
    fsize_t	dstrest;

    u8_t        flags;         /* IODCHN_* */
};

#define IODCHN_ACTIVE  1 /* Tell that buffers were filled. */
#define IODCHN_INTR  2 /* Source object is interrupt driven. */
#define IODCHN_POLL  4 /* Source object is polled. */
#define IODCHN_AUTOCLOSE  8 /* Close channel and unref objects automatically. */
#define IODCHN_IMMEDIATE  16 /* Copy in process context (process waits). */
#define IODCHN_PUSH  32 /* Prepare buffers in advance. */

/* Mask of user-settable flags */
#define IODCHN_ALL \
    (IODCHN_INTR | IODCHN_POLL | IODCHN_AUTOCLOSE | IODCHN_IMMEDIATE | \
     IODCHN_PUSH)

#define IODCHN_IS_ACTIVE(chn)  (chn->flags & IODCHN_ACTIVE)
#define IODCHN_IS_POLLED(chn)  (chn->flags & IODCHN_POLL)
#define IODCHN_IS_AUTOCLOSED(chn)  (chn->flags & IODCHN_AUTOCLOSE)
#define IODCHN_IS_IMMEDIATE(chn)  (chn->flags & IODCHN_IMMEDIATE)
#define IODCHN_IS_PUSHED(chn)  (chn->flags & IODCHN_PUSH)
#define IODCHN_SET_ACTIVE(chn)  (chn->flags |= IODCHN_ACTIVE)
#define IODCHN_SET_INACTIVE(chn)  (chn->flags &= ~IODCHN_ACTIVE)

extern struct proc *iod_proc;  /* iod process info. */
extern u8_t iod_restart;

void iod ();                   /* I/O daemon main loop. */

/* For obj.c only. */
void iod_obj_free (struct obj *);
void iod_chn_wakeup (struct iod_chn *);
void iod_chn_sleep (struct iod_chn *);

#define IOD_START()  proc_funexec (&iod_proc, iod, 0, 0, IOD_STACKSIZE, "iod");

#endif /* #ifndef _SYS_IO_H */
