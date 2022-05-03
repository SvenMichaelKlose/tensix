/*
 * tensix operating system project
 * Copyright (C) 2002-2005, 2010 Sven Klose <pixel@copei.de>
 *
 * Built-in kernel shell
 *
 * $License$
 */

#include <error.h>
#include <string.h>
#include <libc.h>
#include <mem.h>
#include "../kern/mem/mem_intern.h"
#include <proc.h>
#include <buf.h>
#include <dirent.h>
#include <fs.h>
#include <namespace.h>
#include <iod.h>
#include <main.h>
#include <xxx.h>
#include <sh.h>

#include "./mkfs.h"

#define SH_MAX_ARGS	16

void sh ();

int  argc;
char *argv[SH_MAX_ARGS];
char argstrs[256];

char *error_msgs[] = {
    "out of memory",
    "invalid syscall argument",
    "operation not supported",
    "file not found",
    "end of file",
    "resource busy",
    "driver level error",
    "connection to object aborted",
    "connection to object closed",
    "operation timed out",
    "object exists",
    "unknown error code"
};

#if 0
#define MAIN(name, arg1, arg2)  name (arg1, arg2)
#endif

void
sh_errno (int err)
{
    if (err == ENONE)
	    return;

    if (err > MAX_ERR)
	    err = EERROR;

    printf ("%s: ", (int) argv[0]);
    if (err >= sizeof (error_msgs))
        printf ("error code %d\n", err);
    else
        printf ("%s\n", (size_t) error_msgs[err - 1]);
}

/*
 * Exit shell with error message.
 */
void
sh_error (char *msg)
{
    printf ("sh: %s - stop.\n", (size_t) msg);
    exit (-1);
}

/*
 * Break up command at whitespaces.
 */
void
sh_mkargs (char *ap)
{
    int i = 0;
    char *d = argstrs;

    while (*ap >= ' ' && i < SH_MAX_ARGS) {
        /* Skip whitespaces. */
        while (*ap == ' ')
            ap++;

        /* Break at end of line. */
        if (*ap < ' ')
            break;

        /* Save argument position. */
        argv[i++] = d;

        /* Copy argument. */
        while (*ap != 0 && *ap > ' ')
            *d++ = *ap++;

        *d++ = 0;
    }

    argc = i;
    argv[i] = NULL;
}

#ifndef NO_IO

#ifndef NO_PROC
void
sh_ps_sub (struct proc *i_proc)
{
    struct proc *first = i_proc;
    char *state;

    if (first == NULL)
	    return;

    do {
        state = (i_proc->state & PROC_RUNNING) ? "R" : "S";
        printf ("%d\t", (size_t) i_proc->id);
        printf ("%s\t", (size_t) state);
        printf ("%d\t", (size_t) i_proc->ticks_run);
        printf ("%s\t", (size_t) i_proc->name);
        printf ("%d\n", (size_t) i_proc->stacksize);
        i_proc = (struct proc*) i_proc->next;
    } while (i_proc != first);
}

/*
 * Print list of processes.
 */
int
sh_ps (int argc, char **argv)
{
    printf ("ID\tSTAT\tTIME\tCMD\n", 0);
    sh_ps_sub ((struct proc *) procs_running.first);
    sh_ps_sub ((struct proc *) procs_sleeping.first);

    return ENONE;
}
#endif

#ifndef NO_IO

/*
 * List files in current directory.
 */
int
sh_ls (int argc, char **argv)
{
#ifndef NO_PROC
    struct obj    *obj = CURRENT_PROC()->pwd;
#else
    struct obj    *obj = namespace_root_obj;
#endif

    struct dirent  dirent; /* start with first dir */
    struct dir     *dir;
    int err;
    bool f_close = FALSE;

    if (argc == 2) {
        err = open (&obj, argv[1]);
        ERRCODE(err);
		f_close = TRUE;
    }

    err = dir_open (&dir, obj);
    ERRGOTO(err, end);

    while (1) {
		bzero (&dirent.name, NAME_MAX);
		if (obj_dir_read (&dirent, dir))
	    	break;
        printf ("%s ", (size_t) &dirent.name);
    }
    printf ("\n", 0);
    err = dir_close (dir);

end:
    if (f_close)
        close (obj);

    return err;
}

/*
 * Change directory.
 */
