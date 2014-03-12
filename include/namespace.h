/*
 * tensix operating system project
 * Copyright (C) 2002, 2003, 2004, 2005 Sven Klose <pixel@copei.de>
 *
 * Filesystem namespace management
 *
 * $License$
 */

#ifndef _SYS_NAMESPACE_H
#define _SYS_NAMESPACE_H

#include <types.h>
#include <obj.h>
#include <proc.h>
#include <dirent.h>

extern struct obj *namespace_root_obj;

/* Initialise virtual filesystem. */
extern void namespace_init ();

extern int namespace_lookup (struct obj **, struct obj *dir, char *name);
extern int namespace_lookup_path (struct obj **, char *path);

#endif /* #ifndef _SYS_NAMESPACE_H */
