;--------------------------------------------------------
; File Created by SDCC : FreeWare ANSI-C Compiler
; Version 2.6.0 #4309 (Oct 17 2006)
; This file generated Thu Oct 19 04:08:16 2006
;--------------------------------------------------------
	.module mem
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _pmalloc2
	.globl _mem_frag_free
	.globl _mem_frag_alloc
	.globl _mem_frag_add_page
	.globl _mem_frag_clean_stack
	.globl _mem_frag_sort
	.globl _mem_page_free
	.globl _mem_pages_alloc
	.globl _mem_page_alloc
	.globl _mem_pages_lock
	.globl _mem_pages_unref
	.globl _mem_pages_ref
	.globl _ram
	.globl _mem_num_pages_locked
	.globl _mem_num_pages_free
	.globl _page_list
	.globl _page_map
	.globl _fragment_stacks
	.globl _page_alloc
	.globl _mem_init
	.globl _mem_init_proc
	.globl _mem_kill_proc
	.globl _pmalloc
	.globl _kmalloc
	.globl _freep
	.globl _malloc
	.globl _free
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
;  ram data
;--------------------------------------------------------
	.area _DATA
_fragment_stacks::
	.ds 6
_page_map::
	.ds 2
_page_list::
	.ds 2
_mem_num_pages_free::
	.ds 2
_mem_num_pages_locked::
	.ds 2
_ram::
	.ds 0
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
;mem.c:45: void page_alloc (pagenum_t page, fragsize_t fsize, bool cont, proc_t proc)
;	genLabel
;	genFunction
;	---------------------------------
; Function page_alloc
; ---------------------------------
_page_alloc_start::
_page_alloc:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-1
	add	hl,sp
	ld	sp,hl
;mem.c:47: mem_num_pages_free--;                      
;	genMinus
	ld	hl,(_mem_num_pages_free)
	dec	hl
	ld	(_mem_num_pages_free),hl
;mem.c:48: BITMAP_SET(page_map, page, TRUE);         
;	genRightShift
;	AOP_STK for 
	ld	c,4(ix)
	srl	c
	srl	c
	srl	c
;	genPlus
;	Can't optimise plus by inc, falling back to the normal way
	ld	iy,#_page_map
	ld	a,0(iy)
	add	a,c
	ld	c,a
	ld	a,1(iy)
	adc	a,#0x00
	ld	b,a
;	genPointerGet
;	AOP_STK for _page_alloc_sloc0_1_0
	ld	a,(bc)
	ld	-1(ix),a
;	genAnd
;	AOP_STK for 
	ld	a,4(ix)
	and	a,#0x07
;	genLeftShift
	ld	d,a
	inc	a
	push	af
	ld	d,#0x01
	pop	af
	jp	00107$
00106$:
	sla	d
00107$:
	dec	a
	jp	nz,00106$
;	genXor
	ld	a,d
	xor	a,#0xFF
;	genAnd
;	AOP_STK for _page_alloc_sloc0_1_0
	ld	e,a
	and	a,-1(ix)
;	genOr
	ld	e,a
	or	a,d
;	genAssign (pointer)
;	isBitvar = 0
	ld	(bc),a
;mem.c:49: PAGEINFO_SET(page, fsize, cont, proc);
;	genPlus
;	AOP_STK for 
;	Can't optimise plus by inc, falling back to the normal way
	ld	iy,#_page_list
	ld	a,0(iy)
	add	a,4(ix)
	ld	c,a
	ld	a,1(iy)
	adc	a,#0x00
	ld	b,a
;	genIfx
;	AOP_STK for 
	xor	a,a
	or	a,6(ix)
	jp	z,00103$
;	genAssign
	ld	e,#0x04
;	genGoto
	jp	00104$
;	genLabel
00103$:
;	genAssign
	ld	e,#0x00
;	genLabel
00104$:
;	genOr
;	AOP_STK for 
	ld	a,e
	or	a,5(ix)
	ld	e,a
;	genLeftShift
;	AOP_STK for 
	ld	a,7(ix)
	rlca
	rlca
	rlca
	and	a,#0xF8
	ld	d,a
;	genOr
	ld	a,e
	or	a,d
;	genAssign (pointer)
;	isBitvar = 0
	ld	(bc),a
;	genLabel
00101$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_page_alloc_end::
;mem.c:54: mem_pages_ref (pagenum_t p, u16_t num, fragsize_t fsize, proc_t proc)
;	genLabel
;	genFunction
;	---------------------------------
; Function mem_pages_ref
; ---------------------------------
_mem_pages_ref_start::
_mem_pages_ref:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-3
	add	hl,sp
	ld	sp,hl
