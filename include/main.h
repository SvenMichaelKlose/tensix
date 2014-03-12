/*
 * tensix operating system project
 * Copyright (C) 2002, 2003, 2004, 2005 Sven Klose <pixel@copei.de>
 *
 * Kernel toplevel functions
 *
 * $License$
 */

#ifndef _SYS_MAIN_H
#define _SYS_MAIN_H

#include <types.h>

extern void reboot ();
extern void shutdown ();
extern void panic (char* msg);

#endif /* #ifndef _SYS_MAIN_H */
