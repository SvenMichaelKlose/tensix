;--------------------------------------------------------
; File Created by SDCC : FreeWare ANSI-C Compiler
; Version 2.6.0 #4309 (Oct 17 2006)
; This file generated Thu Oct 19 04:11:58 2006
;--------------------------------------------------------
	.module array
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl __sarray_add
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
;array.c:14: _sarray_add (size_t tlen, char* arr)
;	genLabel
;	genFunction
;	---------------------------------
; Function _sarray_add
; ---------------------------------
__sarray_add_start::
__sarray_add:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-2
	add	hl,sp
	ld	sp,hl
;array.c:17: char *end = (char *) SARRAY_END(arr);
;	genCast
;	AOP_STK for 
	ld	c,6(ix)
	ld	b,7(ix)
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
	jp	00113$
00112$:
	sra	d
	rr	e
00113$:
	dec	a
	jp	nz,00112$
;	genPlus
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,c
	add	a,e
	ld	e,a
	ld	a,b
	adc	a,d
	ld	d,a
;	genCast
;	AOP_STK for __sarray_add_end_1_1
	ld	-2(ix),e
	ld	-1(ix),d
;array.c:20: for (i = arr; i < end; i += tlen)
;	genAssign
;	AOP_STK for 
	ld	e,6(ix)
	ld	d,7(ix)
;	genLabel
00103$:
;	genCmpLt
;	AOP_STK for __sarray_add_end_1_1
	ld	a,e
	sub	a,-2(ix)
	ld	a,d
	sbc	a,-1(ix)
	jp	p,00106$
;array.c:21: if (*(u16_t *) i == 0)
;	genPointerGet
	ld	l,e
	ld	h,d
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
;	genIfx
	ld	a,c
	or	a,b
	jp	nz,00105$
;array.c:22: return (void*) i;
;	genRet
; Dump of IC_LEFT: type AOP_REG size 2
;	 reg = de
	ld	l,e
	ld	h,d
	jp	00107$
;	genLabel
00105$:
;array.c:20: for (i = arr; i < end; i += tlen)
;	genPlus
;	AOP_STK for 
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,e
	add	a,4(ix)
	ld	e,a
	ld	a,d
	adc	a,5(ix)
	ld	d,a
;	genGoto
	jp	00103$
;	genLabel
00106$:
;array.c:24: return NULL;
;	genRet
; Dump of IC_LEFT: type AOP_LIT size 2
	ld	hl,#0x0000
;	genLabel
00107$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
__sarray_add_end::
	.area _CODE
