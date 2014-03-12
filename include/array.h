/*
 * tensix operating system project
 * Copyright (C) 2002, 2003, 2004, 2005 Sven Klose <pixel@copei.de>
 *
 * Array allocation macros
 *
 * $License$
 */

#ifndef _SYS_ARRAY_H
#define _SYS_ARRAY_H

#include <mem.h>

/* Get number of array elements. */
#define SARRAY_RANGE(type, arr) \
    FRAGSIZE(ADDR2PAGE(arr)) / sizeof (type)

/* Get address of first byte that follows the array. */
#define SARRAY_END(arr) \
    POINTER_ADD(arr, FRAGSIZE(ADDR2PAGE(arr)))

/* Loop over all used array elements. */
#define SARRAY_FOREACH(type, arr, iter) \
    for (iter = (type *) arr; iter < (type *) SARRAY_END(arr); iter++) \
        if (*iter != NULL)

/* Allocate element and return its pointer. */
#define SARRAY_ADD(type, arr) \
    (type*) _sarray_add (sizeof (type), (char *) arr);

/* Remove a record. */
#define SARRAY_ERASE(type, arr, recp) \
    *recp = (type) NULL;

/*
 * Remove record that equals 'el' from array 'arr'.
 * 'iter' is destroyed.
 */
#define SARRAY_ERASEQ(type, arr, iter, el) \
    SARRAY_FOREACH(type, arr, iter) {      \
	if (*iter == el) {                 \
            SARRAY_ERASE(type, arr, iter); \
	    break;                         \
	}                                  \
    }

extern void *_sarray_add (size_t tlen, char *arr);

#endif /* #ifndef _SYS_ARRAY_H */
