/*
 * tensix operating system project
 * Copyright (C) 2005 Sven Klose <pixel@copei.de>
 *
 * Cyclic redundancy check (CRC) functions
 *
 * $License$
 */

#include <types.h>
#include <crc.h>

u8_t
crc (void *where, size_t size)
{
    u8_t v = 0;
    u8_t *p = (u8_t*) where;
    u8_t width;
    u8_t tmp;

    while (size--) {
	tmp = *p++;
	for (width = sizeof (u8_t) * 8; width > 0; width--) {
	    v ^= tmp;
	    tmp <<= 1;
	}
    }

    return v;
}
