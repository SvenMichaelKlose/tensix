/*
 * tensix operating system project
 * Copyright (C) 2002-2005, 2010 Sven Klose <pixel@copei.de>
 *
 * directory file system.
 *
 * $License$
 */

#include <types.h>
#include <dir.h>
#include <error.h>
#include <libc.h>
#include <obj.h>
#include <namespace.h>
#include <dirent.h>
#include <proc.h>
#include <string.h>
#include <libbuf.h>
#include <xxx.h>
#include <fs.h>

void
dfs_get_gap (fsize_t *gap, size_t *gaplen, struct dirent *dirent,
             fsize_t ofs, fsize_t end)
{
    fsize_t nextp;
    fsize_t gapend;

    /* Get offset of next entry. */
    nextp = dirent->nextrec - ofs;

    /* Get end of gap. Don't cross block end. */
    gapend = (nextp < end) ? nextp : end;

    /* Get offset of gap. */
    *gap = ofs + dirent->reclen;

    /* Get length of gap. */
    *gaplen = gapend - *gap;
}

/*
 * Allocate a directory entry.
 *
 * This function places new entries in gaps or at the end of the directory
 * file. Gaps are not filled at block starts.
 */
int
dfs_create (struct obj *obj, struct obj *newobj, int type)
{
    struct buf    *buf = 0;
    struct dirent *dirent;   /* Directory in buffer. */
    fsize_t       ofs = 0;
    fsize_t       end = ofs;
    fsize_t       new = 0;   /* Offset of new dirent. */
    size_t        gaplen;
    size_t        newreclen = DIRENT_RECLEN(newobj->dirent->name);
    int           i = 0;
    int           err;

    while (1) {
	/* Get next file block, create if neccessary. */
        if (ofs >= end) {
	    bunref (buf);
            err = batofsend (&buf, (void**) &dirent, (void**) &end,
			     obj, ofs, IO_CREATE);
            ERRCODE(err);
	}

	/* Break, if we found a free entry. */
	if (dirent->nextrec == 0) {
	    /* Is it the first entry? */
	    if (dirent->reclen == 0)
		break;

	    /* Don't cross block boundary. */
	    if (end < (ofs + dirent->reclen))
		dirent->nextrec = end;
	    else
	        dirent->nextrec = ofs + dirent->reclen;

	    break;
	}

        /* Is it an erased entry? */
        if (dirent->name == 0) {
	    ofs = dirent->nextrec;
	    continue;
	}

	/* Check if the gap to next record is large enough. */
        dfs_get_gap (&new, &gaplen, dirent, ofs, end);
	if (gaplen >= newreclen) {
	    dirent->nextrec = new;
	    break;
	}

	/* Step to next entry offset. */
	i++;
	ofs = dirent->nextrec;
    }

    /* Directory entry changed - write it back. */
    BDUNREF(buf);

    /* Update new directory entry. */
    err = batofs (&buf, (void**) &dirent, obj, new, 0);
    ERRCODE(err);

    TYPECPY(struct dirent, dirent, newobj->dirent);

    BDUNREF(buf);

    return ENONE;
}

/*
 * Lookup a directory entry by index.
 */
int
dfs_dir_seek (struct buf **retbuf, fsize_t *retofs, void **retptr,
              struct obj *obj, int index)
{
    struct dirent * dirent = NULL;
    struct buf    * buf = 0;
    fsize_t       ofs = 0;
    fsize_t       end = ofs;
    int           err;

    while (index-- >= 0) {
	/* Get current block of directory file. */
	if (ofs >= end) {
	    bunref (buf);
            err = batofsend (&buf, (void**) &dirent, (void**) &end,
			     obj, ofs, IO_CREATE);
            ERRCODE(err);

	    /* Break at end of directory file. */
	    if (buf->blk == obj->size)
		return ENOTFOUND;
	}

	/* Step to next entry. */
	ofs = dirent->nextrec;
    }

    *retofs = ofs;
    *retbuf = buf;
    *retptr = dirent;
    return ENONE;
}
    
/* Free a directory entry. */
int
dfs_unlink (struct obj *obj)
{
#if 0
    struct buf *pbuf = 0;
    struct buf *buf;
    struct dirent *dir;
    struct dirent *pdir;
    fsize_t    ofs;
    int        err;
    int index;
    struct dirent *dirent = obj_get_dirent (obj);

    if (index != 0) {
        dfs_dir_seek (&pbuf, &ofs, (void **) &pdir, obj, index - 1);
        err = batofs (&buf, (void**) &dir, obj, pdir->nextrec, 0);
	pdir->nextrec = dir->nextrec;
    } else {
        dfs_dir_seek (&buf, &ofs, (void **) &dir, obj, index);
	if (ofs != 0) {
            err = batofs (&pbuf, (void**) &pdir, obj, 0, 0);
	    pdir->nextrec = ofs;
	}

	/*
	 * Mark entry as erased. We need this to step over the first gap in
	 * the directory file.
	 */
	dir->name[0] = 0;
    }
    if (pbuf != NULL)
        BDIRTY(pbuf);
    bunref (buf);
#endif

    return ENONE;
}

/* Write a directory entry. */
int
dfs_dir_write (struct dirent *dirent)
{
    return ENOTSUP;
}

#if 0
struct obj_ops dfs_obj_ops = {
    NULL,  /* int (*io) (struct buf *, struct obj *, blk_t, bool mode); */
    dfs_create,  /* int (*create) (struct obj *dir, struct obj *, int type); */
    dfs_unlink,  /* int (*unlink) (struct obj *); */
    NULL,  /* int (*resize) (struct obj *, blk_t newlen); */
    dfs_dir_open,  /* int (*dir_open) (struct dir *); */
    dfs_dir_close,  /* int (*dir_close) (struct dir *); */
    dfs_dir_read,  /* int (*dir_read) (struct dirent *, struct dir *); */
    dfs_lookup,  /* int (*lookup) (struct obj **, struct obj *dir, char *name); */
    NULL,  /* int (*dup) (struct obj *class, struct obj *); */
    NULL,  /* int (*get_obj) (struct obj *, objid_t id); */
    NULL   /* int (*get_dirent) (struct dirent *, objid_t id); */
};

#endif

int
dfs_init_hook_storeops (struct obj *dfsroot, struct obj *fstore)
{
    /* Backup old vector. */
    /* Override directory ops. */
return 0;
}

int
dfs_mount (struct obj *fstore)
{
    struct obj dfsroot;

    /* Open root directory file (id = 1). */
    /* Check if it is a valid dfs directory. */

    /* Create root directory object. */

    dfs_init_hook_storeops (&dfsroot, fstore);
return 0;
}
