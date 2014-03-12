/*
 * tensix operating system project
 * Copyright (C) 2002 Sven Klose <pixel@copei.de>
 *
 * File store
 *
 * $License$
 */

#include <types.h>
#include <dir.h>
#include <obj.h>
#include <buf.h>
#include <nixfs.h>
#include <error.h>
#include <bitmap.h>
#include <string.h>
#include <libbuf.h>
#include <xxx.h>
#include <fs.h>

/*
 * Mark block as used or unused.
 */
int
nixfs_set_block_bitmap (struct obj *obj, blk_t blk, bool val)
{
    struct nixfs_info *info = NIXFS_INFO(obj);
    struct obj        *lower = info->lower;
    struct buf        *buf;
    blk_t             bblk;
    int               err;

    /* Get bitmap block . */
    bblk = info->bmap_start + (blk >> (3 + info->blksize_log));
    err = bref (&buf, lower, bblk, 0);
    ERRCODE(err);

    /* Unset block in bitmap. */
    BITMAP_SET(buf->data, blk % (LOG2INT(info->blksize_log) << 3), val);

    return ENONE;
}

/*
 * Allocate a free block.
 */
int
nixfs_alloc_block (struct obj *obj, blk_t *physp)
{
    struct nixfs_info *info = NIXFS_INFO(obj);
    int         err;
    struct buf  *buf;
    struct obj  *lower = info->lower;
    int         preferred = 0;
    int         dummy;
    blk_t       blk;

    /* Seek free block. */
    err = bio_seek_map (lower, info->bmap_start, info->num_lblks, 1,
                        preferred, &blk, &buf, (void**) &dummy);
    ERRCODE(err);

    bunref (buf);

    *physp = blk;

    return nixfs_set_block_bitmap (obj, blk, 1);
}

/*
 * Free a block.
 */
int
nixfs_dealloc_block (struct obj *obj, blk_t blk)
{
    return nixfs_set_block_bitmap (obj, blk, 0);
}

/*
 * Map in inode structure of an object.
 */
int
nixfs_get_inode (struct buf **buf, struct inode **inode, struct obj *obj,
	 	 inode_t inodenr)
{
    size_t  blksize = OBJ_BLKSIZE(obj);
    fsize_t ofs = inodenr * sizeof (struct inode); /* Offset in lower obj. */
    blk_t   blk = ofs / blksize;  /* Block in lower obj. */
    size_t  rofs = ofs % blksize; /* Inode offset inside buffer. */
    int err;

    /* Get inode buffer. */
    err = bref (buf, obj, blk, 0);
    ERRCODE(err);

    /* Get pointer to inode inside buffer. */
    *inode = POINTER_ADD((*buf)->data, rofs);

    return ENONE;
}

/*
 * Create a new file.
 */
int
nixfs_alloc (struct obj *obj)
{
    inode_t      inodenr;
    struct nixfs_info *info = NIXFS_INFO(obj);
    struct inode *inode;
    struct buf   *buf;
    struct obj   *lower = info->lower;
    int          ofs;
    int          err;

    /* Seek free inode. */
    /* XXX Allocate after last file lock. */
    err = bio_seek_map (lower, info->imap_start, info->num_inodes, 1,
                        info->rr_inode, &inodenr, &buf, (void**) &ofs);
    ERRCODE(err);

    /* Mark inode as used. */
    BITMAP_SET(buf->data, inodenr - ofs, 1);

    /* Mark bitmap buffer as dirty and unref. */
    BDUNREF(buf);

    /* Get inode. */
    err = nixfs_get_inode (&buf, &inode, lower, ofs);
    ERRCODE(err);

    /* Zero out inode. */
    bzero (inode, sizeof (struct inode));

    /* Mark inode buffer dirty. */
    BDUNREF(buf);

    /* Save inode number to object. */
    obj->id = inodenr;
    obj->detail = NULL; /* No more to tell about the file. */

    return ENONE;
}

/*
 * Remove a file.
 */
int
nixfs_dealloc (struct obj *obj)
{
#if 0
    struct nixfs_info *info = NIXFS_INFO(obj);
    struct obj  *lower = info->lower;
    inode_t     inodenr = (inode_t) obj->id;
    fsize_t ofs = inodenr * sizeof (struct inode); /* Offset in lower obj. */
    struct buf  *buf;
    int         err;

    /* Truncate file to 0. */
    err = nixfs_truncate (obj, 0);
    ERRCODE(err);

     /* Get inode map. */
    err = nixfs_get_inode (&buf, lower, inodenr / 8 + info->imap_start);
    ERRCODE(err);

    /* Mark inode as unused. */
    BITMAP_SET(buf->data, inodenr - ofs, 0);

    /* Write back bitmap buffer. */
    BDUNREF(buf);
#endif

    return ENONE;
}

/*
 * Update block index.
 */
