/*
 * tensix operating system project
 * Copyright (C) 2002, 2003 Sven Klose <pixel@hugbox.org>
 *
 * i86-pc vt25 bios console driver
 *
 * $License$
 */

#include <obj.h>
#include <buf.h>
#include <libc.h>
#include <proc.h>
#include <machdep.h>

void
con_out (c)
    char c;
{
    con_bios_out (c);
}

char
con_in ()
{
    return con_bios_in ();
}
