/*
 * tensix operating system project
 * Copyright (C) 2002, 2003, 2004, 2005 Sven Klose <pixel@copei.de>
 *
 * Kernel builtin shell
 *
 * $License$
 */

#ifndef _SYS_SH_H
#define _SYS_SH_H

#include <types.h>

extern void sh ();
extern int sh_parse_cmdline (char *);
extern void sh_errno (int);

#define SH_STACKSIZE  (2048 * 2)

#endif /* #ifndef _SYS_SH_H */
