/*
 * tensix operating system project
 * Copyright (C) 2002, 2003, 2004, 2005 Sven klose <pixel@copei.de>
 *
 * Syncer daemon
 *
 * $License$
 */

#ifndef _SYS_SYNCER_H
#define _SYS_SYNCER_H

#ifdef SYNCER

#include <config.h>

/* Syncer start at boot-time (see kern/init.c). */
#define SYNCER_START() \
    proc_funexec (&syncer_proc, syncer, 0, 0, SYNCER_STACKSIZE, "syncer");  

/*
 * Wake-up syncer for write-back or cause current write-back to rerun if
 * finished.
 */
#define _SYNCER_RESTART \
    { \
        syncer_restart = TRUE; \
        proc_wakeup (syncer_proc); \
    }

#ifdef SYNCER_AVOID_WAKEUP
#define SYNCER_RESTART() if (syncer_restart == FALSE) _SYNCER_RESTART
#else
#define SYNCER_RESTART() _SYNCER_RESTART
#endif

extern struct proc *syncer_proc;
extern u8_t syncer_restart;

#else /* #ifdef SYNCER */

#define SYNCER_START()
#define SYNCER_RESTART() syncer ()

#endif /* #ifdef SYNCER */

extern void syncer ();

#endif /* #ifndef _SYS_SYNCER_H */
