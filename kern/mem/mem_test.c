/*
 * tensix operating system project
 * Copyright (C) 2002, 2003, 2004 Sven Klose <pixel@hugbox.org>
 *
 * Dynamic memory management
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

#ifdef MEM_TEST_STRESS

void
mem_test_stress ()
{
    void **tmp = kmalloc (MEM_TEST_STRESS_FAKES * sizeof (void *));
    int i,j,cnt;
    int c = 0;
    int rand = 0;

    printk ("Memory stress test\n", 0);
    bzero (tmp, sizeof tmp);
    i = 0;
    j = MEM_TEST_STRESS_FAKES / 2;
    while (c++ < MEM_TEST_STRESS_RUNS) {
        cnt = 100000;
	printk ("\trun %d of ", c);
	printk ("%d.\n", MEM_TEST_STRESS_RUNS);

	while (cnt--) {
	    rand >>= 2;
            rand -= i;
	    rand += j;
	    rand ^= rand >> 1;
	    if (tmp[i] == NULL) {
                tmp[i] = kmalloc (rand & 2047);
                rand += (size_t) tmp[i++];
            }

	    if (tmp[j])
	        free (tmp[j]);
	    tmp[j] = NULL;
	    j--;

	    i &= MEM_TEST_STRESS_FAKES - 1;
	    j &= MEM_TEST_STRESS_FAKES - 1;
        }
    }

    for (i = 0; i < MEM_TEST_STRESS_FAKES; i++)
	if (tmp[i])
	   free (tmp[i]);
    free (tmp);

    /* There'll be less memory left due to fragment stack allocation. */
}

#endif /* #ifdef MEM_TEST_STRESS */
