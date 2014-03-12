/*
 * tensix operating system project
 * Copyright (C) 2002, 2003, 2004, 2005 Sven Klose <pixel@copei.de>
 *
 * Stack and queue macros
 *
 * $License$
 */

#ifndef _SYS_QUEUE_H
#define _SYS_QUEUE_H

/*
 * Stacks.
 *
 * Stacks can only be placed in single pages or in page fragments.
 */

#include <mem.h>

/* Stack header structure. */
struct stack_hdr {
   int index;  /* Index of free entry. */
};

/* Cast to stack pointer. */
#define STACK_PTR(p)	((struct stack_hdr*) (p))

/* Number of entries in stack. */
#define STACK_NUMENTRIES(stack)	(stack->index)

/* Address of first element in stack. */
#define STACK_START(stack, type) \
   ((type*) ((size_t) stack + sizeof (struct stack_hdr)))

/* Pointer to an entry. */
#define STACK_ENTRY(stack, type, idx) (&(STACK_START(stack, type)[idx]))

/* Number of bytes currently required by the stack. */
#define STACK_SIZE(stack, type)		(stack->index * sizeof (type) + \
                                	sizeof (struct stack_hdr))
/*
 * Push new entry on stack and return its address.
 * If the stack is full, 0 is returned.
 */
#define STACK_PUSH(stack, type) \
   (STACK_SIZE(stack, type) + sizeof (type) > (size_t) FRAGSIZE(ADDR2PAGE(stack)) ? \
   0 : STACK_ENTRY(stack, type, stack->index++))

/*
 * Pop entry from stack and return its address.
 * If the stack is already empty, 0 is returned.
 */
#define STACK_POP(stack, type) \
   ((stack->index == 0) ? 0 : STACK_ENTRY(stack, type, --stack->index))


/*************************************************************************/

struct dequeue_node {
    struct dequeue_node *prev;
    struct dequeue_node *next;
};

/* Header for doubly-linked queues. */
struct dequeue_hdr {
    struct dequeue_node *first;
    struct dequeue_node *last;
};

#define DEQUEUE_DECL(name) \
    struct dequeue_hdr name

/*
 * Put this into your dequeue element struct first!
 */
#define DEQUEUE_NODE_DECL() \
    struct dequeue_node *prev; \
    struct dequeue_node *next

#define DEQUEUE_REMOVE(list, record) \
    dequeue_remove (list, (struct dequeue_node *) record)

#define DEQUEUE_INSERT_AFTER(list, prev, record) \
    dequeue_insert_after (list, (struct dequeue_node *) prev. (struct dequeue_node *) record)

#define DEQUEUE_INSERT(list, next, record) \
    DEQUEUE_INSERT_AFTER(list, next->prev, record)

#define DEQUEUE_FOREACH(list, iter) \
    for (iter = (void *) ((struct dequeue_hdr *) list)->first; iter != NULL; iter = (void *) ((struct dequeue_node *) iter)->next)

#define DEQUEUE_SEARCH(list, iter, condition) \
    if (condition)                            \
	break;

#define DEQUEUE_WIPE(list) \
    (list)->first = (list)->last = NULL

#define DEQUEUE_IS_AT_FRONT(list,record) \
    (list->first == (struct dequeue_node *) record)

extern void dequeue_remove (struct dequeue_hdr *list, struct dequeue_node * record);
extern void dequeue_insert_after (struct dequeue_hdr *list, struct dequeue_node *prev, struct dequeue_node *record);

extern void dequeue_check (struct dequeue_hdr *list);

#ifndef DEQUEUE_MACRO_CALLS

#define DEQUEUE_PUSH(list, record)                            \
    record->prev = (list)->last;                              \
    record->next = NULL;                                         \
    if ((record)->prev == NULL)                                  \
	(list)->first = (struct dequeue_node*) record;        \
    else                                                      \
        (record)->prev->next = (struct dequeue_node*) record; \
    (list)->last = (struct dequeue_node*) record

#define DEQUEUE_PUSH_FRONT(list, record)                      \
    record->next = (list)->first;                             \
    record->prev = NULL;                                         \
    if ((list)->first == NULL)                                   \
        (list)->last = (struct dequeue_node *) record;        \
    else                                                      \
        (list)->first->prev = (struct dequeue_node *) record; \
    (list)->first = (struct dequeue_node *) record

#define DEQUEUE_POP(list, record) \
    (struct dequeue_node *) record = (list)->last;   \
    if (record->prev != NULL)                           \
        record->prev->next = NULL;                      \
    (list)->last = record->prev

#define DEQUEUE_POP_FRONT(list, record) \
    (struct dequeue_node *) record = (list)->first;  \
    if (record->next != NULL)                           \
        record->next->prev = NULL;                      \
    (list)->first = record->next

#else /* #ifndef DEQUEUE_MACRO_CALLS */

extern void dequeue_push (struct dequeue_hdr *, struct dequeue_node *);
extern void dequeue_push_front (struct dequeue_hdr *, struct dequeue_node *);
extern void dequeue_pop (struct dequeue_hdr *, struct dequeue_node **);
extern void dequeue_pop_front (struct dequeue_hdr *, struct dequeue_node **);

#define DEQUEUE_PUSH(list, record)       dequeue_push (list, (struct dequeue_node *) record)
#define DEQUEUE_PUSH_FRONT(list, record) dequeue_push_front (list, (struct dequeue_node *) record)
#define DEQUEUE_POP(list, record)        dequeue_pop (list, (struct dequeue_node **) &(record))
#define DEQUEUE_POP_FRONT(list, record)  dequeue_pop_front (list, (struct dequeue_node **) &(record))

#endif /* #ifndef DEQUEUE_MACRO_CALLS */

extern void clist_remove (struct dequeue_hdr *list, struct dequeue_node * record);
extern void clist_insert (struct dequeue_hdr *list, struct dequeue_node * record);

#define CLIST_REMOVE(list, record) \
    clist_remove (list, (struct dequeue_node *) record)

#define CLIST_INSERT(list, record) \
    clist_insert (list, (struct dequeue_node *) record)

#endif /* #ifndef _SYS_QUEUE_H */
