;--------------------------------------------------------
; File Created by SDCC : FreeWare ANSI-C Compiler
; Version 2.6.0 #4309 (Oct 17 2006)
; This file generated Thu Oct 19 04:11:59 2006
;--------------------------------------------------------
	.module queue
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _dequeue_check
	.globl _dequeue_remove
	.globl _dequeue_insert_after
	.globl _dequeue_push
	.globl _dequeue_push_front
	.globl _dequeue_pop
	.globl _dequeue_pop_front
	.globl _clist_remove
	.globl _clist_insert
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
;  ram data
;--------------------------------------------------------
	.area _DATA
;--------------------------------------------------------
; overlayable items in  ram 
;--------------------------------------------------------
	.area _OVERLAY
;--------------------------------------------------------
; external initialized ram data
;--------------------------------------------------------
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area _HOME
	.area _GSINIT
	.area _GSFINAL
	.area _GSINIT
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area _HOME
	.area _CODE
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area _CODE
;queue.c:15: dequeue_check (struct dequeue_hdr *list)
;	genLabel
;	genFunction
;	---------------------------------
; Function dequeue_check
; ---------------------------------
_dequeue_check_start::
_dequeue_check:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-10
	add	hl,sp
	ld	sp,hl
;queue.c:23: return;
;	genRet
;queue.c:60: *((char *) 0) = 0;
;	genLabel
00133$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_dequeue_check_end::
__str_0:
	.ascii "invalid NULL in head"
	.db 0x00
__str_1:
	.ascii "invalid ptr to prev"
	.db 0x00
__str_2:
	.ascii "invalid ptr to last"
	.db 0x00
__str_3:
	.ascii "first has prev"
	.db 0x00
__str_4:
	.ascii "last has next"
	.db 0x00
__str_5:
	.ascii "circular err"
	.db 0x00
__str_6:
	.ascii "dequeue_check: %s"
	.db 0x0A
	.db 0x00
;queue.c:66: dequeue_remove (struct dequeue_hdr *list, struct dequeue_node *record)
;	genLabel
;	genFunction
;	---------------------------------
; Function dequeue_remove
; ---------------------------------
_dequeue_remove_start::
_dequeue_remove:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-8
	add	hl,sp
	ld	sp,hl
;queue.c:68: struct dequeue_node *p = record->prev;
;	genAssign
;	AOP_STK for 
	ld	c,6(ix)
	ld	b,7(ix)
;	genPointerGet
	ld	l,c
	ld	h,b
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
;	genAssign
;	AOP_STK for _dequeue_remove_p_1_1
	ld	-2(ix),e
	ld	-1(ix),d
;queue.c:69: struct dequeue_node *n = record->next;
;	genPlus
;	genPlusIncr
	ld	e,c
	ld	d,b
	inc	de
	inc	de
;	genPointerGet
	ld	l,e
	ld	h,d
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
;	genAssign
;	AOP_STK for _dequeue_remove_n_1_1
	ld	-4(ix),e
	ld	-3(ix),d
;queue.c:71: dequeue_check (list);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
;	AOP_STK for 
	ld	l,4(ix)
	ld	h,5(ix)
	push	hl
;	genCall
	call	_dequeue_check
	pop	af
	pop	bc
;queue.c:72: if (p != NULL)
;	genCmpEq
;	AOP_STK for _dequeue_remove_p_1_1
; genCmpEq: left 2, right 2, result 0
	ld	a,-2(ix)
	or	a,-1(ix)
	jp	z,00102$
00115$:
;queue.c:73: p->next = n;
;	genPlus
;	AOP_STK for _dequeue_remove_p_1_1
;	genPlusIncr
	ld	e,-2(ix)
	ld	d,-1(ix)
	inc	de
	inc	de
;	genAssign (pointer)
;	AOP_STK for _dequeue_remove_n_1_1
;	isBitvar = 0
	ld	l,e
	ld	h,d
	ld	a,-4(ix)
	ld	(hl),a
	inc	hl
	ld	a,-3(ix)
	ld	(hl),a
;	genLabel
00102$:
;queue.c:74: if (n != NULL)
;	genCmpEq
;	AOP_STK for _dequeue_remove_n_1_1
; genCmpEq: left 2, right 2, result 0
	ld	a,-4(ix)
	or	a,-3(ix)
	jp	z,00104$
00116$:
;queue.c:75: n->prev = p;
;	genAssign (pointer)
;	AOP_STK for _dequeue_remove_n_1_1
;	AOP_STK for _dequeue_remove_p_1_1
;	isBitvar = 0
	ld	l,-4(ix)
	ld	h,-3(ix)
	ld	a,-2(ix)
	ld	(hl),a
	inc	hl
	ld	a,-1(ix)
	ld	(hl),a
;	genLabel
00104$:
;queue.c:76: if (list->first == record)
;	genAssign
;	AOP_STK for 
;	AOP_STK for _dequeue_remove_sloc0_1_0
	ld	a,4(ix)
	ld	-6(ix),a
	ld	a,5(ix)
	ld	-5(ix),a
