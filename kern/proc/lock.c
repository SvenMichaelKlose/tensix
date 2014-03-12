/*
 * tensix operating system project
 * Copyright (C) 2002, 2003, 2004, 2005 Sven Klose <pixel@hugbox.org>
 *
 * Process locking
 *
 * $License$
 *
 * About this file:
 *
 * Locks are implemented as semaphores. Semaphores allow virtually any number
 * of tasks that own it. If a process tries to set a lock that is already set,
 * it is put to sleep until the lock is released. If more than one task waits
 * for a lock the order in which they're waked up is undefined.
 *
 * If a process dies, the lock it owns is released automatically.
 */

#include <config.h>
#include <types.h>
#include <array.h>
#include <libc.h>
#include <lock.h>
#include <proc.h>
#include <machdep.h>
#include <main.h>
#include <string.h>

#ifdef LOCKS

/* Debugging messages. */
#ifdef DEBUGLOG_LOCK
#define LOCK_PRINTK(fmt, val)  printk (fmt, (int) val)
#define LOCK_PRINTNHEX(fmt, val)  printnhex ((int) fmt, (int) val)
#else
#define LOCK_PRINTK(fmt, val)
#define LOCK_PRINTNHEX(fmt, val)
#endif
/*
 * Reference a lock.
 *
 * If the lock is already referenced by another process, the current
 * process is put to sleep until it is woken up by lock_unref().
 * A process waiting for lock can't be just waked up using proc_wakeup(),
 * because the process state has PROC_LOCKED set.
 */
void
lock_ref2 (lock_t *lockp, bool do_wait)
{
    struct proc *proc = CURRENT_PROC();

    LOCK_PRINTK("lock: %d\n", lockp);

    /* Stop switching to other user processes. */
    SWITCH_OFF();

    /* Increment lock count. */
    (*lockp)++;

    /* Return if we're the first who set the lock (others must wait). */
    if (do_wait == FALSE && *lockp == 1) {
        SWITCH_ON();
	return;
    }

    /* Fill in info to get unlocked. */
    proc->lock = lockp;

    /* Wait until lock is free again. */
    do {
        sleep (); /* Sleep. Will put switching on again. */

	/* We might have been waked up for other reasons. */
	if (proc->lock == NULL)
	    break; /* Ok, we're let loose. */
    } while (1);
}

void
lock_ref (lock_t *lockp)
{
    lock_ref2 (lockp, FALSE);
}

void
lock_ref_wait (lock_t *lockp)
{
    lock_ref2 (lockp, TRUE);
}

/* Wakeup one process waiting for this lock. */
void
lock_wakeup (lock_t *lockp)
{
    struct proc *i_proc = (struct proc *) CURRENT_PROC();

    do {
        if (i_proc->lock != lockp) {
	    i_proc = (struct proc*) i_proc->next;
	    continue;
        }

        /* Clear lock pointer in process. */
        i_proc->lock = NULL;

        /* Wakeup process. */
        proc_wakeup (i_proc);

        break;
    } while (i_proc != CURRENT_PROC());
}
/*
 * Dereference a lock.
 *
 * A random other process waiting for the lock is woken up.
 */
void
lock_unref (lock_t *lockp)
{
    LOCK_PRINTK("unlock: %d\n", lockp);

#ifdef DIAGNOSTICS
    /* Allow this function to be called with a NULL pointer. */
    if (lockp == NULL)
	panic ("lock_unref(): NULL ptr arg");
#endif

    SWITCH_OFF(); /* We can't use lock() here. :) */

#ifndef NO_CHECKS
    /* Check if lock is in use, panic if not. */
    if (*lockp == 0) {
	LOCK_PRINTNHEX((unsigned int) lockp, 4);
	panic ("Lock underflow.");
    }
#endif

    /* Decrement lock count. */
    (*lockp)--;

    /* Break, if no-one is waiting for the lock. */
    if (*lockp != 0)
  	lock_wakeup (lockp);

    SWITCH_ON();
}

void
lock_read_ref (struct rwlock_t *lockp)
{
    LOCK_PRINTK("lock_read_ref: %d\n", lockp);

    /* Stop switching to other user processes. */
    SWITCH_OFF();

    while (1) {
        /* Increment pass-by count. */
        if (!lockp->lock) {
            lockp->passed++;
	    break;
        }

	/* A writer occupied the lock, wait for its release. */
	lock_ref (&lockp->lock);
	lock_unref (&lockp->lock);
    }

    SWITCH_ON();
}


void
lock_write_ref (struct rwlock_t *lockp)
{
    LOCK_PRINTK("lock_write_ref: %d\n", lockp);

    /* Stop switching to other user processes. */
    SWITCH_OFF();

    if (lockp->passed) {
        lockp->lock++;
	lock_ref (&lockp->lock);
        lockp->lock--;
    } else
	lock_ref (&lockp->lock);
}

/*
 * Dereference a lock.
 *
 * A random other process waiting for the lock is woken up.
 */
void
lock_read_unref (struct rwlock_t *lockp)
{
    LOCK_PRINTK("lock_read_unref: %d\n", lockp);

#ifdef DIAGNOSTICS
    /* Allow this function to be called with a NULL pointer. */
    if (lockp == NULL)
	panic ("lock_read_unref(): NULL ptr arg");
#endif

    SWITCH_OFF(); /* We can't use lock() here. :) */

#ifndef NO_CHECKS
    /* Check if lock is in use, panic if not. */
    if (lockp->passed == 0) {
	LOCK_PRINTNHEX((unsigned int) lockp, 4);
	panic ("Read lock underflow.");
    }
#endif

    if ((!--lockp->passed) && (lockp->lock))
        lock_wakeup (&lockp->lock);

    SWITCH_ON();
}

#endif /* #ifdef LOCKS */
