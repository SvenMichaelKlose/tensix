;--------------------------------------------------------
; File Created by SDCC : FreeWare ANSI-C Compiler
; Version 2.6.0 #4309 (Oct 17 2006)
; This file generated Thu Oct 19 04:08:18 2006
;--------------------------------------------------------
	.module pool
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _pool_alloc
	.globl _pool_salloc
	.globl _pool_free
	.globl _pool_create
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
;pool.c:45: pool_alloc (struct pool *pool)
;	genLabel
;	genFunction
;	---------------------------------
; Function pool_alloc
; ---------------------------------
_pool_alloc_start::
_pool_alloc:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-4
	add	hl,sp
	ld	sp,hl
;pool.c:49: DEQUEUE_POP(&pool->unused, rec);
;	genAddrOf
;	AOP_STK for _pool_alloc_sloc0_1_0
	ld	hl,#0x0002
	add	hl,sp
	ld	-4(ix),l
	ld	-3(ix),h
;	genAssign
;	AOP_STK for 
	ld	e,4(ix)
	ld	d,5(ix)
;	genPlus
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,e
	add	a,#0x04
	ld	c,a
	ld	a,d
	adc	a,#0x00
	ld	b,a
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 1 bcInUse: 0 deSending: 0
	push	de
;	AOP_STK for _pool_alloc_sloc0_1_0
	ld	l,-4(ix)
	ld	h,-3(ix)
	push	hl
;	genIpush
	push	bc
;	genCall
	call	_dequeue_pop
	pop	af
	pop	af
	pop	de
;pool.c:51: if (rec == NULL)
;	genCmpEq
;	AOP_STK for _pool_alloc_rec_1_1
; genCmpEq: left 2, right 2, result 0
	ld	a,-2(ix)
	or	a,-1(ix)
	jp	z,00103$
00107$:
;pool.c:54: DEQUEUE_PUSH(&pool->used, rec);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
;	AOP_STK for _pool_alloc_rec_1_1
	ld	l,-2(ix)
	ld	h,-1(ix)
	push	hl
;	genIpush
	push	de
;	genCall
	call	_dequeue_push
	pop	af
	pop	af
;pool.c:60: end:
;	genLabel
00103$:
;pool.c:61: return (void *) rec;
;	genAssign
;	AOP_STK for _pool_alloc_rec_1_1
	ld	l,-2(ix)
	ld	h,-1(ix)
;	genRet
; Dump of IC_LEFT: type AOP_STR size 2
;	genLabel
00104$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_pool_alloc_end::
;pool.c:65: pool_salloc (struct pool *pool)
;	genLabel
;	genFunction
;	---------------------------------
; Function pool_salloc
; ---------------------------------
_pool_salloc_start::
_pool_salloc:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-2
	add	hl,sp
	ld	sp,hl
;pool.c:69: DEQUEUE_POP(&pool->unused, rec);
;	genAddrOf
	ld	hl,#0x0000
	add	hl,sp
	ld	c,l
	ld	b,h
;	genAssign
;	AOP_STK for 
	ld	e,4(ix)
	ld	d,5(ix)
;	genPlus
;	genPlusIncr
	inc	de
	inc	de
	inc	de
	inc	de
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	push	bc
;	genIpush
	push	de
;	genCall
	call	_dequeue_pop
	pop	af
	pop	af
;pool.c:78: return (void *) rec;
;	genAssign
;	AOP_STK for _pool_salloc_rec_1_1
	ld	l,-2(ix)
	ld	h,-1(ix)
;	genRet
; Dump of IC_LEFT: type AOP_STR size 2
;	genLabel
00104$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_pool_salloc_end::
;pool.c:82: pool_free (struct pool *pool, void *rec)
;	genLabel
;	genFunction
;	---------------------------------
; Function pool_free
; ---------------------------------
_pool_free_start::
_pool_free:
	push	ix
	ld	ix,#0
	add	ix,sp
;pool.c:84: struct dequeue_node *r = rec;
;	genAssign
;	(operands are equal 3)
;pool.c:86: ASSERT_MEM(pool->area, r, "pool_free");
;	genAssign
;	AOP_STK for 
	ld	e,4(ix)
	ld	d,5(ix)
;	genPlus
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,e
	add	a,#0x09
	ld	c,a
	ld	a,d
	adc	a,#0x00
	ld	b,a
;	genPointerGet
	ld	l,c
	ld	h,b
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 1 bcInUse: 0 deSending: 0
	push	de
	ld	hl,#__str_0
	push	hl
;	genIpush
;	AOP_STK for 
	ld	l,6(ix)
	ld	h,7(ix)
	push	hl
;	genIpush
	push	bc
;	genCall
	call	_mem_boundary
	pop	af
	pop	af
	pop	af
	pop	de
