/*
 * tensix operating system project
 * Copyright (C) 2002, 2003, 2004, 2005 Sven Klose <pixel@copei.de>
 *
 * Locks
 *
 * $License$
 */

#ifndef _SYS_LOCK_H
#define _SYS_LOCK_H

#include <types.h>
#include <config.h>

/* Use no locks? */
#ifdef LOCKS

typedef u8_t lock_t;     /* Lock counter. */

struct rwlock_t {
    refcnt_t  passed;
    u8_t      lock;
};

extern void lock_ref (lock_t *);
extern void lock_ref_wait (lock_t *);
extern void lock_unref (lock_t *);

/*
 * General locking.
 */
#define LOCK_DEF(name)         lock_t name;
#define EXTERN_LOCK_DEF(name)  extern lock_t name;
#define LOCK_INIT(lock)        (&(lock) = 0)
#define LOCK(lock)             lock_ref (&(lock))
#define LOCKED(lock)           (lock != 0)
#define UNLOCK(lock)           lock_unref (&(lock))

/*
 * Locks for read/write operations.
 */
#define RWLOCK_DEF(name)      lock_t name
#define RWLOCK_INIT(lock)     (lock)->passed = 0; LOCK_INIT((lock)->lock)
#define RWLOCK_READ(name)     lock_read_ref (&(lock))
#define RWUNLOCK_READ(name)   lock_read_unref (&(lock))
#define RWLOCK_WRITE(name)    lock_write_ref (&(lock))
#define RWUNLOCK_WRITE(name)  lock_unref (&((lock)->lock))

#define LOCK_KILL_PROC(proc) if (proc->lock) lock_unref (proc->lock)

#else /* #ifdef LOCKS */

#define LOCK_DEF(name)
#define LOCK_INIT(lock)
#define LOCK(lock)
#define LOCKED(lock)
#define UNLOCK(lock)
#define LOCK_KILL_PROC(proc)

#define RWLOCK_DEF(name)
#define RWLOCK_INIT(lock)
#define RWLOCK_READ(name)
#define RWUNLOCK_READ(name)
#define RWLOCK_WRITE(name)
#define RWUNLOCK_WRITE(name)

#endif /* #ifndef LOCKS */

/*
 * This locks are only compiled if task switching is interrupt driven and
 * can occur anytime.
 */
#ifdef NO_SWITCH_TIMER

#define HS_LOCK_DEF(name)
#define HS_LOCK_INIT(lock)
#define HS_LOCK(lock)
#define HS_UNLOCK(lock)

#else /* #ifdef NO_SWITCH_TIMER */

#define HS_LOCK_DEF(name)		LOCK_DEF(name)
#define HS_LOCK_INIT(lock)		LOCK_INIT(lock)
#define HS_LOCK(lock)			LOCK(lock)
#define HS_UNLOCK(lock)			UNLOCK(lock)

#endif /* #ifdef NO_SWITCH_TIMER */

#define SPINLOCK(test)	\
    while (test) {	\
	MANUAL_SWITCH(); \
    }

#endif /* #ifndef _SYS_LOCK_H */
