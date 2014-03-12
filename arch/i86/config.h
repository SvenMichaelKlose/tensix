/*
 * tensix operating system project
 * Copyright (C) 2003 Sven Klose <pixel@hugbox.org>
 *
 * i86 specific kernel settings
 */

#ifndef _ARCH_I86_CONFIG_H

#define INIT_STACKSIZE 128
#define BYTE_ORDER	LITTLE_ENDIAN

/* Long integer functions. */
#define L___imod
#define L___idiv
#define L___imodu
#define L___idivu
#define L___landl
#define L___lmodul
#define L___ldivul
#define L___lcmpl
#define L___ldivmod
#define L___ltstl
#define L___ldecl
#define L___isl
#define L___isru

#define NATIVE      /* Nothing will run outside RAM. */
#define K_AND_R     /* bcc does the Kerningham & Ritchie way of life. */

#endif /* #ifndef _ARCH_I86_CONFIG_H */