int
sh_cd (int argc, char **argv)
{
    struct obj *obj;
    struct obj *old;
    int err;

    old = CURRENT_PROC()->pwd;

    err = open (&obj, argv[1]);

    if (!(err || obj == NULL)) {
        CURRENT_PROC()->pwd = obj;
	    close (old);
    }

    return err;
}

/*
 * Remove file or empty directory.
 */
int
sh_rm (int argc, char **argv)
{
    return unlink (argv[1]);
}
#endif

/*
 * Print path working directory.
 */
int
sh_pwd (int argc, char **argv)
{
    struct obj *stack[256];
    struct obj *i;
    struct obj **stackp = stack;
    char *path;
    char *p;
    char *s;
    char c;

    if (CURRENT_PROC()->pwd->dirent == NULL) {
        printf ("/\n", 0);
        return ENONE;
    }

    path = malloc (1024);
    p = path;

    i = CURRENT_PROC()->pwd;

    if (i->parent_id == 0) {
	    printf ("no parent id\n", 0);
        *p++ = 0;
        goto end;
    }

    *stackp++ = NULL;
    do {
        s = i->dirent->name;
        *stackp++ = i;
        i = (struct obj *) i->parent_id; /* XXX */
    } while (i != NULL && i->parent_id != 0);

    while (*--stackp != NULL) {
        *p++ = '/';
        s = (*stackp)->dirent->name;
        while ((c = *s++))
            *p++ = c;
    }
    *p++ = 0;
    printf ("%s\n", (int) path);

end:
    free (path);

    return ENONE;
}

int
_sh_create (int type, char *path)
{
    struct obj *obj;
    int err;

    err = create (&obj, CURRENT_PROC()->pwd, type, path);

    if (err == ENONE)
    	close (obj);

    return err;
}

/*
 * Make a file.
 */
int
sh_create (int argc, char **argv)
{
    return _sh_create (OBJ_TYPE_FILE, argv[1]);
}

/*
 * Make a directory.
 */
int
sh_mkdir (int argc, char **argv)
{
    return _sh_create (1, argv[1]);
}

#define SH_OPENCHK(var, file) \
    err = open (&var, file);  \
    ERRCHK(err || var == NULL, err)
/*
 * Create io channel.
 *
 * XXX Leaves src or dst open on error.
 */
int
sh_io (int argc, char **argv)
{
    struct obj *src;
    struct obj *dst;
    struct obj *iod;
    struct buf *buf;
    struct iod_cmd *cmd;
    int err;

    SH_OPENCHK(src, argv[1]); /* Open source file. */
    SH_OPENCHK(dst, argv[2]); /* Open dest file. */
    SH_OPENCHK(iod, "/iod"); /* Open iod file. */

    /* Create buffer. */
    err = bref (&buf, iod, 0, IO_CREATE);
    cmd = (struct iod_cmd *) buf->data;

    /* Set up iod command. */
    IOD_INIT_CMD_CREATE(cmd, src, dst, IODCHN_AUTOCLOSE | IODCHN_IMMEDIATE);

    /* Write command. */
    err = bsend (buf);

    /* Free everything. */
    close (iod);
    close (src);
    close (dst);

    return err;
}

/*
 * Built-in command info.
 */
struct sh_cmd {
    char *name;
    int (*func) (int, char **);
    i8_t  num_args;
};

struct sh_cmd sh_cmds[];

/*
 * Print names of built-in commands.
 */
int
sh_help (int argc, char **argv)
{
    char  name[256];

    if (argc == 1)
		return sh_parse_cmdline ("ls /local/help");

    strcpy (name, "/local/help/");
    strcat (name, argv[1]);
    argv[1] = name;
    argv[2] = "/con";

    return sh_io (3, argv);
}

int
sh_memmap (int argc, char **argv)
{
    mem_dump ();
    return ENONE;
}

int
sh_sh (int argc, char **argv)
{
    struct proc *dummy;

    libc_close ();
    PROC_FUNEXEC(&dummy, sh, 0, 0, 2048, "sh_child");
#if 0
    exit (0);
#endif

    return ENONE;
}

int
sh_dup (int argc, char **argv)
{
    char *src = argv[1];
    char *destdir = argv[2];
    char *destname = argv[3];

    return dup (src, destdir, destname);
}


