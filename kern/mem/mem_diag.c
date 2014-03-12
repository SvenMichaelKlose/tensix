/*
 * tensix operating system project
 * Copyright (C) 2002, 2003, 2004, 2005 Sven Klose <pixel@hugbox.org>
 *
 * Memory management diagnostics.
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

#ifdef DIAGNOSTICS

/* Check if pointer is inside an area of one or more continguous ppages. */
void
mem_boundary_page (pagenum_t parea, pagenum_t pptr, char *msg)
{
    pagenum_t  p = parea;
    pageinfo_t cont; /* Continuation flag (PCONT). */

    if (PAGE_USED(p) == FALSE)
	panic ("%s: page not in use.");

    /* Check if the page continues the previous. */
    if (PAGE_LOCKED(p - 1) == 0 && PAGE_CONT(p - 1) != 0)
	panic ("%s: no page start.");

    /* Count number of pages. */
    do {
	cont = PAGE_CONT(p);
	if (p == pptr)
	    return;
        p++; /* Next page. */
    } while (cont); /* Continued by next. */

    panic ("%s: ptr outside page area.");
}

/* Check if pointer is inside a fragment area. */
void
mem_boundary_frag (void *area, pagenum_t parea, void *ptr, pagenum_t pptr, char *msg)
{
    size_t fsize = FRAGSIZE(pptr);

    if (parea != pptr)
	panic ("%s: ptr outside frag page");

    if (IS_ILLEGAL_FRAG(area))
	panic ("%s: no frag  start");

    if (ptr > POINTER_ADD(area, fsize))
	panic ("%s: ptr outside frag area");
}

void
mem_boundary (void *area, void *ptr, char *msg)
{
    pagenum_t parea = ADDR2PAGE(area);
    pagenum_t pptr = ADDR2PAGE(ptr);

    /* Detect whether to check a page or fragment area. */
    if (FRAGLOG(pptr) == 0)    /* Fragment size in page info? */
	mem_boundary_page (parea, pptr, msg);
    else
	mem_boundary_frag (area, parea, ptr, pptr, msg);
}

#endif /* #ifdef DIAGNOSTICS */