;pool.c:92: DEQUEUE_REMOVE(&pool->used, r);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
;	AOP_STK for 
	ld	l,6(ix)
	ld	h,7(ix)
	push	hl
;	genIpush
	push	de
;	genCall
	call	_dequeue_remove
	pop	af
	pop	af
;pool.c:93: DEQUEUE_PUSH(&pool->unused, r);
;	genAssign
;	AOP_STK for 
	ld	c,4(ix)
	ld	b,5(ix)
;	genPlus
;	genPlusIncr
	inc	bc
	inc	bc
	inc	bc
	inc	bc
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
;	AOP_STK for 
	ld	l,6(ix)
	ld	h,7(ix)
	push	hl
;	genIpush
	push	bc
;	genCall
	call	_dequeue_push
	pop	af
	pop	af
;	genLabel
00101$:
;	genEndFunction
	pop	ix
	ret
_pool_free_end::
__str_0:
	.ascii "pool_free"
	.db 0x00
;pool.c:98: pool_create (struct pool *pool, size_t size, size_t typesize)
;	genLabel
;	genFunction
;	---------------------------------
; Function pool_create
; ---------------------------------
_pool_create_start::
_pool_create:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-12
	add	hl,sp
	ld	sp,hl
;pool.c:100: struct dequeue_node *prev = NULL;
;	genAssign
;	AOP_STK for _pool_create_prev_1_1
	ld	-2(ix),#0x00
	ld	-1(ix),#0x00
;pool.c:104: struct dequeue_hdr  *list = &(pool->unused);
;	genAssign
;	AOP_STK for 
	ld	e,4(ix)
	ld	d,5(ix)
;	genPlus
;	AOP_STK for _pool_create_list_1_1
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,e
	add	a,#0x04
	ld	-10(ix),a
	ld	a,d
	adc	a,#0x00
	ld	-9(ix),a
;pool.c:106: size *= typesize;
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 1 bcInUse: 0 deSending: 0
	push	de
;	AOP_STK for 
	ld	l,8(ix)
	ld	h,9(ix)
	push	hl
;	genIpush
;	AOP_STK for 
	ld	l,6(ix)
	ld	h,7(ix)
	push	hl
;	genCall
	call	__mulint_rrx_s
	ld	b,h
	ld	c,l
	pop	af
	pop	af
	pop	de
;	genAssign
;	AOP_STK for 
	ld	6(ix),c
	ld	7(ix),b
;pool.c:116: pool->area = pos = i = kmalloc (size);
;	genPlus
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,e
	add	a,#0x09
	ld	c,a
	ld	a,d
	adc	a,#0x00
	ld	b,a
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 1 bcInUse: 1 deSending: 0
	push	bc
	push	de
;	AOP_STK for 
	ld	l,6(ix)
	ld	h,7(ix)
	push	hl
;	genCall
	call	_kmalloc
;	AOP_STK for _pool_create_sloc1_1_0
	ld	-11(ix),h
	ld	-12(ix),l
	pop	af
	pop	de
	pop	bc
;	genAssign
;	AOP_STK for _pool_create_sloc1_1_0
;	AOP_STK for _pool_create_i_1_1
	ld	a,-12(ix)
	ld	-6(ix),a
	ld	a,-11(ix)
	ld	-5(ix),a
;	genAssign
;	AOP_STK for _pool_create_i_1_1
;	(registers are the same)
;	genAssign
;	AOP_STK for _pool_create_sloc1_1_0
;	AOP_STK for _pool_create_pos_1_1
	ld	a,-12(ix)
	ld	-8(ix),a
	ld	a,-11(ix)
	ld	-7(ix),a
;	genAssign
;	AOP_STK for _pool_create_pos_1_1
;	(registers are the same)
;	genAssign (pointer)
;	AOP_STK for _pool_create_sloc1_1_0
;	isBitvar = 0
	ld	l,c
	ld	h,b
	ld	a,-12(ix)
	ld	(hl),a
	inc	hl
	ld	a,-11(ix)
	ld	(hl),a
;pool.c:117: if (i == NULL)
;	genCmpEq
;	AOP_STK for _pool_create_i_1_1
; genCmpEq: left 2, right 2, result 0
	ld	a,-6(ix)
	or	a,-5(ix)
	jp	z,00114$
00113$:
	jp	00102$
00114$:
;pool.c:118: return 0;
;	genRet
; Dump of IC_LEFT: type AOP_LIT size 2
	ld	hl,#0x0000
	jp	00108$
;	genLabel
00102$:
;pool.c:119: end = (struct dequeue_node *) POINTER_ADD(pos, size);
;	genCast
;	AOP_STK for _pool_create_pos_1_1
	ld	c,-8(ix)
	ld	b,-7(ix)
