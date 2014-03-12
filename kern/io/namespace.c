/*
 * tensix operating system project
 * Copyright (C) 2002, 2003, 2004 Sven Klose <pixel@copei.de>
 *
 * Virtual filesystem namespace.
 *
 * $License$
 *
 * About this file:
 *
 * The namespace functions may lookup (namespace_lookup_path()), create
 * (namespace_create()) or unlink files and directories (namespace_unlink()).
 */

#include <types.h>
#include <dir.h>
#include <error.h>
#include <libc.h>
#include <obj.h>
#include <namespace.h>
#include <fs.h>
#include <holographicfs.h>
#include <dirent.h>
#include <proc.h>
#include <string.h>
#include <dfs.h>
#include <machdep.h>
#include <xxx.h>

#ifndef NO_IO

#ifdef DEBUGLOG_NAMESPACE
#define NAMESPACE_PRINTK(fmt, val)  printk (fmt, (int) val)
#define NAMESPACE_PRINTNHEX(fmt, val)  printnhex (fmt, (int) val)
#else
#define NAMESPACE_PRINTK(fmt, val)
#define NAMESPACE_PRINTNHEX(fmt, val)
#endif

struct obj *namespace_root_obj;	/* Root directory. */

/*
 * Main init function.
 *
 * (see kern/main.c)
 */
void
namespace_init ()
{
    /* Create an object class for the holographic fs. */
    namespace_root_obj = obj_new_class (NULL);
    UNLOCK(namespace_root_obj->lock);

    /* Set the operation vector. */
    OBJ_OPS(namespace_root_obj) = &holographicfs_obj_ops;
    OBJ_SET_PERSISTENT(namespace_root_obj, TRUE);

    /* Make it a root directory (no parent). */
    obj_set_parent (namespace_root_obj, NULL);
    
    VERBOSE_BOOT_PRINTK("\n", 0);
}

/*
 * Lookup name from holographic directory.
 *
 * This function is called directly by namespace_lookup().
 */
int
namespace_directory_scan (struct obj **retobj, struct obj *obj, char *name)
{
    struct dirent  *i_dirent;
    
    *retobj = NULL;	/* Nothing looked up yet. */

    /* Search through object's dirent list. */
    DEQUEUE_FOREACH(OBJ_DIRENTS(obj), i_dirent) {
        /* Continue if we aren't at the wanted index. */
        if (strcmp (i_dirent->name, name) != FALSE)
             continue;
             
        /* Return directory entry. */
        *retobj = i_dirent->obj;
        return ENONE;
     }  
     
     /* Nothing found. */
     return ENOTFOUND;
}    

/*
 * Lookup object from a directory.
 *
 * The object pointer is initialised with NULL before the object lookup
 * is called.
 */
int
namespace_lookup (struct obj **retobj, struct obj *dir, char *name)
{
    int        err = ENONE;

    NAMESPACE_PRINTK("namespace_lookup %s\n", name);

    /* Lookup object from directory set already in memory. */
    err = namespace_directory_scan (retobj, dir, name);

    /* Return, if we've found the entry. */
    if (*retobj != NULL) {
	NAMESPACE_PRINTK("! namespace_lookup(): obj reused.\n", 0);
	return err;
    }

    /* Check if the object owns a lookup function. */
    ERRCHK(OBJ_OPS(dir)->lookup == NULL, err ? err : ENOTSUP);

    /* Search name via object. */
    err = OBJ_LOOKUP(retobj, dir, name);
    ERRCHK(err == ENONE && *retobj == NULL, ENOTFOUND);

    NAMESPACE_PRINTK("<namespace_lookup %d\n", err);

    return err;
}

/*
 * Deescape path component into a buffer.
 *
 * 'from' points to the next component on return.
 */
int
namespace_deescape_path (char* to, char **from)
{
    char  *path = *from;
    char  *i = to;
    char  c;
    int   err = 0;

    /* De-escape path component into buffer. */
    while (1) {
        c = *path++;
        if (c == '\\') {
	    /* Return an error if 0 follows the slash. */
	    ERRCHK(*path == 0, EINVAL);

	    /* Copy next character as it is. */
	    *i++ = *path++;
            ERRCHK(i == &to[NAME_MAX], EINVAL);
	    continue;
        }

        /* Stop at path component end. */
        if (c == '/') {
	    *i = 0; /* Mark string end. */
	    break;
        }

        *i++ = c;
        ERRCHK(i == &to[NAME_MAX], EINVAL);

        if (c == 0) {
	    path--;  /* We want to get the end without extra checks. */
	    break;
        }
    }

    *from = path;

    return err;
}

/*
 * Lookup object by absolute or relative path.
 *
 * All characters are allowed (includes whitespaces). Slashes must be escaped
 * by backslashes. Multiple slashes are compressed to singles.
 *
 * If path[0] equals '/', the path starts at the root directory, otherwise
 * from the current process' working directory.
 */
int
namespace_lookup_path (struct obj **retobj, char *path)
{
    struct obj *dir;
    char       *nbuf;
    int        err = 0;

    NAMESPACE_PRINTK("namespace_lookup_path %s\n", path);

    *retobj = NULL;	/* Nothing looked up yet. */

#ifndef NO_CHECKS
    /* Check if the path is empty. */
    ERRCHK(path == 0, EINVAL);
#endif

    /* Get buffer for de-escaped names. */
    nbuf = (char *) malloc (NAME_MAX);
    ERRCHK(nbuf == 0, ENOMEM);

#ifndef NO_PROC
    /* Check wether to start from the root node or working directory. */
    if (*path == '/') {
#endif
	dir = namespace_root_obj;

	/* Skip any more slashes that follow. */
	CHARSKIP(path, '/');
#ifndef NO_PROC
    } else
        dir = CURRENT_PROC()->pwd;
#endif

    *retobj = dir;

    /* Lookup component by component. */
    while (*path != 0) {
	err = namespace_deescape_path (nbuf, &path);
	ERRGOTO(err, error1);

	/* Lookup object from directory set already in memory. */
	err = namespace_lookup (retobj, dir, nbuf);
	ERRGOTO(err, error1);

	/* Break, if the component wasn't found. */
        ERRGOTO(*retobj == NULL, error1);

	/* Return not found error. */
	ERRCGOTO(retobj == 0, EINVAL, error1);

	/* Skip double slashes. */
	CHARSKIP(path, '/');

	/* The new object is our next directory to use for lookups. */
	dir = *retobj;
    }

    /* We have the object. err is 0. */

error1:
    free (nbuf);

    NAMESPACE_PRINTK("<namespace_lookup_path: %d\n", *retobj);

    return err;
}

#endif /* #ifndef NO_IO */
