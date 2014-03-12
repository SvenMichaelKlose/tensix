/*
 * tensix operating system project
 * Copyright (C) 2002, 2003, 2004 Sven Klose <pixel@c-base.org>
 *
 * Compile-time kernel configuration
 *
 * All possible options are listed in here
 *
 * $License$
 */

#ifndef _SYS_CONFIG_H
#define _SYS_CONFIG_H

#include <version.h>

/*******************
 * GENERAL OPTIONS *
 *******************/

#if 0

/* Print messages. Without this option NOTHING will be printed. */
#define VERBOSE
#define VERBOSE_BOOT

/* Don't check if it's not needed to implement an algorithm. */
#define NO_CHECKS

/* Accept less speed in favour for a smaller kernel. */
#define FAVOUR_SIZE

/* Don't track object and buffer usage per process. */
#define NO_BOOKKEEPING

/* Exclude process management. */
#define NO_PROC

/* Exclude I/O services. */
#define NO_IO

#endif

/***************************
 * BUILT-IN OBJECT CLASSES *
 ***************************/

#if 0

/* Have a console. */
#define CONSOLE

/* Include disk device. */
#define DISK
#define DISK_BLKS	65535	/* Maximum number of blocks. */

/* Include memory file system. */
#define MEMFS

/* Wrapper FS for userland kernel. */
#define WRAPFS

/* Default ethernet device. */
#define ETHERNET

#endif

/******************************
 * PROCESS MANAGEMENT OPTIONS *
 ******************************/

#if 0

#define MULTITASKING

/* Maximum number of processes (no matter of state). */
#define PROC_MAX   16

/* This option will force switches in system calls. */
#define NO_SWITCH_TIMER

#define INIT_STACKSIZE 128
#define NO_RESIDENT_INIT /* Kill init process if user application runs. */

/* Don't count ticks running. */
#define PROC_NO_TICKS

/**********************
 * I/O SYSTEM OPTIONS *
 **********************/

#define SYNCER		       /* Run syncer daemon for output. */
#define IOD		       /* Run iod daemon for async input. */
#define NUM_OBJS           32  /* Maximum number of file objects. */
#define NUM_OBJCLASSES     16  /* Maximum number of object classes. */
#define NUM_OBJSUBCLASSES  16  /* Maximum number of object subclasses. */
#define OBJS_PER_PROC 	   NUM_OBJS
#define DIRS_PER_PROC 	   NUM_OBJS

#define NUM_DIRENTS        32  /* Maximum number of cached dirents. */

#define NUM_BUFS           32  /* Maximum number of I/O buffers. */
#define BUFS_PER_PROC      NUM_BUFS
#define BUF_STREAMSIZE     256 /* Default buffer size for streams. */

#define BUF_SHARED_DATA	       /* Allow shared data areas. */
#define BUF_JIT_STREAMS	       /* Just-in-time network streams. */

#endif

/*
 * Have object event (required).
 */
#define OBJ_EVENTS

/* Number of I/O daemon channels, serving interrupt routines. */
#ifndef IOD_CHANNELS
#define IOD_CHANNELS	NUM_OBJSUBCLASSES
#endif

#if 0
/*
 * If this option is set, reused buffers are moved to the front of their
 * object's buffer list where it is found faster. Newly created buffers are
 * placed at the end of the list to avoid spoiling the cache with sequencial
 * or random-accesses.
 *
 * If this option is off, all buffers created are pushed to the front of
 * the object's buffer list.
 */
#define BUF_SORT_REUSED

/**********************
 * FILESYSTEM OPTIONS *
 **********************/

#define NAME_MAX   32 /* Maximum file name length, including last 0 byte. */

#define SYNCER_STACKSIZE	1024
#define SYNCER_SLEEP_DELAY 2 /* Number of idle context switches before
				syncer sleeps. */

/*********************
 * DEBUGGING OPTIONS *
 *********************/

/*
 * Check pointers and data structures.
 * Passing pointers to kernel structures that don't lie in a pool
 * to system calls will be detected and the process is killed.
 * You should use this for kernel or application development.
 */
