/*
 * tensix operating system project
 * Copyright (C) 2002, 2003 Sven Klose <pixel@hugbox.org>
 *
 * Initial process
 *
 * $License$
 */

#include <types.h>
#include <dir.h>
#include <buf.h>
#include <mem.h>
#include <obj.h>
#include <main.h>
#include <libc.h>
#include <namespace.h>
#include <proc.h>
#include <string.h>
#include <fs.h>
#include <main.h>
#include <sh.h>
#include <syncer.h>
#include <iod.h>
#include <tests.h>

/* Execute initial shell script. */
void
init_script ()
{
    /* Mount local filesystem. */
    sh_parse_cmdline ("dup /wrapfs / local");
    sh_parse_cmdline ("help intro");
}

/* Initialisation in multiprocessing mode. */
void
init ()
{
    struct proc *dummy;

    VERBOSE_BOOT_PRINTK(TXT_GOING_MULTIPROC, 0);

    /* Start kernel daemons. */
#ifndef NO_IO
    /* Start syncer daemon. */
    SYNCER_START();

    /* Start I/O daemon. */
    IOD_START();
#endif

#ifndef NO_IO
    /* Initialise driver objects. */
    obj_classes_init ();
#endif

    /* Start init shell script. */
    VERBOSE_BOOT_PRINTK(TXT_GOING_INIT, 0);
    init_script ();
/*
    PROC_FUNEXEC(&dummy, init_script, 0, 0, SH_STACKSIZE, "sh");
*/

#ifdef DIAGNOSTICS
    tests ();
#endif

    /* Start boot shell for the user. */
    PROC_FUNEXEC(&dummy, sh, 0, 0, SH_STACKSIZE, "sh");

#ifndef NO_RESIDENT_INIT
    sleep ();
#endif
}
