/*
 * tensix operating system project
 * Copyright (C) 2002, 2003 Sven Klose <pixel@copei.de>
 *
 * Kernel C library string functions.
 *
 * $License$
 */

#ifndef _SYS_STRING_H
#define _SYS_STRING_H

#include <types.h>

extern void bzero (void *dest, size_t len);
extern void memcpy (void *dest, void *src, size_t len);
extern int memcmp (void *s1, void *s2, size_t len);
extern char *strcpy (char *dest, char *src);
extern char *strcat (char *dest, char *src);
extern size_t strlen (char *s1);
extern int strcmp (char *s1, char *s2);

#define CHARSKIP(ptr, chr) \
    while (*ptr == chr)    \
	ptr++;

/* Data type copy. */
#define TYPECPY(type, to, from)  memcpy (to, from, sizeof (type))

#endif /* #ifndef _SYS_STRING_H */
