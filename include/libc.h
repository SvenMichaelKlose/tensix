/*
 * tensix operating system project
 * Copyright (C) 2002, 2003 Sven Klose <pixel@copei.de>
 *
 * Kernel C library.
 *
 * $License$
 */

#ifndef _SYS_LIBC_H
#define _SYS_LIBC_H

#include <types.h>

extern struct obj  *libc_con;

#define stdin libc_con
#define stdout libc_con

extern void libc_init ();
extern void libc_close ();
extern void printndec (unsigned int v);
extern void printnhex (unsigned int v, unsigned int digits);
extern void printk (char* fmt, unsigned int v);
extern void printf (char* fmt, unsigned int v);

#ifdef VERBOSE
#define VERBOSE_PRINTK(msg, arg) printk (msg,arg)
#else   
#define VERBOSE_PRINTK(msg, arg)
#endif
 
#ifdef VERBOSE_BOOT
#define VERBOSE_BOOT_PRINTK(msg, arg) printk (msg,arg)
#else
#define VERBOSE_BOOT_PRINTK(msg, arg)
#endif

#endif /* #ifndef _SYS_LIBC_H */
