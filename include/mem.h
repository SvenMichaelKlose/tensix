/*
 * tensix operating system project
 * Copyright (C) 2002, 2003, 2004, 2005 Sven Klose <pixel@copei.de>
 *
 * Dynamic memory management
 *
 * $License$
 */

#ifndef _SYS_MEM_H
#define _SYS_MEM_H

#include <types.h>
#include <bitmap.h>
#include <queue.h>

/*
 * Pages.
 */

/* By default the kernel is compiled as an executable for the host platform. */
#ifndef NATIVE
extern u8_t ram[RAMSIZE]; /* Simulated RAM. */
#define ADDR2RAM(addr)  ((size_t) POINTER_SUB(addr, ram))
#define RAM2ADDR(addr)  ((void *) POINTER_ADD(addr, ram))
#else
#define ram 0
#define ADDR2RAM(addr)  ((size_t) addr)
#define RAM2ADDR(addr)  (addr)
#endif

/* Logarithmic page size. */
#ifndef PAGESIZE_LOG
#error PAGESIZE_LOG missing.
#endif

/* Size of all pages. */
#define PAGESIZE	(1 << PAGESIZE_LOG)

/* Total number of pages. */
#define NUM_PAGES	(RAMSIZE / PAGESIZE)

/* Data type of page number. */
#if NUM_PAGES < 257
typedef u8_t pagenum_t;
#else
typedef u16_t pagenum_t;
#endif

/* Page table info mask. */
#define PFRAG FRAGMENT_SIZES	   /* Fragment size mask. */
#define PCONT (FRAGMENT_SIZES + 1) /* Page is continued by next. */
#define PPROC ((PROC_MAX - 1) * PCONT * 2) /* Process the page belongs to. */

/* Address to page number translation. */
#ifndef ADDR2PAGE
#define ADDR2PAGE(addr) (ADDR2RAM(addr) >> PAGESIZE_LOG)
#endif

/* Page number to address translation. */
#ifndef PAGE2ADDR
#define PAGE2ADDR(page) (RAM2ADDR(page * PAGESIZE))
#endif

/* Page info type. */
typedef u8_t pageinfo_t;

/* Global page list. */
extern pageinfo_t *page_list;

/* Access to page list entries. */
#ifndef PAGEINFO
#define PAGEINFO(page)	(page_list[page])
#endif

/* Set page info in list. */
#ifndef PAGEINFO_SET
#define PAGEINFO_SET(page, fsize, cont, proc)	\
   (PAGEINFO(page) = fsize | (cont ? PCONT : 0) | PCONT * 2 * proc)
#endif

/* Test if page is continued by next. */
#define PAGE_CONT(page)		(PAGEINFO(page) & PCONT)

/* Get process id. */
#define PAGE_PROC(page)		(PAGEINFO(page) / PCONT / 2)

/* Mark page as being used. */
#define PAGE_ALLOC(page, fsize, cont, proc)                            \
	page_alloc(page, fsize, cont, proc)

#if 0
   mem_num_pages_free--;                                               \
   BITMAP_SET(page_map, page, TRUE);                                   \
   PAGEINFO_SET(page, fsize, cont, proc)
#endif

/* Mark page as being unused. */
#define PAGE_FREE(page) \
   BITMAP_SET(page_map, page, FALSE); \
   PAGEINFO_SET(page, 0, 0, 0);       \
   mem_num_pages_free++

/* Test if page is used. */
#define PAGE_USED(page)		BITMAP_GET(page_map, page)

/*
 * Mark page as locked.
 *
 * Locked pages cannot be freed. They have a fragment size plus a
 * continuation flag (PCONT) which makes no sense so far.
 */
#define PAGE_LOCK(page)                         \
    if (PAGE_LOCKED(page) == FALSE) {		\
        BITMAP_SET(page_map, page, TRUE);       \
        PAGE_ALLOC(page, 1, 1, 0);              \
        mem_num_pages_locked++;			\
    }

/* Check if page is locked forever. */
#define PAGE_LOCKED(page)	(PAGE_CONT(page) && FRAGLOG(page))

/*
 * Page fragments.
 */

/* Data type for logarithmic fragment sizes. */
typedef u8_t fragsize_t;

/* Mininum logarithmic fragment size. */
#ifndef FRAGSIZEMIN_LOG
#error FRAGSIZEMIN_LOG missing.
#endif

/* Minimum fragment size in bytes. */
#define FRAGSIZEMIN	(1 << FRAGSIZEMIN_LOG)

