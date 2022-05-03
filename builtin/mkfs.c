/*
 * tensix operating system project
 * Copyright (C) 2004 Sven Klose <pixel@hugbox.org>
 *
 * Built-in mkfs
 * Filesystem creation utility
 *
 * $License$
 */

#include <buf.h>
#include <error.h>
#include <dir.h>
#include <dirent.h>
#include <fs.h>
#include <nixfs.h>
#include <string.h>
#include <libc.h>
#include <xxx.h>

#include "./mkfs.h"

int
mkfs_clr (struct obj *obj, blk_t start, blk_t num)
{
    struct buf  *buf;

    while (num--) {
        bref (&buf, obj, start, IO_CREATE | IO_ZERO);
	    BDUNREF(buf);
        start++;
    }

    return ENONE;
}

int
mkfs (int argc, char** argv)
{
    struct nixfs_super  *super;
    struct nixfs_info   *info;
    unsigned int  total_blks = 1440;
    blk_t  bmap_blks;
    blk_t  imap_blks;
    unsigned int num_inodes;
    struct obj *  obj;
    struct buf *  buf;
    int err;

    if (argc != 2)
	    return EINVAL;

    err = open (&obj, argv[1]);
    ERRCODE(err);

    /* Clear boot sector. */
    mkfs_clr (obj, 0, 1);

    err = bref (&buf, obj, 1, IO_CREATE | IO_ZERO);
    ERRCODE(err);

    super = (struct nixfs_super *) buf->data;
    info = &super->info;

    strcpy (super->magic, "NIXFS");
    super->ver = 0;
    super->chksum = 0;
    info->blksize_log = 8; /* 512 */
    info->num_lblks = total_blks;
    num_inodes = info->num_inodes = total_blks / 8;
    info->bmap_start = 2;
    bmap_blks = NIXFS_BMAPSIZE(info);
    imap_blks = NIXFS_IMAPSIZE(super);
    info->imap_start = info->bmap_start + bmap_blks;
    info->inode_start = info->imap_start + imap_blks;

    /* Clear block map. */
    mkfs_clr (obj, info->bmap_start, bmap_blks + imap_blks);


    info->rr_inode = 0;

    BDUNREF(buf);
    close (obj);

    printf ("mkfs: nixfs, %d blocks, ", total_blks);
    printf ("%d system blocks, ", bmap_blks + imap_blks + 2);
    printf ("%d inodes.\n", num_inodes);

    return err;
}