#define DIAGNOSTICS
#endif

#ifdef DIAGNOSTICS
#ifndef DIAGNOSTICS_DEQUEUE
#define DIAGNOSTICS_DEQUEUE
#endif
#endif /* #ifdef DIAGNOSTICS */

#if 0

#define DEBUGLOG_BUF    /* Print what the buffer layer is doing. */
#define DEBUGLOG_MEM    /* Print what the memory manager is doing. */
#define DEBUGLOG_FS     /* Print what the fs layer is doing. */
#define DEBUGLOG_NAMESPACE    /* Print namespace ops. */
#define DEBUGLOG_OBJ    /* Print what the object functions are doing. */
#define DEBUGLOG_POOL   /* Print what the pool manager is doing. */
#define DEBUGLOG_PROC   /* Print what the process manager is doing. */
#define DEBUGLOG_LOCK   /* Print when locks are accessed. */
#define DEBUGLOG_SYNCER /* Print what the syncer is doing. */
#define DEBUGLOG_IOD /* Print what the I/O daemon is doing. */

/**************************
 * MEMORY MANAGER OPTIONS *
 **************************/

#define MEM_SINGLE_PAGE   /* Separate single pages from large blocks. */
#define MEM_USE_FRAGMENTS /* Also handle fragments of pages. */
#define MEM_USE_HINTS     /* Use hints for page seeks. */
#define MEM_PAGE_LIST     /* Use page allocation list instead of bitmap. */
#define MEM_DYN_STACKS    /* Have dynamically growing fragment stacks. */
#define MEM_BZERO_PAGE    /* Zero out allocated pages. */
#define MEM_BZERO_FRAG    /* Zero out free'd fragments. */
#define MEM_DUMP          /* Include mem_dump() function. */

/* Include mem_test_stress() function. */
#define MEM_TEST_STRESS
#define MEM_TEST_STRESS_FAKES 256 /* Number of simultaneous allocations. */

#endif

/*
 * Switch on all MEM_BZERO_* options.
 */
#define MEM_BZERO	/* required */

/**************************
 * MEMORY POOL MANAGEMENT *
 **************************/

#if 0

/* Use functions for list manipulation instead of inline code. */
#define DEQUEUE_MACRO_CALLS

/****************************
 * MEMORY LAYOUT PARAMETERS *
 ****************************/

#define RAMSIZE	           65536   /* Size of address space. */
#define PAGESIZE_LOG	   8       /* Logarithmic page size. */
#define FRAGSIZEMIN_LOG	   5       /* Mininum logarithmic fragment size. */
#define KERNEL_START       0x0000
#define KERNEL_END         0x5fff  /* NOTICE: Last address occupied. */
#define KERNEL_STACKPAGE   240     /* First page of the kernel stack. */
#define KERNEL_STACKPAGES  16      /* Number of kernel stack pages. */
#define MMANAGER_STARTPAGE KERNEL_PAGES /* Memory management pages.  */

#endif

/*************
 * Endianess *
 *************/

#ifndef LITTLE_ENDIAN
#define LITTLE_ENDIAN  3412
#endif /* LITTLE_ENDIAN */
#ifndef BIG_ENDIAN
#define BIG_ENDIAN     1234
#endif /* BIGE_ENDIAN */

/************
 * Messages *
 ************/

/* All languages. */
#define TXT_WELCOME \
    "\ftensix operating system (" __DATE__ " " __TIME__ ", " MACHINE ")\n" \
    "Copyright (c) 2002, 2003, 2004, 2005, 2006 Sven Klose <pixel@copei.de>\n-\n"

#define TXT_GOING_MULTIPROC   	"-\n"
#define TXT_GOING_INIT   	"-\n"

/*
 * Include user configuration.
 */
#include ARCHCONFIG
#include CONFIG

/*
 * Add dependencies here.
 */

/*********
 * LOCKS *
 *********/
/* Have locks. Required for MULTITASKING */
#ifdef MULTITASKING
#define LOCKS
#endif

#endif /* #ifndef _SYS_CONFIG_H */
