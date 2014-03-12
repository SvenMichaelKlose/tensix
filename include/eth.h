/*
 * tensix operating system project
 * Copyright (C) 2002, 2003 Sven Klose <pixel@hugbox.org>
 *
 * Default ethernet driver
 *
 * $License$
 */

#ifndef _SYS_ETH_H
#define _SYS_ETH_H

#include <obj.h>

extern void eth_init (struct obj *);
extern int eth_io (struct buf *, struct obj *, blk_t blk, bool mode);

#endif /* #ifndef _SYS_ETH_H */
