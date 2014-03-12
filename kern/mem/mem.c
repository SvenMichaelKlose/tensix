/*
 * tensix operating system project
 * Copyright (C) 2002, 2003, 2004, 2005 Sven Klose <pixel@hugbox.org>
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
#include <machdep.h>
#include "./mem_intern.h"

#include <buf.h>

#ifdef MEM_USE_FRAGMENTS
struct  stack_hdr  *fragment_stacks[FRAGMENT_SIZES];
HS_LOCK_DEF(fragment_locks[FRAGMENT_SIZES])
#endif

HS_LOCK_DEF(mem_bitmap_lock)

u8_t * page_map;  /* Bitmap of allocated pages. */
pageinfo_t *page_list;         /* Page info table. */
size_t mem_num_pages_free;     /* Number of free pages. */
size_t mem_num_pages_locked;   /* Number of locked pages. */

#ifdef MEM_USE_HINTS
pagenum_t mem_hint_top;
pagenum_t mem_hint_bottom;
#endif

#ifndef NATIVE
u8_t ram[RAMSIZE];
#endif

void page_alloc (pagenum_t page, fragsize_t fsize, bool cont, proc_t proc)
{
   mem_num_pages_free--;                      
   BITMAP_SET(page_map, page, TRUE);         
   PAGEINFO_SET(page, fsize, cont, proc);
}

/* Mark pages as used. */
void
mem_pages_ref (pagenum_t p, u16_t num, fragsize_t fsize, proc_t proc)
{
    /* Walk along the pages. */
    while (num--) {
        /* Mark single page as used, add PCONT flag for continuations. */
        PAGE_ALLOC(p, fsize, num != 0, proc); /* Don't set PCONT of last. */

#ifdef MEM_BZERO_PAGE
        /* Zero out page. */
        bzero (PAGE2ADDR(p), PAGESIZE);
#endif

        p++; /* Next page. */
    }
}

/* Mark pages as unused. */
void
mem_pages_unref (pagenum_t p)
{
    pageinfo_t cont; /* Continuation flag (PCONT). */

#ifdef MEM_USE_HINTS
    if (p < mem_hint_bottom)
        mem_hint_bottom = p;
#endif

    /* Check if the page continues the previous. */
    if (PAGE_LOCKED(p - 1) == 0 && PAGE_CONT(p - 1) != 0)
        return; /* Yes, do nothing. */

    /* Deallocate page by page. */
    do {
        ASSERT(PAGE_LOCKED(p), "mem_pages_unref(): Shouldn't unlock.\n");

        /* Save continuation flag state. */
        cont = PAGE_CONT(p);

        /* Mark page as being unused and step to next. */
        PAGE_FREE(p);

        p++; /* Next page. */
    } while (cont); /* Continued by next. */

#ifdef MEM_USE_HINTS
    p--;
    if (p > mem_hint_top)
        mem_hint_top = p;
#endif
}

/* Mark pages as locked. */
void
mem_pages_lock (pagenum_t p, u16_t num)
{
    while (num--) {
        if (PAGE_LOCKED(p) == FALSE) {
            PAGE_LOCK(p);
	}
#ifdef DEBUGLOG_MEM
	else
	    printk ("mem_pages_lock: Page %d already locked.\n", p);
#endif

        p++; /* Next page. */
    }
}

#ifdef MEM_SINGLE_PAGE
/* Allocate a single page. */
pagenum_t
mem_page_alloc (fragsize_t fsize, proc_t proc)
{
    pagenum_t  page = 0;
    pagenum_t  m;
    i16_t      i;
#ifdef MEM_USE_HINTS
    pagenum_t first = mem_hint_top;
#else
    pagenum_t first = NUM_PAGES - 1;
#endif

    HS_LOCK(mem_bitmap_lock);

    /* Check from top to bottom of map. */
    for (i = (first >> 3); i >= 0; i--) {
        /* Is there a free page? */
        if (page_map[i] == 0xff)
            continue; /* No. */

        /* Seek first unset bit. */
        for (page = 7, m = 128; page_map[i] & m; m >>= 1, page--);

        /* Add page number of first bit in byte. */
        page += i << 3;
        break;
    }

    /* Mark page as used if found. */
    if (page != 0)
        mem_pages_ref (page, 1, fsize, proc);

    HS_UNLOCK(mem_bitmap_lock);

    return page;
}
#endif /* #ifdef MEM_SINGLE_PAGE */

