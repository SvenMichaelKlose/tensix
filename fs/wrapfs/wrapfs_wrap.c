/*
 * tensix operating system project
 * Copyright (C) 2002, 2003, 2004, 2005 Sven Klose <pixel@copei.de>
 *
 * libc filesystem wrapper
 *
 * $License$
 */

#include <sys/types.h>
#include <sys/stat.h>
#include <dirent.h>
#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include "../../include/wrapfs.h"

int wrapfs_numobjs;
char *wrapfs_dirs[16284];
char wrapfs_names[162840];
struct wrapfs_obj wrapfs_objects[16284];

int
wrapfsw_size (char *path)
{
   int size;
   FILE *file = fopen (path, "r");
   if (file == NULL)
      return 0;
   fseek(file, 0, SEEK_END);
   size = ftell (file);
   fclose (file);

   return size;
}

/*
 * Read block from file.
 */
int
wrapfsw_io (char *path, int offset, void *data, int *len, int mode)
{
    int nlen;
    FILE *file = fopen (path, "r+");

    fseek (file, offset, SEEK_SET);

    if (mode == 0)
        nlen = fread (data, 1, *len, file);
    else
        nlen = fwrite (data, 1, *len, file);

    if (nlen < *len)
	*len = nlen;

    fclose (file);

    return 0;
}

struct wrapfs_obj *
wrapfsw_mkmetaobj (char *path, struct wrapfs_obj *parent, struct wrapfs_obj *last, char *newname, int nlen)
{
    char spath[128];

    /* Get pointer to free meta object and its name entry. */
    struct wrapfs_obj *w = &wrapfs_objects[wrapfs_numobjs++];
    char *name = w->name;

    /* Link record to previous sibling. */
    w->parent = parent;
    w->prev = last;
    if (last != NULL)
        last->next = w;
    else
        parent->childs = w;

    /* Copy name into directory entry. */
    strncpy (name, newname, nlen);
    strcpy (spath, path);
    name[nlen] = 0;

    /* Get file size. */
    strcat (spath, "/");
    strcat (spath, name);
    w->size = wrapfsw_size (spath);
    w->next = NULL;

    return w;
}
 
/*
 * Create a file or directory.
 */
int
wrapfsw_create (struct wrapfs_obj **ret, int id, char *path, char *name, int type)
{
    struct wrapfs_obj  *i;
    int fd;

    strcat (path, "/");
    strcat (path, name);

    /* Create a file. */
    if (type == 1) {
        fd = creat (path, S_IRWXU);
	if (fd == 0)
	    return -1;
	//close (fd);

	/* Get first meta object of directory. */
        i = wrapfs_objects[id].childs;

	while (i->next != NULL)
	    i = i->next;

	*ret = wrapfsw_mkmetaobj (path, i->parent, i->prev, name, strlen (name));
	return 0;
    }

    /* Create a directory. */
    return mkdir (path, S_IRWXU);
}

/*
 * Remove a file.
 */
int
wrapfsw_unlink (char *path)
{
    return unlink (path);
}

/*
 * Resize a file.
 */
int
wrapfsw_resize (char *path, int newlen)
{
    return truncate (path, newlen);
}

char *wdopath;

/*
 * Open directory.
 */
int
wrapfsw_dir_open (void *next, char *path)
{
    DIR **dirhdl = (DIR **) next;
    DIR *dir = opendir (path);
    wdopath = path;
    readdir (dir); /* Ignore first two entries. */
    readdir (dir);
    *dirhdl = dir;

    return 0;
}

/*
 * Close directory.
 */
int
wrapfsw_dir_close (void *next)
{
    DIR **dirhdl = (DIR **) next;
    closedir (*dirhdl);

    return 0;
}

/*
 * Read directory entry of a file.
 */
int
wrapfsw_dir_read (char *name, int *size, void *next)
{
    char path[128];
    DIR **dirhdl = (DIR **) next;
    struct dirent *dirent = readdir (*dirhdl);
    if (dirent == NULL)
        return -1;

    strncpy (name, (void *) &dirent->d_name, dirent->d_namlen);
    name[dirent->d_namlen] = 0;
    strcpy (path, wdopath);
    strcat (path, "/");
    strcat (path, name);
    *size = wrapfsw_size (path);
    return 0;
}

/*
 * Read directory entry of a file.
 */
int
wrapfsw_dir_write (struct dirent *dirent, char *path)
{
    return 0;
}

void
_wrapfs_make_path (char *path, struct wrapfs_obj *i)
{
    struct wrapfs_obj *stack[256];
    struct wrapfs_obj **stackp = stack;
    char *p = path;
    char *s;
    char c;

    *p++ = '.';
    if (i->parent == NULL) {
        *p++ = 0;
	return;
    }

    *stackp++ = NULL;
    do {
	*stackp++ = i;
        i = i->parent;
    } while (i != NULL && i->name[0] !=0);

    while (*--stackp != NULL) {
	*p++ = '/';
	s = (*stackp)->name;
	while ((c = *s++))
	    *p++ = c;
    }
    *p++ = 0;
}

void
_wrapfs_collect_dir (int id)
{
    struct wrapfs_obj *parent = &wrapfs_objects[id];
    struct wrapfs_obj *prev = NULL;
    struct dirent *dirent;
    DIR   *d;
    char path[128];

    /* Quit if directory is already read. */
    if (parent->is_cached != 0)
        return;
    parent->is_cached = -1;

    _wrapfs_make_path (path, parent);

    /* Read names into tree and array. */
    d = opendir (path);
    dirent = readdir (d);  /* Ignore first two entries. */
    dirent = readdir (d);
    while ((dirent = readdir (d)))
	prev = wrapfsw_mkmetaobj (path, parent, prev, dirent->d_name, dirent->d_namlen);

    closedir (d);
}
