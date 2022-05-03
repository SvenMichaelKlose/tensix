/*
 * tensix operating system project
 * Copyright (C) 2002, 2003 Sven Klose <pixel@copei.de>
 *
 * Kernel libc string functions
 *
 * $License$
 */

#include <types.h>

void
bzero (void *dest, size_t len)
{
    while (len--)
        *(u8_t *) dest++ = 0;
}

void
memcpy (void *dest, void *src, size_t len)
{
    while (len--)
        *(u8_t *) dest++ = *(u8_t *) src++;
}

/*
 * Compare 2 memory blocks.
 *
 * Returns a value less than 0 if s1 < s2, or a value greater that 0 if
 * s1 > s2. 0 is returned if the blocks match.
 */
int
memcmp (void *s1, void *s2, size_t len)
{
    char r = 0;

    while (len--) {
        r = *(u8_t *) s2 - *(u8_t *) s1;
        if (r)
	        return r;
        s1++;
        s2++;
    }

    return 0;
}

size_t
strlen (char *p)
{
    size_t len = 0;

    while (*p++)
        len++;

    return len;
}

char *
strcpy (char *dest, char *src)
{
    char *ret = dest;

    while ((*dest++ = *src++) != 0);

    return ret;
}

char *
strcat (char *dest, char *src)
{
    char *ret = dest;

    while (*dest != 0)
	    dest++;

    while ((*dest++ = *src++) != 0);

    return ret;
}

/*
 * Compare 2 strings.
 *
 * Returns a value less than 0 if s1 < s2, or a value greater that 0 if
 * s1 > s2. 0 is returned if the blocks match.
 */
int
strcmp (char *s1, char *s2)
{
    char r = 0;

    while (1) {
        /* Get difference between characters. */
        r = *s2 - *s1;

        /* Check if characters match. */
        if (r != 0)
	    return r;

        /* Additionally check if strings terminate. */
        if (*s1 == 0)
            break;

        /* Get to next chars. */
        s1++;
        s2++;
    }

    return 0; /* Strings matched. */
}

int
strncmp (char *s1, char *s2, size_t len)
{
    char r = 0;

    while (len--) {
        /* Get difference between characters. */
        r = *s2 - *s1;

        /* Check if characters match. */
        if (r != 0)
	    return r;

        /* Additionally check if trings terminated. */
        if (*s1 == 0)
            break;

        /* Get to next chars. */
        s1++;
        s2++;
    }

    return 0; /* Strings matched. */
}