int
nixfs_truncate_block (struct obj *lower, blk_t *logp, bool add)
{
    int err;

    if (add != 0) {
        err = nixfs_alloc_block (lower, logp);
    } else {
        err = nixfs_dealloc_block (lower, *logp);
        if (err == 0)
            *logp = 0;
    }

    return err;
}

/*
 * Extend or shorten a file.
 */
int
nixfs_truncate (struct obj *obj, blk_t newlen)
{
    struct nixfs_info *info = NIXFS_INFO(obj);
    struct obj   *lower = info->lower;
    struct buf   *ibuf;
    struct buf   *idx1buf;
    struct inode *inode;
    inode_t      inodenr = (inode_t) obj->id;
    blk_t        *idx1;
    blk_t        oldlen = 0;
    blk_t        end;
    blk_t        p;
    char         add;
    int          err;

    /* Get type of operation. */
    add = newlen > oldlen;

    /* Get start and end. */
    if (add == FALSE) {
	p = oldlen;
        end = newlen;
    } else {
	p = newlen;
        end = oldlen;
    }
    
    /* Get inode buffer. */
    err = nixfs_get_inode (&ibuf, &inode, lower, inodenr);
    ERRCODE(err);

    /* Process directly indexed blocks. */
    while (p < NIXFS_MAXIDX0 && p < end) {
        nixfs_truncate_block (lower, &(inode->idx0[p]), add);
	p++;
    }

    /* Break here if we have finished. */
    if (p == end)
        goto done;

    /* Get index block. */
    err = bref (&idx1buf, lower, inode->idx1, 0);
    ERRCODE(err);
    idx1 = idx1buf->data;

    /* Process indirectly indexed blocks. */
    while (p < end) {
        nixfs_truncate_block (lower, &(idx1[p]), add);
	p++;
    }

    /* Free index block. */
    BDUNREF(idx1buf);

done:
    /* Save new file size. */
    inode->size = newlen;
    BDUNREF(ibuf);

    return ENONE;
}

/*
 * Read or write file block-wise.
 */
int
nixfs_io (struct buf **buf, struct obj *obj, blk_t lblk, bool mode)
{
    struct nixfs_info *info = NIXFS_INFO(obj);
    struct obj *lower = info->lower; /* Object containing the fs. */
    struct buf    *ibuf;    /* Inode buffer. */
    struct inode  *inode;   /* Pointer to inode in buffer. */
    struct buf    *idx1buf; /* Indirect index buffer. */
    blk_t         *idx1;    /* Pointer to first indirect index in buffer. */
    blk_t         phys;     /* Physical block number. */
    blk_t         *physp;   /* Physical block number in index. */
    int           err;

    /* Get inode. */
    err = nixfs_get_inode (&ibuf, &inode, lower, obj->id);
    ERRCODE(err);

    /* Get physical block number. */
    if (lblk <= NIXFS_MAXIDX0) {
        /* Get from direct index in inode. */
        physp = &(inode->idx0[lblk]);
    } else {
	/* Get indirect index. */
        err = bref (&idx1buf, lower, inode->idx1, 0);
        ERRCODE(err);
	idx1 = idx1buf->data;

        /* Get physical block number. */
        physp = &(idx1[lblk - NIXFS_MAXIDX0]);

	/* Unreference index buffer. */
	bunref (idx1buf);
    }

    /* Allocate a block if there's none. */
    if (mode == IO_W && *physp == 0) {
        err = nixfs_alloc_block (obj, physp);
        if (err != 0) {
            bunref (ibuf);
            return err;
        }
    }
    phys = *physp;

    /* Unreference inode buffer. */
    bunref (ibuf);

    /* Get block from lower obj. */
    return ENONE; /* return bio (buf, lower, phys, mode); */
}

/*
 * Mount a filesystem instance to an object.
 */
int
nixfs_mount (struct obj *newobj, struct obj *store)
{
    struct nixfs_super *super;
    struct nixfs_info  *info;
    struct buf         *buf;
    int                err;

    /* Read filesystem info. */
    err = bref (&buf, store, 1, 0);
    ERRCODE(err);
    super = (struct nixfs_super*) buf->data;

    /* Check magic. */
    ERRCGOTO(memcmp ((char*) super, "NIXFS", 5), EINVAL, error1);

    /* Allocate space for info. */
    info = KTMALLOC(struct nixfs_info);
    ERRCGOTO(info == NULL, ENOMEM, error1);

    /* Copy info. */
    memcpy ((char*) info, (char*) &((*super).info), sizeof (struct nixfs_info));

    /* Save lower object. */
    info->lower = store;

    /* Save info as object type detail. */
    OBJ_CLASS(newobj)->detail = info;

    /* Save block size in object. */
    OBJ_BLKSIZE(newobj) = NIXFS_BLKSIZE(info);

error1:
    bunref (buf);
    return err;
}
