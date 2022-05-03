/*
 * tensix operating system project
 * Copyright (C) 2002, 2003 Sven Klose <pixel@hugbox.org>
 *
 * machine-dependent functions
 *
 * $License$
 */

#include <config.h>

#include <proc.h>
#include <libc.h>
#include <main.h>
#include <machdep.h>

/*
 * Machine dependent functions.
 *
 * This functions must be provided by a machine-dependent driver in arch/.
 */
extern void machdep_wrap_proc_enter (void *context, void *nextcontext, void *startup_func, void *entry, void *stack, size_t stacksize);
extern void machdep_wrap_switch (void *oldcontext, void *newcontext);
extern void machdep_wrap_initial_switch (void *context);

/*
 * Initialise the switcher.
 */
void
machdep_switch_init ()
{
#ifdef DEBUGLOG_MACHDEP
    printk ("machdep_switchinit(%d)\n ", CURRENT_PROC()->machdep);
#endif

    machdep_wrap_initial_switch (CURRENT_PROC()->machdep);

#ifdef DEBUGLOG_MACHDEP
    printk ("<machdep_switchinit()\n ", 0);
#endif
}

/*
 * Initialise context for new task.
 */
void
machdep_proc_enter (proc, entry)
    struct proc *proc;
    void *entry;
{
    machdep_wrap_proc_enter ((void *) proc->machdep, NULL, proc_startup, entry, proc->stack, proc->stacksize);
}

/*
 * Perform context switch.
 */
void
machdep_switch ()
{
    if (proc_context == NULL) {
#ifdef DEBUGLOG_MACHDEP
        printk ("machdep_switch(): no context to switch from\n ", 0);
#endif
	    return;
    }

    /* Print debug info. */
#ifdef DEBUGLOG_MACHDEP
    printk ("switch from ", 0);
    printnhex (proc_context, 8);
    printk ("(%s)", proc_context->name);
    printk (" to ", 0);
#endif

    CURRENT_PROC() = (struct proc *) CURRENT_PROC()->next;

#ifdef DEBUGLOG_MACHDEP
    printnhex (CURRENT_PROC(), 8);
    printk ("(%s)", CURRENT_PROC()->name);
    printk ("\n", 0);
#endif

    /* Check if stack boundary was overwritten. */
    if ((*(u32_t *) CURRENT_PROC()->stack) != 0)
	    panic ("proc crossed stack boundary.\n");

#ifdef DIAGNOSTICS
    if ((CURRENT_PROC()->state & PROC_RUNNING) == FALSE)
	    panic ("machdep_switch(): proc is not running.\n");
#endif

#ifndef PROC_NO_TICKS
    CURRENT_PROC()->ticks_run++;
#endif

    machdep_wrap_switch (proc_context->machdep, CURRENT_PROC()->machdep);
    proc_context = CURRENT_PROC();

#ifdef DEBUGLOG_MACHDEP
    printk ("\n*** SWITCH TO '%s' ***\n", proc_context->name);
#endif

#ifdef DEBUGLOG_MACHDEP
    printk ("out with context ", 0);
    printnhex (proc_context, 8);
    printk ("\n", 0);
#endif
}

void
reboot ()
{
    machdep_reboot ();
}