int
sh_exit (int argc, char **argv)
{
    printk ("sh: exiting.\n", 0);
    exit (0);
    return ENONE;
}

struct nixfilep {
    struct obj *obj;
    struct buf *buf;
    blk_t      blk;
    size_t     rpos;
    void       *pos;
};

int
nixfilep_open (struct nixfilep *fp, struct obj *obj)
{
    int err;

    fp->obj = obj;
    fp->rpos = 0;
    fp->blk = 0;

    err = bref (&fp->buf, obj, 0, 0);

    fp->pos = fp->buf->data;

    return err;
}

void
nixfilep_close (struct nixfilep *fp)
{
    bunref (fp->buf);
}

int
nixfilep_step (struct nixfilep *fp, size_t step)
{
    int      err = ENONE;
    blk_t    blk = fp->blk;
    fsize_t  np = fp->rpos + step;
    blk_t    rblk = np / OBJ_BLKSIZE(fp->obj);

    fp->rpos = np % OBJ_BLKSIZE(fp->obj);

    if (np < 0)
	    blk -= rblk;
    else if (np > fp->buf->len)
	    blk += rblk;

    if (blk != fp->blk) {
        fp->blk = blk;
        bunref (fp->buf);
        err = bref (&fp->buf, fp->obj, fp->blk, 0);
    }

    fp->pos = (void *) ((size_t) fp->buf->data + (size_t) fp->rpos);

    return err;
}

#define NIXFILEP_GET(type, fp) (*(type *) fp->pos)

int
nixfilep_skip_crlf (struct nixfilep *fp, size_t direction)
{
    char c;

    while (1) {
        nixfilep_step (fp, direction);
	    c = NIXFILEP_GET(char, fp);
        if (c != '\r' && c == '\n')
	    break;
    }

    return ENONE;
}

int
nixfilep_step_line (struct nixfilep *fp, size_t direction)
{
    char c;
    char c2;

    if (direction == -1)
	nixfilep_skip_crlf (fp, direction);

    while (1) {
        nixfilep_step (fp, direction);
	    c = NIXFILEP_GET(char, fp);

        if (c != '\r' && c != '\n')
	        continue;

        if (direction == 1) {
            nixfilep_step (fp, direction);
	        c2 = NIXFILEP_GET(char, fp);
            if (c2 != '\r' && c2 != '\n')
                nixfilep_step (fp, -direction);
	    } else
	        nixfilep_step (fp, -direction);

	    break;
    }

    return ENONE;
}

/*
 * Display file page wise. We assume a 80x25 chars display.
 */
int
sh_page (int argc, char **argv)
{
    unsigned pagenr = 1;
    struct obj *con;
    struct buf *buf;
    int  err;

    /* Get the console. */
    err = open (&con, "/con");
    ERRCODE(err);

    while (1) {
        err = bref (&buf, con, 0, 0);
	    ERRCODE(err);

        switch (*(char *) buf->data) {
            case 'j':
                pagenr++;
                break;

            case 'k':
                if (pagenr != 1)
                    pagenr--;
                break;

            default:
                continue;
        }
    }

    /* Close console. */
    close (con);

    return ENONE;
}

void
sh_objstat_findprocs (struct obj *obj, struct dequeue_hdr *proclist)
{
    struct obj **i_procobj;
    struct proc *i_proc;
    struct proc *i_tmpproc;

    i_tmpproc = (struct proc *) proclist->first;
    DEQUEUE_FOREACH(proclist, i_proc) {
        SARRAY_FOREACH(struct obj *, i_proc->objects, i_procobj) {
            if (*i_procobj == obj) {
                printk (i_proc->name, 0);
                printk (" ", 0);
                break;
            }
        }
        if (i_proc->next == (void *) i_tmpproc)
            break;
    }
}