;mem.c:57: while (num--) {
;	genAssign
;	AOP_STK for 
;	AOP_STK for _mem_pages_ref_sloc0_1_0
	ld	a,4(ix)
	ld	-1(ix),a
;	genAssign
;	AOP_STK for 
	ld	e,5(ix)
	ld	d,6(ix)
;	genLabel
00101$:
;	genAssign
	ld	b,e
	ld	c,d
;	genMinus
	dec	de
;	genIfx
	ld	a,b
	or	a,c
	jp	z,00104$
;mem.c:59: PAGE_ALLOC(p, fsize, num != 0, proc); /* Don't set PCONT of last. */
;	genCmpEq
; genCmpEq: left 2, right 2, result 1
;4
	ld	a,e
	or	a,d
	jp	nz,00109$
	ld	a,#0x01
	jp	00110$
00109$:
	xor	a,a
00110$:
;6
	ld	c,a
;	genNot
	xor	a,a
	or	a,c
	sub	a,#0x01
	ld	a,#0x00
	rla
	ld	c,a
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 1 bcInUse: 0 deSending: 0
	push	de
;	AOP_STK for 
	ld	a,8(ix)
	push	af
	inc	sp
;	genIpush
	ld	a,c
	push	af
	inc	sp
;	genIpush
;	AOP_STK for 
	ld	a,7(ix)
	push	af
	inc	sp
;	genIpush
;	AOP_STK for _mem_pages_ref_sloc0_1_0
	ld	a,-1(ix)
	push	af
	inc	sp
;	genCall
	call	_page_alloc
	pop	af
	pop	af
	pop	de
;mem.c:63: bzero (PAGE2ADDR(p), PAGESIZE);
;	genCast
;	AOP_STK for _mem_pages_ref_sloc0_1_0
	ld	c,-1(ix)
	ld	b,#0x00
;	genLeftShift
;	AOP_STK for _mem_pages_ref_sloc1_1_0
	ld	-2(ix),c
	ld	-3(ix),#0x00
;	genCast
	ld	c,#<_ram
	ld	b,#>_ram
;	genPlus
;	AOP_STK for _mem_pages_ref_sloc1_1_0
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,-3(ix)
	add	a,c
	ld	c,a
	ld	a,-2(ix)
	adc	a,b
	ld	b,a
;	genCast
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 1 bcInUse: 0 deSending: 0
	push	de
	ld	hl,#0x0100
	push	hl
;	genIpush
	push	bc
;	genCall
	call	_bzero
	pop	af
	pop	af
	pop	de
;mem.c:66: p++; /* Next page. */
;	genPlus
;	AOP_STK for _mem_pages_ref_sloc0_1_0
;	genPlusIncr
	inc	-1(ix)
;	genGoto
	jp	00101$
;	genLabel
00104$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_mem_pages_ref_end::
;mem.c:72: mem_pages_unref (pagenum_t p)
;	genLabel
;	genFunction
;	---------------------------------
; Function mem_pages_unref
; ---------------------------------
_mem_pages_unref_start::
_mem_pages_unref:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-4
	add	hl,sp
	ld	sp,hl
;mem.c:82: if (PAGE_LOCKED(p - 1) == 0 && PAGE_CONT(p - 1) != 0)
;	genCast
;	AOP_STK for 
	ld	c,4(ix)
	ld	b,#0x00
;	genMinus
	dec	bc
;	genPlus
;	Can't optimise plus by inc, falling back to the normal way
	ld	iy,#_page_list
	ld	a,0(iy)
	add	a,c
	ld	c,a
	ld	a,1(iy)
	adc	a,b
	ld	b,a
;	genPointerGet
	ld	a,(bc)
;	genAnd
	ld	c,a
	and	a,#0x04
;	genIfx
	ld	b,a
	or	a,a
	jp	z,00103$
;	genAnd
	ld	a,c
	and	a,#0x03
	jp	z,00120$
00119$:
	jp	00117$
00120$:
;	genLabel
00103$:
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	a,b
	or	a,a
;mem.c:83: return; /* Yes, do nothing. */
;	genRet
;mem.c:86: do {
;	genLabel
	jp	z,00117$
00121$:
	jp	00111$
00117$:
;	genAssign
;	AOP_STK for 
	ld	c,4(ix)
;	genLabel
00107$:
;mem.c:87: ASSERT(PAGE_LOCKED(p), "mem_pages_unref(): Shouldn't unlock.\n");
;	genPlus
;	Can't optimise plus by inc, falling back to the normal way
	ld	iy,#_page_list
	ld	a,0(iy)
	add	a,c
	ld	e,a
	ld	a,1(iy)
	adc	a,#0x00
	ld	d,a
;	genPointerGet
	ld	a,(de)
;	genAnd
	ld	b,a
	and	a,#0x04
	jp	z,00105$
00122$:
;	genAnd
	ld	a,b
	and	a,#0x03
	jp	z,00105$
00123$:
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	ld	hl,#__str_0
	push	hl
;	genCall
	call	_panic
	pop	af
	pop	bc
;	genLabel
00105$:
;mem.c:90: cont = PAGE_CONT(p);
;	genPlus
;	AOP_STK for _mem_pages_unref_sloc0_1_0
;	Can't optimise plus by inc, falling back to the normal way
	ld	iy,#_page_list
	ld	a,0(iy)
	add	a,c
	ld	-3(ix),a
	ld	a,1(iy)
	adc	a,#0x00
	ld	-2(ix),a
;	genPointerGet
;	AOP_STK for _mem_pages_unref_sloc0_1_0
	ld	l,-3(ix)
	ld	h,-2(ix)
	ld	b,(hl)
;	genAnd
;	AOP_STK for _mem_pages_unref_cont_1_1
	ld	a,b
	and	a,#0x04
	ld	-1(ix),a
;mem.c:93: PAGE_FREE(p);
;	genRightShift
	ld	b,c
	srl	b
	srl	b
	srl	b
;	genPlus
;	Can't optimise plus by inc, falling back to the normal way
	ld	iy,#_page_map
	ld	a,0(iy)
	add	a,b
	ld	b,a
	ld	a,1(iy)
	adc	a,#0x00
	ld	e,a
;	genPointerGet
;	AOP_STK for _mem_pages_unref_sloc1_1_0
	ld	l,b
	ld	h,e
	ld	a,(hl)
	ld	-4(ix),a
;	genAnd
	ld	a,c
	and	a,#0x07
;	genLeftShift
	ld	d,a
	inc	a
	push	af
	ld	d,#0x01
	pop	af
	jp	00125$
00124$:
	sla	d
00125$:
	dec	a
	jp	nz,00124$
;	genXor
	ld	a,d
	xor	a,#0xFF
	ld	d,a
;	genAnd
;	AOP_STK for _mem_pages_unref_sloc1_1_0
	ld	a,-4(ix)
	and	a,d
;	genAssign (pointer)
;	isBitvar = 0
	ld	l,b
	ld	h,e
	ld	(hl),a
;	genAssign (pointer)
;	AOP_STK for _mem_pages_unref_sloc0_1_0
;	isBitvar = 0
	ld	l,-3(ix)
	ld	h,-2(ix)
	ld	(hl),#0x00
;	genPlus
;	genPlusIncr
	ld	iy,#_mem_num_pages_free
	inc	0(iy)
	jp	nz,00126$
	inc	1(iy)
00126$:
;mem.c:95: p++; /* Next page. */
;	genPlus
;	genPlusIncr
; Removed redundent load
	inc	c
;mem.c:96: } while (cont); /* Continued by next. */
;	genIfx
;	AOP_STK for _mem_pages_unref_cont_1_1
	xor	a,a
	or	a,-1(ix)
	jp	nz,00107$
;	genLabel
00111$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_mem_pages_unref_end::
__str_0:
	.ascii "mem_pages_unref(): Shouldn't unlock."
	.db 0x0A
	.db 0x00
;mem.c:107: mem_pages_lock (pagenum_t p, u16_t num)
;	genLabel
;	genFunction
;	---------------------------------
; Function mem_pages_lock
; ---------------------------------
_mem_pages_lock_start::
_mem_pages_lock:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-4
	add	hl,sp
	ld	sp,hl
;mem.c:109: while (num--) {
;	genAssign
;	AOP_STK for 
	ld	c,4(ix)
;	genAssign
;	AOP_STK for 
;	AOP_STK for _mem_pages_lock_sloc0_1_0
	ld	a,5(ix)
	ld	-2(ix),a
	ld	a,6(ix)
	ld	-1(ix),a
;	genLabel
00105$:
;	genAssign
;	AOP_STK for _mem_pages_lock_sloc0_1_0
	ld	b,-2(ix)
	ld	e,-1(ix)
;	genMinus
;	AOP_STK for _mem_pages_lock_sloc0_1_0
	ld	l,-2(ix)
	ld	h,-1(ix)
	dec	hl
	ld	-2(ix),l
	ld	-1(ix),h
;	genIfx
	ld	a,b
	or	a,e
	jp	z,00110$
;mem.c:110: if (PAGE_LOCKED(p) == FALSE) {
;	genPlus
;	Can't optimise plus by inc, falling back to the normal way
	ld	iy,#_page_list
	ld	a,0(iy)
	add	a,c
	ld	e,a
	ld	a,1(iy)
	adc	a,#0x00
	ld	d,a
;	genPointerGet
	ld	a,(de)
;	genAnd
	ld	b,a
	and	a,#0x04
	jp	z,00103$
00117$:
;	genAnd
	ld	a,b
	and	a,#0x03
	jp	z,00119$
00118$:
	jp	00104$
00119$:
;	genLabel
00103$:
;mem.c:111: PAGE_LOCK(p);
;	genPlus
;	Can't optimise plus by inc, falling back to the normal way
	ld	iy,#_page_list
	ld	a,0(iy)
	add	a,c
	ld	e,a
	ld	a,1(iy)
	adc	a,#0x00
	ld	d,a
;	genPointerGet
	ld	a,(de)
;	genAnd
	ld	b,a
	and	a,#0x04
	jp	z,00101$
00120$:
;	genAnd
	ld	a,b
	and	a,#0x03
	jp	z,00122$
00121$:
	jp	00104$
00122$:
;	genLabel
00101$:
;	genRightShift
	ld	b,c
	srl	b
	srl	b
	srl	b
;	genPlus
;	Can't optimise plus by inc, falling back to the normal way
	ld	iy,#_page_map
	ld	a,0(iy)
	add	a,b
	ld	b,a
	ld	a,1(iy)
	adc	a,#0x00
	ld	e,a
;	genPointerGet
;	AOP_STK for _mem_pages_lock_sloc1_1_0
	ld	l,b
	ld	h,e
	ld	a,(hl)
	ld	-3(ix),a
;	genAnd
	ld	a,c
	and	a,#0x07
;	genLeftShift
	ld	d,a
	inc	a
;	AOP_STK for _mem_pages_lock_sloc2_1_0
	push	af
	ld	-4(ix),#0x01
	pop	af
	jp	00124$
00123$:
	sla	-4(ix)
00124$:
	dec	a
	jp	nz,00123$
;	genXor
;	AOP_STK for _mem_pages_lock_sloc2_1_0
	ld	a,-4(ix)
	xor	a,#0xFF
;	genAnd
;	AOP_STK for _mem_pages_lock_sloc1_1_0
	ld	d,a
	and	a,-3(ix)
;	genOr
;	AOP_STK for _mem_pages_lock_sloc2_1_0
	ld	d,a
	or	a,-4(ix)
;	genAssign (pointer)
;	isBitvar = 0
	ld	l,b
	ld	h,e
	ld	(hl),a
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	ld	hl,#0x0001
	push	hl
;	genIpush
	ld	a,#0x01
	push	af
	inc	sp
;	genIpush
	ld	a,c
	push	af
	inc	sp
;	genCall
	call	_page_alloc
	pop	af
	pop	af
	pop	bc
;	genPlus
;	genPlusIncr
	ld	iy,#_mem_num_pages_locked
	inc	0(iy)
	jp	nz,00125$
	inc	1(iy)
00125$:
;	genLabel
00104$:
;mem.c:118: p++; /* Next page. */
;	genPlus
;	genPlusIncr
; Removed redundent load
	inc	c
;	genGoto
	jp	00105$
;	genLabel
00110$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_mem_pages_lock_end::
;mem.c:125: mem_page_alloc (fragsize_t fsize, proc_t proc)
;	genLabel
;	genFunction
;	---------------------------------
; Function mem_page_alloc
; ---------------------------------
_mem_page_alloc_start::
_mem_page_alloc:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-4
	add	hl,sp
	ld	sp,hl
;mem.c:127: pagenum_t  page = 0;
;	genAssign
;	AOP_STK for _mem_page_alloc_page_1_1
	ld	-1(ix),#0x00
;mem.c:139: for (i = (first >> 3); i >= 0; i--) {
;	genAssign
	ld	de,#0x001F
;	genAssign
;	AOP_STK for _mem_page_alloc_i_1_1
	ld	-4(ix),#0x1F
	ld	-3(ix),#0x00
;	genLabel
00103$:
;	genCmpLt
;	AOP_STK for _mem_page_alloc_i_1_1
	ld	a,-3(ix)
	bit	7,a
	jp	nz,00106$
;mem.c:141: if (page_map[i] == 0xff)
;	genPlus
;	AOP_STK for _mem_page_alloc_i_1_1
;	Can't optimise plus by inc, falling back to the normal way
	ld	iy,#_page_map
	ld	a,0(iy)
	add	a,-4(ix)
	ld	c,a
	ld	a,1(iy)
	adc	a,-3(ix)
	ld	b,a
;	genPointerGet
	ld	a,(bc)
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	c,a
	cp	a,#0xFF
	jp	z,00105$
00122$:
;mem.c:145: for (page = 7, m = 128; page_map[i] & m; m >>= 1, page--);
;	genAssign
;	AOP_STK for _mem_page_alloc_m_1_1
	ld	-2(ix),#0x80
;	genAssign
;	AOP_STK for _mem_page_alloc_page_1_1
	ld	-1(ix),#0x07
;	genLabel
00109$:
;	genPlus
;	Can't optimise plus by inc, falling back to the normal way
	ld	iy,#_page_map
	ld	a,0(iy)
	add	a,e
	ld	b,a
	ld	a,1(iy)
	adc	a,d
	ld	c,a
;	genPointerGet
	ld	l,b
	ld	h,c
	ld	b,(hl)
;	genAnd
;	AOP_STK for _mem_page_alloc_m_1_1
	ld	a,b
	and	a,-2(ix)
;	genIfx
	or	a,a
	jp	z,00112$
;	genRightShift
;	AOP_STK for _mem_page_alloc_m_1_1
	ld	a,-2(ix)
	srl	a
	ld	-2(ix),a
;	genMinus
;	AOP_STK for _mem_page_alloc_page_1_1
	dec	-1(ix)
;	genGoto
	jp	00109$
;	genLabel
00112$:
;mem.c:148: page += i << 3;
;	genCast
	ld	c,e
;	genLeftShift
	ld	a,c
	rlca
	rlca
	rlca
	and	a,#0xF8
	ld	c,a
;	genPlus
;	AOP_STK for _mem_page_alloc_page_1_1
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,-1(ix)
	add	a,c
	ld	c,a
;	genAssign
;	AOP_STK for _mem_page_alloc_page_1_1
	ld	-1(ix),c
;mem.c:149: break;
;	genGoto
	jp	00106$
;	genLabel
00105$:
;mem.c:139: for (i = (first >> 3); i >= 0; i--) {
;	genMinus
;	AOP_STK for _mem_page_alloc_i_1_1
	ld	l,-4(ix)
	ld	h,-3(ix)
	dec	hl
	ld	-4(ix),l
	ld	-3(ix),h
;	genAssign
;	AOP_STK for _mem_page_alloc_i_1_1
	ld	e,-4(ix)
	ld	d,-3(ix)
;	genGoto
	jp	00103$
;	genLabel
00106$:
;mem.c:153: if (page != 0)
;	genCmpEq
;	AOP_STK for _mem_page_alloc_page_1_1
; genCmpEq: left 1, right 1, result 0
	ld	a,-1(ix)
	or	a,a
	jp	z,00108$
00123$:
;mem.c:154: mem_pages_ref (page, 1, fsize, proc);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
;	AOP_STK for 
	ld	a,5(ix)
	push	af
	inc	sp
;	genIpush
;	AOP_STK for 
	ld	a,4(ix)
	push	af
	inc	sp
;	genIpush
	ld	hl,#0x0001
	push	hl
;	genIpush
;	AOP_STK for _mem_page_alloc_page_1_1
	ld	a,-1(ix)
	push	af
	inc	sp
;	genCall
	call	_mem_pages_ref
	pop	af
	pop	af
	inc	sp
;	genLabel
00108$:
;mem.c:158: return page;
;	genRet
;	AOP_STK for _mem_page_alloc_page_1_1
; Dump of IC_LEFT: type AOP_STK size 1
;	 aop_stk -1
	ld	l,-1(ix)
;	genLabel
00113$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_mem_page_alloc_end::
;mem.c:164: mem_pages_alloc (pagenum_t num, fragsize_t fsize, proc_t proc)
;	genLabel
;	genFunction
;	---------------------------------
; Function mem_pages_alloc
; ---------------------------------
_mem_pages_alloc_start::
_mem_pages_alloc:
	push	ix
	ld	ix,#0
	add	ix,sp
;mem.c:176: if (num == 1)
;	genCmpEq
;	AOP_STK for 
; genCmpEq: left 1, right 1, result 0
	ld	a,4(ix)
	cp	a,#0x01
	jp	z,00110$
00109$:
	jp	00102$
00110$:
;mem.c:177: return mem_page_alloc (fsize, proc);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
;	AOP_STK for 
	ld	a,6(ix)
	push	af
	inc	sp
;	genIpush
;	AOP_STK for 
	ld	a,5(ix)
	push	af
	inc	sp
;	genCall
	call	_mem_page_alloc
	pop	af
;	genRet
; Dump of IC_LEFT: type AOP_STR size 1
	jp	00105$
;	genLabel
00102$:
;mem.c:183: ret = bitmap_seek (page_map, NUM_PAGES, first, num);
;	genCast
;	AOP_STK for 
	ld	c,4(ix)
	ld	b,#0x00
;	genAssign
	ld	de,(_page_map)
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	push	bc
;	genIpush
	ld	hl,#0x0000
	push	hl
;	genIpush
	ld	hl,#0x0100
	push	hl
;	genIpush
	push	de
;	genCall
	call	_bitmap_seek
	ld	d,h
	ld	e,l
	pop	af
	pop	af
	pop	af
	pop	af
	pop	bc
;	genCast
; Removed redundent load
;mem.c:185: if (ret != 0)
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	a,e
	or	a,a
	jp	z,00104$
00111$:
;mem.c:187: mem_pages_ref (ret, num, fsize, proc);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 1 bcInUse: 0 deSending: 0
	push	de
;	AOP_STK for 
	ld	a,6(ix)
	push	af
	inc	sp
;	genIpush
;	AOP_STK for 
	ld	a,5(ix)
	push	af
	inc	sp
;	genIpush
	push	bc
;	genIpush
	ld	a,e
	push	af
	inc	sp
;	genCall
	call	_mem_pages_ref
	pop	af
	pop	af
	inc	sp
	pop	de
;	genLabel
00104$:
;mem.c:191: return ret;
;	genRet
; Dump of IC_LEFT: type AOP_REG size 1
;	 reg = e
	ld	l,e
;	genLabel
00105$:
;	genEndFunction
	pop	ix
	ret
_mem_pages_alloc_end::
;mem.c:196: mem_page_free (void *pos)
;	genLabel
;	genFunction
;	---------------------------------
; Function mem_page_free
; ---------------------------------
_mem_page_free_start::
_mem_page_free:
	push	ix
	ld	ix,#0
	add	ix,sp
;mem.c:198: pagenum_t        p = ADDR2PAGE(pos);
;	genCast
;	AOP_STK for 
	ld	c,4(ix)
	ld	b,5(ix)
;	genCast
	ld	e,#<_ram
	ld	d,#>_ram
;	genMinus
	ld	a,c
	sub	a,e
	ld	c,a
	ld	a,b
	sbc	a,d
	ld	b,a
;	genCast
;	genCast
;	genRightShift
	ld	c,b
	ld	b,#0x00
;	genCast
; Removed redundent load
;mem.c:202: if (!PAGE_USED(p))
;	genRightShift
	ld	b,c
	srl	b
	srl	b
	srl	b
;	genPlus
;	Can't optimise plus by inc, falling back to the normal way
	ld	iy,#_page_map
	ld	a,0(iy)
	add	a,b
	ld	b,a
	ld	a,1(iy)
	adc	a,#0x00
	ld	e,a
;	genPointerGet
	ld	l,b
	ld	h,e
	ld	b,(hl)
;	genAnd
	ld	a,c
	and	a,#0x07
;	genLeftShift
	ld	e,a
	inc	a
	push	af
	ld	e,#0x01
	pop	af
	jp	00107$
00106$:
	sla	e
00107$:
	dec	a
	jp	nz,00106$
;	genAnd
	ld	a,b
	and	a,e
;	genIfx
	or	a,a
;mem.c:203: return;
;	genRet
;	genLabel
	jp	z,00103$
00102$:
;mem.c:207: mem_pages_unref (p);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	a,c
	push	af
	inc	sp
;	genCall
	call	_mem_pages_unref
	inc	sp
;	genLabel
00103$:
;	genEndFunction
	pop	ix
	ret
_mem_page_free_end::
;mem.c:216: mem_frag_sort (struct stack_hdr *stack)
;	genLabel
;	genFunction
;	---------------------------------
; Function mem_frag_sort
; ---------------------------------
_mem_frag_sort_start::
_mem_frag_sort:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-21
	add	hl,sp
	ld	sp,hl
;mem.c:221: u16_t       num = stack->index; /* Number of elements on stack. */
;	genAssign
;	AOP_STK for 
	ld	c,4(ix)
	ld	b,5(ix)
	push	bc
	pop	iy
;	genPointerGet
	ld	c,0(iy)
	ld	b,1(iy)
;	genAssign
;	AOP_STK for _mem_frag_sort_num_1_1
	ld	-6(ix),c
	ld	-5(ix),b
;mem.c:222: struct fragment  *st = STACK_START(stack, struct fragment);
;	genCast
;	AOP_STK for 
	ld	e,4(ix)
	ld	d,5(ix)
;	genPlus
;	genPlusIncr
	inc	de
	inc	de
;	genCast
;	AOP_STK for _mem_frag_sort_st_1_1
	ld	-8(ix),e
	ld	-7(ix),d
;mem.c:224: for (i = 0; i < num - 1; i++) {
;	genMinus
;	AOP_STK for _mem_frag_sort_num_1_1
;	AOP_STK for _mem_frag_sort_sloc4_1_0
	ld	a,-6(ix)
	add	a,#0xFF
	ld	-17(ix),a
	ld	a,-5(ix)
	adc	a,#0xFF
	ld	-16(ix),a
;	genAssign
;	AOP_STK for _mem_frag_sort_i_1_1
	ld	-2(ix),#0x00
	ld	-1(ix),#0x00
;	genLabel
00107$:
;	genCmpLt
;	AOP_STK for _mem_frag_sort_i_1_1
;	AOP_STK for _mem_frag_sort_sloc4_1_0
	ld	a,-2(ix)
	sub	a,-17(ix)
	ld	a,-1(ix)
	sbc	a,-16(ix)
	jp	nc,00111$
;mem.c:225: for (j = i + 1; j < num; j++) {
;	genPlus
;	AOP_STK for _mem_frag_sort_i_1_1
;	genPlusIncr
	ld	e,-2(ix)
	ld	d,-1(ix)
	inc	de
;	genLeftShift
;	AOP_STK for _mem_frag_sort_i_1_1
;	AOP_STK for _mem_frag_sort_sloc0_1_0
	ld	a,-2(ix)
	ld	-10(ix),a
	ld	a,-1(ix)
	ld	-9(ix),a
	sla	-10(ix)
	rl	-9(ix)
;	genPlus
;	AOP_STK for _mem_frag_sort_st_1_1
;	AOP_STK for _mem_frag_sort_sloc0_1_0
;	AOP_STK for _mem_frag_sort_sloc1_1_0
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,-8(ix)
	add	a,-10(ix)
	ld	-12(ix),a
	ld	a,-7(ix)
	adc	a,-9(ix)
	ld	-11(ix),a
;	genAssign
;	(registers are the same)
;	genLabel
00103$:
;	genCmpLt
;	AOP_STK for _mem_frag_sort_num_1_1
	ld	a,e
	sub	a,-6(ix)
	ld	a,d
	sbc	a,-5(ix)
	jp	nc,00109$
;mem.c:226: if (st[i].page > st[j].page) {
;	genPointerGet
;	AOP_STK for _mem_frag_sort_sloc1_1_0
;	AOP_STK for _mem_frag_sort_sloc2_1_0
	ld	l,-12(ix)
	ld	h,-11(ix)
	ld	a,(hl)
	ld	-13(ix),a
;	genLeftShift
;	AOP_STK for _mem_frag_sort_sloc3_1_0
	ld	-15(ix),e
	ld	-14(ix),d
	sla	-15(ix)
	rl	-14(ix)
;	genPlus
;	AOP_STK for _mem_frag_sort_st_1_1
;	AOP_STK for _mem_frag_sort_sloc3_1_0
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,-8(ix)
	add	a,-15(ix)
	ld	c,a
	ld	a,-7(ix)
	adc	a,-14(ix)
	ld	b,a
;	genPointerGet
	ld	a,(bc)
;	genCmpGt
;	AOP_STK for _mem_frag_sort_sloc2_1_0
	ld	c,a
	sub	a,-13(ix)
	jp	nc,00105$
;mem.c:227: pg = st[i].page;
;	genAssign
;	AOP_STK for _mem_frag_sort_sloc2_1_0
	ld	b,-13(ix)
;	genAssign
;	AOP_STK for _mem_frag_sort_pg_1_1
	ld	-3(ix),b
;mem.c:228: id = st[i].idx;
;	genPlus
;	AOP_STK for _mem_frag_sort_st_1_1
;	AOP_STK for _mem_frag_sort_sloc0_1_0
;	AOP_STK for _mem_frag_sort_sloc6_1_0
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,-8(ix)
	add	a,-10(ix)
	ld	-19(ix),a
	ld	a,-7(ix)
	adc	a,-9(ix)
	ld	-18(ix),a
;	genPlus
;	AOP_STK for _mem_frag_sort_sloc6_1_0
;	AOP_STK for _mem_frag_sort_sloc7_1_0
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,-19(ix)
	add	a,#0x01
	ld	-21(ix),a
	ld	a,-18(ix)
	adc	a,#0x00
	ld	-20(ix),a
;	genPointerGet
;	AOP_STK for _mem_frag_sort_sloc7_1_0
	ld	l,-21(ix)
	ld	h,-20(ix)
	ld	b,(hl)
;	genAssign
;	AOP_STK for _mem_frag_sort_id_1_1
	ld	-4(ix),b
;mem.c:229: st[i].page = st[j].page;
;	genAssign (pointer)
;	AOP_STK for _mem_frag_sort_sloc6_1_0
;	isBitvar = 0
	ld	l,-19(ix)
	ld	h,-18(ix)
	ld	(hl),c
;mem.c:230: st[i].idx = st[j].idx;
;	genPlus
;	AOP_STK for _mem_frag_sort_st_1_1
;	AOP_STK for _mem_frag_sort_sloc3_1_0
;	AOP_STK for _mem_frag_sort_sloc6_1_0
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,-8(ix)
	add	a,-15(ix)
	ld	-19(ix),a
	ld	a,-7(ix)
	adc	a,-14(ix)
	ld	-18(ix),a
;	genPlus
;	AOP_STK for _mem_frag_sort_sloc6_1_0
;	genPlusIncr
	ld	c,-19(ix)
	ld	b,-18(ix)
	inc	bc
;	genPointerGet
	ld	a,(bc)
;	genAssign (pointer)
;	AOP_STK for _mem_frag_sort_sloc7_1_0
;	isBitvar = 0
	ld	l,-21(ix)
	ld	h,-20(ix)
	ld	(hl),a
;mem.c:231: st[j].page = pg;
;	genAssign (pointer)
;	AOP_STK for _mem_frag_sort_sloc6_1_0
;	AOP_STK for _mem_frag_sort_pg_1_1
;	isBitvar = 0
	ld	l,-19(ix)
	ld	h,-18(ix)
	ld	a,-3(ix)
	ld	(hl),a
;mem.c:232: st[j].idx = id;
;	genAssign (pointer)
;	AOP_STK for _mem_frag_sort_id_1_1
;	isBitvar = 0
	ld	a,-4(ix)
	ld	(bc),a
;	genLabel
00105$:
;mem.c:225: for (j = i + 1; j < num; j++) {
;	genPlus
;	genPlusIncr
	inc	de
;	genGoto
	jp	00103$
;	genLabel
00109$:
;mem.c:224: for (i = 0; i < num - 1; i++) {
;	genPlus
;	AOP_STK for _mem_frag_sort_i_1_1
;	genPlusIncr
	inc	-2(ix)
	jp	nz,00124$
	inc	-1(ix)
00124$:
;	genGoto
	jp	00107$
;	genLabel
00111$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_mem_frag_sort_end::
;mem.c:251: mem_frag_clean_stack (struct stack_hdr *stack, int frags)
;	genLabel
;	genFunction
;	---------------------------------
; Function mem_frag_clean_stack
; ---------------------------------
_mem_frag_clean_stack_start::
_mem_frag_clean_stack:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-19
	add	hl,sp
	ld	sp,hl
;mem.c:256: u16_t       num = stack->index; /* Number of elements on stack. */
;	genAssign
;	AOP_STK for 
;	AOP_STK for _mem_frag_clean_stack_sloc1_1_0
	ld	a,4(ix)
	ld	-13(ix),a
	ld	a,5(ix)
	ld	-12(ix),a
;	genPointerGet
;	AOP_STK for _mem_frag_clean_stack_sloc1_1_0
	ld	l,-13(ix)
	ld	h,-12(ix)
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
;	genAssign
;	AOP_STK for _mem_frag_clean_stack_num_1_1
	ld	-7(ix),e
	ld	-6(ix),d
;mem.c:257: struct fragment  *st = STACK_START(stack, struct fragment);
;	genCast
;	AOP_STK for 
	ld	e,4(ix)
	ld	d,5(ix)
;	genPlus
;	genPlusIncr
	inc	de
	inc	de
;	genCast
;	AOP_STK for _mem_frag_clean_stack_st_1_1
	ld	-9(ix),e
	ld	-8(ix),d
;mem.c:260: if (num < frags)
;	genAssign
;	(operands are equal 3)
;	genCmpLt
;	AOP_STK for _mem_frag_clean_stack_num_1_1
;	AOP_STK for 
	ld	a,-7(ix)
	sub	a,6(ix)
	ld	a,-6(ix)
	sbc	a,7(ix)
	jp	nc,00102$
;mem.c:261: return;
;	genRet
	jp	00117$
;	genLabel
00102$:
;mem.c:263: mem_frag_sort (stack);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
;	AOP_STK for _mem_frag_clean_stack_sloc1_1_0
	ld	l,-13(ix)
	ld	h,-12(ix)
	push	hl
;	genCall
	call	_mem_frag_sort
	pop	af
;mem.c:266: src = 0;
;	genAssign
;	AOP_STK for _mem_frag_clean_stack_src_1_1
	ld	-2(ix),#0x00
	ld	-1(ix),#0x00
;mem.c:267: dst = 0;
;	genAssign
;	AOP_STK for _mem_frag_clean_stack_dst_1_1
	ld	-4(ix),#0x00
	ld	-3(ix),#0x00
;mem.c:268: while (src < num) {
;	genLabel
00114$:
;	genCmpLt
;	AOP_STK for _mem_frag_clean_stack_src_1_1
;	AOP_STK for _mem_frag_clean_stack_num_1_1
	ld	a,-2(ix)
	sub	a,-7(ix)
	ld	a,-1(ix)
	sbc	a,-6(ix)
	jp	nc,00116$
;mem.c:271: pg = st[src].page;
;	genLeftShift
;	AOP_STK for _mem_frag_clean_stack_src_1_1
	ld	e,-2(ix)
	ld	d,-1(ix)
	sla	e
	rl	d
;	genPlus
;	AOP_STK for _mem_frag_clean_stack_st_1_1
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,-9(ix)
	add	a,e
	ld	e,a
	ld	a,-8(ix)
	adc	a,d
	ld	d,a
;	genPointerGet
	ld	a,(de)
	ld	e,a
;	genAssign
	ld	c,e
;mem.c:273: while ((src + id) < num && st[src + id].page == pg)
;	genAssign
	ld	b,#0x01
;	genLabel
00104$:
;	genCast
	ld	e,b
	ld	d,#0x00
;	genPlus
;	AOP_STK for _mem_frag_clean_stack_src_1_1
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,-2(ix)
	add	a,e
	ld	e,a
	ld	a,-1(ix)
	adc	a,d
	ld	d,a
;	genCmpLt
;	AOP_STK for _mem_frag_clean_stack_num_1_1
	ld	a,e
	sub	a,-7(ix)
	ld	a,d
	sbc	a,-6(ix)
	jp	nc,00106$
;	genLeftShift
	sla	e
	rl	d
;	genPlus
;	AOP_STK for _mem_frag_clean_stack_st_1_1
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,-9(ix)
	add	a,e
	ld	e,a
	ld	a,-8(ix)
	adc	a,d
	ld	d,a
;	genPointerGet
	ld	a,(de)
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	e,a
	cp	c
	jp	z,00135$
00134$:
	jp	00106$
00135$:
;mem.c:274: id++;
;	genPlus
;	genPlusIncr
; Removed redundent load
	inc	b
;	genGoto
	jp	00104$
;	genLabel
00106$:
;mem.c:277: if (id == frags) {
;	genCast
	ld	e,b
	ld	d,#0x00
;	genCmpEq
;	AOP_STK for 
; genCmpEq: left 2, right 2, result 0
	ld	a,6(ix)
	cp	e
	jp	nz,00136$
	ld	a,7(ix)
	cp	d
	jp	z,00137$
00136$:
	jp	00108$
00137$:
;mem.c:279: mem_pages_unref (pg);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 1 bcInUse: 0 deSending: 0
	push	de
	ld	a,c
	push	af
	inc	sp
;	genCall
	call	_mem_pages_unref
	inc	sp
	pop	de
;mem.c:282: src += id;
;	genPlus
;	AOP_STK for _mem_frag_clean_stack_src_1_1
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,-2(ix)
	add	a,e
	ld	-2(ix),a
	ld	a,-1(ix)
	adc	a,d
	ld	-1(ix),a
;mem.c:286: continue;
;	genGoto
	jp	00114$
;	genLabel
00108$:
;mem.c:290: if (src == dst) {
;	genCmpEq
;	AOP_STK for _mem_frag_clean_stack_src_1_1
;	AOP_STK for _mem_frag_clean_stack_dst_1_1
; genCmpEq: left 2, right 2, result 0
	ld	a,-4(ix)
	cp	-2(ix)
	jp	nz,00138$
	ld	a,-3(ix)
	cp	-1(ix)
	jp	z,00139$
00138$:
	jp	00128$
00139$:
;mem.c:291: src += id;
;	genPlus
;	AOP_STK for _mem_frag_clean_stack_src_1_1
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,-2(ix)
	add	a,e
	ld	-2(ix),a
	ld	a,-1(ix)
	adc	a,d
	ld	-1(ix),a
;mem.c:292: dst = src;
;	genAssign
;	AOP_STK for _mem_frag_clean_stack_src_1_1
;	AOP_STK for _mem_frag_clean_stack_dst_1_1
	ld	a,-2(ix)
	ld	-4(ix),a
	ld	a,-1(ix)
	ld	-3(ix),a
;mem.c:293: continue;
;	genGoto
	jp	00114$
;mem.c:297: while (id--) {
;	genLabel
00128$:
;	genAssign
;	AOP_STK for _mem_frag_clean_stack_src_1_1
	ld	e,-2(ix)
	ld	d,-1(ix)
;	genAssign
;	AOP_STK for _mem_frag_clean_stack_dst_1_1
;	AOP_STK for _mem_frag_clean_stack_sloc0_1_0
	ld	a,-4(ix)
	ld	-11(ix),a
	ld	a,-3(ix)
	ld	-10(ix),a
;	genAssign
;	AOP_STK for _mem_frag_clean_stack_id_1_1
	ld	-5(ix),b
;	genLabel
00111$:
;	genAssign
;	AOP_STK for _mem_frag_clean_stack_id_1_1
	ld	b,-5(ix)
;	genMinus
;	AOP_STK for _mem_frag_clean_stack_id_1_1
	dec	-5(ix)
;	genIfx
	xor	a,a
	or	a,b
	jp	z,00114$
;mem.c:298: st[dst].page = st[src].page;
;	genLeftShift
;	AOP_STK for _mem_frag_clean_stack_sloc0_1_0
;	AOP_STK for _mem_frag_clean_stack_sloc2_1_0
	ld	a,-11(ix)
	ld	-15(ix),a
	ld	a,-10(ix)
	ld	-14(ix),a
	sla	-15(ix)
	rl	-14(ix)
;	genPlus
;	AOP_STK for _mem_frag_clean_stack_st_1_1
;	AOP_STK for _mem_frag_clean_stack_sloc2_1_0
;	AOP_STK for _mem_frag_clean_stack_sloc3_1_0
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,-9(ix)
	add	a,-15(ix)
	ld	-17(ix),a
	ld	a,-8(ix)
	adc	a,-14(ix)
	ld	-16(ix),a
;	genLeftShift
;	AOP_STK for _mem_frag_clean_stack_sloc4_1_0
	ld	-19(ix),e
	ld	-18(ix),d
	sla	-19(ix)
	rl	-18(ix)
;	genPlus
;	AOP_STK for _mem_frag_clean_stack_st_1_1
;	AOP_STK for _mem_frag_clean_stack_sloc4_1_0
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,-9(ix)
	add	a,-19(ix)
	ld	c,a
	ld	a,-8(ix)
	adc	a,-18(ix)
	ld	b,a
;	genPointerGet
	ld	a,(bc)
;	genAssign (pointer)
;	AOP_STK for _mem_frag_clean_stack_sloc3_1_0
;	isBitvar = 0
	ld	l,-17(ix)
	ld	h,-16(ix)
	ld	(hl),a
;mem.c:299: st[dst].idx = st[src].idx;
;	genPlus
;	AOP_STK for _mem_frag_clean_stack_st_1_1
;	AOP_STK for _mem_frag_clean_stack_sloc2_1_0
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,-9(ix)
	add	a,-15(ix)
	ld	c,a
	ld	a,-8(ix)
	adc	a,-14(ix)
	ld	b,a
;	genPlus
;	AOP_STK for _mem_frag_clean_stack_sloc3_1_0
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,c
	add	a,#0x01
	ld	-17(ix),a
	ld	a,b
	adc	a,#0x00
	ld	-16(ix),a
;	genPlus
;	AOP_STK for _mem_frag_clean_stack_st_1_1
;	AOP_STK for _mem_frag_clean_stack_sloc4_1_0
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,-9(ix)
	add	a,-19(ix)
	ld	c,a
	ld	a,-8(ix)
	adc	a,-18(ix)
	ld	b,a
;	genPlus
;	genPlusIncr
	inc	bc
;	genPointerGet
	ld	a,(bc)
;	genAssign (pointer)
;	AOP_STK for _mem_frag_clean_stack_sloc3_1_0
;	isBitvar = 0
	ld	l,-17(ix)
	ld	h,-16(ix)
	ld	(hl),a
;mem.c:300: src++;
;	genPlus
;	genPlusIncr
	inc	de
;	genAssign
;	AOP_STK for _mem_frag_clean_stack_src_1_1
	ld	-2(ix),e
	ld	-1(ix),d
;mem.c:301: dst++;
;	genPlus
;	AOP_STK for _mem_frag_clean_stack_sloc0_1_0
;	genPlusIncr
	inc	-11(ix)
	jp	nz,00144$
	inc	-10(ix)
00144$:
;	genAssign
;	AOP_STK for _mem_frag_clean_stack_sloc0_1_0
;	AOP_STK for _mem_frag_clean_stack_dst_1_1
	ld	a,-11(ix)
	ld	-4(ix),a
	ld	a,-10(ix)
	ld	-3(ix),a
;	genGoto
	jp	00111$
;	genLabel
00116$:
;mem.c:306: stack->index = dst;
;	genAssign (pointer)
;	AOP_STK for _mem_frag_clean_stack_sloc1_1_0
;	AOP_STK for _mem_frag_clean_stack_dst_1_1
;	isBitvar = 0
	ld	l,-13(ix)
	ld	h,-12(ix)
	ld	a,-4(ix)
	ld	(hl),a
	inc	hl
	ld	a,-3(ix)
	ld	(hl),a
;	genLabel
00117$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_mem_frag_clean_stack_end::
;mem.c:326: mem_frag_add_page (struct stack_hdr *stack, fragsize_t fs, struct proc *proc)
;	genLabel
;	genFunction
;	---------------------------------
; Function mem_frag_add_page
; ---------------------------------
_mem_frag_add_page_start::
_mem_frag_add_page:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-13
	add	hl,sp
	ld	sp,hl
;mem.c:329: fragsize_t	num = FRAGLOG2NUM(fs);
;	genLeftShift
;	AOP_STK for 
	ld	a,6(ix)
	inc	a
;	AOP_STK for _mem_frag_add_page_num_1_1
	push	af
	ld	-1(ix),#0x01
	pop	af
	jp	00130$
00129$:
	sla	-1(ix)
00130$:
	dec	a
	jp	nz,00129$
;mem.c:330: proc_t    procid = proc->id;
;	genAssign
;	AOP_STK for 
	ld	e,7(ix)
	ld	d,8(ix)
;	genPlus
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,e
	add	a,#0x25
	ld	b,a
	ld	a,d
	adc	a,#0x00
	ld	c,a
;	genPointerGet
	ld	l,b
	ld	h,c
	ld	b,(hl)
;	genAssign
;	AOP_STK for _mem_frag_add_page_procid_1_1
	ld	-2(ix),b
;mem.c:335: ERRCHK(FRAGSPACE(proc, fs) < (sizeof (struct fragment) * num), ENOMEM);
;	genPlus
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,e
	add	a,#0x18
	ld	e,a
	ld	a,d
	adc	a,#0x00
	ld	d,a
;	genMinus
;	AOP_STK for 
	ld	a,6(ix)
	add	a,#0xFF
;	genLeftShift
	ld	b,a
	add	a,a
	ld	b,a
;	genPlus
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,e
	add	a,b
	ld	b,a
	ld	a,d
	adc	a,#0x00
	ld	e,a
;	genPointerGet
	ld	l,b
	ld	h,e
	ld	b,(hl)
	inc	hl
	ld	e,(hl)
;	genPointerGet
	ld	l,b
	ld	h,e
	ld	b,(hl)
	inc	hl
	ld	e,(hl)
;	genLeftShift
	sla	b
	rl	e
;	genPlus
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,b
	add	a,#0x02
	ld	b,a
	ld	a,e
	adc	a,#0x00
	ld	e,a
;	genMinus
	ld	a,#0x00
	sub	a,b
	ld	b,a
	ld	a,#0x01
	sbc	a,e
	ld	e,a
;	genCast
;	AOP_STK for _mem_frag_add_page_num_1_1
	ld	d,-1(ix)
	ld	c,#0x00
;	genLeftShift
	sla	d
	rl	c
;	genCmpLt
	ld	a,b
	sub	a,d
	ld	a,e
	sbc	a,c
	jp	p,00102$
;	genRet
; Dump of IC_LEFT: type AOP_LIT size 2
	ld	hl,#0x0001
	jp	00114$
;	genLabel
00102$:
;mem.c:339: p = mem_page_alloc (fs, procid);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
;	AOP_STK for _mem_frag_add_page_procid_1_1
	ld	a,-2(ix)
	push	af
	inc	sp
;	genIpush
;	AOP_STK for 
	ld	a,6(ix)
	push	af
	inc	sp
;	genCall
	call	_mem_page_alloc
	ld	c,l
	pop	af
;	genAssign
;	AOP_STK for _mem_frag_add_page_p_1_1
	ld	-3(ix),c
;mem.c:343: ERRCHK(p == 0, ENOMEM); /* Out of memory. */
;	genIfx
;	AOP_STK for _mem_frag_add_page_p_1_1
	xor	a,a
	or	a,-3(ix)
	jp	nz,00104$
;	genRet
; Dump of IC_LEFT: type AOP_LIT size 2
	ld	hl,#0x0001
	jp	00114$
;	genLabel
00104$:
;mem.c:346: for (i = 0; i < num; i++) {
;	genAssign
;	AOP_STK for _mem_frag_add_page_sloc4_1_0
	ld	-13(ix),#0x00
;	genAssign
;	AOP_STK for _mem_frag_add_page_i_1_1
	ld	-4(ix),#0x00
;	genLabel
00110$:
;	genCmpLt
;	AOP_STK for _mem_frag_add_page_i_1_1
;	AOP_STK for _mem_frag_add_page_num_1_1
	ld	a,-4(ix)
	sub	a,-1(ix)
	jp	nc,00113$
;mem.c:348: nfrag = FRAG_PUSH(stack);
;	genAssign
;	AOP_STK for 
;	AOP_STK for _mem_frag_add_page_sloc0_1_0
	ld	a,4(ix)
	ld	-6(ix),a
	ld	a,5(ix)
	ld	-5(ix),a
;	genPointerGet
;	AOP_STK for _mem_frag_add_page_sloc0_1_0
;	AOP_STK for _mem_frag_add_page_sloc1_1_0
	ld	l,-6(ix)
	ld	h,-5(ix)
	ld	a,(hl)
	ld	-8(ix),a
	inc	hl
	ld	a,(hl)
	ld	-7(ix),a
;	genLeftShift
;	AOP_STK for _mem_frag_add_page_sloc1_1_0
;	AOP_STK for _mem_frag_add_page_sloc2_1_0
	ld	a,-8(ix)
	ld	-10(ix),a
	ld	a,-7(ix)
	ld	-9(ix),a
	sla	-10(ix)
	rl	-9(ix)
;	genPlus
;	AOP_STK for _mem_frag_add_page_sloc2_1_0
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,-10(ix)
	add	a,#0x04
	ld	d,a
	ld	a,-9(ix)
	adc	a,#0x00
	ld	c,a
;	genCast
;	AOP_STK for 
;	AOP_STK for _mem_frag_add_page_sloc3_1_0
	ld	a,4(ix)
	ld	-12(ix),a
	ld	a,5(ix)
	ld	-11(ix),a
;	genCast
	ld	e,#<_ram
	ld	b,#>_ram
;	genMinus
;	AOP_STK for _mem_frag_add_page_sloc3_1_0
	ld	a,-12(ix)
	sub	a,e
	ld	e,a
	ld	a,-11(ix)
	sbc	a,b
	ld	b,a
;	genCast
;	genCast
;	genRightShift
	ld	e,b
	ld	b,#0x00
;	genPlus
;	Can't optimise plus by inc, falling back to the normal way
	ld	iy,#_page_list
	ld	a,0(iy)
	add	a,e
	ld	e,a
	ld	a,1(iy)
	adc	a,b
	ld	b,a
;	genPointerGet
	ld	l,e
	ld	h,b
	ld	e,(hl)
;	genAnd
	ld	a,e
	and	a,#0x03
;	genRightShift
	ld	e,a
	inc	a
	push	af
	ld	e,#0x00
	ld	b,#0x01
	pop	af
	jp	00138$
00137$:
	srl	b
	rr	e
00138$:
	dec	a
	jp	nz,00137$
;	genCmpGt
	ld	a,e
	sub	a,d
	ld	a,b
	sbc	a,c
	jp	nc,00116$
;	genAssign
	ld	bc,#0x0000
;	genGoto
	jp	00117$
;	genLabel
00116$:
;	genPlus
;	AOP_STK for _mem_frag_add_page_sloc3_1_0
;	genPlusIncr
	ld	e,-12(ix)
	ld	d,-11(ix)
	inc	de
	inc	de
;	genCast
;	AOP_STK for _mem_frag_add_page_sloc3_1_0
	ld	-12(ix),e
	ld	-11(ix),d
;	genPlus
;	AOP_STK for _mem_frag_add_page_sloc1_1_0
;	genPlusIncr
	ld	e,-8(ix)
	ld	d,-7(ix)
	inc	de
;	genAssign (pointer)
;	AOP_STK for _mem_frag_add_page_sloc0_1_0
;	isBitvar = 0
	ld	l,-6(ix)
	ld	h,-5(ix)
	ld	(hl),e
	inc	hl
	ld	(hl),d
;	genPlus
;	AOP_STK for _mem_frag_add_page_sloc3_1_0
;	AOP_STK for _mem_frag_add_page_sloc2_1_0
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,-12(ix)
	add	a,-10(ix)
	ld	c,a
	ld	a,-11(ix)
	adc	a,-9(ix)
	ld	b,a
;	genLabel
00117$:
;	genAssign
;	(registers are the same)
;	genAssign
;	(registers are the same)
;mem.c:354: if (nfrag == 0) {
;	genIfx
	ld	a,c
	or	a,b
	jp	nz,00109$
;mem.c:355: while (i--)
;	genAssign
;	AOP_STK for _mem_frag_add_page_sloc4_1_0
	ld	c,-13(ix)
;	genLabel
00105$:
;	genAssign
	ld	d,c
;	genMinus
	dec	c
;	genIfx
	xor	a,a
	or	a,d
	jp	z,00107$
;mem.c:356: FRAG_POP(stack);
;	genPointerGet
;	AOP_STK for _mem_frag_add_page_sloc0_1_0
	ld	l,-6(ix)
	ld	h,-5(ix)
	ld	d,(hl)
	inc	hl
	ld	e,(hl)
;	genNot
	ld	a,d
	or	a,e
	sub	a,#0x01
	ld	a,#0x00
	rla
	ld	d,a
;	genIfx
	xor	a,a
	or	a,d
	jp	nz,00105$
;	genPointerGet
;	AOP_STK for _mem_frag_add_page_sloc0_1_0
	ld	l,-6(ix)
	ld	h,-5(ix)
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
;	genMinus
	dec	de
;	genAssign (pointer)
;	AOP_STK for _mem_frag_add_page_sloc0_1_0
;	isBitvar = 0
	ld	l,-6(ix)
	ld	h,-5(ix)
	ld	(hl),e
	inc	hl
	ld	(hl),d
;	genGoto
	jp	00105$
;	genLabel
00107$:
;mem.c:359: PAGE_FREE(p);
;	genRightShift
;	AOP_STK for _mem_frag_add_page_p_1_1
	ld	e,-3(ix)
	srl	e
	srl	e
	srl	e
;	genPlus
;	Can't optimise plus by inc, falling back to the normal way
	ld	iy,#_page_map
	ld	a,0(iy)
	add	a,e
	ld	c,a
	ld	a,1(iy)
	adc	a,#0x00
	ld	b,a
;	genPointerGet
	ld	a,(bc)
	ld	e,a
;	genAnd
;	AOP_STK for _mem_frag_add_page_p_1_1
	ld	a,-3(ix)
	and	a,#0x07
;	genLeftShift
	ld	d,a
	inc	a
	push	af
	ld	d,#0x01
	pop	af
	jp	00140$
00139$:
	sla	d
00140$:
	dec	a
	jp	nz,00139$
;	genXor
	ld	a,d
	xor	a,#0xFF
	ld	d,a
;	genAnd
	ld	a,e
	and	a,d
;	genAssign (pointer)
;	isBitvar = 0
	ld	(bc),a
;	genPlus
;	AOP_STK for _mem_frag_add_page_p_1_1
;	Can't optimise plus by inc, falling back to the normal way
	ld	iy,#_page_list
	ld	a,0(iy)
	add	a,-3(ix)
	ld	e,a
	ld	a,1(iy)
	adc	a,#0x00
	ld	d,a
;	genAssign (pointer)
;	isBitvar = 0
	ld	a,#0x00
	ld	(de),a
;	genPlus
;	genPlusIncr
	ld	iy,#_mem_num_pages_free
	inc	0(iy)
	jp	nz,00141$
	inc	1(iy)
00141$:
;mem.c:361: return ENOMEM; /* Out of memory. */
;	genRet
; Dump of IC_LEFT: type AOP_LIT size 2
	ld	hl,#0x0001
	jp	00114$
;	genLabel
00109$:
;mem.c:365: nfrag->page = p; /* Page number. */
;	genAssign (pointer)
;	AOP_STK for _mem_frag_add_page_p_1_1
;	isBitvar = 0
	ld	a,-3(ix)
	ld	(bc),a
;mem.c:366: nfrag->idx = i;  /* Fragment index within the page. */
;	genPlus
;	genPlusIncr
	inc	bc
;	genAssign (pointer)
;	AOP_STK for _mem_frag_add_page_i_1_1
;	isBitvar = 0
	ld	a,-4(ix)
	ld	(bc),a
;mem.c:346: for (i = 0; i < num; i++) {
;	genPlus
;	AOP_STK for _mem_frag_add_page_i_1_1
;	genPlusIncr
	inc	-4(ix)
;	genAssign
;	AOP_STK for _mem_frag_add_page_i_1_1
;	AOP_STK for _mem_frag_add_page_sloc4_1_0
	ld	a,-4(ix)
	ld	-13(ix),a
;	genGoto
	jp	00110$
;	genLabel
00113$:
;mem.c:369: return ENONE;
;	genRet
; Dump of IC_LEFT: type AOP_LIT size 2
	ld	hl,#0x0000
;	genLabel
00114$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_mem_frag_add_page_end::
;mem.c:374: mem_frag_alloc (size_t size, struct proc *proc)
;	genLabel
;	genFunction
;	---------------------------------
; Function mem_frag_alloc
; ---------------------------------
_mem_frag_alloc_start::
_mem_frag_alloc:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-9
	add	hl,sp
	ld	sp,hl
;mem.c:385: for (fs = 0, i = PAGESIZE / 2; i >= FRAGSIZEMIN; fs++, i >>= 1)
;	genAssign
	ld	bc,#0x0080
;	genAssign
;	AOP_STK for _mem_frag_alloc_fs_1_1
	ld	-1(ix),#0x00
;	genLabel
00103$:
;	genCmpLt
	ld	a,c
	sub	a,#0x20
	ld	a,b
	sbc	a,#0x00
	jp	c,00106$
;mem.c:386: if (i < size)
;	genCmpLt
;	AOP_STK for 
	ld	a,c
	sub	a,4(ix)
	ld	a,b
	sbc	a,5(ix)
	jp	c,00106$
;mem.c:385: for (fs = 0, i = PAGESIZE / 2; i >= FRAGSIZEMIN; fs++, i >>= 1)
;	genPlus
;	AOP_STK for _mem_frag_alloc_fs_1_1
;	genPlusIncr
	inc	-1(ix)
;	genRightShift
	srl	b
	rr	c
;	genGoto
	jp	00103$
;	genLabel
00106$:
;mem.c:392: s = FRAG_STACK(proc, fs);
;	genAssign
;	AOP_STK for 
	ld	c,6(ix)
	ld	b,7(ix)
;	genPlus
;	AOP_STK for _mem_frag_alloc_sloc0_1_0
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,c
	add	a,#0x18
	ld	-9(ix),a
	ld	a,b
	adc	a,#0x00
	ld	-8(ix),a
;	genMinus
;	AOP_STK for _mem_frag_alloc_fs_1_1
	ld	a,-1(ix)
	add	a,#0xFF
;	genLeftShift
	ld	e,a
	add	a,a
	ld	e,a
;	genPlus
;	AOP_STK for _mem_frag_alloc_sloc0_1_0
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,-9(ix)
	add	a,e
	ld	e,a
	ld	a,-8(ix)
	adc	a,#0x00
	ld	d,a
;	genPointerGet
	ld	l,e
	ld	h,d
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
;	genAssign
;	AOP_STK for _mem_frag_alloc_s_1_1
	ld	-3(ix),e
	ld	-2(ix),d
;mem.c:395: if (FRAG_AVAILABLE(s) == 0) {
;	genPointerGet
;	AOP_STK for _mem_frag_alloc_s_1_1
	ld	l,-3(ix)
	ld	h,-2(ix)
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
;	genIfx
	ld	a,e
	or	a,d
	jp	nz,00110$
;mem.c:396: err = mem_frag_add_page (s, fs, proc);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	push	bc
;	genIpush
;	AOP_STK for _mem_frag_alloc_fs_1_1
	ld	a,-1(ix)
	push	af
	inc	sp
;	genIpush
;	AOP_STK for _mem_frag_alloc_s_1_1
	ld	l,-3(ix)
	ld	h,-2(ix)
	push	hl
;	genCall
	call	_mem_frag_add_page
	ld	b,h
	ld	c,l
	pop	af
	pop	af
	inc	sp
;	genAssign
;	(registers are the same)
;mem.c:397: if (err != 0) {
;	genCmpEq
; genCmpEq: left 2, right 2, result 0
	ld	a,c
	or	a,b
	jp	z,00110$
00124$:
;mem.c:399: return 0; /* Out of memory. */
;	genRet
; Dump of IC_LEFT: type AOP_LIT size 2
	ld	hl,#0x0000
	jp	00111$
;	genLabel
00110$:
;mem.c:404: frag = FRAG_POP(s);
;	genPointerGet
;	AOP_STK for _mem_frag_alloc_s_1_1
	ld	l,-3(ix)
	ld	h,-2(ix)
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
;	genNot
	ld	a,c
	or	a,b
	sub	a,#0x01
	ld	a,#0x00
	rla
;	genIfx
	ld	c,a
	or	a,a
	jp	z,00113$
;	genAssign
	ld	bc,#0x0000
;	genGoto
	jp	00114$
;	genLabel
00113$:
;	genCast
;	AOP_STK for _mem_frag_alloc_s_1_1
	ld	e,-3(ix)
	ld	d,-2(ix)
;	genPlus
;	genPlusIncr
	inc	de
	inc	de
;	genCast
;	AOP_STK for _mem_frag_alloc_sloc0_1_0
	ld	-9(ix),e
	ld	-8(ix),d
;	genPointerGet
;	AOP_STK for _mem_frag_alloc_s_1_1
	ld	l,-3(ix)
	ld	h,-2(ix)
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
;	genMinus
	dec	de
;	genAssign (pointer)
;	AOP_STK for _mem_frag_alloc_s_1_1
;	isBitvar = 0
	ld	l,-3(ix)
	ld	h,-2(ix)
	ld	(hl),e
	inc	hl
	ld	(hl),d
;	genLeftShift
	sla	e
	rl	d
;	genPlus
;	AOP_STK for _mem_frag_alloc_sloc0_1_0
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,-9(ix)
	add	a,e
	ld	c,a
	ld	a,-8(ix)
	adc	a,d
	ld	b,a
;	genLabel
00114$:
;	genAssign
;	(registers are the same)
;	genAssign
;	AOP_STK for _mem_frag_alloc_frag_1_1
	ld	-5(ix),c
	ld	-4(ix),b
;mem.c:407: pagebase = frag->page * PAGESIZE;
;	genPointerGet
;	AOP_STK for _mem_frag_alloc_frag_1_1
	ld	l,-5(ix)
	ld	h,-4(ix)
	ld	e,(hl)
;	genCast
	ld	d,e
	ld	c,#0x00
;	genLeftShift
;	AOP_STK for _mem_frag_alloc_pagebase_1_1
	ld	-6(ix),d
	ld	-7(ix),#0x00
;mem.c:410: idxofs = frag->idx << FRAGSIZELOG(frag->page);
;	genPlus
;	AOP_STK for _mem_frag_alloc_frag_1_1
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,-5(ix)
	add	a,#0x01
	ld	b,a
	ld	a,-4(ix)
	adc	a,#0x00
	ld	c,a
;	genPointerGet
	ld	l,b
	ld	h,c
	ld	b,(hl)
;	genCast
; Removed redundent load
	ld	c,#0x00
;	genPlus
;	Can't optimise plus by inc, falling back to the normal way
	ld	iy,#_page_list
	ld	a,0(iy)
	add	a,e
	ld	e,a
	ld	a,1(iy)
	adc	a,#0x00
	ld	d,a
;	genPointerGet
	ld	a,(de)
;	genAnd
	ld	e,a
	and	a,#0x03
	ld	e,a
;	genCast
; Removed redundent load
	ld	d,#0x00
;	genMinus
	ld	a,#0x08
	sub	a,e
	ld	e,a
	ld	a,#0x00
	sbc	a,d
	ld	d,a
;	genLeftShift
	ld	a,e
	inc	a
	jp	00128$
00127$:
	sla	b
	rl	c
00128$:
	dec	a
	jp	nz,00127$
;	genAssign
;	(registers are the same)
;mem.c:415: return (void*) (pagebase + idxofs + ram);
;	genPlus
;	AOP_STK for _mem_frag_alloc_pagebase_1_1
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,-7(ix)
	add	a,b
	ld	b,a
	ld	a,-6(ix)
	adc	a,c
	ld	c,a
;	genPlus
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,#<_ram
	add	a,b
	ld	l,a
	ld	a,#>_ram
	adc	a,c
	ld	h,a
;	genRet
; Dump of IC_LEFT: type AOP_STR size 2
;	genLabel
00111$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_mem_frag_alloc_end::
;mem.c:420: mem_frag_free (void *pos, struct proc *proc)
;	genLabel
;	genFunction
;	---------------------------------
; Function mem_frag_free
; ---------------------------------
_mem_frag_free_start::
_mem_frag_free:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-11
	add	hl,sp
	ld	sp,hl
;mem.c:429: if (IS_ILLEGAL_FRAG(pos)) {
;	genCast
;	AOP_STK for 
;	AOP_STK for _mem_frag_free_sloc2_1_0
	ld	a,4(ix)
	ld	-11(ix),a
	ld	a,5(ix)
	ld	-10(ix),a
;	genCast
	ld	e,#<_ram
	ld	d,#>_ram
;	genMinus
;	AOP_STK for _mem_frag_free_sloc2_1_0
	ld	a,-11(ix)
	sub	a,e
	ld	e,a
	ld	a,-10(ix)
	sbc	a,d
	ld	d,a
;	genCast
;	genCast
	ld	c,e
	ld	b,d
;	genCast
	ld	e,#<_ram
	ld	d,#>_ram
;	genMinus
;	AOP_STK for _mem_frag_free_sloc2_1_0
	ld	a,-11(ix)
	sub	a,e
	ld	e,a
	ld	a,-10(ix)
	sbc	a,d
	ld	d,a
;	genCast
;	genCast
;	genRightShift
	ld	e,d
	ld	d,#0x00
;	genPlus
;	Can't optimise plus by inc, falling back to the normal way
	ld	iy,#_page_list
	ld	a,0(iy)
	add	a,e
	ld	e,a
	ld	a,1(iy)
	adc	a,d
	ld	d,a
;	genPointerGet
	ld	a,(de)
;	genAnd
	ld	e,a
	and	a,#0x03
;	genRightShift
	ld	e,a
	inc	a
	push	af
	ld	e,#0x00
	ld	d,#0x01
	pop	af
	jp	00113$
00112$:
	sra	d
	rr	e
00113$:
	dec	a
	jp	nz,00112$
;	genMinus
	dec	de
;	genAnd
	ld	a,e
	and	a,c
	ld	e,a
	ld	a,d
	and	a,b
	ld	d,a
;	genIfx
	ld	a,e
	or	a,d
	jp	z,00102$
;mem.c:431: printk ("mem_frag_free: Illegal fragment boundary ", 0);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0x0000
	push	hl
;	genIpush
	ld	hl,#__str_1
	push	hl
;	genCall
	call	_printk
	pop	af
	pop	af
;mem.c:432: printnhex (pos - (void*) ram, 4);
;	genMinus
;	AOP_STK for 
	ld	a,4(ix)
	sub	a,#<_ram
	ld	e,a
	ld	a,5(ix)
	sbc	a,#>_ram
	ld	d,a
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0x0004
	push	hl
;	genIpush
	push	de
;	genCall
	call	_printnhex
	pop	af
	pop	af
;mem.c:433: printk (" \n", 0);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0x0000
	push	hl
;	genIpush
	ld	hl,#__str_2
	push	hl
;	genCall
	call	_printk
	pop	af
	pop	af
;mem.c:435: return;
;	genRet
	jp	00105$
;	genLabel
00102$:
;mem.c:440: p = ADDR2PAGE(pos);
;	genCast
	ld	e,#<_ram
	ld	d,#>_ram
;	genMinus
;	AOP_STK for _mem_frag_free_sloc2_1_0
	ld	a,-11(ix)
	sub	a,e
	ld	e,a
	ld	a,-10(ix)
	sbc	a,d
	ld	d,a
;	genCast
;	genCast
;	genRightShift
	ld	e,d
	ld	d,#0x00
;	genCast
;	AOP_STK for _mem_frag_free_p_1_1
	ld	-1(ix),e
;mem.c:441: fs = FRAGLOG(p);
;	genPlus
;	AOP_STK for _mem_frag_free_p_1_1
;	Can't optimise plus by inc, falling back to the normal way
	ld	iy,#_page_list
	ld	a,0(iy)
	add	a,-1(ix)
	ld	d,a
	ld	a,1(iy)
	adc	a,#0x00
	ld	e,a
;	genPointerGet
	ld	l,d
	ld	h,e
	ld	d,(hl)
;	genAnd
	ld	a,d
	and	a,#0x03
	ld	d,a
;	genAssign
;mem.c:443: bzero (pos, FRAGSIZE(p));
;	genRightShift
	ld	c,d
	ld	a,c
	inc	a
	push	af
	ld	d,#0x00
	ld	e,#0x01
	pop	af
	jp	00115$
00114$:
	sra	e
	rr	d
00115$:
	dec	a
	jp	nz,00114$
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	ld	l,d
	ld	h,e
	push	hl
;	genIpush
;	AOP_STK for 
	ld	l,4(ix)
	ld	h,5(ix)
	push	hl
;	genCall
	call	_bzero
	pop	af
	pop	af
	pop	bc
;mem.c:446: s = FRAG_STACK(proc, fs);
;	genAssign
;	AOP_STK for 
	ld	e,6(ix)
	ld	d,7(ix)
;	genPlus
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,e
	add	a,#0x18
	ld	b,a
	ld	a,d
	adc	a,#0x00
	ld	d,a
;	genMinus
	ld	a,c
	add	a,#0xFF
;	genLeftShift
	ld	e,a
	add	a,a
	ld	e,a
;	genPlus
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,b
	add	a,e
	ld	e,a
	ld	a,d
	adc	a,#0x00
	ld	d,a
;	genPointerGet
	ld	l,e
	ld	h,d
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
;	genAssign
;	AOP_STK for _mem_frag_free_s_1_1
	ld	-5(ix),e
	ld	-4(ix),d
;mem.c:450: mem_frag_clean_stack (s, FRAGLOG2NUM(FRAGLOG(p)));
;	genPlus
;	AOP_STK for _mem_frag_free_p_1_1
;	Can't optimise plus by inc, falling back to the normal way
	ld	iy,#_page_list
	ld	a,0(iy)
	add	a,-1(ix)
	ld	e,a
	ld	a,1(iy)
	adc	a,#0x00
	ld	d,a
;	genPointerGet
	ld	a,(de)
;	genAnd
	ld	e,a
	and	a,#0x03
;	genLeftShift
	ld	e,a
	inc	a
	push	af
	ld	e,#0x01
	ld	d,#0x00
	pop	af
	jp	00117$
00116$:
	sla	e
	rl	d
00117$:
	dec	a
	jp	nz,00116$
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	push	de
;	genIpush
;	AOP_STK for _mem_frag_free_s_1_1
	ld	l,-5(ix)
	ld	h,-4(ix)
	push	hl
;	genCall
	call	_mem_frag_clean_stack
	pop	af
	pop	af
;mem.c:453: frag = FRAG_PUSH(s);
;	genPointerGet
;	AOP_STK for _mem_frag_free_s_1_1
	ld	l,-5(ix)
	ld	h,-4(ix)
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
;	genLeftShift
	sla	e
	rl	d
;	genPlus
;	AOP_STK for _mem_frag_free_sloc0_1_0
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,e
	add	a,#0x04
	ld	-7(ix),a
	ld	a,d
	adc	a,#0x00
	ld	-6(ix),a
;	genCast
;	AOP_STK for _mem_frag_free_s_1_1
	ld	c,-5(ix)
	ld	b,-4(ix)
;	genCast
	ld	e,#<_ram
	ld	d,#>_ram
;	genMinus
	ld	a,c
	sub	a,e
	ld	e,a
	ld	a,b
	sbc	a,d
	ld	d,a
;	genCast
;	genCast
;	genRightShift
	ld	e,d
	ld	d,#0x00
;	genPlus
;	Can't optimise plus by inc, falling back to the normal way
	ld	iy,#_page_list
	ld	a,0(iy)
	add	a,e
	ld	e,a
	ld	a,1(iy)
	adc	a,d
	ld	d,a
;	genPointerGet
	ld	a,(de)
;	genAnd
	ld	e,a
	and	a,#0x03
;	genRightShift
	ld	e,a
	inc	a
	push	af
	ld	e,#0x00
	ld	d,#0x01
	pop	af
	jp	00121$
00120$:
	srl	d
	rr	e
00121$:
	dec	a
	jp	nz,00120$
;	genCmpGt
;	AOP_STK for _mem_frag_free_sloc0_1_0
	ld	a,e
	sub	a,-7(ix)
	ld	a,d
	sbc	a,-6(ix)
	jp	nc,00107$
;	genAssign
	ld	de,#0x0000
;	genGoto
	jp	00108$
;	genLabel
00107$:
;	genPlus
;	genPlusIncr
	inc	bc
	inc	bc
;	genCast
;	AOP_STK for _mem_frag_free_sloc1_1_0
	ld	-9(ix),c
	ld	-8(ix),b
;	genPointerGet
;	AOP_STK for _mem_frag_free_s_1_1
	ld	l,-5(ix)
	ld	h,-4(ix)
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
;	genPlus
;	genPlusIncr
	ld	c,e
	ld	b,d
	inc	bc
;	genAssign (pointer)
;	AOP_STK for _mem_frag_free_s_1_1
;	isBitvar = 0
	ld	l,-5(ix)
	ld	h,-4(ix)
	ld	(hl),c
	inc	hl
	ld	(hl),b
;	genLeftShift
	ld	c,e
	ld	b,d
	sla	c
	rl	b
;	genPlus
;	AOP_STK for _mem_frag_free_sloc1_1_0
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,-9(ix)
	add	a,c
	ld	e,a
	ld	a,-8(ix)
	adc	a,b
	ld	d,a
;	genLabel
00108$:
;	genAssign
	ld	c,e
	ld	b,d
;	genAssign
;	AOP_STK for _mem_frag_free_frag_1_1
	ld	-3(ix),c
	ld	-2(ix),b
;mem.c:454: if (frag == NULL) {
;	genCmpEq
;	AOP_STK for _mem_frag_free_frag_1_1
; genCmpEq: left 2, right 2, result 0
	ld	a,-3(ix)
	or	a,-2(ix)
	jp	z,00125$
00124$:
	jp	00104$
00125$:
;mem.c:456: VERBOSE_PRINTK("mem_frag_free: stack %d full.\n", FRAGLOG(p));
;	genPlus
;	AOP_STK for _mem_frag_free_p_1_1
;	Can't optimise plus by inc, falling back to the normal way
	ld	iy,#_page_list
	ld	a,0(iy)
	add	a,-1(ix)
	ld	e,a
	ld	a,1(iy)
	adc	a,#0x00
	ld	d,a
;	genPointerGet
	ld	a,(de)
;	genAnd
	ld	e,a
	and	a,#0x03
	ld	e,a
;	genCast
; Removed redundent load
	ld	d,#0x00
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	push	de
;	genIpush
	ld	hl,#__str_3
	push	hl
;	genCall
	call	_printk
	pop	af
	pop	af
;mem.c:457: return;
;	genRet
	jp	00105$
;	genLabel
00104$:
;mem.c:459: frag->idx = ADDR2FRAGIDX(pos); /* Index within page. */
;	genPlus
;	AOP_STK for _mem_frag_free_frag_1_1
;	genPlusIncr
	ld	e,-3(ix)
	ld	d,-2(ix)
	inc	de
;	genCast
	ld	c,#<_ram
	ld	b,#>_ram
;	genMinus
;	AOP_STK for _mem_frag_free_sloc2_1_0
	ld	a,-11(ix)
	sub	a,c
	ld	c,a
	ld	a,-10(ix)
	sbc	a,b
	ld	b,a
;	genCast
;	genCast
;	genAnd
	ld	b,#0x00
;	genCast
;	AOP_STK for _mem_frag_free_sloc1_1_0
	ld	-9(ix),c
;	genCast
	ld	b,#<_ram
	ld	c,#>_ram
;	genMinus
;	AOP_STK for _mem_frag_free_sloc2_1_0
	ld	a,-11(ix)
	sub	a,b
	ld	b,a
	ld	a,-10(ix)
	sbc	a,c
	ld	c,a
;	genCast
;	genCast
;	genRightShift
	ld	b,c
	ld	c,#0x00
;	genPlus
;	Can't optimise plus by inc, falling back to the normal way
	ld	iy,#_page_list
	ld	a,0(iy)
	add	a,b
	ld	b,a
	ld	a,1(iy)
	adc	a,c
	ld	c,a
;	genPointerGet
	ld	l,b
	ld	h,c
	ld	b,(hl)
;	genAnd
	ld	a,b
	and	a,#0x03
;	genRightShift
	ld	b,a
	inc	a
;	AOP_STK for _mem_frag_free_sloc2_1_0
	push	af
	ld	-11(ix),#0x00
	ld	-10(ix),#0x01
	pop	af
	jp	00127$
00126$:
	sra	-10(ix)
	rr	-11(ix)
00127$:
	dec	a
	jp	nz,00126$
;	genCast
;	AOP_STK for _mem_frag_free_sloc1_1_0
	ld	c,-9(ix)
	ld	b,#0x00
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 1 bcInUse: 0 deSending: 0
	push	de
;	AOP_STK for _mem_frag_free_sloc2_1_0
	ld	l,-11(ix)
	ld	h,-10(ix)
	push	hl
;	genIpush
	push	bc
;	genCall
	call	__divsint_rrx_s
	ld	b,h
	ld	c,l
	pop	af
	pop	af
	pop	de
;	genCast
	ld	a,c
;	genAssign (pointer)
;	isBitvar = 0
	ld	(de),a
;mem.c:460: frag->page = p;
;	genAssign (pointer)
;	AOP_STK for _mem_frag_free_frag_1_1
;	AOP_STK for _mem_frag_free_p_1_1
;	isBitvar = 0
	ld	l,-3(ix)
	ld	h,-2(ix)
	ld	a,-1(ix)
	ld	(hl),a
;	genLabel
00105$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_mem_frag_free_end::
__str_1:
	.ascii "mem_frag_free: Illegal fragment boundary "
	.db 0x00
__str_2:
	.ascii " "
	.db 0x0A
	.db 0x00
__str_3:
	.ascii "mem_frag_free: stack %d full."
	.db 0x0A
	.db 0x00
;mem.c:486: mem_init ()
;	genLabel
;	genFunction
;	---------------------------------
; Function mem_init
; ---------------------------------
_mem_init_start::
_mem_init:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-8
	add	hl,sp
	ld	sp,hl
;mem.c:497: for (j = 65535; j >= 0; j--)
;	genAssign
;	AOP_STK for _mem_init_j_1_1
	ld	-4(ix),#0xFF
	ld	-3(ix),#0xFF
;	genLabel
00101$:
;	genCmpLt
;	AOP_STK for _mem_init_j_1_1
	ld	a,-3(ix)
	bit	7,a
	jp	nz,00104$
;mem.c:498: ram[j] = j & 255;
;	genPlus
;	AOP_STK for _mem_init_j_1_1
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,#<_ram
	add	a,-4(ix)
	ld	e,a
	ld	a,#>_ram
	adc	a,-3(ix)
	ld	d,a
;	genAnd
;	AOP_STK for _mem_init_j_1_1
	ld	c,-4(ix)
	ld	b,#0x00
;	genCast
	ld	a,c
;	genAssign (pointer)
;	isBitvar = 0
	ld	(de),a
;mem.c:497: for (j = 65535; j >= 0; j--)
;	genMinus
;	AOP_STK for _mem_init_j_1_1
	ld	l,-4(ix)
	ld	h,-3(ix)
	dec	hl
	ld	-4(ix),l
	ld	-3(ix),h
;	genGoto
	jp	00101$
;	genLabel
00104$:
;mem.c:502: mem_num_pages_free = NUM_PAGES;
;	genAssign
	ld	iy,#_mem_num_pages_free
	ld	0(iy),#0x00
	ld	1(iy),#0x01
;mem.c:503: mem_num_pages_locked = 0;
;	genAssign
	ld	iy,#_mem_num_pages_locked
	ld	0(iy),#0x00
	ld	1(iy),#0x00
;mem.c:512: page_map = PAGE2ADDR(p);
;	genCast
	ld	c,#<_ram
	ld	b,#>_ram
;	genPlus
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,c
	add	a,#0x00
	ld	c,a
	ld	a,b
	adc	a,#0x03
	ld	b,a
;	genCast
	ld	iy,#_page_map
	ld	0(iy),c
	ld	1(iy),b
;mem.c:517: page_list = PAGE2ADDR(p);
;	genCast
	ld	c,#<_ram
	ld	b,#>_ram
;	genPlus
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,c
	add	a,#0x00
	ld	c,a
	ld	a,b
	adc	a,#0x04
	ld	b,a
;	genCast
	ld	iy,#_page_list
	ld	0(iy),c
	ld	1(iy),b
;mem.c:519: p += tmp ? tmp : 1;
;	genAssign
	ld	c,#0x05
;mem.c:522: bzero (page_map, NUM_PAGES >> 3);
;	genAssign
	ld	de,(_page_map)
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	ld	hl,#0x0020
	push	hl
;	genIpush
	push	de
;	genCall
	call	_bzero
	pop	af
	pop	af
	pop	bc
;mem.c:523: bzero (page_list, sizeof (pageinfo_t) * NUM_PAGES);
;	genAssign
	ld	de,(_page_list)
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	ld	hl,#0x0100
	push	hl
;	genIpush
	push	de
;	genCall
	call	_bzero
	pop	af
	pop	af
	pop	bc
;mem.c:526: mem_pages_lock (MMANAGER_STARTPAGE, p - MMANAGER_STARTPAGE);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	ld	hl,#0x0002
	push	hl
;	genIpush
	ld	a,#0x03
	push	af
	inc	sp
;	genCall
	call	_mem_pages_lock
	pop	af
	inc	sp
	pop	bc
;mem.c:529: mem_pages_lock (0, 1);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	ld	hl,#0x0001
	push	hl
;	genIpush
	ld	a,#0x00
	push	af
	inc	sp
;	genCall
	call	_mem_pages_lock
	pop	af
	inc	sp
	pop	bc
;mem.c:532: mem_pages_lock (KERNEL_STARTPAGE, KERNEL_PAGES);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	ld	hl,#0x0003
	push	hl
;	genIpush
	ld	a,#0x00
	push	af
	inc	sp
;	genCall
	call	_mem_pages_lock
	pop	af
	inc	sp
	pop	bc
;mem.c:535: MEM_PAGES_REF(KERNEL_STACKPAGE, KERNEL_STACKPAGES, 0);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	ld	hl,#0x0000
	push	hl
;	genIpush
	ld	hl,#0x0010
	push	hl
;	genIpush
	ld	a,#0xF0
	push	af
	inc	sp
;	genCall
	call	_mem_pages_ref
	pop	af
	pop	af
	inc	sp
	pop	bc
;mem.c:539: for (i = 0; i < FRAGMENT_SIZES; i++) {
;	genAssign
;	(registers are the same)
;	genAssign
;	AOP_STK for _mem_init_i_1_1
	ld	-2(ix),#0x00
	ld	-1(ix),#0x00
;	genLabel
00105$:
;	genCmpLt
;	AOP_STK for _mem_init_i_1_1
	ld	a,-2(ix)
	sub	a,#0x03
	ld	a,-1(ix)
	sbc	a,#0x00
	jp	nc,00108$
;mem.c:541: MEM_PAGES_REF(p, 1, 0);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	ld	hl,#0x0000
	push	hl
;	genIpush
	ld	hl,#0x0001
	push	hl
;	genIpush
	ld	a,c
	push	af
	inc	sp
;	genCall
	call	_mem_pages_ref
	pop	af
	pop	af
	inc	sp
	pop	bc
;mem.c:544: proc_current->fragment_stacks[i] = STACK_PTR(PAGE2ADDR(p));
;	genAssign
	ld	hl,(_proc_current)
	ld	b,l
	ld	e,h
;	genPlus
;	AOP_STK for _mem_init_sloc0_1_0
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,b
	add	a,#0x18
	ld	-6(ix),a
	ld	a,e
	adc	a,#0x00
	ld	-5(ix),a
;	genLeftShift
;	AOP_STK for _mem_init_i_1_1
	ld	d,-2(ix)
	ld	b,-1(ix)
	sla	d
	rl	b
;	genPlus
;	AOP_STK for _mem_init_sloc0_1_0
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,-6(ix)
	add	a,d
	ld	-6(ix),a
	ld	a,-5(ix)
	adc	a,b
	ld	-5(ix),a
;	genCast
	ld	e,c
	ld	b,#0x00
;	genLeftShift
;	AOP_STK for _mem_init_sloc1_1_0
	ld	-7(ix),e
	ld	-8(ix),#0x00
;	genCast
	ld	d,#<_ram
	ld	b,#>_ram
;	genPlus
;	AOP_STK for _mem_init_sloc1_1_0
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,-8(ix)
	add	a,d
	ld	d,a
	ld	a,-7(ix)
	adc	a,b
	ld	b,a
;	genCast
;	genAssign (pointer)
;	AOP_STK for _mem_init_sloc0_1_0
;	isBitvar = 0
	ld	l,-6(ix)
	ld	h,-5(ix)
	ld	(hl),d
	inc	hl
	ld	(hl),b
;mem.c:546: p++; /* Next page. */
;	genPlus
;	genPlusIncr
; Removed redundent load
	inc	c
;mem.c:539: for (i = 0; i < FRAGMENT_SIZES; i++) {
;	genPlus
;	AOP_STK for _mem_init_i_1_1
;	genPlusIncr
	inc	-2(ix)
	jp	nz,00125$
	inc	-1(ix)
00125$:
;	genGoto
	jp	00105$
;	genLabel
00108$:
;mem.c:551: printk ("mem: %d bytes", (int) (PAGESIZE * NUM_PAGES));
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0x0000
	push	hl
;	genIpush
	ld	hl,#__str_4
	push	hl
;	genCall
	call	_printk
	pop	af
	pop	af
;mem.c:552: printk (", %d free", (int) (PAGESIZE * (mem_num_pages_free + KERNEL_STACKPAGES)));
;	genPlus
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	iy,#_mem_num_pages_free
	ld	a,0(iy)
	add	a,#0x10
	ld	c,a
	ld	a,1(iy)
	adc	a,#0x00
	ld	b,a
;	genLeftShift
	ld	b,c
	ld	c,#0x00
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	push	bc
;	genIpush
	ld	hl,#__str_5
	push	hl
;	genCall
	call	_printk
	pop	af
	pop	af
;mem.c:553: printk (", %d system.\n", (int) (PAGESIZE * (NUM_PAGES - mem_num_pages_free - KERNEL_STACKPAGES)));
;	genCast
	ld	iy,#_mem_num_pages_free
	ld	c,0(iy)
	ld	b,1(iy)
	ld	de,#0x0000
;	genMinus
	ld	a,#0xF0
	sub	a,c
	ld	c,a
	ld	a,#0x00
	sbc	a,b
	ld	b,a
	ld	a,#0x00
	sbc	a,e
	ld	e,a
	ld	a,#0x00
	sbc	a,d
	ld	d,a
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	a,#0x08
	push	af
	inc	sp
;	genIpush
	push	de
	push	bc
;	genCall
	call	__rlslong_rrx_s
; Removed redundent load
; Removed redundent load
	ld	b,h
	ld	c,l
	pop	af
	pop	af
	inc	sp
;	genCast
; Removed redundent load
; Removed redundent load
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	push	bc
;	genIpush
	ld	hl,#__str_6
	push	hl
;	genCall
	call	_printk
	pop	af
	pop	af
;	genLabel
00109$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_mem_init_end::
__str_4:
	.ascii "mem: %d bytes"
	.db 0x00
__str_5:
	.ascii ", %d free"
	.db 0x00
__str_6:
	.ascii ", %d system."
	.db 0x0A
	.db 0x00
;mem.c:563: mem_init_proc (struct proc *proc)
;	genLabel
;	genFunction
;	---------------------------------
; Function mem_init_proc
; ---------------------------------
_mem_init_proc_start::
_mem_init_proc:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-4
	add	hl,sp
	ld	sp,hl
;mem.c:569: for (p = 0; p < FRAGMENT_SIZES; p++) {
;	genAssign
;	AOP_STK for _mem_init_proc_p_1_1
	ld	-2(ix),#0x00
	ld	-1(ix),#0x00
;	genLabel
00101$:
;	genCmpLt
;	AOP_STK for _mem_init_proc_p_1_1
	ld	a,-2(ix)
	sub	a,#0x03
	ld	a,-1(ix)
	sbc	a,#0x00
	jp	nc,00105$
;mem.c:570: proc->fragment_stacks[p] = pmalloc (PAGESIZE, proc);
;	genAssign
;	AOP_STK for 
	ld	e,4(ix)
	ld	d,5(ix)
;	genPlus
;	AOP_STK for _mem_init_proc_sloc0_1_0
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,e
	add	a,#0x18
	ld	-4(ix),a
	ld	a,d
	adc	a,#0x00
	ld	-3(ix),a
;	genLeftShift
;	AOP_STK for _mem_init_proc_p_1_1
	ld	c,-2(ix)
	ld	b,-1(ix)
	sla	c
	rl	b
;	genPlus
;	AOP_STK for _mem_init_proc_sloc0_1_0
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,-4(ix)
	add	a,c
	ld	c,a
	ld	a,-3(ix)
	adc	a,b
	ld	b,a
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	push	de
;	genIpush
	ld	hl,#0x0100
	push	hl
;	genCall
	call	_pmalloc
	ld	d,h
	ld	e,l
	pop	af
	pop	af
	pop	bc
;	genAssign (pointer)
;	isBitvar = 0
	ld	l,c
	ld	h,b
	ld	(hl),e
	inc	hl
	ld	(hl),d
;mem.c:569: for (p = 0; p < FRAGMENT_SIZES; p++) {
;	genPlus
;	AOP_STK for _mem_init_proc_p_1_1
;	genPlusIncr
	inc	-2(ix)
	jp	nz,00112$
	inc	-1(ix)
00112$:
;	genGoto
	jp	00101$
;	genLabel
00105$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_mem_init_proc_end::
;mem.c:580: mem_kill_proc (struct proc *proc)
;	genLabel
;	genFunction
;	---------------------------------
; Function mem_kill_proc
; ---------------------------------
_mem_kill_proc_start::
_mem_kill_proc:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-9
	add	hl,sp
	ld	sp,hl
;mem.c:586: for (p = 0; p < NUM_PAGES; p++) {
;	genAssign
;	AOP_STK for 
	ld	c,4(ix)
	ld	b,5(ix)
;	genPlus
;	AOP_STK for _mem_kill_proc_sloc0_1_0
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,c
	add	a,#0x25
	ld	-4(ix),a
	ld	a,b
	adc	a,#0x00
	ld	-3(ix),a
;	genAssign
;	AOP_STK for _mem_kill_proc_p_1_1
	ld	-2(ix),#0x00
	ld	-1(ix),#0x00
;	genLabel
00107$:
;	genCast
;	AOP_STK for _mem_kill_proc_p_1_1
	ld	e,-2(ix)
	ld	d,-1(ix)
	ld	bc,#0x0000
;	genCmpLt
	ld	a,e
	sub	a,#0x00
	ld	a,d
	sbc	a,#0x01
	ld	a,c
	sbc	a,#0x00
	ld	a,b
	sbc	a,#0x00
	jp	p,00111$
;mem.c:588: if (PAGE_LOCKED(p) != FALSE)
;	genPlus
;	AOP_STK for _mem_kill_proc_p_1_1
;	Can't optimise plus by inc, falling back to the normal way
	ld	iy,#_page_list
	ld	a,0(iy)
	add	a,-2(ix)
	ld	c,a
	ld	a,1(iy)
	adc	a,-1(ix)
	ld	b,a
;	genPointerGet
	ld	a,(bc)
;	genAnd
	ld	c,a
	and	a,#0x04
	jp	z,00113$
00123$:
;	genAnd
	ld	a,c
	and	a,#0x03
	jp	z,00125$
00124$:
	jp	00114$
00125$:
;	genLabel
00113$:
;	genAssign
	ld	c,#0x00
;	genGoto
	jp	00115$
;	genLabel
00114$:
;	genAssign
	ld	c,#0x01
;	genLabel
00115$:
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	a,c
	or	a,a
	jp	z,00127$
00126$:
	jp	00109$
00127$:
;mem.c:592: if (PAGE_USED(p) == FALSE)
;	genRightShift
;	AOP_STK for _mem_kill_proc_p_1_1
	ld	c,-2(ix)
	ld	b,-1(ix)
	srl	b
	rr	c
	srl	b
	rr	c
	srl	b
	rr	c
;	genPlus
;	Can't optimise plus by inc, falling back to the normal way
	ld	iy,#_page_map
	ld	a,0(iy)
	add	a,c
	ld	c,a
	ld	a,1(iy)
	adc	a,b
	ld	b,a
;	genPointerGet
;	AOP_STK for _mem_kill_proc_sloc1_1_0
	ld	a,(bc)
	ld	-5(ix),a
;	genAnd
;	AOP_STK for _mem_kill_proc_p_1_1
	ld	a,-2(ix)
	and	a,#0x07
	ld	d,a
	ld	e,#0x00
;	genLeftShift
	ld	a,d
	inc	a
;	AOP_STK for _mem_kill_proc_sloc2_1_0
	push	af
	ld	-7(ix),#0x01
	ld	-6(ix),#0x00
	pop	af
	jp	00131$
00130$:
	sla	-7(ix)
	rl	-6(ix)
00131$:
	dec	a
	jp	nz,00130$
;	genCast
;	AOP_STK for _mem_kill_proc_sloc1_1_0
	ld	e,-5(ix)
	ld	d,#0x00
;	genAnd
;	AOP_STK for _mem_kill_proc_sloc2_1_0
	ld	a,e
	and	a,-7(ix)
	ld	e,a
	ld	a,d
	and	a,-6(ix)
	ld	d,a
;	genIfx
	ld	a,e
	or	a,d
	jp	z,00109$
;mem.c:596: if (PAGE_PROC(p) != proc->id)
;	genPlus
;	AOP_STK for _mem_kill_proc_p_1_1
;	AOP_STK for _mem_kill_proc_sloc3_1_0
;	Can't optimise plus by inc, falling back to the normal way
	ld	iy,#_page_list
	ld	a,0(iy)
	add	a,-2(ix)
	ld	-9(ix),a
	ld	a,1(iy)
	adc	a,-1(ix)
	ld	-8(ix),a
;	genPointerGet
;	AOP_STK for _mem_kill_proc_sloc3_1_0
	ld	l,-9(ix)
	ld	h,-8(ix)
	ld	e,(hl)
;	genRightShift
; Removed redundent load
	srl	e
	srl	e
	srl	e
;	genPointerGet
;	AOP_STK for _mem_kill_proc_sloc0_1_0
	ld	l,-4(ix)
	ld	h,-3(ix)
	ld	d,(hl)
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	a,e
	cp	d
	jp	z,00133$
00132$:
	jp	00109$
00133$:
;mem.c:600: PAGE_FREE(p);
;	genCast
;	AOP_STK for _mem_kill_proc_sloc2_1_0
	ld	e,-7(ix)
;	genXor
	ld	a,e
	xor	a,#0xFF
	ld	e,a
;	genAnd
;	AOP_STK for _mem_kill_proc_sloc1_1_0
	ld	a,-5(ix)
	and	a,e
;	genAssign (pointer)
;	isBitvar = 0
	ld	(bc),a
;	genAssign (pointer)
;	AOP_STK for _mem_kill_proc_sloc3_1_0
;	isBitvar = 0
	ld	l,-9(ix)
	ld	h,-8(ix)
	ld	(hl),#0x00
;	genPlus
;	genPlusIncr
	ld	iy,#_mem_num_pages_free
	inc	0(iy)
	jp	nz,00134$
	inc	1(iy)
00134$:
;	genLabel
00109$:
;mem.c:586: for (p = 0; p < NUM_PAGES; p++) {
;	genPlus
;	AOP_STK for _mem_kill_proc_p_1_1
;	genPlusIncr
	inc	-2(ix)
	jp	nz,00135$
	inc	-1(ix)
00135$:
;	genGoto
	jp	00107$
;	genLabel
00111$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_mem_kill_proc_end::
;mem.c:608: pmalloc2 (size_t size, struct proc *proc)
;	genLabel
;	genFunction
;	---------------------------------
; Function pmalloc2
; ---------------------------------
_pmalloc2_start::
_pmalloc2:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-2
	add	hl,sp
	ld	sp,hl
;mem.c:614: if (size == 0)
;	genIfx
;	AOP_STK for 
	ld	a,4(ix)
	or	a,5(ix)
	jp	nz,00102$
;mem.c:615: return NULL;
;	genRet
; Dump of IC_LEFT: type AOP_LIT size 2
	ld	hl,#0x0000
	jp	00111$
;	genLabel
00102$:
;mem.c:620: if (size <= (PAGESIZE / 2)) {
;	genCmpGt
;	AOP_STK for 
	ld	a,#0x80
	sub	a,4(ix)
	ld	a,#0x00
	sbc	a,5(ix)
	jp	c,00104$
;mem.c:621: ret = mem_frag_alloc (size, proc);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
;	AOP_STK for 
	ld	l,6(ix)
	ld	h,7(ix)
	push	hl
;	genIpush
;	AOP_STK for 
	ld	l,4(ix)
	ld	h,5(ix)
	push	hl
;	genCall
	call	_mem_frag_alloc
	ld	b,h
	ld	c,l
	pop	af
	pop	af
;	genAssign
;	AOP_STK for _pmalloc2_ret_1_1
	ld	-2(ix),c
	ld	-1(ix),b
;mem.c:623: return ret;
;	genRet
;	AOP_STK for _pmalloc2_ret_1_1
; Dump of IC_LEFT: type AOP_STK size 2
;	 aop_stk -2
	ld	l,-2(ix)
	ld	h,-1(ix)
	jp	00111$
;	genLabel
00104$:
;mem.c:628: p = mem_pages_alloc (ROUNDBLEN(size, PAGESIZE), 0, proc->id);
;	genAssign
;	AOP_STK for 
	ld	e,6(ix)
	ld	d,7(ix)
;	genPlus
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,e
	add	a,#0x25
	ld	e,a
	ld	a,d
	adc	a,#0x00
	ld	d,a
;	genPointerGet
	ld	a,(de)
	ld	c,a
;	genRightShift
;	AOP_STK for 
	ld	d,5(ix)
	ld	e,#0x00
;	genCast
	ld	e,d
;	genAnd
;	AOP_STK for 
	ld	a,4(ix)
	or	a,a
	jp	z,00113$
00121$:
;	genAssign
	ld	d,#0x01
;	genGoto
	jp	00114$
;	genLabel
00113$:
;	genAssign
	ld	d,#0x00
;	genLabel
00114$:
;	genPlus
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,e
	add	a,d
	ld	e,a
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	a,c
	push	af
	inc	sp
;	genIpush
	ld	a,#0x00
	push	af
	inc	sp
;	genIpush
	ld	a,e
	push	af
	inc	sp
;	genCall
	call	_mem_pages_alloc
	ld	e,l
	pop	af
	inc	sp
;	genAssign
;	(registers are the same)
;mem.c:629: if (p == 0) {
;	genIfx
	xor	a,a
	or	a,e
	jp	nz,00106$
;mem.c:631: return NULL;
;	genRet
; Dump of IC_LEFT: type AOP_LIT size 2
	ld	hl,#0x0000
	jp	00111$
;	genLabel
00106$:
;mem.c:636: ret = PAGE2ADDR(p);
;	genCast
; Removed redundent load
	ld	d,#0x00
;	genLeftShift
	ld	b,e
	ld	c,#0x00
;	genCast
	ld	e,#<_ram
	ld	d,#>_ram
;	genPlus
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,c
	add	a,e
	ld	e,a
	ld	a,b
	adc	a,d
	ld	d,a
;	genCast
;	AOP_STK for _pmalloc2_ret_1_1
	ld	-2(ix),e
	ld	-1(ix),d
;mem.c:637: RAMASSERT(ret);
;	genIfx
;	AOP_STK for _pmalloc2_ret_1_1
	ld	a,-2(ix)
	or	a,-1(ix)
	jp	z,00108$
;	genAssign
;	AOP_STK for _pmalloc2_ret_1_1
	ld	e,-2(ix)
	ld	d,-1(ix)
;	genCmpLt
	ld	a,e
	sub	a,#<_ram
	ld	a,d
	sbc	a,#>_ram
	jp	c,00107$
;	genAssign
;	AOP_STK for _pmalloc2_ret_1_1
	ld	e,-2(ix)
	ld	d,-1(ix)
;	genPlus
;	genPlusIncr
	ld	bc,#_ram + 65535
;	genCmpGt
	ld	a,c
	sub	a,e
	ld	a,b
	sbc	a,d
	jp	nc,00108$
;	genLabel
00107$:
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#__str_7
	push	hl
;	genCall
	call	_panic
	pop	af
;	genLabel
00108$:
;mem.c:638: return ret;
;	genRet
;	AOP_STK for _pmalloc2_ret_1_1
; Dump of IC_LEFT: type AOP_STK size 2
;	 aop_stk -2
	ld	l,-2(ix)
	ld	h,-1(ix)
;	genLabel
00111$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_pmalloc2_end::
__str_7:
	.ascii "Pointer outside memory."
	.db 0x0A
	.db 0x00
;mem.c:642: pmalloc (size_t size, struct proc *proc)
;	genLabel
;	genFunction
;	---------------------------------
; Function pmalloc
; ---------------------------------
_pmalloc_start::
_pmalloc:
	push	ix
	ld	ix,#0
	add	ix,sp
;mem.c:644: void *p = pmalloc2 (size, proc);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
;	AOP_STK for 
	ld	l,6(ix)
	ld	h,7(ix)
	push	hl
;	genIpush
;	AOP_STK for 
	ld	l,4(ix)
	ld	h,5(ix)
	push	hl
;	genCall
	call	_pmalloc2
	ld	b,h
	ld	c,l
	pop	af
	pop	af
;	genAssign
;	(registers are the same)
;mem.c:646: if (p == NULL) {
;	genCmpEq
; genCmpEq: left 2, right 2, result 0
	ld	a,c
	or	a,b
	jp	z,00107$
00106$:
	jp	00102$
00107$:
;mem.c:647: bcleanup_glob ();
;	genCall
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	call	_bcleanup_glob
;mem.c:648: p = pmalloc2 (size, proc);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
;	AOP_STK for 
	ld	l,6(ix)
	ld	h,7(ix)
	push	hl
;	genIpush
;	AOP_STK for 
	ld	l,4(ix)
	ld	h,5(ix)
	push	hl
;	genCall
	call	_pmalloc2
	ld	d,h
	ld	e,l
	pop	af
	pop	af
;	genAssign
	ld	c,e
	ld	b,d
;	genLabel
00102$:
;mem.c:651: return p;
;	genRet
; Dump of IC_LEFT: type AOP_REG size 2
;	 reg = bc
	ld	l,c
	ld	h,b
;	genLabel
00103$:
;	genEndFunction
	pop	ix
	ret
_pmalloc_end::
;mem.c:656: kmalloc (size_t size)
;	genLabel
;	genFunction
;	---------------------------------
; Function kmalloc
; ---------------------------------
_kmalloc_start::
_kmalloc:
	push	ix
	ld	ix,#0
	add	ix,sp
;mem.c:658: return pmalloc (size, &proc_holographic);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#_proc_holographic
	push	hl
;	genIpush
;	AOP_STK for 
	ld	l,4(ix)
	ld	h,5(ix)
	push	hl
;	genCall
	call	_pmalloc
	pop	af
	pop	af
;	genRet
; Dump of IC_LEFT: type AOP_STR size 2
;	genLabel
00101$:
;	genEndFunction
	pop	ix
	ret
_kmalloc_end::
;mem.c:663: freep (void *pos, struct proc *proc)
;	genLabel
;	genFunction
;	---------------------------------
; Function freep
; ---------------------------------
_freep_start::
_freep:
	push	ix
	ld	ix,#0
	add	ix,sp
;mem.c:667: RAMASSERT(pos);
;	genIfx
;	AOP_STK for 
	ld	a,4(ix)
	or	a,5(ix)
	jp	z,00102$
;	genAssign
;	AOP_STK for 
	ld	c,4(ix)
	ld	b,5(ix)
;	genCmpLt
	ld	a,c
	sub	a,#<_ram
	ld	a,b
	sbc	a,#>_ram
	jp	c,00101$
;	genAssign
;	(registers are the same)
;	genPlus
;	genPlusIncr
	ld	de,#_ram + 65535
;	genCmpGt
	ld	a,e
	sub	a,c
	ld	a,d
	sbc	a,b
	jp	nc,00102$
;	genLabel
00101$:
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#__str_8
	push	hl
;	genCall
	call	_panic
	pop	af
;	genLabel
00102$:
;mem.c:670: p = ADDR2PAGE(pos);
;	genCast
;	AOP_STK for 
	ld	c,4(ix)
	ld	b,5(ix)
;	genCast
	ld	e,#<_ram
	ld	d,#>_ram
;	genMinus
	ld	a,c
	sub	a,e
	ld	c,a
	ld	a,b
	sbc	a,d
	ld	b,a
;	genCast
;	genCast
;	genRightShift
	ld	c,b
	ld	b,#0x00
;	genCast
; Removed redundent load
;mem.c:674: if (FRAGLOG(p) == 0)    /* Fragment size in page info? */
;	genPlus
;	Can't optimise plus by inc, falling back to the normal way
	ld	iy,#_page_list
	ld	a,0(iy)
	add	a,c
	ld	c,a
	ld	a,1(iy)
	adc	a,#0x00
	ld	b,a
;	genPointerGet
	ld	a,(bc)
;	genAnd
	ld	c,a
	and	a,#0x03
	jp	z,00114$
00113$:
	jp	00106$
00114$:
;mem.c:675: mem_page_free (pos);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
;	AOP_STK for 
	ld	l,4(ix)
	ld	h,5(ix)
	push	hl
;	genCall
	call	_mem_page_free
	pop	af
;	genGoto
	jp	00108$
;	genLabel
00106$:
;mem.c:677: mem_frag_free (pos, proc);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
;	AOP_STK for 
	ld	l,6(ix)
	ld	h,7(ix)
	push	hl
;	genIpush
;	AOP_STK for 
	ld	l,4(ix)
	ld	h,5(ix)
	push	hl
;	genCall
	call	_mem_frag_free
	pop	af
	pop	af
;	genLabel
00108$:
;	genEndFunction
	pop	ix
	ret
_freep_end::
__str_8:
	.ascii "Pointer outside memory."
	.db 0x0A
	.db 0x00
;mem.c:693: malloc (size_t size)
;	genLabel
;	genFunction
;	---------------------------------
; Function malloc
; ---------------------------------
_malloc_start::
_malloc:
	push	ix
	ld	ix,#0
	add	ix,sp
;mem.c:696: struct proc *proc = (CURRENT_PROC() != NULL) ? CURRENT_PROC() : NULL;
;	genCmpEq
; genCmpEq: left 2, right 2, result 1
;4
	ld	iy,#_proc_current
	ld	a,0(iy)
	or	a,1(iy)
	jp	nz,00106$
	ld	a,#0x01
	jp	00107$
00106$:
	xor	a,a
00107$:
;6
	ld	c,a
;	genNot
	xor	a,a
	or	a,c
	sub	a,#0x01
	ld	a,#0x00
	rla
;	genIfx
	ld	c,a
	or	a,a
	jp	z,00103$
;	genAssign
	ld	bc,(_proc_current)
;	genGoto
	jp	00104$
;	genLabel
00103$:
;	genAssign
	ld	bc,#0x0000
;	genLabel
00104$:
;	genAssign
;	(registers are the same)
;mem.c:701: return pmalloc (size, proc);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	push	bc
;	genIpush
;	AOP_STK for 
	ld	l,4(ix)
	ld	h,5(ix)
	push	hl
;	genCall
	call	_pmalloc
	pop	af
	pop	af
;	genRet
; Dump of IC_LEFT: type AOP_STR size 2
;	genLabel
00101$:
;	genEndFunction
	pop	ix
	ret
_malloc_end::
;mem.c:705: free (void *pos)
;	genLabel
;	genFunction
;	---------------------------------
; Function free
; ---------------------------------
_free_start::
_free:
	push	ix
	ld	ix,#0
	add	ix,sp
;mem.c:707: freep (pos, CURRENT_PROC());
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,(_proc_current)
	push	hl
;	genIpush
;	AOP_STK for 
	ld	l,4(ix)
	ld	h,5(ix)
	push	hl
;	genCall
	call	_freep
	pop	af
	pop	af
;	genLabel
00101$:
;	genEndFunction
	pop	ix
	ret
_free_end::
	.area _CODE
