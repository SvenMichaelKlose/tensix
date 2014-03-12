/*
 * tensix operating system project
 * Copyright (C) 2002 Sven klose <pixel@copei.de>
 *
 * Utilities for buffered I/O
 *
 * $License$
 */

#ifndef _SYS_LIBBUF_H
#define _SYS_LIBBUF_H

/*
 * Allocate a buffer like bio() but take an offset into the
 * object. The pointer to the buffer data where the specified object
 * starts is returned in 'ptr'.
 *
 * If you need the number of bytes available relative to 'ptr' use
 * the BUF_REMSIZ() macro.
 */
extern int batofs (struct buf **, void **ptr, struct obj *, fsize_t ofs, u8_t mode);
extern int batofsend (struct buf **, void **ptr, void **end, struct obj *, fsize_t ofs, u8_t mode);

extern int bio_seek_map (struct obj *obj, blk_t start, unsigned int num, unsigned int needed, blk_t preferred, blk_t *blk, struct buf **buf, void **blkofs);

#endif /* #ifndef _SYS_LIBBUF_H */
