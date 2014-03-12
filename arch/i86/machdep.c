/*
 * tensix operating system project
 * Copyright (C) 2002, 2003 Sven Klose <pixel@hugbox.org>
 *
 * i86 CPU driver
 *
 * $License$
 */

#include <proc.h>

void
machdep_proc_enter (proc, entry)
    struct proc *proc;
    void        *entry;
{
    u16_t *stack = POINTER_SUB(POINTER_ADD(proc->stack, proc->stacksize), 2);
    int   i;

    /*
     * Initialise register context. It is popped from the stack by the
     * switcher function machdep_switch().
     */
    *stack-- = proc_startup; /* return address */
    *stack-- = 0;	     /* flags */
    *stack-- = entry;	     /* ax */
    for (i = 6; i > 0; i--)  /* bx, cx, dx, si, di, bp */
         *stack-- = 0;

    proc->stack = stack;
}

void
machdep_switch_init ()
{
}