/* Allocate >1 pages. */
pagenum_t
mem_pages_alloc (pagenum_t num, fragsize_t fsize, proc_t proc)
{
    pagenum_t ret;

#ifdef MEM_USE_HINTS
    pagenum_t first = mem_hint_bottom;
#else
    pagenum_t first = 0;
#endif

#ifdef MEM_SINGLE_PAGE
    /* Allocate single pages from top of memory. */
    if (num == 1)
       return mem_page_alloc (fsize, proc);
#endif

    HS_LOCK(mem_bitmap_lock);

    /* Seek first free entry. */
    ret = bitmap_seek (page_map, NUM_PAGES, first, num);

    if (ret != 0)
        /* Mark pages as being used. */
        mem_pages_ref (ret, num, fsize, proc);

    HS_UNLOCK(mem_bitmap_lock);

    return ret;
}

/* Free a page. */
void
mem_page_free (void *pos)
{
    pagenum_t        p = ADDR2PAGE(pos);

#ifndef NO_CHECKS
    /* Check if page is allocated. */
    if (!PAGE_USED(p))
        return;
#endif

    /* Remove pages starting with page p. */
    mem_pages_unref (p);
}

#ifdef MEM_USE_FRAGMENTS

/*
 * Sort fragment stack by page.
 */
INLINE void
mem_frag_sort (struct stack_hdr *stack)
{
    u16_t       i,j;
    pagenum_t   pg;
    fragsize_t  id;
    u16_t       num = stack->index; /* Number of elements on stack. */
    struct fragment  *st = STACK_START(stack, struct fragment);

    for (i = 0; i < num - 1; i++) {
        for (j = i + 1; j < num; j++) {
            if (st[i].page > st[j].page) {
	        pg = st[i].page;
	        id = st[i].idx;
	        st[i].page = st[j].page;
	        st[i].idx = st[j].idx;
	        st[j].page = pg;
	        st[j].idx = id;
	    }
        }
    }

#ifdef DEBUGLOG_MEM
    for (i = 0; i < num; i++) {
	printk ("%d:", i);
	printk (" %d", st[i].page);
	printk (" %d\n", st[i].idx);
    }
    printk ("\n", 0);
#endif
}

/*
 * Remove free pages from a fragment stack.
 */
void
mem_frag_clean_stack (struct stack_hdr *stack, int frags)
{
    u16_t       src,dst;
    pagenum_t   pg;
    fragsize_t  id;
    u16_t       num = stack->index; /* Number of elements on stack. */
    struct fragment  *st = STACK_START(stack, struct fragment);

    /* Skip cleanup if there aren't enough fragments anyway. */
    if (num < frags)
	return;

    mem_frag_sort (stack);

    /* Step along fragments and remove entries that fill a page. */
    src = 0;
    dst = 0;
    while (src < num) {

        /* Get number of fragments in current page. */
        pg = st[src].page;
        id = 1;
        while ((src + id) < num && st[src + id].page == pg)
            id++;

        /* Remove page if number of fragments is ok. */
        if (id == frags) {
	    /* Free page. */
	    mem_pages_unref (pg);

	    /* Continue with following fragments. */
            src += id;

            MEM_PRINTK("frags %d freed\n", frags);

            continue;
        }

        /* Jump over incomplete page fragments. */
        if (src == dst) {
            src += id;
            dst = src;
	    continue;
        }

        /* Copy incomplete page fragments to new position. */
        while (id--) {
            st[dst].page = st[src].page;
            st[dst].idx = st[src].idx;
            src++;
            dst++;
        }
    }

    /* Update stack size. */
    stack->index = dst;
}

#ifdef MEM_DYN_STACKS

