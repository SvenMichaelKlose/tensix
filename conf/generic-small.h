/*
 * tensix operating system project
 *
 * Compile-time configuration
 *
 * Copy this to a new file and modify it to suit your needs.
 */

/* Have a console. */
#define CONSOLE

/* Print error messages. */
#define VERBOSE

/* Print boot messages. */
#define VERBOSE_BOOT

/* Default disk driver. */
#define DISK
#define DISK_BLKS	65535

/* Default ethernet driver. */
#define ETHERNET

/*
 * File systems
 */
#if 0
#define MEMFS
#endif

/*
 * Multitasking
 *
 * If multitasking is supported, multiple processes can run concurrently.
 * Otherwise, if a process executes another, it must wait until it exited.
 * Without multitasking, there's no I/O write cache.
 */
#define MULTITASKING

/*
 * If multitasking is used, the syncer daemon can do I/O writes so other
 * processes don't need to wait until a write is finished. This speeds
 * things up a lot.
 */
#define SYNCER
#define SYNCER_SLEEP_DELAY  2
#define SYNCER_AVOID_WAKEUP
#define IOD

/*
 * Kill init process if user process runs.
 */
#define NO_RESIDENT_INIT

/*
 * Options to reduce the kernel size.
 */
#define DEQUEUE_MACRO_CALLS /* Leave this in for less (inline) code. */

#define NO_CHECKS            /* Don't check syscall parameters. */
#define FAVOUR_SIZE          /* Favor size instead of speed. */

/*
 * Include memory dumper.
 */
#define MEM_DUMP
#if 0
#endif

/******************************
 * PROCESS MANAGEMENT OPTIONS *
 ******************************/

/* Maximum number of processes. */
#define PROC_MAX   16

/* This option will force switches in system calls. */
#define NO_SWITCH_TIMER 1

#define INIT_STACKSIZE 768
#define SYNCER_STACKSIZE 1024
#define IOD_STACKSIZE 1024

/**************************
 * I/O MANAGEMENT OPTIONS *
 **************************/

/* Maximum number of I/O buffers. */
#define NUM_BUFS   64

/* Maximum number of file objects. */
#define NUM_OBJS   16

/* Maximum number of object classes. */
#define NUM_OBJCLASSES   8

/* Maximum number of object subclasses. */
#define NUM_OBJSUBCLASSES   16

/* Maximum number of cached dirents. */
#define NUM_DIRENTS   16

#define BUFS_PER_PROC NUM_BUFS
#define OBJS_PER_PROC NUM_OBJS
#define DIRS_PER_PROC NUM_OBJS

/*
 * Move reused buffers to the beginning of their list to have them found
 * faster.
 */
#define BUF_SORT_REUSED

/* Buffer size for streams. */
#define BUF_STREAMSIZE  256

/* Max. number of I/O daemon channels. */
#if 0
#define IOD_CHANNELS	16
#endif

/**********************
 * FILESYSTEM OPTIONS *
 **********************/

/* Maximum file name length, including last 0 byte. */
#define NAME_MAX   32

/**************************
 * MEMORY MANAGER OPTIONS *
 **************************/

/* Separate single pages from large blocks and search them faster. */
#define MEM_SINGLE_PAGE

/* Also handle fragments of pages. */
#define MEM_USE_FRAGMENTS

#define MEM_TEST_STRESS
#define MEM_TEST_STRESS_FAKES	128
#define MEM_TEST_STRESS_RUNS	2

/****************************
 * MEMORY LAYOUT PARAMETERS *
 ****************************/

/* Size of address space. */
#define RAMSIZE	           65536

/* Logarithmic page size. */
#define PAGESIZE_LOG	   8 /* 256 byte pages. */

/* Mininum logarithmic fragment size. */
#define FRAGSIZEMIN_LOG	   5 /* 32 byte fragments. */

#define KERNEL_START       0x0000
#define KERNEL_END         0x02ff /* NOTICE: Last address occupied. */

/* First page of the kernel stack. */
#define KERNEL_STACKPAGE   240

/* Number of kernel stack pages. */
#define KERNEL_STACKPAGES  16

/* Memory management pages.  */
/*#define MMANAGER_STARTPAGE (KERNEL_ENDPAGE - KERNEL_PAGES - MMANAGER_PAGES)*/
#define MMANAGER_STARTPAGE KERNEL_PAGES
