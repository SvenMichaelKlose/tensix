/*
 * tensix operating system project
 * Copyright (C) 2002, 2003, 2004, 2005 Sven Klose <pixel@copei.de>
 *
 * Process management
 *
 * $License$
 */

#ifndef _SYS_PROC_H
#define _SYS_PROC_H

#include <config.h>
#include <queue.h>
#include <lock.h>

#define CURRENT_PROC() proc_current

/* States. */
#define PROC_RUNNING   1

struct proc {
    DEQUEUE_NODE_DECL();

    /* I/O system */
    struct obj         *pwd;      /* Current working directory. */
#ifndef NO_BOOKKEEPING
    struct obj         **objects; /* Pointers to referenced objects. */
    struct buf         **buffers; /* Pointers to referenced buffers. */
    struct dir         **dirs;    /* Directory handles. */
#endif

    /* memory management */
    void    *stack;
    size_t  stacksize;
    void    *code;
    size_t  codesize;
    void    *data;
    size_t  datasize;
#ifdef MEM_USE_FRAGMENTS
    struct  stack_hdr  *fragment_stacks[FRAGMENT_SIZES];
    HS_LOCK_DEF(fragment_locks[FRAGMENT_SIZES])
#endif

    /* switcher */
    void   *machdep;
    u8_t   state;

#ifdef LOCKS
    /* locking */
    lock_t  *lock;      /* Address of lock held by the process. */
#endif

    /* process management */
#ifndef PROC_NO_TICKS
    u32_t  ticks_run;
#endif
    proc_t id;
    char *name;
};

/* Circular process lists. Use CLIST+* instead of DEQUEUE_* */
extern DEQUEUE_DECL(procs_running);
extern DEQUEUE_DECL(procs_sleeping);

#define PROC_BUFFERS(procp) (procp->buffers)

/* Pointer to current process descriptor. */
extern struct proc *proc_current;

extern struct proc proc_holographic;

/*
 * This is for the switch routine, so it can save the current context even
 * if proc_current was modified by proc_sleep.
 */
extern struct proc *proc_context;

/* Initialise process management. */
extern void proc_init();

/* Make a process sleep. */
extern void proc_sleep (struct proc *);

/* Make a process run. */
extern void proc_wakeup (struct proc *);

/* Create a process descriptor. */
extern int proc_create (struct proc **, char *name);

/* Kill a process. */
/* XXX no need if no MULTITASKING */
extern void proc_kill (struct proc *);

/* Execute a process. */
extern int proc_exec (struct proc *, void *entry);

/* Execute function as a new process. */
extern int proc_funexec (struct proc **, void *func, size_t codesize, size_t datasize, size_t stacksize, char *name);

/* Terminate current process with exit status. */
extern void exit (int);

/* Put current process to sleep. */
extern void sleep ();

#ifdef MULTITASKING
/* Startup a process. */
extern void proc_startup (void *entry);
#endif

#ifdef DIAGNOSTICS
extern void proc_count_procs ();
#endif

#ifndef NO_PROC

/* Use this right in the head of the main function. */
#define PROC_INIT_BOOT()  proc_current = &proc_holographic;

#define PROC_RUN_FIRST(func, codesize, datasize, stacksize) \
    proc_funexec (&(CURRENT_PROC()), init, codesize, datasize, stacksize, "init"); \
    free (PAGE2ADDR(KERNEL_STACKPAGE));                                  \
    MACHDEP_SWITCH_INIT()

#define PROC_FUNEXEC(ret, func, codesize, datasize, stacksize, name) \
    proc_funexec (ret, *func, codesize, datasize, stacksize, name)

#else /* #ifndef NO_PROC */

#define PROC_RUN_FIRST(func, codesize, datasize, stacksize) \
    init ()

#define PROC_FUNEXEC(func, codesize, datasize, stacksize, name) \
    func ()

#define PROC_INIT_BOOT()

#endif /* #ifndef NO_PROC */

#ifdef NO_SWITCH_TIMER
#define MANUAL_SWITCH() SWITCH()
#else
#define MANUAL_SWITCH()
#endif

#endif /* #ifndef _SYS_PROC_H */
