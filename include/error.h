/*
 * tensix operating system project
 * Copyright (C) 2002, 2003 Sven Klose <pixel@hugbox.org>
 *
 * Errors
 *
 * $License$
 */

#ifndef _SYS_ERROR_H
#define _SYS_ERROR_H

#define ERRDBG()

#define ERRCODE(errcode) \
    if (errcode != 0) {  \
	ERRDBG(); 	 \
        return errcode;  \
    }

#define ERRCHK(test, errcode) \
    if (test) {               \
	ERRDBG();             \
        return errcode;       \
    }

#define ERRNULL(var) \
    if (var == NULL) {        \
	ERRDBG();             \
        return NULL;          \
    }

#define ERRNULLC(var, retcode) \
    if (var == NULL) {         \
	ERRDBG();              \
        return retcode;        \
    }

#define ERRGOTO(test, label) \
    if (test) {              \
	ERRDBG(); 	     \
        goto label;          \
    }

#define ERRCGOTO(test, errcode, label) \
    if (test) {                        \
	err = errcode;                 \
	ERRDBG(); 		       \
        goto label;                    \
    }

#define ENONE       0   /* No error. */
#define ENOMEM      1   /* Out of memory. */
#define EINVAL      2   /* Invalid syscall parameters. */
#define ENOTSUP     3   /* Filesystem operation not supported by the object. */
#define ENOTFOUND   4   /* File not found. */
#define ENOIODATA   5   /* No data for I/O buffer. */
#define EBUSY       6   /* Resource busy. */
#define EDRVR       7   /* Driver level error. */
#define EABORT      8   /* Access to object was aborted. */
#define ECLOSE      9   /* Access to object was closed. */
#define ETIMEOUT   10   /* Operation timed out. */
#define EEXISTS    11   /* Object exists. */
#define EINTERNAL  12   /* Internal kernel error. */
#define EERROR     13   /* Unknown error code. */

#define MAX_ERR	   EERROR

/*
 * Debugging macros.
 */
#ifdef DIAGNOSTICS
#define ASSERT(condition, panicmsg) \
    if (condition)                  \
        panic (panicmsg)
#else
 #define ASSERT(condition, panicmsg)
#endif

#ifndef NO_CHECKS
#define IASSERT(condition, panicmsg) \
    if (condition)                   \
        panic (panicmsg)
#else
#define IASSERT(condition, panicmsg)
#endif

#endif /* #ifndef _SYS_ERROR_H */
