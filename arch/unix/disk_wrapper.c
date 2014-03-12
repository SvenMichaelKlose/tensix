/*
 * tensix operating system project
 * Copyright (C) 2002, 2003, 2004, 2005 Sven Klose <pixel@copei.de>
 *
 * unix platform driver
 * disk driver libc wrapper.
 *
 * $License$
 */

#include <stdio.h>
#include <errno.h>

FILE *disk_raw_file;

int
disk_io_raw (void *data, int len, int blk, int mode)
{
    int l;

    fseek (disk_raw_file, len * blk, SEEK_SET);

    if (mode == 0)
        l = fread (data, len, 1, disk_raw_file);
    else
        fwrite (data, len, 1, disk_raw_file);

    return 0;
}

void
disk_init_raw ()
{
    disk_raw_file = fopen ("image.dsk", "r+");
}