/* Grow a fragment stack. */
void
mem_grow_stack (struct stack_hdr *stackp)
{
    /* Get stack size. */
    /* If stack is a fragment, double its size. Add the page size otherwise. */
    /* Allocate new memory block. */
    /* Update the stack pointer. */
    /* Free old memory block. */
}

#endif /* #ifdef MEM_DYN_STACKS */

/* Add new fragments to a stack. */
int
mem_frag_add_page (struct stack_hdr *stack, fragsize_t fs, struct proc *proc)
{
    struct fragment *nfrag;
    fragsize_t	num = FRAGLOG2NUM(fs);
    proc_t    procid = proc->id;
    pagenum_t p;
    pagenum_t i;

    /* Check if there's enough space left on the stack. */
    ERRCHK(FRAGSPACE(proc, fs) < (sizeof (struct fragment) * num), ENOMEM);

    /* Allocate a new page for fragments. */
#ifdef MEM_SINGLE_PAGE
    p = mem_page_alloc (fs, procid);
#else
    p = mem_pages_alloc (1, fs, procid);
#endif
    ERRCHK(p == 0, ENOMEM); /* Out of memory. */

    /* Push new fragments on the list. */
    for (i = 0; i < num; i++) {
        /* Add fragment. */
        nfrag = FRAG_PUSH(stack);

        /*
         * Remove fragments again if the stack is full.
         * This is because the page won't be freed again.
         */
        if (nfrag == 0) {
            while (i--)
                FRAG_POP(stack);

            /* Free page. */
            PAGE_FREE(p);
            HS_UNLOCK(fragment_locks[fs]);
            return ENOMEM; /* Out of memory. */
        }

        /* Add fragment info to entry. */
        nfrag->page = p; /* Page number. */
        nfrag->idx = i;  /* Fragment index within the page. */
    }

    return ENONE;
}

/* Allocate a page fragment. */
void*
mem_frag_alloc (size_t size, struct proc *proc)
{
    fragsize_t       fs;
    size_t           i;
    struct stack_hdr *s;
    struct fragment  *frag;
    size_t           pagebase;
    size_t           idxofs;
    int              err;

    /* Get logarithmic fragment size. */
    for (fs = 0, i = PAGESIZE / 2; i >= FRAGSIZEMIN; fs++, i >>= 1)
        if (i < size)
            break;

    HS_LOCK(fragment_locks[fs]);

    /* Get fragment stack. */
    s = FRAG_STACK(proc, fs);

    /* Add new fragments to stack if empty. */
    if (FRAG_AVAILABLE(s) == 0) {
        err = mem_frag_add_page (s, fs, proc);
        if (err != 0) {
            HS_UNLOCK(fragment_locks[fs]);
	    return 0; /* Out of memory. */
	}
    }

    /* Pop a free fragment from the stack. Returns 0 if empty. */
    frag = FRAG_POP(s);

    /* Get address of page. */
    pagebase = frag->page * PAGESIZE;

    /* Get offset of fragment within page. */
    idxofs = frag->idx << FRAGSIZELOG(frag->page);

    HS_UNLOCK(fragment_locks[fs]);

    /* Add up everything to get the absolute address. */
    return (void*) (pagebase + idxofs + ram);
}

/* Free page fragment. */
void
mem_frag_free (void *pos, struct proc *proc)
{
    pagenum_t        p;
    struct fragment  *frag;
    struct stack_hdr *s;
    fragsize_t       fs;

#ifndef NO_CHECKS
    /* Check if address points to a legal fragment boundary. */
    if (IS_ILLEGAL_FRAG(pos)) {
#ifdef VERBOSE
        printk ("mem_frag_free: Illegal fragment boundary ", 0);
        printnhex (pos - (void*) ram, 4);
        printk (" \n", 0);
#endif
        return;
    }
#endif

    /* Get page. */
    p = ADDR2PAGE(pos);
    fs = FRAGLOG(p);

    bzero (pos, FRAGSIZE(p));

    /* Get fragment stack. */
    s = FRAG_STACK(proc, fs);

    HS_LOCK(fragment_locks[fs]);

    mem_frag_clean_stack (s, FRAGLOG2NUM(FRAGLOG(p)));

    /* Push fragment on stack. */
    frag = FRAG_PUSH(s);
    if (frag == NULL) {
        /* Stack overflow: Fragment is lost until process terminates. */
        VERBOSE_PRINTK("mem_frag_free: stack %d full.\n", FRAGLOG(p));
        return;
    }
    frag->idx = ADDR2FRAGIDX(pos); /* Index within page. */
    frag->page = p;

    HS_UNLOCK(fragment_locks[fs]);
}

