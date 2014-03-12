/*
 * tensix operating system project
 * Copyright (C) 2002 Sven Klose <pixel@copei.de>
 *
 * Disk driver
 *
 * $License$
 */

#ifndef _SYS_DISK_H
#define _SYS_DISK_H

#include <obj.h>

extern void disk_init (struct obj *);
extern int disk_io (struct buf *, struct obj *, blk_t blk, bool mode);

#endif /* #ifndef _SYS_DISK_H */