;	genPointerGet
;	AOP_STK for _dequeue_remove_sloc0_1_0
	ld	l,-6(ix)
	ld	h,-5(ix)
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
;	genCmpEq
; genCmpEq: left 2, right 2, result 0
	ld	a,e
	cp	c
	jp	nz,00117$
	ld	a,d
	cp	b
	jp	z,00118$
00117$:
	jp	00106$
00118$:
;queue.c:77: list->first = n;
;	genAssign (pointer)
;	AOP_STK for _dequeue_remove_sloc0_1_0
;	AOP_STK for _dequeue_remove_n_1_1
;	isBitvar = 0
	ld	l,-6(ix)
	ld	h,-5(ix)
	ld	a,-4(ix)
	ld	(hl),a
	inc	hl
	ld	a,-3(ix)
	ld	(hl),a
;	genLabel
00106$:
;queue.c:78: if (list->last == record)
;	genPlus
;	AOP_STK for _dequeue_remove_sloc0_1_0
;	AOP_STK for _dequeue_remove_sloc1_1_0
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,-6(ix)
	add	a,#0x02
	ld	-8(ix),a
	ld	a,-5(ix)
	adc	a,#0x00
	ld	-7(ix),a
;	genPointerGet
;	AOP_STK for _dequeue_remove_sloc1_1_0
	ld	l,-8(ix)
	ld	h,-7(ix)
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
;	genCmpEq
; genCmpEq: left 2, right 2, result 0
	ld	a,e
	cp	c
	jp	nz,00119$
	ld	a,d
	cp	b
	jp	z,00120$
00119$:
	jp	00108$
00120$:
;queue.c:79: list->last = p;
;	genAssign (pointer)
;	AOP_STK for _dequeue_remove_sloc1_1_0
;	AOP_STK for _dequeue_remove_p_1_1
;	isBitvar = 0
	ld	l,-8(ix)
	ld	h,-7(ix)
	ld	a,-2(ix)
	ld	(hl),a
	inc	hl
	ld	a,-1(ix)
	ld	(hl),a
;	genLabel
00108$:
;queue.c:80: dequeue_check (list);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
;	AOP_STK for _dequeue_remove_sloc0_1_0
	ld	l,-6(ix)
	ld	h,-5(ix)
	push	hl
;	genCall
	call	_dequeue_check
	pop	af
;	genLabel
00109$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_dequeue_remove_end::
;queue.c:85: dequeue_insert_after (struct dequeue_hdr *list, struct dequeue_node *prev, struct dequeue_node *record)
;	genLabel
;	genFunction
;	---------------------------------
; Function dequeue_insert_after
; ---------------------------------
_dequeue_insert_after_start::
_dequeue_insert_after:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-4
	add	hl,sp
	ld	sp,hl
;queue.c:89: dequeue_check (list);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
;	AOP_STK for 
	ld	l,4(ix)
	ld	h,5(ix)
	push	hl
;	genCall
	call	_dequeue_check
	pop	af
;queue.c:90: record->prev = prev;
;	genAssign
;	AOP_STK for 
;	AOP_STK for _dequeue_insert_after_sloc0_1_0
	ld	a,8(ix)
	ld	-2(ix),a
	ld	a,9(ix)
	ld	-1(ix),a
;	genAssign (pointer)
;	AOP_STK for _dequeue_insert_after_sloc0_1_0
;	AOP_STK for 
;	isBitvar = 0
	ld	l,-2(ix)
	ld	h,-1(ix)
	ld	a,6(ix)
	ld	(hl),a
	inc	hl
	ld	a,7(ix)
	ld	(hl),a
