/*
 * tensix operating system project
 * Copyright (C) 2002, 2003, 2004, 2005 Sven Klose <pixel@copei.de>
 *
 * Type definitions
 *
 * $License$
 */

#ifndef _SYS_TYPES_H
#define _SYS_TYPES_H

#include <config.h>

#define NULL	((void*) 0) /* Null pointer. */

#define FALSE	0
#define TRUE	-1

typedef unsigned int addr_t;
typedef unsigned int size_t;

typedef unsigned char  u8_t;
typedef signed char  i8_t;

#ifdef NATIVE
typedef int i16_t;
typedef long i32_t;
typedef unsigned int u16_t;
typedef unsigned long u32_t;
#else
typedef short i16_t;
typedef int i32_t;
typedef unsigned short u16_t;
typedef unsigned int u32_t;
#endif

typedef u32_t fpos_t;
typedef u32_t fsize_t;

typedef u16_t blk_t;
typedef u16_t blksize_t;

typedef u8_t bool;
typedef u8_t proc_t; /* Process id. */
typedef u16_t fid_t; /* File id. */

typedef proc_t refcnt_t; /* Reference count. */

typedef size_t objid_t;  /* Object ID. */
typedef void * dir_t;

typedef int (*func_t) ();
typedef void (*voidfunc_t) ();

#define ROUND(x, blk)	(x / blk)
#define ROUNDUP(x, blk)	((x / blk) + ((x % blk) ? 1 : 0))

#define ARRAY_OFFSET(type, index)	(sizeof (type) * index)

#define MINMAX(a, b)	(a < b ? a : b)
#define MAXMIN(a, b)	(a > b ? a : b)

#define LOG2INT(log) (1 << log)

/*
 * Adding pointers.
 */
#define POINTER_ADD(a, b)    ((void*) ((size_t) (a) + (size_t) (b)))
#define POINTER_SUB(a, b)    ((void*) ((size_t) (a) - (size_t) (b)))

#define INLINE
#define VOLATILE

#endif /* #ifndef _SYS_TYPES_H */