#endif /* #ifdef MEM_USE_FRAGMENTS */

#define ROUNDBLEN(x, base)	(x / base + (x % base ? 1 : 0))

#ifdef DEBUGLOG_MEM
void
mem_malloc_printk (void *ret, size_t len)
{
    printk ("malloc: ", 0);
    printnhex ((size_t) ret, 4);
    printk (" ", 0);
    printnhex ((size_t) len, 4);
    printk ("\n", 0);
}
#define MEM_DL(addr,size) mem_malloc_printk((void *) ADDR2RAM(addr), (size_t) size)
#else
#define MEM_DL(addr,size)
#endif /* #ifdef DEBUGLOG_MEM */

/* Initialise memory manager. */
void
mem_init ()
{
    pagenum_t  p;
    pagenum_t  tmp;
#ifdef MEM_USE_FRAGMENTS
    u16_t      i; /* temp */
#endif

#ifndef NATIVE
    i32_t  j;
    /* Simulate spoiled RAM. */
    for (j = 65535; j >= 0; j--)
	ram[j] = j & 255;
#endif

    /* Save number of free pages. */
    mem_num_pages_free = NUM_PAGES;
    mem_num_pages_locked = 0;
#ifdef MEM_USE_HINTS
    mem_hint_top = NUM_PAGES - 1;
    mem_hint_bottom = 0;
#endif

    p = MMANAGER_STARTPAGE; /* First page to wire. */

    /* Wire page map area. */
    page_map = PAGE2ADDR(p);
    tmp = NUM_PAGES / 8 / PAGESIZE;
    p += tmp ? tmp : 1;

    /* Wire page list. */
    page_list = PAGE2ADDR(p);
    tmp = sizeof(pageinfo_t) * NUM_PAGES / PAGESIZE;
    p += tmp ? tmp : 1;

    /* Zero out page allocation bitmap and info table. */
    bzero (page_map, NUM_PAGES >> 3);
    bzero (page_list, sizeof (pageinfo_t) * NUM_PAGES);

    /* Lock page list area. */
    mem_pages_lock (MMANAGER_STARTPAGE, p - MMANAGER_STARTPAGE);

    /* Lock zero page. */
    mem_pages_lock (0, 1);

    /* Lock kernel area. */
    mem_pages_lock (KERNEL_STARTPAGE, KERNEL_PAGES);

    /* Allocate kernel process stack. */
    mem_pages_lock (KERNEL_STACKPAGE, KERNEL_STACKPAGES);

#ifdef MEM_USE_FRAGMENTS
    /* Wire a page for each fragment stack. */
    for (i = 0; i < FRAGMENT_SIZES; i++) {
        /* Mark page as being used. */
        MEM_PAGES_REF(p, 1, 0);

        /* Save address of page to list of stacks. */
        proc_current->fragment_stacks[i] = STACK_PTR(PAGE2ADDR(p));

        p++; /* Next page. */
    }
#endif

#ifdef VERBOSE_BOOT
    printk ("mem: %d bytes", (int) (PAGESIZE * NUM_PAGES));
    printk (", %d free", (int) (PAGESIZE * (mem_num_pages_free + KERNEL_STACKPAGES)));
    printk (", %d system.\n", (int) (PAGESIZE * (NUM_PAGES - mem_num_pages_free - KERNEL_STACKPAGES)));
#endif
}

#ifndef NO_BOOKKEEPING

/*
 * Create fragment stacks for process.
 */