/* Number of fragment sizes. */
#define FRAGMENT_SIZES	(PAGESIZE_LOG - FRAGSIZEMIN_LOG)

/* Read logarithmic fragment size. */
#define FRAGLOG(page)	(PAGEINFO(page) & PFRAG)

/* Read fragment size in bytes from page table. */
#define FRAGSIZE(page)    ((1 << PAGESIZE_LOG) >> FRAGLOG(page))

/* Get logarithmic fragment size. */
#define FRAGSIZELOG(page) (PAGESIZE_LOG - FRAGLOG(page))

/* Translate logarithmic fragment size to number of fragments. */
#define FRAGLOG2NUM(fs)	(1 << fs)

/* Bytes left on fragment stack. */
#define FRAGSPACE(proc, fs)	\
    (PAGESIZE - STACK_SIZE(FRAG_STACK(proc, fs), struct fragment *))

/* Translate address to fragment index in its page. */
#define ADDR2FRAGIDX(pos) \
   ((fragsize_t) ((size_t) ADDR2RAM(pos) % PAGESIZE) / FRAGSIZE(ADDR2PAGE(pos)))

/* Check if address points to a legal fragment start. */
#define IS_ILLEGAL_FRAG(pos) \
   ((size_t) ADDR2RAM(pos) & (FRAGSIZE(ADDR2PAGE(pos)) - 1))

/* Get fragment stack for logarithmic fragment size. */
#define FRAG_STACK(proc, fs)		(proc->fragment_stacks[(fs) - 1])

/* Entry in fragment stack. */
struct fragment {
   pagenum_t  page;
   fragsize_t idx;  /* Fragment index and process id. */
};

/* Check if fragment stack contains anything. */
#define FRAG_AVAILABLE(stack)	STACK_NUMENTRIES(stack)

/* Push new element on fragment stack. */
#define FRAG_PUSH(stack)	STACK_PUSH(stack, struct fragment)

/* Pop element on fragment stack. */
#define FRAG_POP(stack)		STACK_POP(stack, struct fragment)

/*
 * Kernel area.
 */

#ifndef KERNEL_START
#error KERNEL_START missing.
#endif

#ifndef KERNEL_END
#error KERNEL_END missing. (Address of last byte occupied).
#endif

/* Data area created by the compiler. */
#define KERNEL_DATA_PAGES	1

#define KERNEL_STARTPAGE	(KERNEL_START / PAGESIZE)
#define KERNEL_ENDPAGE		(KERNEL_END / PAGESIZE)
#define KERNEL_PAGES \
   (KERNEL_ENDPAGE - KERNEL_STARTPAGE + KERNEL_DATA_PAGES)

/*
 * Memory management tables.
 * Use a whole page for each fragment stack.
 */
#define MMANAGER_PAGES     FRAGMENT_SIZES
#ifndef MMANAGER_STARTPAGE
#define MMANAGER_STARTPAGE missing.
#endif

extern void *malloc (size_t len);  /* Allocate memory block. */
extern void *kmalloc (size_t len); /* Allocate kernel memory block. */
struct proc;
extern void *pmalloc (size_t len, struct proc *proc); /* Allocate kernel memory block. */
extern void free (void* block);    /* Free memory block. */

extern void freep (void* block, struct proc *);    /* Free memory block. */

extern void mem_init (); 	        /* Initialise memory manager. */

extern void page_alloc (pagenum_t, fragsize_t, bool, proc_t);

#ifndef NO_BOOKKEEPING
/* Free all memory occupied by a process. */
extern void mem_init_proc (struct proc *proc);
extern void mem_kill_proc (struct proc *proc);
#endif

/* Allocate single space for a data type. */
#define PTMALLOC(type, proc)  ((type*) pmalloc (sizeof (type), proc))
#define KTMALLOC(type)        ((type*) kmalloc (sizeof (type)))

/* Allocate multiple space for a data type. */
#define PTCMALLOC(type, count, proc)   ((type*) pmalloc (sizeof (type) * count, proc))
#define KTCMALLOC(type, count)  ((type*) kmalloc (sizeof (type) * count))

#ifdef MEM_DUMP
extern void mem_dump ();
#endif

#ifdef DIAGNOSTICS
extern void mem_boundary (void* area, void *ptr, char *msg);
#define ASSERT_MEM(area, ptr, msg) (mem_boundary (area, (void *) ptr, msg))
#else
#define ASSERT_MEM(area, ptr, msg)
#endif

#endif /* #ifndef _SYS_MEM_H */
