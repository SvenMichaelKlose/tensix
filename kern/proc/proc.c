/*
 * tensix operating system project
 * Copyright (c) 2002-2005 Sven Klose <pixel@c-base.org>
 *
 * Process management
 *
 * $License$
 *
 * About this file:
 *
 * Process descriptors are held in three lists: the proc_pool, containing
 * unused records, a cyclic list of running processes and one of sleeping
 * processes.
 * The task switcher is supposed to step over the list of running processes.
 */

#include <types.h>
#include <proc.h>
#include <namespace.h>
#include <error.h>
#include <machdep.h>
#include <libc.h>
#include <main.h>
#include <fs.h>
#include <xxx.h>

#ifndef NO_PROC

/* Debugging messages. */
#ifdef DEBUGLOG_PROC
#define PROC_PRINTK(fmt, val)  printk (fmt, (int) val)
#define PROC_PRINTNHEX(fmt, val)  printnhex ((int) fmt, (int) val)
#else
#define PROC_PRINTK(fmt, val)
#define PROC_PRINTNHEX(fmt, val)
#endif

struct proc *proc_current;     /* Currently running process. */
struct proc *proc_context;     /* Currently running process,
				  unmodified by proc_sleep(). */

struct proc proc_holographic;

proc_t proc_id;                /* Process ID counter. */

POOL_DECL(proc_pool);          /* Pool of unused proc structs. */
DEQUEUE_DECL(procs_running);   /* Running processes. */
DEQUEUE_DECL(procs_sleeping);  /* Sleeping processes. */

/*
 * Initialise this module.
 */
void
proc_init ()
{
    void *p;

    proc_id = -1; /* Holographic proc id must be -1! */

    /* Allocate proc descriptor pool. */
    p = POOL_CREATE(&proc_pool, PROC_MAX, struct proc);
    IASSERT(p == NULL, "proc: no mem");

    /* Wipe the list headers. */
    DEQUEUE_WIPE(&procs_sleeping);
    DEQUEUE_WIPE(&procs_running);

    /* Set up a holographic process. */
    /* proc_create (&proc_current, "holographic"); */
    proc_current->name = "holographic";
#if 0
    /* Holographic proc doesn't require I/O. */
#ifndef NO_IO
    fs_kill_proc (proc_current);
#endif
    proc_holographic = proc_current;
#endif

    proc_context = NULL; /* Do not switch! */

    VERBOSE_BOOT_PRINTK("proc: %d tasks.\n", PROC_MAX);
}

/*
 * Create new sleeping task.
 *
 * This creates and registers a new process.
 * Code, data and stack areas are NOT created.
 */
int
proc_create (struct proc **proc, char *name)
{
    struct proc *p;
    int err;

    PROC_PRINTK("proc_create: '%s'\n", name);

    /* Get a free process descriptor. */
    p = POOL_SALLOC(&proc_pool);
    ERRCHK(p == NULL, ENOMEM);
    p->name = name;
    p->state = 0;
#ifndef PROC_NO_TICKS
    p->ticks_run = 0;
#endif
    p->id = proc_id;

    /* TODO: Collision check missing. */
    proc_id++;
    if (proc_id == 0)
	    proc_id = 1;

    /* Initialise process-related memory management. */
    mem_init_proc (p);

#ifndef NO_IO
    /* Initialise everything needed by the filesystem for this process. */
    err = fs_init_proc (p);
    if (err != ENONE) {
        /* Return descriptor to pool. */
        POOL_SFREE(&proc_pool, p);
	    return err;
    }
#endif

    /* The process should sleep until it's ready to run. */
    CLIST_INSERT(&procs_sleeping, p);

    *proc = p;

    return ENONE;
}

/*
 * Run a created process.
 *
 * 'proc' takes a process descriptor created by proc_create() and should
 * have the codesize, datasize and stacksize fields filled in.
 *
 * For simplicity only the stack is allocated until everything _works_.
 */
int
proc_exec (struct proc *proc, void *entry)
{
#ifndef MULTITASKING
    PROC_PRINTK("proc_exec: '%s'\n", proc->name);
    return (*(func_t) entry) ();
#else
    int err;

    /* Allocate stack. */
    if (proc->stacksize != 0) {
        proc->stack = pmalloc (proc->stacksize, proc);
        ERRCGOTO(proc->stack == NULL, ENOMEM, error1);
    }

    /* Have CPU state initialised. */
    proc->machdep = pmalloc (PAGESIZE * 4, proc);
    PROC_PRINTK("proc_exec: calling machdep_proc_enter\n", 0);
    machdep_proc_enter (proc, entry);
    PROC_PRINTK("proc_exec: return from machdep_proc_enter\n", 0);

    /* Move process to running list. */
    proc_wakeup (proc);
    MANUAL_SWITCH();

    PROC_PRINTK("<proc_exec id=%d\n", proc->id);

    return ENONE;

error1:
    return err;
#endif
}

#ifdef MULTITASKING
/*
 * Startup process.
 */
