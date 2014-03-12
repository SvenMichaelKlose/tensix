/*
 * tensix operating system project
 * Copyright (C) 2002, 2003 Sven Klose <pixel@copei.de>
 *
 * libc functions.
 *
 * $License$
 */

#include <types.h>
#include <libc.h>
#include <obj.h>
#include <fs.h>
#include <error.h>
#include <proc.h>

struct obj  *libc_con;

void
libc_init ()
{
    int err = open (&libc_con, "/con");
    if (err != ENONE) {
        printk ("libc: fatal error: can't open /con\n", 0);
        exit (-1);
    }
}

void
libc_close ()
{
    close (libc_con);
}

#ifdef LIBC_BUFFERED
/* Flush output buffer. */
void
libc_flush ()
{
}
#endif

/*
 * Print decimal number.
 */
void
libc_printndec (char ** whereto, unsigned int n)
{
    char *to = *whereto;
    char out[12];
    unsigned int  i = 0;

    do {
        out[i++] = n % 10;
        n /= 10;
    } while (n);

    while (i--)
        *to++ = out[i] + '0';

    *whereto = to;
}

/* Stupid printf. */
void
printf (char *fmt, unsigned int v)
{
    int      d;
    char     c;
    char     *s;
    struct buf  *buf;
    char     *p;
    int     err;

    err = bref (&buf, libc_con, 0, IO_CREATE);
    if (err != ENONE) {
        printk ("printf: fatal error: can't get console buffer\n", 0);
        exit (-1);
    }
    p = buf->data;

    while ((c = *fmt++) != 0) {
        if (c != '%') {
	    *p++ = c;
	    continue;
	}
	c = *fmt++;
	switch (c) {
        case 'd':
        case 'l':
            d = (unsigned int) v;
	    libc_printndec (&p, (unsigned int) d);
	    break;

        case 's':
            s = (char*) v;
	    while ((c = *s++) != 0)
	        *p++ = c;
	    break;

        default:
	    *p++ = '%';
	    *p++ = c;
	}
    }

    buf->len = (size_t) POINTER_SUB(p, buf->data);
    BDIRTY(buf);
    bunref (buf);
}