int
sh_objstat (int argc, char **argv)
{
    struct obj *i_obj;

    printk ("name\trefs\tlocks\tdirty\tstate\tprocs\n", 0);
    DEQUEUE_FOREACH(&obj_pool.used, i_obj) {
        if (i_obj->dirent) {
            printk (i_obj->dirent->name, 0);
            printk ("\t", 0);
        } else
            printk ("/\t", 0);
        printk ("%d\t", i_obj->refcnt);
        printk ("%d\t", i_obj->lock);
        printk ("%d\t", i_obj->dirtybufs);
        if (OBJ_IS_STREAM(i_obj))
            printk ("s", 0);
        else
            printk ("b", 0);
        if (OBJ_IS_PERSISTENT(i_obj))
	        printk ("p", 0);
    	printk ("\t", 0);
        sh_objstat_findprocs (i_obj, &procs_running);
        sh_objstat_findprocs (i_obj, &procs_sleeping);
    	printk ("\n", 0);
    }
    printk ("%d of ", objects_in_use);
    printk ("%d objects in use.\n", NUM_OBJS);
    printk ("%d of ", buffers_in_use);
    printk ("%d buffers in use.\n", NUM_BUFS);
    return ENONE;
}

int
sh_info (int argc, char **argv)
{
    size_t s;
    size_t t = 0;

    printk ("GENERAL INFO:\n\n", 0);

    printk ("Endianess:\t", 0);
#ifdef LITTLE_ENDIAN
    printk ("little\n", 0);
#else
    printk ("big\n", 0);
#endif

    printk ("Page size:\t%d\n", PAGESIZE);
    printk ("Total pages:\t%d\n", NUM_PAGES);
    printk ("Used pages:\t%d\n", NUM_PAGES - mem_num_pages_free);
    printk ("Free pages:\t%d\n", mem_num_pages_free);
    printk ("Fragment sizes:\t%d\n", FRAGMENT_SIZES);

    printk ("Single page to top:\t", 0);
#ifdef MEM_SINGLE_PAGE
    printk ("yes\n", 0);
#else
    printk ("no\n", 0);
#endif

    printk ("Dynamic frag stacks:\t", 0);
#ifdef MEM_DYN_STACKS
    printk ("yes\n", 0);
#else
    printk ("no\n", 0);
#endif

    printk ("\n", 0);

    printk ("Kernel systems:\tmem", 0);
#ifndef NO_PROC
    printk (" proc", 0);
#endif
#ifndef NO_IO
    printk (" io", 0);
#endif
    printk ("\n", 0);

    printk ("Multitasking:\t", 0);
#ifdef MULTITASKING
    printk ("on\n", 0);
#else
    printk ("off\n", 0);
#endif

    printk ("Switch timer:\t", 0);
#ifdef NO_SWITCH_TIMER
    printk ("no\n", 0);
#else
    printk ("yes\n", 0);
#endif

    printk ("Kernel checks:\t", 0);
#ifdef NO_CHECKS
    printk ("off\n", 0);
#else
    printk ("on\n", 0);
#endif

    printk ("Diagnostics:\t", 0);
#ifdef DIAGNOSTICS
    printk ("on\n", 0);
#else
    printk ("off\n", 0);
#endif

    printk ("Bookkeeping:\t", 0);
#ifdef NO_BOOKKEEPING
    printk ("off\n", 0);
#else
    printk ("on\n", 0);
#endif

    printk ("\n", 0);

    printk ("Bufs per proc:\t%d\n", BUFS_PER_PROC);
    printk ("Objs per proc:\t%d\n", OBJS_PER_PROC);
    printk ("Dirs per proc:\t%d\n", DIRS_PER_PROC);

    printk ("Shared bufdata:\t", 0);
#ifdef BUF_SHARED_DATA
    printk ("yes\n", 0);
#else
    printk ("no\n", 0);
#endif

    printk ("JIT streams:\t", 0);
#ifdef BUF_JIT_STREAMS
    printk ("yes\n", 0);
#else
    printk ("no\n", 0);
#endif

    printk ("Usage sort:\t", 0);
#ifdef BUF_SORT_REUSED
    printk ("yes\n", 0);
#else
    printk ("no\n", 0);
#endif

    printk ("Name length:\t%d\n", NAME_MAX);
    printk ("Iod channels:\t%d\n", IOD_CHANNELS);

    printk ("\n", 0);
    printk ("", 0);

    printk ("MEMORY REQUIREMENTS:\n\n", 0);
    s = PROC_MAX * sizeof (struct proc);
    t += s;
    printk ("procs:\t%d", PROC_MAX);
    printk (" * %d", sizeof (struct proc));
    printk (" = %d\n", s);

    /* stack, code, 3 fragstacks, 3 fsrefs */
    printk ("Min. proc size:\t%d\n", PAGESIZE * 8 );
    /* relocbuf, sections, callgates, */
    printk ("Min. dynproc size:\t%d\n", PAGESIZE * (8 + 3));

    s = NUM_OBJS * sizeof (struct obj);
    t += s;
    printk ("obj:\t%d", NUM_OBJS);
    printk (" * %d", sizeof (struct obj));
    printk (" = %d\n", s);

    s = NUM_OBJSUBCLASSES * sizeof (struct obj_subclass);
    t += s;
    printk ("obj subclasses:\t%d", NUM_OBJSUBCLASSES);
    printk (" * %d", sizeof (struct obj_subclass));
    printk (" = %d\n", s);

    s = NUM_OBJCLASSES * sizeof (struct obj_class);
    t += s;
    printk ("obj classes:\t%d", NUM_OBJCLASSES);
    printk (" * %d", sizeof (struct obj_class));
    printk (" = %d\n", s);

    s = NUM_BUFS * sizeof (struct buf);
    t += s;
    printk ("buf:\t%d", NUM_BUFS);
    printk (" * %d", sizeof (struct buf));
    printk (" = %d\n", s);

    s = NUM_DIRENTS * sizeof (struct buf);
    t += s;
    printk ("dirents:\t%d", NUM_DIRENTS);
    printk (" * %d", sizeof (struct dirent));
    printk (" = %d\n", s);

    s = PAGESIZE;
    t += s;
    printk ("rootpage:\t%d\n", s);

    s = PAGESIZE * FRAGMENT_SIZES;
    t += s;
    printk ("rootfrags:\t%d", FRAGMENT_SIZES);
    printk (" * %d", PAGESIZE);
    printk (" = %d\n", s);

    printk ("Total:\t%d\n", t);

    return ENONE;
}

