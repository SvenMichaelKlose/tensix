/*
 * tensix operating system project
 * Copyright (C) 2002, 2003 Sven Klose <pixel@copei.de>
 *
 * Generic console driver
 *
 * $License$
 */

#ifndef _SYS_CON_H
#define _SYS_CON_H

#include <obj.h>

extern void con_init (struct obj *);
extern int con_io (struct buf *, struct obj *, blk_t blk, bool mode);

extern char con_in ();
extern void con_out (char c);
extern void con_init_raw ();

#endif /* #ifndef _SYS_CON_H */
