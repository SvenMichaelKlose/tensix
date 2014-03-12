/*
 * tensix operating system project
 * Copyright (C) 2002 Sven Klose <pixel@copei.de>
 *
 * Bitmap functions
 *
 * $License$
 */

#ifndef _SYS_BITMAP_H
#define _SYS_BITMAP_H

#include <config.h>

/* Byte of bitmap index. */
#define BITMAP_BYTE(bitmap, index) (((u8_t*) bitmap)[index / 8])

/* Bit of bitmap index. */
#define BITMAP_BIT(index)	(1 << (index % 8))

/* Mask for bit at index. */
#define BITMAP_MASK(index)	(BITMAP_BIT(index) ^ -1)

/* Read bit. */
#define BITMAP_GET(bitmap, index) \
   (BITMAP_BYTE(bitmap, index) & BITMAP_BIT(index))

/* Set bit. */
#define BITMAP_SET(bitmap, index, val) \
   BITMAP_BYTE(bitmap, index) = ((BITMAP_BYTE(bitmap, index) & \
                                 BITMAP_MASK(index)) | \
                                 (val ? BITMAP_BIT(index) : 0))

/*
 * Check for continuous gap of 'len' bits starting at bit 'index'.
 * If successful, len is set to 0.
 */
#define BITMAP_GAP_LEN(bitmap, index, len) \
   for (;len > 0; index++, len--)	\
      if (BITMAP_GET(bitmap, index))	\
         break;

extern int bitmap_seek (u8_t * bitmap, size_t size, size_t first, size_t len);

#endif /* #ifndef _SYS_BITMAP_H */
