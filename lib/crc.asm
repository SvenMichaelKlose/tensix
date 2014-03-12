;--------------------------------------------------------
; File Created by SDCC : FreeWare ANSI-C Compiler
; Version 2.6.0 #4309 (Oct 17 2006)
; This file generated Thu Oct 19 04:12:00 2006
;--------------------------------------------------------
	.module crc
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _crc
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
;crc.c:14: crc (void *where, size_t size)
;	genLabel
;	genFunction
;	---------------------------------
; Function crc
; ---------------------------------
_crc_start::
_crc:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-4
	add	hl,sp
	ld	sp,hl
;crc.c:16: u8_t v = 0;
;	genAssign
;	AOP_STK for _crc_v_1_1
	ld	-1(ix),#0x00
;crc.c:17: u8_t *p = (u8_t*) where;
;	genAssign
;	AOP_STK for 
	ld	e,4(ix)
	ld	d,5(ix)
;crc.c:21: while (size--) {
;	genAssign
;	AOP_STK for _crc_p_1_1
	ld	-3(ix),e
	ld	-2(ix),d
;	genAssign
;	AOP_STK for 
	ld	b,6(ix)
	ld	c,7(ix)
;	genLabel
00101$:
;	genAssign
	ld	e,b
	ld	d,c
;	genMinus
	ld	l,b
	ld	h,c
	dec	hl
	ld	b,l
	ld	c,h
;	genIfx
	ld	a,e
	or	a,d
	jp	z,00103$
;crc.c:22: tmp = *p++;
;	genPointerGet
;	AOP_STK for _crc_p_1_1
	ld	l,-3(ix)
	ld	h,-2(ix)
	ld	e,(hl)
;	genPlus
;	AOP_STK for _crc_p_1_1
;	genPlusIncr
	inc	-3(ix)
	jp	nz,00118$
	inc	-2(ix)
00118$:
;	genAssign
;	(registers are the same)
;crc.c:23: for (width = sizeof (u8_t) * 8; width > 0; width--) {
;	genAssign
	ld	d,#0x08
;	genLabel
00104$:
;	genIfx
	xor	a,a
	or	a,d
	jp	z,00110$
;	genAssign
;	AOP_STK for _crc_sloc0_1_0
	ld	-4(ix),#0x01
;	genGoto
	jp	00111$
;	genLabel
00110$:
;	genAssign
;	AOP_STK for _crc_sloc0_1_0
	ld	-4(ix),#0x00
;	genLabel
00111$:
;	genIfx
;	AOP_STK for _crc_sloc0_1_0
	xor	a,a
	or	a,-4(ix)
	jp	z,00101$
;crc.c:24: v ^= tmp;
;	genXor
;	AOP_STK for _crc_v_1_1
	ld	a,-1(ix)
	xor	a,e
	ld	-1(ix),a
;crc.c:25: tmp <<= 1;
;	genLeftShift
	ld	a,e
	add	a,a
	ld	e,a
;crc.c:23: for (width = sizeof (u8_t) * 8; width > 0; width--) {
;	genMinus
	dec	d
;	genGoto
	jp	00104$
;	genLabel
00103$:
;crc.c:29: return v;
;	genRet
;	AOP_STK for _crc_v_1_1
; Dump of IC_LEFT: type AOP_STK size 1
;	 aop_stk -1
	ld	l,-1(ix)
;	genLabel
00108$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_crc_end::
	.area _CODE
