/*
 * tensix operating system project
 * Copyright (C) 2002, 2003, 2004, 2005 Sven Klose <pixel@copei.de>
 *
 * Holographic filesystem (default filesystem operations)
 *
 * $License$
 */

#include <types.h>
#include <dir.h>
#include <error.h>
#include <libc.h>
#include <obj.h>
#include <namespace.h>
#include <dirent.h>
#include <proc.h>
#include <string.h>
#include <dfs.h>
#include <holographicfs.h>
#include <machdep.h>
#include <xxx.h>

#ifdef DEBUGLOG_HOLOFS
#define HOLOFS_PRINTK(fmt, val)  printk (fmt, (int) val)
#define HOLOFS_PRINTNHEX(fmt, val)  printnhex (fmt, (int) val)
#else
#define HOLOFS_PRINTK(fmt, val)
#define HOLOFS_PRINTNHEX(fmt, val)
#endif

/*
 * Read first/next entry from holographic fs.
 */
int
holographicfs_dir_read (struct dirent *retdir, struct dir *dir)
{
    struct dirent *dirent;

    HOLOFS_PRINTK("holographicfs_dir_read\n", 0);

    /*
     * The 'next' field in 'struct dir' is initially set to 0.
     * Is it the initial call for the first directory entry?
     */
    if (dir->next == 0) {
	/* No, get first entry. */
        dirent = (struct dirent *) dir->obj->dirents.first;
    } else {
	/* Yes, use 'next' field to get the last directory. */
	dirent = (struct dirent *) dir->next;

	/* Get the next directory of it. */
	dirent = (struct dirent *) dirent->next;
	if (dirent == NULL)
	    return ENOTFOUND;
    }

    /* Save pointer to this directory in the 'next' field. */
    dir->next = dirent;

    /* Holographic directories have no size. */
    retdir->size = 0;

    /* Copy name to the user's directory record. */
    strcpy (retdir->name, dirent->name);

    return ENONE;
}

/*
 * Holographic file-system operations.
 *
 * The holographic fs can only access files that are already in memory.
 * It is used for the root directory.
 */
struct obj_ops holographicfs_obj_ops = {
    NULL,  /* io */
    NULL,  /* create */
    do_nothing,  /* unlink (struct obj *) */
    NULL,  /* truncate */
    do_nothing,  /* dir_open */
    NULL,  /* dir_close */
    holographicfs_dir_read,  /* dir_read */
    do_nothing,  /* lookup */
    NULL,  /* dup */
    NULL,  /* get_obj */
    NULL   /* get_dirent */
};
