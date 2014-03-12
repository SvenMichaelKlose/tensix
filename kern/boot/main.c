/*
 * tensix operating system project
 * Copyright (C) 2002, 2003 Sven Klose <pixel@hugbox.org>
 *
 * Top-level
 *
 * $License$
 */

#include <config_deps.h>
#include <types.h>
#include <dir.h>
#include <buf.h>
#include <mem.h>
#include <obj.h>
#include <crt0.h>
#include <main.h>
#include <proc.h>
#include <machdep.h>
#include <libc.h>
#include <namespace.h>
#include <string.h>
#include <init.h>
#include <con.h>
#include <syncer.h>
#include <iod.h>

/* Gracefully shut down everything. */
void
shutdown ()
{
    VERBOSE_PRINTK("\nHALT\n", 0);

    con_in ();
    reboot ();
}

void
panic (char *msg)
{
    printk ("panic: %s\n", (int) msg);
    *(char *)0 = 0;

    shutdown ();
}

/*
 * Kernel entry point.
 */
void
main ()
{
    /* Tell everyone that we're not having processes yet.
     * This is quite practical for the system call layer.
     */
    PROC_INIT_BOOT();

    VERBOSE_BOOT_PRINTK(TXT_WELCOME, 0);

    /*
     * Initialise memory management. Prepare use of malloc() and free(). The
     * kernel code and stack is locked out. See also kern/pool.c and array.c.
     */
    mem_init ();

#ifndef NO_IO
    /*
     * Prepare pool of I/O buffers.
     */
    buf_init ();

    /*
     * Prepare object, class, subclass and dirent pools,
     */
    obj_init ();

    /*
     * Initialise filesystem namespace.
     */
    namespace_init ();
#endif

#ifndef NO_PROC
    /*
     * Init process management and holographic process, so I/O services
     * can be used.
     */
    proc_init ();
#endif

    /*
     * Replace holographic process by init process. This function
     * does not return.
     */
    PROC_RUN_FIRST(init, 0, 0, INIT_STACKSIZE);

    /*NOTREACHED*/
}
