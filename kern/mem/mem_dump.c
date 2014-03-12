/*
 * tensix operating system project
 * Copyright (C) 2002, 2003, 2004, 2005 Sven Klose <pixel@hugbox.org>
 *
 * Status dump
 *
 * $License$
 */

#include <types.h>
#include <bitmap.h>
#include <string.h>
#include <mem.h>
#include <libc.h>
#include <error.h>
#include <main.h>
#include <proc.h>
#include <lock.h>

#include "./mem_intern.h"

#ifdef MEM_DUMP

/* Print debug dump of page allocations. */
void
mem_dump ()
{
    int i;
    int c = 0;
    int ct = 0;
#if 0
    int f128;
    int f64;
    int f32;
#endif

    printk ("page map: *=locked, 0-3=page or frag, []=multipage, .=free\n", 0);
    for (i = 0; i < NUM_PAGES; i++) {
        ct = PAGE_CONT(i);
        if (!(i % 16) && i != 0)
            printk ("\n", 0);
        if (!(i % 16)) {
            printnhex (PAGESIZE * i, 4);
            printk (": ", 0);
        }
        if (PAGE_LOCKED(i)) {
            printk ("* ", 0);
            ct = 0;
        } else if (PAGE_USED(i)) {
            if (FRAGLOG(i) == 0)
               printk (ct ? (!c ? "[ " : "X ") : (c ? "] " : "0 "), 0);
            else
               printk ("%d ", FRAGLOG(i));
        } else 
            printk (". ", 0); /* free */
        if ((i % 4) == 3)
            printk (" ", 0);
        c = ct;
    }

#if 0
/* For each process. */
#ifdef MEM_USE_FRAGMENTS
    f128 = STACK_NUMENTRIES(fragment_stacks[0]);
    f64 = STACK_NUMENTRIES(fragment_stacks[1]);
    f32 = STACK_NUMENTRIES(fragment_stacks[2]);
    printk ("\nFragments: %d (128b), ", f128);
    printk ("%d (64b), ", f64);
    printk ("%d (32b); ", f32);
#endif
#endif
    printk ("\n%d bytes free.\n", (int) (PAGESIZE * mem_num_pages_free));
}

#endif /* #ifdef MEM_DUMP */
