/*
 * tensix operating system project
 * Copyright (C) 2002 Sven Klose <pixel@copei.de>
 *
 * Filestore
 *
 * $License$
 */

#ifndef _SYS_NIXFS_H
#define _SYS_NIXFS_H

#include <types.h>

typedef u16_t	inode_t;

#define NIXFS_MAXIDX0	8

/*
 *  Filesystem info structure.
 */
struct nixfs_info {
    u8_t  blksize_log; /* Logarithmic block size. */

    blk_t num_lblks;   /* Number of logical blocks. */
    blk_t num_inodes;  /* Number of inodes in table. */

    blk_t bmap_start;  /* First block containing the block map. */
    blk_t imap_start;  /* First block containing the inode map. */
    blk_t inode_start; /* First block containing the inode table. */

    blk_t rr_inode;    /* Hint to find a free inode. */
    struct obj *lower;
};

/*
 *  The super block which is stored in the first physical block of a drive.
 */
struct nixfs_super {
    char    magic[5];
    u16_t   ver;	/* Filesystem version. */
    struct nixfs_info info;
    u8_t    chksum;	/* CRC checksum for filesystem detection. */
};

struct inode {
    blk_t idx0[NIXFS_MAXIDX0]; /* Direct block index. */
    blk_t idx1; /* Number of block containing the indirect index. */
    blk_t size; /* Size of file in blocks. */
};

/* Get filesystem info. */
#define NIXFS_INFO(obj)	((struct nixfs_info*) OBJ_SUBCLASS(obj)->detail)

/* Get size of allocation map in blocks. */
#define NIXFS_BMAPSIZE(info)   ROUNDUP(info->num_lblks / 8, NIXFS_BLKSIZE(info))

/* Get size of inode table in blocks. */
#define NIXFS_IMAPSIZE(super) \
	ROUNDUP(info->num_inodes * sizeof (struct inode), NIXFS_BLKSIZE(info))

/* Get block size. */
#define NIXFS_BLKSIZE(info)	(1 << info->blksize_log)

int nixfs_alloc (struct obj *obj);
int nixfs_dealloc (struct obj *obj);
int nixfs_truncate (struct obj *obj, blk_t newlen);
int nixfs_io (struct buf **buf, struct obj *obj, blk_t lblk, bool mode);

#endif /* #ifndef _SYS_NIXFS_H */
