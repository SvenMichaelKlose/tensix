/*
 * tensix operating system project
 * Copyright (C) 2003 Sven Klose <pixel@copei.de>
 *
 * Directory handles
 *
 * $License$
 */

#ifndef _SYS_DIR_H
#define _SYS_DIR_H

#include <types.h>

struct dir {
    struct obj  *obj;
    void        *next;   /* Driver-specific pointer to next record. */
};

#endif /* #ifndef _SYS_DIR_H */
