/*
 * tensix operating system project
 * Copyright (C) 2003 Sven Michael Klose <pixel@hugbox.org>
 *
 * nix compile-time kernel configuration
 * Checking of option dependencies.
 *
 * $License$
 */

#ifndef _SYS_CONFIG_DEPS_H
#define _SYS_CONFIG_DEPS_H

#include <config.h>

/* Check SYNCER requirements. */
#ifdef SYNCER
#ifndef MULTITASKING
#error No SYNCER without MULTITASKING.
#endif
#endif

#endif /* #ifndef _SYS_CONFIG_DEPS_H */