void
mem_init_proc (struct proc *proc)
{
    u16_t p;

    MEM_PRINTK("mem_proc_init: %s\n", proc->name);

    for (p = 0; p < FRAGMENT_SIZES; p++) {
	proc->fragment_stacks[p] = pmalloc (PAGESIZE, proc);
    }

    MEM_PRINTK("<mem_proc_init\n", 0);
}

/*
 * Free all pages occupied by a certain process.
 */
void
mem_kill_proc (struct proc *proc)
{
    u16_t p;

    MEM_PRINTK("mem_proc_kill: %s\n", proc->name);

    for (p = 0; p < NUM_PAGES; p++) {
	/* Skip page if locked. */
        if (PAGE_LOCKED(p) != FALSE)
	    continue;

	/* Skip page if unused. */
	if (PAGE_USED(p) == FALSE)
	    continue;

	/* Skip page if it has another id. */
	if (PAGE_PROC(p) != proc->id)
	    continue;

	/* Free page. */
	PAGE_FREE(p);
    }
}

#endif /* #ifndef NO_BOOKKEEPING */

/* Allocate a memory block. */
void*
pmalloc2 (size_t size, struct proc *proc)
{
    pagenum_t  p;
    void       *ret;

#ifndef NO_CHECKS
    if (size == 0)
        return NULL;
#endif

#ifdef MEM_USE_FRAGMENTS
    /* Allocate fragment. */
    if (size <= (PAGESIZE / 2)) {
        ret = mem_frag_alloc (size, proc);
        MEM_DL(ret, size); /* debug log */
        return ret;
    }
#endif

    /* Round up to nearest page size. */
    p = mem_pages_alloc (ROUNDBLEN(size, PAGESIZE), 0, proc->id);
    if (p == 0) {
        MEM_PRINTK("malloc: out of mem\n", 0);
        return NULL;
    }

    MEM_DL(PAGE2ADDR(p), size); /* debug log */

    ret = PAGE2ADDR(p);
    RAMASSERT(ret);
    return ret;
}

void*
pmalloc (size_t size, struct proc *proc)
{
    void *p = pmalloc2 (size, proc);

    if (p == NULL) {
	bcleanup_glob ();
	p = pmalloc2 (size, proc);
    }

    return p;
}

/* Allocate a memory block. */
void*
kmalloc (size_t size)
{
    return pmalloc (size, &proc_holographic);
}

/* Free a memory block. */
void
freep (void *pos, struct proc *proc)
{
    pagenum_t p;

    RAMASSERT(pos);

    /* Get page number. */
    p = ADDR2PAGE(pos);

#ifdef MEM_USE_FRAGMENTS
    /* Decide wether to free a page or fragment. */
    if (FRAGLOG(p) == 0)    /* Fragment size in page info? */
        mem_page_free (pos);
    else     
        mem_frag_free (pos, proc);
#else
    mem_page_free (pos);
#endif

    MEM_PRINTK("free: ", 0);
    MEM_PRINTNHEX(ADDR2RAM(pos), 4);
    MEM_PRINTK("\n", 0);
}

LOCK_DEF(mem_wait_lock)
#define MEM_WAIT_THRESHOLD	16

/********************/
/*** SYSTEM CALLS ***/
/********************/

/* Allocate a memory block. */
void*
malloc (size_t size)
{
#ifndef NO_PROC
    struct proc *proc = (CURRENT_PROC() != NULL) ? CURRENT_PROC() : NULL;
#else
    proc_t proc = 0;
#endif
    int tr = ROUNDBLEN(size, PAGESIZE) + MEM_WAIT_THRESHOLD;

    /* Wait for memory if it's low to keep the kernel and daemons running. */
    /* The system will halt in proc_sleep(), if memory is full. */
    if (mem_num_pages_free < tr) {
        if (LOCKED(mem_wait_lock) == FALSE)
	    bcleanup_glob ();
        while (mem_num_pages_free < tr)
	    lock_ref_wait (&mem_wait_lock);
    }

    return pmalloc (size, proc);
}

void
free (void *pos)
{
    freep (pos, CURRENT_PROC());

    /* Wakeup user processes waiting for memory. */
    if (LOCKED(mem_wait_lock))
	lock_unref (&mem_wait_lock);
}
