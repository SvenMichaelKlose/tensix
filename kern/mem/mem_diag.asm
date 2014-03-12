;--------------------------------------------------------
; File Created by SDCC : FreeWare ANSI-C Compiler
; Version 2.6.0 #4309 (Oct 17 2006)
; This file generated Thu Oct 19 04:08:17 2006
;--------------------------------------------------------
	.module mem_diag
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _mem_boundary_frag
	.globl _mem_boundary_page
	.globl _mem_boundary
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
;mem_diag.c:26: mem_boundary_page (pagenum_t parea, pagenum_t pptr, char *msg)
;	genLabel
;	genFunction
;	---------------------------------
; Function mem_boundary_page
; ---------------------------------
_mem_boundary_page_start::
_mem_boundary_page:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-1
	add	hl,sp
	ld	sp,hl
;mem_diag.c:28: pagenum_t  p = parea;
;	genAssign
;	AOP_STK for 
;	AOP_STK for _mem_boundary_page_p_1_1
	ld	a,4(ix)
	ld	-1(ix),a
;mem_diag.c:31: if (PAGE_USED(p) == FALSE)
;	genRightShift
;	AOP_STK for _mem_boundary_page_p_1_1
	ld	b,-1(ix)
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
;	AOP_STK for _mem_boundary_page_p_1_1
	ld	a,-1(ix)
	and	a,#0x07
;	genLeftShift
	ld	e,a
	inc	a
	push	af
	ld	e,#0x01
	ld	d,#0x00
	pop	af
	jp	00121$
00120$:
	sla	e
	rl	d
00121$:
	dec	a
	jp	nz,00120$
;	genCast
; Removed redundent load
	ld	c,#0x00
;	genAnd
	ld	a,e
	and	a,b
	ld	e,a
	ld	a,d
	and	a,c
	ld	d,a
;	genIfx
	ld	a,e
	or	a,d
	jp	nz,00102$
;mem_diag.c:32: panic ("%s: page not in use.");
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#__str_0
	push	hl
;	genCall
	call	_panic
	pop	af
;	genLabel
00102$:
;mem_diag.c:35: if (PAGE_LOCKED(p - 1) == 0 && PAGE_CONT(p - 1) != 0)
;	genCast
;	AOP_STK for _mem_boundary_page_p_1_1
	ld	c,-1(ix)
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
	jp	z,00105$
;	genAnd
	ld	a,c
	and	a,#0x03
	jp	z,00123$
00122$:
	jp	00118$
00123$:
;	genLabel
00105$:
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	a,b
	or	a,a
	jp	z,00118$
00124$:
;mem_diag.c:36: panic ("%s: no page start.");
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#__str_1
	push	hl
;	genCall
	call	_panic
	pop	af
;mem_diag.c:39: do {
;	genLabel
00118$:
;	genAssign
;	AOP_STK for _mem_boundary_page_p_1_1
	ld	c,-1(ix)
;	genLabel
00108$:
;mem_diag.c:40: cont = PAGE_CONT(p);
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
	ld	b,a
;mem_diag.c:41: if (p == pptr)
;	genCmpEq
;	AOP_STK for 
; genCmpEq: left 1, right 1, result 0
	ld	a,5(ix)
	cp	c
	jp	z,00126$
00125$:
	jp	00107$
00126$:
;mem_diag.c:42: return;
;	genRet
	jp	00112$
;	genLabel
00107$:
;mem_diag.c:43: p++; /* Next page. */
;	genPlus
;	genPlusIncr
; Removed redundent load
	inc	c
;mem_diag.c:44: } while (cont); /* Continued by next. */
;	genIfx
	xor	a,a
	or	a,b
	jp	nz,00108$
;mem_diag.c:46: panic ("%s: ptr outside page area.");
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#__str_2
	push	hl
;	genCall
	call	_panic
	pop	af
;	genLabel
00112$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_mem_boundary_page_end::
__str_0:
	.ascii "%s: page not in use."
	.db 0x00
__str_1:
	.ascii "%s: no page start."
	.db 0x00
__str_2:
	.ascii "%s: ptr outside page area."
	.db 0x00
;mem_diag.c:51: mem_boundary_frag (void *area, pagenum_t parea, void *ptr, pagenum_t pptr, char *msg)
;	genLabel
;	genFunction
;	---------------------------------
; Function mem_boundary_frag
; ---------------------------------
_mem_boundary_frag_start::
_mem_boundary_frag:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-4
	add	hl,sp
	ld	sp,hl
;mem_diag.c:53: size_t fsize = FRAGSIZE(pptr);
;	genPlus
;	AOP_STK for 
;	Can't optimise plus by inc, falling back to the normal way
	ld	iy,#_page_list
	ld	a,0(iy)
	add	a,9(ix)
	ld	c,a
	ld	a,1(iy)
	adc	a,#0x00
	ld	b,a
;	genPointerGet
	ld	a,(bc)
;	genAnd
	ld	c,a
	and	a,#0x03
;	genRightShift
	ld	c,a
	inc	a
;	AOP_STK for _mem_boundary_frag_fsize_1_1
	push	af
	ld	-2(ix),#0x00
	ld	-1(ix),#0x01
	pop	af
	jp	00113$
00112$:
	srl	-1(ix)
	rr	-2(ix)
00113$:
	dec	a
	jp	nz,00112$
;mem_diag.c:55: if (parea != pptr)
;	genCmpEq
;	AOP_STK for 
;	AOP_STK for 
; genCmpEq: left 1, right 1, result 0
	ld	a,9(ix)
	cp	6(ix)
	jp	z,00102$