int
sh_forget (int argc, char **argv)
{
    bcleanup_glob ();
    return ENONE;
}

/*
 * List of built-in commands.
 */
struct sh_cmd sh_cmds[] = {
    { "objstat",  sh_objstat, 0 },
    { "create",   sh_create, 1 },
    { "forget",   sh_forget, 0 },
#ifdef MEM_DUMP
    { "memmap",  sh_memmap, 0 },
#endif
    { "mkdir",   sh_mkdir, 1 },
    { "info",   sh_info, 0 },
#ifndef NO_PROC
    { "exit", sh_exit, 0 },
#endif
    { "mkfs", mkfs, 1 },
    { "help", sh_help, -1 },
    { "pwd", sh_pwd, 0 },
    { "dup", sh_dup, 3 },
#ifndef NO_IO
    { "ls",   sh_ls, -1 },
    { "io",   sh_io, 2 },
#endif
#ifndef NO_PROC
    { "ps",   sh_ps, 0 },
#endif
    { "cd",   sh_cd, 1 },
    { "rm",   sh_rm, 1 },
    { "sh",   sh_sh, 0 },
    { NULL, NULL, 0 }
};

/*
 * Execute command.
 */
int
sh_parse_cmdline (char *buf)
{
    struct sh_cmd *i_cmd = sh_cmds;

    sh_mkargs (buf);
    if (argc == 0)
	return ENONE;

    while (i_cmd->name != NULL) {
        if (strcmp (argv[0], i_cmd->name) == 0) {
            if ((i_cmd->num_args != -1) && (i_cmd->num_args + 1) != argc) {
                printf ("%s requires ", (size_t) argv[0]);
                printf ("%d args.\n", (size_t) i_cmd->num_args);
                return ENONE;
            }
            return i_cmd->func (argc, argv);
        }
        i_cmd++;
    }

    printf ("?\n", 0);

    return ENONE;
}

/*
 * Read and execute a line.
 */
int
sh_prompt ()
{
    struct buf    *buf;
    int err;

    /* Print prompt. */
    printf ("# ", 0);

    /* Request line. */
    err = bref (&buf, stdin, 0, 0);
    ERRCODE(err);

    /* Check end of transmission. */
    if (buf == NULL)
        return -1;

    /* Process input. */
    err = sh_parse_cmdline (buf->data);

    /* Release line. */
    bunref (buf);

    return err;
}

void
sh ()
{
    int err;

    libc_init ();

    while (1) {
        err = sh_prompt ();
        if (err == -1)
            break;
        if (err != ENONE)
  	        sh_errno (err);
    }

    libc_close ();

    shutdown ();
}

#endif
