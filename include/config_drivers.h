/*
 * tensix operating system project
 * Copyright (C) 2002, 2003 Sven Klose <pixel@copei.de>
 *
 * List of available drivers
 *
 * $License$
 */

#ifdef CONSOLE
con_init,
#endif

#ifdef DISK
disk_init,
#endif

#ifdef MEMFS
memfs_init,
#endif

#ifdef ETHERNET
eth_init,
#endif

#ifdef WRAPFS
wrapfs_init,
#endif

#if 0
#ifdef UIP
uip_if_init,
#endif
#endif
