/*
 * tensix operating system project
 * Copyright (C) 2002, 2003, 2004, 2005 Sven Klose <pixel@copei.de>
 *
 * unix platform driver
 * machine-dependent functions (libc wrapper).
 *
 * $License$
 */

#include <stdlib.h>
#include <unistd.h>
#include <ucontext.h>

extern void panic (char *msg);

void
machdep_wrap_proc_enter (context, nextcontext, startup_func, func, stack, stacksize)
    void        *context;
    void        *nextcontext;
    void        *startup_func;
    void        *func;
    void        *stack;
    size_t      stacksize;
{
    ucontext_t *con = (ucontext_t *) context;
    if (stacksize < 4096)    /* FreeBSD implementation checks this for sigs */
        stacksize = 4096;

    getcontext (con);
    con->uc_stack.ss_sp = stack;
    con->uc_stack.ss_size = stacksize;
    con->uc_stack.ss_flags = 0;
    con->uc_link = NULL; /* startup_func should never return. */
    makecontext (con, startup_func, 1, func);
}

void
machdep_wrap_switch (oldcontext, newcontext)
    void        *oldcontext;
    void        *newcontext;
{
    int err;

    err = swapcontext ((ucontext_t *) oldcontext, (ucontext_t *) newcontext);

    if (err)
	panic ("machdep_wrap_switch(): err\n");
}

void
machdep_wrap_initial_switch (context)
    void  *context;
{
    setcontext ((ucontext_t *) context);
}

void
machdep_reboot ()
{
    exit (0);
}
