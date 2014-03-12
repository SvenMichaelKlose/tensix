/*
 * tensix operating system project
 * Copyright (C) 2002, 2003 Sven Klose <pixel@hugbox.org>
 *
 * C library
 *
 * $License$
 */

#include <types.h>
#include <con.h>
#include <libc.h>

void
printnhex (unsigned int n, unsigned int digits)
{
    unsigned s = digits << 2;

    while (digits--)
        con_out ("0123456789abcdef"[(n >> (s -= 4)) & 15]);
}

/*
 * Print decimal number.
 */
void
printndec (unsigned int n)
{
    char out[12];
    unsigned int  i = 0;

    do {
        out[i++] = n % 10;
	n /= 10;
    } while (n);

    while (i--)
        con_out (out[i] + '0');
}

/* Stupid printf. */
void
printk (char *fmt, unsigned int v)
{
    int      d;
    char     c;
    char     *s;

    while ((c = *fmt++) != 0) {
        if (c != '%') {
            con_out (c);
	    continue;
	}
	c = *fmt++;
	switch (c) {
        case 'd':
        case 'l':
            d = (unsigned int) v;
	    printndec ((unsigned int) d);
	    break;

        case 's':
            s = (char*) v;
	    while ((c = *s++) != 0)
	        con_out (c);
	    break;

        default:
	    con_out ('%');
	    con_out (c);
	}
    }
}
