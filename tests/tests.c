/*
 * tensix operating system project
 * Copyright (C) 2002, 2003, 2004, 2005 Sven Klose <pixel@copei.de>
 *
 * Testing
 *
 * $License$
 */

#include <obj.h>
#include <fs.h>
#include <buf.h>
#include <libc.h>
#include <sh.h>
#include <main.h>
#include <proc.h>
#include <machdep.h>
#include <error.h>

void mem_test_stress ();

#define TEST_PROC_MAX	PROC_MAX
#define TEST_FS_BLKS	4096

LOCK_DEF(tests_proc_lock);

int tests_proc_cnt;

void
tests_proc_func ()
{
    int i = 1000;

    printk ("\t\t%d\n", tests_proc_cnt);

    SPINLOCK(i--);

    LOCK(tests_proc_lock);
    tests_proc_cnt--;
    UNLOCK(tests_proc_lock);

    SPINLOCK(1);
}

int
tests_proc ()
{
    struct proc *procs[TEST_PROC_MAX];
    int i;
    int err;

    printk ("\nTesting process management:\n", 0);

    tests_proc_cnt = 0;
    for (i = 0; i < TEST_PROC_MAX; i++)
	procs[i] = NULL;

    printk ("\tcreating\n", 0);
    for (i = 0; i < TEST_PROC_MAX; i++) {
        LOCK(tests_proc_lock);
        tests_proc_cnt++;
        UNLOCK(tests_proc_lock);
        err = PROC_FUNEXEC(&procs[i], tests_proc_func, 0, 0, 2047, "proc_test");
        if (err != ENONE) {
            LOCK(tests_proc_lock);
            tests_proc_cnt--;
            UNLOCK(tests_proc_lock);
	    i--;
	    break;
	}
    }
    printk ("\t%d procs created.\n", i + 1);

    printk ("\twaiting until procs ran\n", 0);
    SPINLOCK(tests_proc_cnt);

    printk ("\tkilling procs\n", 0);
    for (i = 0; i < TEST_PROC_MAX; i++) {
        if (procs[i] != NULL)
	    proc_kill (procs[i]);
    }

    return ENONE;
}

int
tests_fs ()
{
    struct obj *obj;
    struct obj *dir;
    struct buf *buf;
    char *p;
    int err;
    int i;
    int j;

    printk ("\nTesting filesystem operations:\n", 0);

    printk ("\tunlink missing\n", 0);
    err = unlink ("/local/fstest.tmp");
    err = unlink ("/local/fstest.tmp");
    ERRCHK(err == ENONE, err = EINTERNAL);

    printk ("\topen missing\n", 0);
    err = open (&dir, " /fa;jdlks");
    ERRCHK(err != ENONE && err != ENOTFOUND, err);

    printk ("\topen directory\n", 0);
    err = open (&dir, "/local");
    ERRCODE(err);

    printk ("\tcreate file\n", 0);
    err = create (&obj, dir, OBJ_TYPE_FILE, "fstest.tmp");
    ERRCODE(err);
    err = close (obj);
    ERRCODE(err);

    printk ("\topen file\n", 0);
    err = open (&obj, "/local/fstest.tmp");
    ERRCODE(err);

    printk ("\twrite file\n", 0);
    for (i = 0; i < TEST_FS_BLKS; i++) {
        err = bref (&buf, obj, i, IO_CREATE);
        ERRCODE(err);
	for (p = buf->data, j = buf->len; j > 0; j--, p++)
	    *p = (char) i;
	BDIRTY(buf);
	bunref (buf);
    }

    printk ("\tread file\n", 0);
    for (i = 0; i < TEST_FS_BLKS; i++) {
        err = bref (&buf, obj, i, 0);
        ERRCODE(err);
	for (p = buf->data, j = buf->len; j > 0; j--, p++)
	    if (*p != (char) i)
		panic ("fs write/read: invalid file content");
	bunref (buf);
    }

    err = close (obj);
    ERRCODE(err);

    printk ("\tunlink\n", 0);
    err = unlink ("/local/fstest.tmp");
    ERRCODE(err);
    err = open (&obj, "/local/fstest.tmp");
    if (err != ENOTFOUND)
	panic ("fs_test: unlink failed.");

    printk ("\tunlink missing\n", 0);
    err = unlink ("/local/fstest.tmp");
    ERRCHK(err == ENONE && err == ENOTFOUND, err);

    printk ("\tclose\n", 0);
    err = close (dir);
    ERRCODE(err);

    return ENONE;
}

int
tests_all ()
{
    int err;

#ifdef MEM_TEST_STRESS
    mem_test_stress ();
#endif

    err = tests_proc ();
    ERRCODE(err);

    err = tests_fs ();
    return err;
}

void
tests ()
{
    int err;

    libc_init ();

    err = tests_all ();
    if (err)
	sh_errno (err);

    libc_close ();
}
