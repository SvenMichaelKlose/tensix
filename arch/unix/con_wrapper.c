/*
 * tensix operating system project
 * Copyright (C) 2002, 2003 Sven Klose <pixel@hugbox.org>
 *
 * unix platform driver
 * libc wrapper for the unix console driver.
 *
 * $License$
 */

#include <stdio.h>
#include <unistd.h>
#include <termios.h>

void
con_out (c)
    char c;
{
    switch (c) {
	case '\f': /* FF */
	    printf ("\033[2J\033[H");
	    return;
	case 0x7f: /* DEL */
	    printf ("\033[D1");
	    return;
	case '\n': /* LF */
	    putchar (c);
	    putchar (13);  /* CR */
	    return;
    };
    putchar (c);
}

char
con_in ()
{
    int c = getchar ();

    if (c == EOF) {
        clearerr (stdin);
	usleep (10000);
        return 0;
    }

    return c;
}

void
con_init_raw ()
{
    struct termios settings;
    int result;
    int desc = STDIN_FILENO;

    result = tcgetattr (desc, &settings);
    if (result < 0) {
        perror ("con");
        return;
    }
    settings.c_lflag &= ~ICANON;
    settings.c_cc[VMIN] = 0;
    settings.c_cc[VTIME] = 0;
    result = tcsetattr (desc, TCSANOW, &settings);
    if (result < 0) {
        perror ("con");
        return;
    }
}