void
proc_startup (void *func)
{
    PROC_PRINTK("proc_startup ", 0);
    PROC_PRINTNHEX(func, 8);
    PROC_PRINTK("\n", 0);

    proc_context = CURRENT_PROC(); /* XXX explain this. */
    ASSERT(func == NULL, "proc_startup: no entry\n");
    ((func_t) func) ();

    exit (ENONE);
}
#endif /* #ifdef MULTITASKING */

void
proc_kill (struct proc *proc)
{
    struct proc *next;

    PROC_PRINTK("proc_kill: '%s' ", proc->name);
    PROC_PRINTNHEX(proc, 8);
    PROC_PRINTK("\n", 0);

    /* Release lock held by the process. */
    LOCK_KILL_PROC(proc);

#ifndef NO_BOOKKEEPING
    /* Let filesystem free objects, buffers and dirents. */
    fs_kill_proc (proc);

    /* Free memory still occupied by the process. */
    mem_kill_proc (proc);
#endif

    /* Force process to be on the running list. */
    proc_wakeup (proc);

    /* Stop switcher and other processes from accessing the process list. */
    SWITCH_OFF();

    next = (struct proc *) proc->next;
    if (next == proc_current)
		next = NULL;

    /* Remove descriptor from the list. */
    CLIST_REMOVE(&procs_running, proc);

    /* Return descriptor back to pool. */
    POOL_SFREE(&proc_pool, proc);

    /* Avoid switch to sleeping process. */
    if (proc == proc_current) {
        if (next != NULL)
	    	proc_current = (struct proc *) next->prev;
        else
            proc_current = next;
    }

#ifdef MANUAL_SWITCH
    /* Shutdown if no processes are running. */
    if (proc_current == NULL)
        shutdown ();
#endif

    SWITCH_ON();
}

/*
 * Kill the current process and switch out.
 */
void
exit (int code)
{
    proc_kill (proc_current);

    /* Stop this process by switching to the next. */
    SWITCH();

#ifdef DIAGNOSTICS
    panic ("proc_startup() shouldn't return!");
#endif

    /*NOTREACHED*/
}

/*
 * Execute function as a new process.
 */
int
proc_funexec (struct proc ** ret, void *func, size_t codesize, size_t datasize, size_t stacksize, char *name)
{
    struct proc *p;
    int err;

    err = proc_create (ret, name);
    ERRCODE(err);
    p = *ret;

    p->codesize = codesize;
    p->datasize = datasize;
    if (stacksize < 4096)
	    stacksize = 4096;
    p->stacksize = stacksize;

    err = proc_exec (p, func);
    if (err != ENONE)
        proc_kill (p);

    return err;
}

/*
 * Put process to sleep.
 */
void
proc_sleep (struct proc *proc)
{
    struct proc *next;

    PROC_PRINTK("proc_sleep\n", proc);
    SWITCH_OFF();

    /* Don't wakeup processes that are already running. */
    if ((proc->state & PROC_RUNNING) == FALSE) {
	    PROC_PRINTK("proc_sleep: no reason", 0);
        PROC_PRINTNHEX(proc, 8);
	    PROC_PRINTK("\n", 0);
	    goto end;
    }

    /* Don't wakeup processes waiting for locks. */
    if (proc->lock != NULL)
	    goto end;

    /* Put of scheduler because we'd be lost after a switch if we're
     * removed from the process lists. */
    proc->state &= ~PROC_RUNNING;
    next = (struct proc *) proc->next;

    /* Move process to list of sleeping processes. */
    CLIST_REMOVE(&procs_running, proc);
    CLIST_INSERT(&procs_sleeping, proc);

    /* Continue multiprocessing. */
    SWITCH_ON();

    if (proc == proc_current) {
	    PROC_PRINTK("proc_sleep(): '%s' nodds off.\n", proc->name);
	    proc_current = (struct proc *) next->prev;
	    SWITCH();
    } else
	    PROC_PRINTK("proc_sleep(): '%s' asleep.\n", proc->name);

    return;
end:
    SWITCH_ON();
}

/*
 * Wakeup process.
 */
void
proc_wakeup (struct proc *proc)
{
    PROC_PRINTK("proc_wakeup\n", 0);

    /* Turn off scheduler because we'd be lost after a switch if we're
     * removed from the process lists. */
    SWITCH_OFF();

    if (proc->state & PROC_RUNNING) {
	    PROC_PRINTK("proc_wakeup: %d already up", proc);
        PROC_PRINTNHEX(proc, 8);
	    PROC_PRINTK("\n", 0);
	    goto already_up;
    }

    proc->state |= PROC_RUNNING;

    /* Move process to list of running processes. */
    CLIST_REMOVE(&procs_sleeping, proc);
    CLIST_INSERT(&procs_running, proc);

    /* Continue multiprocessing. */
already_up:
    SWITCH_ON();
}

/*
 * Put current process to sleep.
 */
void
sleep ()
{
    PROC_PRINTK("sleep ", 0);
    PROC_PRINTNHEX(proc_current, 8);
    PROC_PRINTK("\n", 0);

    proc_sleep (proc_current);
}

#endif
