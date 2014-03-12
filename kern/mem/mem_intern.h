/*
 * tensix operating system project
 * Copyright (C) 2002, 2003 Sven Klose <pixel@hugbox.org>
 *
 * Dynamic memory management.
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

#ifdef DEBUGLOG_MEM
#define MEM_PRINTK(fmt, val)  printk (fmt, (int) val)
#define MEM_PRINTNHEX(fmt, val)  printnhex ((int) fmt, (int) val)
#else
#define MEM_PRINTK(fmt, val)
#define MEM_PRINTNHEX(fmt, val)
#endif

EXTERN_LOCK_DEF(mem_bitmap_lock)

/* List of fragment stacks. */
#ifdef MEM_USE_FRAGMENTS
extern struct stack_hdr *fragment_stacks[FRAGMENT_SIZES];
EXTERN_LOCK_DEF(fragment_locks[FRAGMENT_SIZES])
#endif

#define MEM_PAGES_REF(page, num, proc) mem_pages_ref (page, num, 0, proc)

extern u8_t *page_map;  	      /* Bitmap of allocated pages. */
extern pageinfo_t *page_list;         /* Page info table. */
extern size_t mem_num_pages_free;     /* Number of free pages. */
extern size_t mem_num_pages_locked;   /* Number of locked pages. */

#ifdef MEM_USE_HINTS
extern pagenum_t mem_hint_top;
extern pagenum_t mem_hint_bottom;
#endif

#ifndef NATIVE
extern u8_t ram[RAMSIZE];

/* On a non-native environment check if pointer is inside ram array. */
#define RAMASSERT(p) \
     if (p && ((u8_t *) p < ram || (u8_t *) p > &ram[RAMSIZE - 1])) \
         panic ("Pointer outside memory.\n");
#else
#define RAMASSERT(p)
#endif

/* Make sure we have the memory dumper for the stress test. */
#ifdef MEM_TEST_STRESS
#ifndef MEM_DUMP
#define MEM_DUMP
#endif
#endif

/* Turn on all bzero options if desired. */
#ifdef MEM_BZERO
#ifndef MEM_BZERO_PAGE
#define MEM_BZERO_PAGE
#endif
#ifndef MEM_BZERO_FRAG
#define MEM_BZERO_FRAG
#endif
#endif