;queue.c:91: if (prev == NULL) {
;	genCmpEq
;	AOP_STK for 
; genCmpEq: left 2, right 2, result 0
	ld	a,6(ix)
	or	a,7(ix)
	jp	z,00115$
00114$:
	jp	00102$
00115$:
;queue.c:92: next = list->first;
;	genAssign
;	AOP_STK for 
	ld	c,4(ix)
	ld	b,5(ix)
	push	bc
	pop	iy
;	genPointerGet
	ld	e,0(iy)
	ld	d,1(iy)
;	genAssign
;	(registers are the same)
;queue.c:93: list->first = record;
;	genAssign (pointer)
;	AOP_STK for _dequeue_insert_after_sloc0_1_0
;	isBitvar = 0
	ld	a,-2(ix)
	ld	0(iy),a
	ld	a,-1(ix)
	ld	1(iy),a
;	genGoto
	jp	00103$
;	genLabel
00102$:
;queue.c:95: next = prev->next;
;	genAssign
;	AOP_STK for 
	ld	c,6(ix)
	ld	b,7(ix)
;	genPlus
;	AOP_STK for _dequeue_insert_after_sloc1_1_0
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,c
	add	a,#0x02
	ld	-4(ix),a
	ld	a,b
	adc	a,#0x00
	ld	-3(ix),a
;	genPointerGet
;	AOP_STK for _dequeue_insert_after_sloc1_1_0
	ld	l,-4(ix)
	ld	h,-3(ix)
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
;	genAssign
	ld	e,c
	ld	d,b
;queue.c:96: prev->next = record;
;	genAssign (pointer)
;	AOP_STK for _dequeue_insert_after_sloc1_1_0
;	AOP_STK for _dequeue_insert_after_sloc0_1_0
;	isBitvar = 0
	ld	l,-4(ix)
	ld	h,-3(ix)
	ld	a,-2(ix)
	ld	(hl),a
	inc	hl
	ld	a,-1(ix)
	ld	(hl),a
;	genLabel
00103$:
;queue.c:98: record->next = next;
;	genPlus
;	AOP_STK for _dequeue_insert_after_sloc0_1_0
;	genPlusIncr
	ld	c,-2(ix)
	ld	b,-1(ix)
	inc	bc
	inc	bc
;	genAssign (pointer)
;	isBitvar = 0
	ld	l,c
	ld	h,b
	ld	(hl),e
	inc	hl
	ld	(hl),d
;queue.c:99: if (next == NULL)
;	genCmpEq
; genCmpEq: left 2, right 2, result 0
	ld	a,e
	or	a,d
	jp	z,00117$
00116$:
	jp	00105$
00117$:
;queue.c:100: list->last = record;
;	genAssign
;	AOP_STK for 
	ld	c,4(ix)
	ld	b,5(ix)
;	genPlus
;	genPlusIncr
	inc	bc
	inc	bc
;	genAssign (pointer)
;	AOP_STK for _dequeue_insert_after_sloc0_1_0
;	isBitvar = 0
	ld	l,c
	ld	h,b
	ld	a,-2(ix)
	ld	(hl),a
	inc	hl
	ld	a,-1(ix)
	ld	(hl),a
;	genGoto
	jp	00106$
;	genLabel
00105$:
;queue.c:102: next->prev = record;
;	genAssign (pointer)
;	AOP_STK for _dequeue_insert_after_sloc0_1_0
;	isBitvar = 0
	ld	l,e
	ld	h,d
	ld	a,-2(ix)
	ld	(hl),a
	inc	hl
	ld	a,-1(ix)
	ld	(hl),a
;	genLabel
00106$:
;queue.c:103: if (list->first == NULL)
;	genAssign
;	AOP_STK for 
	ld	c,4(ix)
	ld	b,5(ix)
;	genPointerGet
	ld	l,c
	ld	h,b
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
;	genCmpEq
; genCmpEq: left 2, right 2, result 0
	ld	a,e
	or	a,d
	jp	z,00119$
00118$:
	jp	00108$
00119$:
;queue.c:104: list->first = record;
;	genAssign (pointer)
;	AOP_STK for _dequeue_insert_after_sloc0_1_0
;	isBitvar = 0
	ld	l,c
	ld	h,b
	ld	a,-2(ix)
	ld	(hl),a
	inc	hl
	ld	a,-1(ix)
	ld	(hl),a
;	genLabel
00108$:
;queue.c:105: dequeue_check (list);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	push	bc
;	genCall
	call	_dequeue_check
	pop	af
;	genLabel
00109$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_dequeue_insert_after_end::
;queue.c:111: dequeue_push (struct dequeue_hdr *list, struct dequeue_node *record)
;	genLabel
;	genFunction
;	---------------------------------
; Function dequeue_push
; ---------------------------------
_dequeue_push_start::
_dequeue_push:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-6
	add	hl,sp
	ld	sp,hl
;queue.c:113: dequeue_check (list);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
;	AOP_STK for 
	ld	l,4(ix)
	ld	h,5(ix)
	push	hl
;	genCall
	call	_dequeue_check
	pop	af
;queue.c:114: record->prev = list->last;
;	genAssign
;	AOP_STK for 
	ld	c,6(ix)
	ld	b,7(ix)
;	genAssign
;	AOP_STK for 
;	AOP_STK for _dequeue_push_sloc1_1_0
	ld	a,4(ix)
	ld	-4(ix),a
	ld	a,5(ix)
	ld	-3(ix),a
;	genPlus
;	AOP_STK for _dequeue_push_sloc1_1_0
;	AOP_STK for _dequeue_push_sloc0_1_0
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,-4(ix)
	add	a,#0x02
	ld	-2(ix),a
	ld	a,-3(ix)
	adc	a,#0x00
	ld	-1(ix),a
;	genPointerGet
;	AOP_STK for _dequeue_push_sloc0_1_0
;	AOP_STK for _dequeue_push_sloc2_1_0
	ld	l,-2(ix)
	ld	h,-1(ix)
	ld	a,(hl)
	ld	-6(ix),a
	inc	hl
	ld	a,(hl)
	ld	-5(ix),a
;	genAssign (pointer)
;	AOP_STK for _dequeue_push_sloc2_1_0
;	isBitvar = 0
	ld	l,c
	ld	h,b
	ld	a,-6(ix)
	ld	(hl),a
	inc	hl
	ld	a,-5(ix)
	ld	(hl),a
;queue.c:115: record->next = NULL;
;	genPlus
;	genPlusIncr
	ld	e,c
	ld	d,b
	inc	de
	inc	de
;	genAssign (pointer)
;	isBitvar = 0
	ld	l,e
	ld	h,d
	ld	(hl),#0x00
	inc	hl
	ld	(hl),#0x00
;queue.c:116: if (record->prev == NULL)
;	genCmpEq
;	AOP_STK for _dequeue_push_sloc2_1_0
; genCmpEq: left 2, right 2, result 0
	ld	a,-6(ix)
	or	a,-5(ix)
	jp	z,00108$
00107$:
	jp	00102$
00108$:
;queue.c:117: list->first = record;
;	genAssign (pointer)
;	AOP_STK for _dequeue_push_sloc1_1_0
;	isBitvar = 0
	ld	l,-4(ix)
	ld	h,-3(ix)
	ld	(hl),c
	inc	hl
	ld	(hl),b
;	genGoto
	jp	00103$
;	genLabel
00102$:
;queue.c:119: record->prev->next = record;
;	genPointerGet
	ld	l,c
	ld	h,b
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
;	genPlus
;	genPlusIncr
	inc	de
	inc	de
;	genAssign (pointer)
;	isBitvar = 0
	ld	l,e
	ld	h,d
	ld	(hl),c
	inc	hl
	ld	(hl),b
;	genLabel
00103$:
;queue.c:120: list->last = record;
;	genAssign (pointer)
;	AOP_STK for _dequeue_push_sloc0_1_0
;	isBitvar = 0
	ld	l,-2(ix)
	ld	h,-1(ix)
	ld	(hl),c
	inc	hl
	ld	(hl),b
;queue.c:121: dequeue_check (list);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
;	AOP_STK for _dequeue_push_sloc1_1_0
	ld	l,-4(ix)
	ld	h,-3(ix)
	push	hl
;	genCall
	call	_dequeue_check
	pop	af
;	genLabel
00104$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_dequeue_push_end::
;queue.c:125: dequeue_push_front (struct dequeue_hdr *list, struct dequeue_node *record)
;	genLabel
;	genFunction
;	---------------------------------
; Function dequeue_push_front
; ---------------------------------
_dequeue_push_front_start::
_dequeue_push_front:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-4
	add	hl,sp
	ld	sp,hl
;queue.c:127: dequeue_check (list);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
;	AOP_STK for 
	ld	l,4(ix)
	ld	h,5(ix)
	push	hl
;	genCall
	call	_dequeue_check
	pop	af
;queue.c:128: record->next = list->first;
;	genAssign
;	AOP_STK for 
	ld	c,6(ix)
	ld	b,7(ix)
;	genPlus
;	AOP_STK for _dequeue_push_front_sloc1_1_0
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,c
	add	a,#0x02
	ld	-4(ix),a
	ld	a,b
	adc	a,#0x00
	ld	-3(ix),a
;	genAssign
;	AOP_STK for 
;	AOP_STK for _dequeue_push_front_sloc0_1_0
	ld	a,4(ix)
	ld	-2(ix),a
	ld	a,5(ix)
	ld	-1(ix),a
;	genPointerGet
;	AOP_STK for _dequeue_push_front_sloc0_1_0
	ld	l,-2(ix)
	ld	h,-1(ix)
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
;	genAssign (pointer)
;	AOP_STK for _dequeue_push_front_sloc1_1_0
;	isBitvar = 0
	ld	l,-4(ix)
	ld	h,-3(ix)
	ld	(hl),e
	inc	hl
	ld	(hl),d
;queue.c:129: record->prev = NULL;
;	genAssign (pointer)
;	isBitvar = 0
	ld	l,c
	ld	h,b
	ld	(hl),#0x00
	inc	hl
	ld	(hl),#0x00
;queue.c:130: if (list->first == NULL)
;	genCmpEq
; genCmpEq: left 2, right 2, result 0
	ld	a,e
	or	a,d
	jp	z,00108$
00107$:
	jp	00102$
00108$:
;queue.c:131: list->last = record;
;	genPlus
;	AOP_STK for _dequeue_push_front_sloc0_1_0
;	genPlusIncr
	ld	e,-2(ix)
	ld	d,-1(ix)
	inc	de
	inc	de
;	genAssign (pointer)
;	isBitvar = 0
	ld	l,e
	ld	h,d
	ld	(hl),c
	inc	hl
	ld	(hl),b
;	genGoto
	jp	00103$
;	genLabel
00102$:
;queue.c:133: list->first->prev = record;
;	genPointerGet
;	AOP_STK for _dequeue_push_front_sloc0_1_0
	ld	l,-2(ix)
	ld	h,-1(ix)
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
;	genAssign (pointer)
;	isBitvar = 0
	ld	l,e
	ld	h,d
	ld	(hl),c
	inc	hl
	ld	(hl),b
;	genLabel
00103$:
;queue.c:134: list->first = record;
;	genAssign (pointer)
;	AOP_STK for _dequeue_push_front_sloc0_1_0
;	isBitvar = 0
	ld	l,-2(ix)
	ld	h,-1(ix)
	ld	(hl),c
	inc	hl
	ld	(hl),b
;queue.c:135: dequeue_check (list);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
;	AOP_STK for _dequeue_push_front_sloc0_1_0
	ld	l,-2(ix)
	ld	h,-1(ix)
	push	hl
;	genCall
	call	_dequeue_check
	pop	af
;	genLabel
00104$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_dequeue_push_front_end::
;queue.c:139: dequeue_pop (struct dequeue_hdr *list, struct dequeue_node **record)
;	genLabel
;	genFunction
;	---------------------------------
; Function dequeue_pop
; ---------------------------------
_dequeue_pop_start::
_dequeue_pop:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-4
	add	hl,sp
	ld	sp,hl
;queue.c:143: dequeue_check (list);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
;	AOP_STK for 
	ld	l,4(ix)
	ld	h,5(ix)
	push	hl
;	genCall
	call	_dequeue_check
	pop	af
;queue.c:144: rec = list->last;
;	genAssign
;	AOP_STK for 
	ld	c,4(ix)
	ld	b,5(ix)
;	genPlus
;	AOP_STK for _dequeue_pop_sloc0_1_0
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,c
	add	a,#0x02
	ld	-2(ix),a
	ld	a,b
	adc	a,#0x00
	ld	-1(ix),a
;	genPointerGet
;	AOP_STK for _dequeue_pop_sloc0_1_0
	ld	l,-2(ix)
	ld	h,-1(ix)
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
;	genAssign
;	(registers are the same)
;queue.c:145: *record = rec;
;	genAssign
;	AOP_STK for 
	push	hl
	ld	l,6(ix)
	ld	h,7(ix)
	push	hl
	pop	iy
	pop	hl
;	genAssign (pointer)
;	isBitvar = 0
	ld	0(iy),e
	ld	1(iy),d
;queue.c:146: if (rec == NULL)
;	genCmpEq
; genCmpEq: left 2, right 2, result 0
	ld	a,e
	or	a,d
	jp	z,00106$
00111$:
;queue.c:149: if (rec->prev != NULL)
;	genPointerGet
;	AOP_STK for _dequeue_pop_sloc1_1_0
	ld	l,e
	ld	h,d
	ld	a,(hl)
	ld	-4(ix),a
	inc	hl
	ld	a,(hl)
	ld	-3(ix),a
;	genCmpEq
;	AOP_STK for _dequeue_pop_sloc1_1_0
; genCmpEq: left 2, right 2, result 0
	ld	a,-4(ix)
	or	a,-3(ix)
	jp	z,00104$
00112$:
;queue.c:150: rec->prev->next = NULL;
;	genPlus
;	AOP_STK for _dequeue_pop_sloc1_1_0
;	genPlusIncr
	ld	e,-4(ix)
	ld	d,-3(ix)
	inc	de
	inc	de
;	genAssign (pointer)
;	isBitvar = 0
	ld	l,e
	ld	h,d
	ld	(hl),#0x00
	inc	hl
	ld	(hl),#0x00
;	genGoto
	jp	00105$
;	genLabel
00104$:
;queue.c:152: list->first = NULL;
;	genAssign (pointer)
;	isBitvar = 0
	ld	l,c
	ld	h,b
	ld	(hl),#0x00
	inc	hl
	ld	(hl),#0x00
;	genLabel
00105$:
;queue.c:153: list->last = rec->prev;
;	genAssign (pointer)
;	AOP_STK for _dequeue_pop_sloc0_1_0
;	AOP_STK for _dequeue_pop_sloc1_1_0
;	isBitvar = 0
	ld	l,-2(ix)
	ld	h,-1(ix)
	ld	a,-4(ix)
	ld	(hl),a
	inc	hl
	ld	a,-3(ix)
	ld	(hl),a
;queue.c:155: end:
;	genLabel
00106$:
;queue.c:156: dequeue_check (list);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	push	bc
;	genCall
	call	_dequeue_check
	pop	af
;	genLabel
00107$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_dequeue_pop_end::
;queue.c:160: dequeue_pop_front (struct dequeue_hdr *list, struct dequeue_node **record)
;	genLabel
;	genFunction
;	---------------------------------
; Function dequeue_pop_front
; ---------------------------------
_dequeue_pop_front_start::
_dequeue_pop_front:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-2
	add	hl,sp
	ld	sp,hl
;queue.c:164: dequeue_check (list);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
;	AOP_STK for 
	ld	l,4(ix)
	ld	h,5(ix)
	push	hl
;	genCall
	call	_dequeue_check
	pop	af
;queue.c:165: rec = list->first;
;	genAssign
;	AOP_STK for 
	ld	c,4(ix)
	ld	b,5(ix)
;	genPointerGet
	ld	l,c
	ld	h,b
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
;	genAssign
;	(registers are the same)
;queue.c:166: *record = rec;
;	genAssign
;	AOP_STK for 
	push	hl
	ld	l,6(ix)
	ld	h,7(ix)
	push	hl
	pop	iy
	pop	hl
;	genAssign (pointer)
;	isBitvar = 0
	ld	0(iy),e
	ld	1(iy),d
;queue.c:167: if (rec == NULL)
;	genCmpEq
; genCmpEq: left 2, right 2, result 0
	ld	a,e
	or	a,d
	jp	z,00106$
00111$:
;queue.c:170: if (rec->next != NULL)
;	genPlus
;	genPlusIncr
	inc	de
	inc	de
;	genPointerGet
;	AOP_STK for _dequeue_pop_front_sloc0_1_0
	ld	l,e
	ld	h,d
	ld	a,(hl)
	ld	-2(ix),a
	inc	hl
	ld	a,(hl)
	ld	-1(ix),a
;	genCmpEq
;	AOP_STK for _dequeue_pop_front_sloc0_1_0
; genCmpEq: left 2, right 2, result 0
	ld	a,-2(ix)
	or	a,-1(ix)
	jp	z,00104$
00112$:
;queue.c:171: rec->next->prev = NULL;
;	genPointerGet
	ld	l,e
	ld	h,d
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
;	genAssign (pointer)
;	isBitvar = 0
	ld	l,e
	ld	h,d
	ld	(hl),#0x00
	inc	hl
	ld	(hl),#0x00
;	genGoto
	jp	00105$
;	genLabel
00104$:
;queue.c:173: list->last = NULL;
;	genPlus
;	genPlusIncr
	ld	e,c
	ld	d,b
	inc	de
	inc	de
;	genAssign (pointer)
;	isBitvar = 0
	ld	l,e
	ld	h,d
	ld	(hl),#0x00
	inc	hl
	ld	(hl),#0x00
;	genLabel
00105$:
;queue.c:174: list->first = rec->next;
;	genAssign (pointer)
;	AOP_STK for _dequeue_pop_front_sloc0_1_0
;	isBitvar = 0
	ld	l,c
	ld	h,b
	ld	a,-2(ix)
	ld	(hl),a
	inc	hl
	ld	a,-1(ix)
	ld	(hl),a
;queue.c:176: end:
;	genLabel
00106$:
;queue.c:177: dequeue_check (list);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	push	bc
;	genCall
	call	_dequeue_check
	pop	af
;	genLabel
00107$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_dequeue_pop_front_end::
;queue.c:184: clist_remove (struct dequeue_hdr *list, struct dequeue_node *record)
;	genLabel
;	genFunction
;	---------------------------------
; Function clist_remove
; ---------------------------------
_clist_remove_start::
_clist_remove:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-12
	add	hl,sp
	ld	sp,hl
;queue.c:186: struct dequeue_node *p = record->prev;
;	genAssign
;	AOP_STK for 
	ld	c,6(ix)
	ld	b,7(ix)
;	genPointerGet
;	AOP_STK for _clist_remove_p_1_1
	ld	l,c
	ld	h,b
	ld	a,(hl)
	ld	-2(ix),a
	inc	hl
	ld	a,(hl)
	ld	-1(ix),a
;	genAssign
;	AOP_STK for _clist_remove_p_1_1
;	AOP_STK for _clist_remove_sloc0_1_0
	ld	a,-2(ix)
	ld	-6(ix),a
	ld	a,-1(ix)
	ld	-5(ix),a
;queue.c:187: struct dequeue_node *n = record->next;
;	genPlus
;	AOP_STK for _clist_remove_sloc1_1_0
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,c
	add	a,#0x02
	ld	-8(ix),a
	ld	a,b
	adc	a,#0x00
	ld	-7(ix),a
;	genPointerGet
;	AOP_STK for _clist_remove_sloc1_1_0
;	AOP_STK for _clist_remove_n_1_1
	ld	l,-8(ix)
	ld	h,-7(ix)
	ld	a,(hl)
	ld	-4(ix),a
	inc	hl
	ld	a,(hl)
	ld	-3(ix),a
;	genAssign
;	AOP_STK for _clist_remove_n_1_1
;	AOP_STK for _clist_remove_sloc2_1_0
	ld	a,-4(ix)
	ld	-10(ix),a
	ld	a,-3(ix)
	ld	-9(ix),a
;queue.c:189: if (p == record) {
;	genCmpEq
;	AOP_STK for _clist_remove_sloc0_1_0
; genCmpEq: left 2, right 2, result 0
	ld	a,-6(ix)
	cp	c
	jp	nz,00109$
	ld	a,-5(ix)
	cp	b
	jp	z,00110$
00109$:
	jp	00102$
00110$:
;queue.c:190: list->first = NULL;
;	genAssign
;	AOP_STK for 
;	AOP_STK for _clist_remove_sloc3_1_0
	ld	a,4(ix)
	ld	-12(ix),a
	ld	a,5(ix)
	ld	-11(ix),a
;	genAssign (pointer)
;	AOP_STK for _clist_remove_sloc3_1_0
;	isBitvar = 0
	ld	l,-12(ix)
	ld	h,-11(ix)
	ld	(hl),#0x00
	inc	hl
	ld	(hl),#0x00
;queue.c:191: list->last = NULL;
;	genPlus
;	AOP_STK for _clist_remove_sloc3_1_0
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,-12(ix)
	add	a,#0x02
	ld	-12(ix),a
	ld	a,-11(ix)
	adc	a,#0x00
	ld	-11(ix),a
;	genAssign (pointer)
;	AOP_STK for _clist_remove_sloc3_1_0
;	isBitvar = 0
	ld	l,-12(ix)
	ld	h,-11(ix)
	ld	(hl),#0x00
	inc	hl
	ld	(hl),#0x00
;queue.c:192: return;
;	genRet
	jp	00105$
;	genLabel
00102$:
;queue.c:194: if (list->first == record) {
;	genAssign
;	AOP_STK for 
;	AOP_STK for _clist_remove_sloc3_1_0
	ld	a,4(ix)
	ld	-12(ix),a
	ld	a,5(ix)
	ld	-11(ix),a
;	genPointerGet
;	AOP_STK for _clist_remove_sloc3_1_0
	ld	l,-12(ix)
	ld	h,-11(ix)
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
;	genCmpEq
; genCmpEq: left 2, right 2, result 0
	ld	a,e
	cp	c
	jp	nz,00111$
	ld	a,d
	cp	b
	jp	z,00112$
00111$:
	jp	00104$
00112$:
;queue.c:195: list->first = n;
;	genAssign (pointer)
;	AOP_STK for _clist_remove_sloc3_1_0
;	AOP_STK for _clist_remove_sloc2_1_0
;	isBitvar = 0
	ld	l,-12(ix)
	ld	h,-11(ix)
	ld	a,-10(ix)
	ld	(hl),a
	inc	hl
	ld	a,-9(ix)
	ld	(hl),a
;	genLabel
00104$:
;queue.c:197: p->next = record->next;
;	genPlus
;	AOP_STK for _clist_remove_sloc0_1_0
;	genPlusIncr
	ld	e,-6(ix)
	ld	d,-5(ix)
	inc	de
	inc	de
;	genAssign (pointer)
;	AOP_STK for _clist_remove_n_1_1
;	isBitvar = 0
	ld	l,e
	ld	h,d
	ld	a,-4(ix)
	ld	(hl),a
	inc	hl
	ld	a,-3(ix)
	ld	(hl),a
;queue.c:198: n->prev = record->prev;
;	genAssign (pointer)
;	AOP_STK for _clist_remove_sloc2_1_0
;	AOP_STK for _clist_remove_p_1_1
;	isBitvar = 0
	ld	l,-10(ix)
	ld	h,-9(ix)
	ld	a,-2(ix)
	ld	(hl),a
	inc	hl
	ld	a,-1(ix)
	ld	(hl),a
;queue.c:200: record->next = NULL;
;	genAssign (pointer)
;	AOP_STK for _clist_remove_sloc1_1_0
;	isBitvar = 0
	ld	l,-8(ix)
	ld	h,-7(ix)
	ld	(hl),#0x00
	inc	hl
	ld	(hl),#0x00
;queue.c:201: record->prev = NULL;
;	genAssign (pointer)
;	isBitvar = 0
	ld	l,c
	ld	h,b
	ld	(hl),#0x00
	inc	hl
	ld	(hl),#0x00
;	genLabel
00105$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_clist_remove_end::
;queue.c:206: clist_insert (struct dequeue_hdr *list, struct dequeue_node *record)
;	genLabel
;	genFunction
;	---------------------------------
; Function clist_insert
; ---------------------------------
_clist_insert_start::
_clist_insert:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-7
	add	hl,sp
	ld	sp,hl
;queue.c:211: if (list->first == NULL && list->last == NULL) {
;	genAssign
;	AOP_STK for 
	ld	c,4(ix)
	ld	b,5(ix)
;	genPointerGet
	ld	l,c
	ld	h,b
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
;	genCmpEq
;	AOP_STK for _clist_insert_sloc1_1_0
; genCmpEq: left 2, right 2, result 1
;4
	ld	a,e
	or	a,d
	jp	nz,00112$
	ld	a,#0x01
	jp	00113$
00112$:
	xor	a,a
00113$:
;6
;	genIfx
;	AOP_STK for _clist_insert_sloc1_1_0
	ld	-7(ix),a
	or	a,a
	jp	z,00102$
;	genPlus
;	AOP_STK for _clist_insert_sloc0_1_0
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,c
	add	a,#0x02
	ld	-6(ix),a
	ld	a,b
	adc	a,#0x00
	ld	-5(ix),a
;	genPointerGet
;	AOP_STK for _clist_insert_sloc0_1_0
	ld	l,-6(ix)
	ld	h,-5(ix)
	ld	d,(hl)
	inc	hl
	ld	e,(hl)
;	genCmpEq
; genCmpEq: left 2, right 2, result 0
	ld	a,d
	or	a,e
	jp	z,00115$
00114$:
	jp	00102$
00115$:
;queue.c:212: list->first = record;
;	genAssign (pointer)
;	AOP_STK for 
;	isBitvar = 0
	ld	l,c
	ld	h,b
	ld	a,6(ix)
	ld	(hl),a
	inc	hl
	ld	a,7(ix)
	ld	(hl),a
;queue.c:213: list->last = record;
;	genAssign (pointer)
;	AOP_STK for _clist_insert_sloc0_1_0
;	AOP_STK for 
;	isBitvar = 0
	ld	l,-6(ix)
	ld	h,-5(ix)
	ld	a,6(ix)
	ld	(hl),a
	inc	hl
	ld	a,7(ix)
	ld	(hl),a
;queue.c:214: record->prev = record;
;	genAssign
;	AOP_STK for 
	ld	c,6(ix)
	ld	b,7(ix)
;	genAssign (pointer)
;	isBitvar = 0
	ld	l,c
	ld	h,b
	ld	(hl),c
	inc	hl
	ld	(hl),b
;queue.c:215: record->next = record;
;	genPlus
;	genPlusIncr
	ld	e,c
	ld	d,b
	inc	de
	inc	de
;	genAssign (pointer)
;	isBitvar = 0
	ld	l,e
	ld	h,d
	ld	(hl),c
	inc	hl
	ld	(hl),b
;queue.c:216: return;
;	genRet
	jp	00107$
;	genLabel
00102$:
;queue.c:220: if (list->first == NULL || list->last == NULL)
;	genIfx
;	AOP_STK for _clist_insert_sloc1_1_0
	xor	a,a
	or	a,-7(ix)
	jp	nz,00104$
;	genPlus
;	genPlusIncr
	ld	e,c
	ld	d,b
	inc	de
	inc	de
;	genPointerGet
	ld	l,e
	ld	h,d
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
;	genCmpEq
; genCmpEq: left 2, right 2, result 0
	ld	a,e
	or	a,d
	jp	z,00117$
00116$:
	jp	00105$
00117$:
;	genLabel
00104$:
;queue.c:221: panic ("clist_insert(): Inconsistent header.\n");
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	ld	hl,#__str_7
	push	hl
;	genCall
	call	_panic
	pop	af
	pop	bc
;	genLabel
00105$:
;queue.c:224: next = list->first;
;	genPointerGet
	ld	l,c
	ld	h,b
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
;	genAssign
;	AOP_STK for _clist_insert_next_1_1
	ld	-2(ix),e
	ld	-1(ix),d
;queue.c:225: prev = next->prev;
;	genPointerGet
;	AOP_STK for _clist_insert_next_1_1
	ld	l,-2(ix)
	ld	h,-1(ix)
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
;	genAssign
;	AOP_STK for _clist_insert_prev_1_1
	ld	-4(ix),e
	ld	-3(ix),d
;queue.c:227: record->next = next;
;	genAssign
;	AOP_STK for 
;	AOP_STK for _clist_insert_sloc0_1_0
	ld	a,6(ix)
	ld	-6(ix),a
	ld	a,7(ix)
	ld	-5(ix),a
;	genPlus
;	AOP_STK for _clist_insert_sloc0_1_0
;	genPlusIncr
	ld	e,-6(ix)
	ld	d,-5(ix)
	inc	de
	inc	de
;	genAssign (pointer)
;	AOP_STK for _clist_insert_next_1_1
;	isBitvar = 0
	ld	l,e
	ld	h,d
	ld	a,-2(ix)
	ld	(hl),a
	inc	hl
	ld	a,-1(ix)
	ld	(hl),a
;queue.c:228: record->prev = prev;
;	genAssign (pointer)
;	AOP_STK for _clist_insert_sloc0_1_0
;	AOP_STK for _clist_insert_prev_1_1
;	isBitvar = 0
	ld	l,-6(ix)
	ld	h,-5(ix)
	ld	a,-4(ix)
	ld	(hl),a
	inc	hl
	ld	a,-3(ix)
	ld	(hl),a
;queue.c:229: next->prev = record;
;	genAssign (pointer)
;	AOP_STK for _clist_insert_next_1_1
;	AOP_STK for _clist_insert_sloc0_1_0
;	isBitvar = 0
	ld	l,-2(ix)
	ld	h,-1(ix)
	ld	a,-6(ix)
	ld	(hl),a
	inc	hl
	ld	a,-5(ix)
	ld	(hl),a
;queue.c:230: prev->next = record;
;	genPlus
;	AOP_STK for _clist_insert_prev_1_1
;	genPlusIncr
	ld	e,-4(ix)
	ld	d,-3(ix)
	inc	de
	inc	de
;	genAssign (pointer)
;	AOP_STK for _clist_insert_sloc0_1_0
;	isBitvar = 0
	ld	l,e
	ld	h,d
	ld	a,-6(ix)
	ld	(hl),a
	inc	hl
	ld	a,-5(ix)
	ld	(hl),a
;queue.c:231: list->first = record;
;	genAssign (pointer)
;	AOP_STK for _clist_insert_sloc0_1_0
;	isBitvar = 0
	ld	l,c
	ld	h,b
	ld	a,-6(ix)
	ld	(hl),a
	inc	hl
	ld	a,-5(ix)
	ld	(hl),a
;	genLabel
00107$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_clist_insert_end::
__str_7:
	.ascii "clist_insert(): Inconsistent header."
	.db 0x0A
	.db 0x00
	.area _CODE