;	genPlus
;	AOP_STK for 
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,c
	add	a,6(ix)
	ld	c,a
	ld	a,b
	adc	a,7(ix)
	ld	b,a
;	genCast
;	AOP_STK for _pool_create_end_1_1
	ld	-4(ix),c
	ld	-3(ix),b
;pool.c:121: list->first = i;
;	genAssign (pointer)
;	AOP_STK for _pool_create_list_1_1
;	AOP_STK for _pool_create_i_1_1
;	isBitvar = 0
	ld	l,-10(ix)
	ld	h,-9(ix)
	ld	a,-6(ix)
	ld	(hl),a
	inc	hl
	ld	a,-5(ix)
	ld	(hl),a
;pool.c:122: while (1) {
;	genLabel
00106$:
;pool.c:123: i->prev = prev; 
;	genAssign (pointer)
;	AOP_STK for _pool_create_i_1_1
;	AOP_STK for _pool_create_prev_1_1
;	isBitvar = 0
	ld	l,-6(ix)
	ld	h,-5(ix)
	ld	a,-2(ix)
	ld	(hl),a
	inc	hl
	ld	a,-1(ix)
	ld	(hl),a
;pool.c:124: i->next = POINTER_ADD(i, typesize);
;	genPlus
;	AOP_STK for _pool_create_i_1_1
;	AOP_STK for _pool_create_sloc1_1_0
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,-6(ix)
	add	a,#0x02
	ld	-12(ix),a
	ld	a,-5(ix)
	adc	a,#0x00
	ld	-11(ix),a
;	genCast
;	AOP_STK for _pool_create_i_1_1
	ld	c,-6(ix)
	ld	b,-5(ix)
;	genPlus
;	AOP_STK for 
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,c
	add	a,8(ix)
	ld	c,a
	ld	a,b
	adc	a,9(ix)
	ld	b,a
;	genCast
;	genAssign (pointer)
;	AOP_STK for _pool_create_sloc1_1_0
;	isBitvar = 0
	ld	l,-12(ix)
	ld	h,-11(ix)
	ld	(hl),c
	inc	hl
	ld	(hl),b
;pool.c:125: if (i->next >= end) {
;	genCmpLt
;	AOP_STK for _pool_create_end_1_1
	ld	a,c
	sub	a,-4(ix)
	ld	a,b
	sbc	a,-3(ix)
	jp	m,00104$
;pool.c:126: i->next = 0;
;	genAssign (pointer)
;	AOP_STK for _pool_create_sloc1_1_0
;	isBitvar = 0
	ld	l,-12(ix)
	ld	h,-11(ix)
	ld	(hl),#0x00
	inc	hl
	ld	(hl),#0x00
;pool.c:127: break;
;	genGoto
	jp	00107$
;	genLabel
00104$:
;pool.c:129: prev = i;
;	genAssign
;	AOP_STK for _pool_create_i_1_1
;	AOP_STK for _pool_create_prev_1_1
	ld	a,-6(ix)
	ld	-2(ix),a
	ld	a,-5(ix)
	ld	-1(ix),a
;pool.c:130: i = POINTER_ADD(i, typesize);
;	genAssign
;	(registers are the same)
;	genAssign
;	AOP_STK for _pool_create_i_1_1
	ld	-6(ix),c
	ld	-5(ix),b
;	genGoto
	jp	00106$
;	genLabel
00107$:
;pool.c:132: list->last = i;
;	genPlus
;	AOP_STK for _pool_create_list_1_1
;	genPlusIncr
	ld	c,-10(ix)
	ld	b,-9(ix)
	inc	bc
	inc	bc
;	genAssign (pointer)
;	AOP_STK for _pool_create_i_1_1
;	isBitvar = 0
	ld	l,c
	ld	h,b
	ld	a,-6(ix)
	ld	(hl),a
	inc	hl
	ld	a,-5(ix)
	ld	(hl),a
;pool.c:134: DEQUEUE_WIPE(&(pool->used));
;	genPlus
;	genPlusIncr
	ld	c,e
	ld	b,d
	inc	bc
	inc	bc
;	genAssign (pointer)
;	isBitvar = 0
	ld	l,c
	ld	h,b
	ld	(hl),#0x00
	inc	hl
	ld	(hl),#0x00
;	genAssign (pointer)
;	isBitvar = 0
	ld	l,e
	ld	h,d
	ld	(hl),#0x00
	inc	hl
	ld	(hl),#0x00
;pool.c:142: return pos;
;	genRet
;	AOP_STK for _pool_create_pos_1_1
; Dump of IC_LEFT: type AOP_STK size 2
;	 aop_stk -8
	ld	l,-8(ix)
	ld	h,-7(ix)
;	genLabel
00108$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_pool_create_end::
	.area _CODE
