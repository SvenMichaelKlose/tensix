/*
 * tensix operating system project
 * Copyright (C) 2002, 2003, 2004, 2005 Sven Klose <pixel@copei.de>
 *
 * Machine-dependent functions
 *
 * $License$
 */

#ifndef _SYS_MACHDEP_H
#define _SYS_MACHDEP_H

#include <config.h>

#ifdef MULTITASKING
extern void machdep_init ();
extern void machdep_switch_enable ();
extern void machdep_switch_init ();
extern void machdep_switch ();
extern void machdep_proc_enter (struct proc *proc, void *entry);
extern void machdep_reboot ();

#define SWITCH()      		(machdep_switch ())
#define MACHDEP_SWITCH_INIT()	(machdep_switch_init ())

#else /* #ifdef MULTITASKING */

#define SWITCH()
#define MACHDEP_SWITCH_INIT()

#endif /* #ifdef MULTITASKING */

/* Hardware interrupt context switching. */
#define STI()
#define CLI()

#define SWITCH_ON()
#define SWITCH_OFF()

#endif /* #ifndef _SYS_MACHDEP_H */
