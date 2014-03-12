/*
 * tensix operating system project
 * Copyright (C) 2002 Sven Klose <pixel@hugbox.org>
 *
 * Bitmap functions
 *
 * $License$
 */

#include <types.h>
#include <bitmap.h>
#include <libc.h>
#include <error.h>
#include <main.h>

/*
 * Seek gap of 'len' unset bits in 'bitmap' of 'max' bits. Start at bit 'b'.
 */
int
bitmap_seek (u8_t * bitmap, size_t size, size_t b, size_t len)
{
    int l;
    int i;

    ASSERT(len > size, "bitmap_seek: Wanted len is greater than bitmap size.\n");

    while (b < (size - len)) {
        if ((b % 8) && (BITMAP_BYTE(bitmap, b) == 255)) {
	    b += 8;
            continue;
        }

        /* Continue if bit is set. */
        if (BITMAP_GET(bitmap, b)) {
	    b++;
	    continue;
        }

        /* Check if range is large enough. */
        l = len;
        i = b;
        BITMAP_GAP_LEN(bitmap, i, l);

        /* Enough bits found? */
        if (l == 0)
            return b; /* Yes. */

        /* Step over checked bits. */
        b = i + 1;
    }

    return 0; /* Nothing found. */
}
