/*
 * tensix operating system project
 * Copyright (C) 2003, 2004, 2005 Sven Klose <pixel@copei.de>
 *
 * Lib-C filesystem
 *
 * $License$
 */

#ifndef _SYS_WRAPFS_H
#define _SYS_WRAPFS_H

struct obj;
extern void wrapfs_init (struct obj *);

struct wrapfs_obj {
    struct wrapfs_obj  *prev;
    struct wrapfs_obj  *next;
    struct wrapfs_obj  *childs;
    struct wrapfs_obj  *parent;
    void	       *obj;
    unsigned int       id;
    char	       type; /* 0 = file, !0 = directory */
    char	       is_cached;
    char               name[256];
    unsigned long      size;
};

extern int wrapfs_numobjs;
extern struct wrapfs_obj wrapfs_objects[16284];
extern char wrapfs_names[162840];

#endif /* #ifndef _SYS_WRAPFS_H */
