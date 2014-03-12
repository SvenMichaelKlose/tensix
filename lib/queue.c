/*
 * tensix operating system project
 * Copyright (C) 2002, 2003 Sven Klose <pixel@hugbox.org>
 *
 * Dequeue functions
 *
 * $License$
 */

#include <queue.h>
#include <main.h>
#include <libc.h>

#ifdef DIAGNOSTICS_DEQUEUE

void
dequeue_check (struct dequeue_hdr *list)
{
    char *msg = NULL;
    struct dequeue_node *i;
    struct dequeue_node *last = NULL;
    struct dequeue_node *prev = NULL;
    int safe = 256;

return;
    if (list->first == NULL || list->last == NULL) {
        if ((list->first == NULL && list->last == NULL))
	    return;
        msg = "invalid NULL in head";
    }

    if (!msg) {
  	DEQUEUE_FOREACH(list, i) {
	    last = i;
	    if (i->prev != prev) {
	    	msg = "invalid ptr to prev";
		break;
	    }
	    prev = i;
	}
	if (last != list->last)
	    msg = "invalid ptr to last";
    }

    if (!msg) {
    	if (list->first->prev != NULL)
	    msg = "first has prev";
        else if (list->last->next != NULL)
	    msg = "last has next";
        else {
            DEQUEUE_FOREACH(list, i) {
	        if (!safe--) {
		    msg = "circular err";
		    break;
                }
            }
	}
    }

    if (msg != NULL) {
        printk ("dequeue_check: %s\n", (size_t) msg);
        BANG();
    }
}

#endif /* #ifdef DIAGNOSTICS_DEQUEUE */

#ifdef DIAGNOSTICS_DEQUEUE
#define DEQUEUE_CHECK(q)  dequeue_check(q)
#else
#define DEQUEUE_CHECK(q)
#endif

/* Remove element from a dequeue. */
void
dequeue_remove (struct dequeue_hdr *list, struct dequeue_node *record)
{
    struct dequeue_node *p = record->prev;
    struct dequeue_node *n = record->next;

    DEQUEUE_CHECK(list);

    if (p != NULL)
	p->next = n;
    if (n != NULL)
	n->prev = p;
    if (list->first == record)
        list->first = n;
    if (list->last == record)
        list->last = p;

    DEQUEUE_CHECK(list);
}

/* Insert element after element in dequeue. 0 inserts to the front. */
void
dequeue_insert_after (struct dequeue_hdr *list, struct dequeue_node *prev, struct dequeue_node *record)
{
    struct dequeue_node *next;

    DEQUEUE_CHECK(list);

    record->prev = prev;
    if (prev == NULL) {
        next = list->first;
	list->first = record;
    } else {
        next = prev->next;
	prev->next = record;
    }
    record->next = next;
    if (next == NULL)
        list->last = record;
    else
        next->prev = record;
    if (list->first == NULL)
	list->first = record;

    DEQUEUE_CHECK(list);
}

#ifdef DEQUEUE_MACRO_CALLS

void
dequeue_push (struct dequeue_hdr *list, struct dequeue_node *record)
{
    DEQUEUE_CHECK(list);

    record->prev = list->last;
    record->next = NULL;
    if (record->prev == NULL)
	list->first = record;
    else
        record->prev->next = record;
    list->last = record;

    DEQUEUE_CHECK(list);
}

void
dequeue_push_front (struct dequeue_hdr *list, struct dequeue_node *record)
{
    DEQUEUE_CHECK(list);

    record->next = list->first;
    record->prev = NULL;
    if (list->first == NULL)
        list->last = record;
    else
        list->first->prev = record;
    list->first = record;

    DEQUEUE_CHECK(list);
}

void
dequeue_pop (struct dequeue_hdr *list, struct dequeue_node **record)
{
    struct dequeue_node *rec;

    DEQUEUE_CHECK(list);

    rec = list->last;
    *record = rec;
    if (rec == NULL)
	goto end;

    if (rec->prev != NULL)
        rec->prev->next = NULL;
    else
	list->first = NULL;
    list->last = rec->prev;

end:
    DEQUEUE_CHECK(list);
}

void
dequeue_pop_front (struct dequeue_hdr *list, struct dequeue_node **record)
{
    struct dequeue_node *rec;

    DEQUEUE_CHECK(list);

    rec = list->first;
    *record = rec;
    if (rec == NULL)
	goto end;

    if (rec->next != NULL)
        rec->next->prev = NULL;
    else
	list->last = NULL;
    list->first = rec->next;

end:

    DEQUEUE_CHECK(list);
}

#endif /* #ifdef DEQUEUE_MACRO_CALLS */

/* Remove element from cyclic list. */
void
clist_remove (struct dequeue_hdr *list, struct dequeue_node *record)
{
    struct dequeue_node *p = record->prev;
    struct dequeue_node *n = record->next;

    if (p == record) {
	list->first = NULL;
	list->last = NULL;
	return;
    }
    if (list->first == record) {
	list->first = n;
    }
    p->next = record->next;
    n->prev = record->prev;

    record->next = NULL;
    record->prev = NULL;
}

/* Insert element after element in dequeue. 0 inserts to the front. */
void
clist_insert (struct dequeue_hdr *list, struct dequeue_node *record)
{
    struct dequeue_node *next;
    struct dequeue_node *prev;

    if (list->first == NULL && list->last == NULL) {
	list->first = record;
	list->last = record;
	record->prev = record;
	record->next = record;
	return;
    }

#ifdef DIAGNOSTICS
    if (list->first == NULL || list->last == NULL)
	panic ("clist_insert(): Inconsistent header.\n");
#endif

    next = list->first;
    prev = next->prev;

    record->next = next;
    record->prev = prev;
    next->prev = record;
    prev->next = record;
    list->first = record;
}