00114$:
;mem_diag.c:56: panic ("%s: ptr outside frag page");
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#__str_3
	push	hl
;	genCall
	call	_panic
	pop	af
;	genLabel
00102$:
;mem_diag.c:58: if (IS_ILLEGAL_FRAG(area))
;	genCast
;	AOP_STK for 
	ld	e,4(ix)
	ld	d,5(ix)
;	genCast
	ld	c,#<_ram
	ld	b,#>_ram
;	genMinus
	ld	a,e
	sub	a,c
	ld	c,a
	ld	a,d
	sbc	a,b
	ld	b,a
;	genCast
;	genCast
;	AOP_STK for _mem_boundary_frag_sloc0_1_0
	ld	-4(ix),c
	ld	-3(ix),b
;	genCast
	ld	c,#<_ram
	ld	b,#>_ram
;	genMinus
	ld	a,e
	sub	a,c
	ld	c,a
	ld	a,d
	sbc	a,b
	ld	b,a
;	genCast
;	genCast
;	genRightShift
	ld	c,b
	ld	b,#0x00
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
	and	a,#0x03
;	genRightShift
	ld	c,a
	inc	a
	push	af
	ld	c,#0x00
	ld	b,#0x01
	pop	af
	jp	00116$
00115$:
	sra	b
	rr	c
00116$:
	dec	a
	jp	nz,00115$
;	genMinus
	dec	bc
;	genAnd
;	AOP_STK for _mem_boundary_frag_sloc0_1_0
	ld	a,c
	and	a,-4(ix)
	ld	c,a
	ld	a,b
	and	a,-3(ix)
	ld	b,a
;	genIfx
	ld	a,c
	or	a,b
	jp	z,00104$
;mem_diag.c:59: panic ("%s: no frag  start");
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 1 bcInUse: 0 deSending: 0
	push	de
	ld	hl,#__str_4
	push	hl
;	genCall
	call	_panic
	pop	af
	pop	de
;	genLabel
00104$:
;mem_diag.c:61: if (ptr > POINTER_ADD(area, fsize))
;	genPlus
;	AOP_STK for _mem_boundary_frag_fsize_1_1
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,e
	add	a,-2(ix)
	ld	c,a
	ld	a,d
	adc	a,-1(ix)
	ld	b,a
;	genCast
;	genCmpGt
;	AOP_STK for 
	ld	a,c
	sub	a,7(ix)
	ld	a,b
	sbc	a,8(ix)
	jp	p,00107$
;mem_diag.c:62: panic ("%s: ptr outside frag area");
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#__str_5
	push	hl
;	genCall
	call	_panic
	pop	af
;	genLabel
00107$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_mem_boundary_frag_end::
__str_3:
	.ascii "%s: ptr outside frag page"
	.db 0x00
__str_4:
	.ascii "%s: no frag  start"
	.db 0x00
__str_5:
	.ascii "%s: ptr outside frag area"
	.db 0x00
;mem_diag.c:66: mem_boundary (void *area, void *ptr, char *msg)
;	genLabel
;	genFunction
;	---------------------------------
; Function mem_boundary
; ---------------------------------
_mem_boundary_start::
_mem_boundary:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-1
	add	hl,sp
	ld	sp,hl
;mem_diag.c:68: pagenum_t parea = ADDR2PAGE(area);
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
;	AOP_STK for _mem_boundary_parea_1_1
	ld	-1(ix),c
;mem_diag.c:69: pagenum_t pptr = ADDR2PAGE(ptr);
;	genCast
;	AOP_STK for 
	ld	e,6(ix)
	ld	d,7(ix)
;	genCast
	ld	b,#<_ram
	ld	c,#>_ram
;	genMinus
	ld	a,e
	sub	a,b
	ld	b,a
	ld	a,d
	sbc	a,c
	ld	c,a
;	genCast
;	genCast
;	genRightShift
	ld	b,c
	ld	c,#0x00
;	genCast
	ld	c,b
;mem_diag.c:72: if (FRAGLOG(pptr) == 0)    /* Fragment size in page info? */
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
	and	a,#0x03
	jp	z,00108$
00107$:
	jp	00102$
00108$:
;mem_diag.c:73: mem_boundary_page (parea, pptr, msg);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
;	AOP_STK for 
	ld	l,8(ix)
	ld	h,9(ix)
	push	hl
;	genIpush
	ld	a,c
	push	af
	inc	sp
;	genIpush
;	AOP_STK for _mem_boundary_parea_1_1
	ld	a,-1(ix)
	push	af
	inc	sp
;	genCall
	call	_mem_boundary_page
	pop	af
	pop	af
;	genGoto
	jp	00104$
;	genLabel
00102$:
;mem_diag.c:75: mem_boundary_frag (area, parea, ptr, pptr, msg);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
;	AOP_STK for 
	ld	l,8(ix)
	ld	h,9(ix)
	push	hl
;	genIpush
	ld	a,c
	push	af
	inc	sp
;	genIpush
;	AOP_STK for 
	ld	l,6(ix)
	ld	h,7(ix)
	push	hl
;	genIpush
;	AOP_STK for _mem_boundary_parea_1_1
	ld	a,-1(ix)
	push	af
	inc	sp
;	genIpush
;	AOP_STK for 
	ld	l,4(ix)
	ld	h,5(ix)
	push	hl
;	genCall
	call	_mem_boundary_frag
	pop	af
	pop	af
	pop	af
	pop	af
;	genLabel
00104$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_mem_boundary_end::
	.area _CODE
