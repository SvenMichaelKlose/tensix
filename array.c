/*
 * tensix operating system project
 * Copyright (C) 2002, 2003 Sven Klose <pixel@copei.de>
 *
 * Array functions.
 *
 * $License$
 */

#include <array.h>

/* We assume it's free if the first two bytes are 0. */
void*
_sarray_add (size_t tlen, char* arr)
{
    char *i;
    char *end = (char *) SARRAY_END(arr);

    /* Step through the whole array. */
    for (i = arr; i < end; i += tlen)
        if (*(u16_t *) i == 0)
	    return (void*) i;

    return NULL;
}
