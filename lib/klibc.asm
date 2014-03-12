;--------------------------------------------------------
; File Created by SDCC : FreeWare ANSI-C Compiler
; Version 2.6.0 #4309 (Oct 17 2006)
; This file generated Thu Oct 19 04:11:58 2006
;--------------------------------------------------------
	.module klibc
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _printnhex
	.globl _printndec
	.globl _printk
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
;klibc.c:15: printnhex (unsigned int n, unsigned int digits)
;	genLabel
;	genFunction
;	---------------------------------
; Function printnhex
; ---------------------------------
_printnhex_start::
_printnhex:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-2
	add	hl,sp
	ld	sp,hl
;klibc.c:17: unsigned s = digits << 2;
;	genLeftShift
;	AOP_STK for 
;	AOP_STK for _printnhex_s_1_1
	ld	a,6(ix)
	ld	-2(ix),a
	ld	a,7(ix)
	ld	-1(ix),a
	ld	a,#0x02+1
	jp	00110$
00109$:
	sla	-2(ix)
	rl	-1(ix)
00110$:
	dec	a
	jp	nz,00109$
;klibc.c:19: while (digits--)
;	genAssign
;	AOP_STK for 
	ld	e,6(ix)
	ld	d,7(ix)
;	genLabel
00101$:
;	genAssign
	ld	c,e
	ld	b,d
;	genMinus
	dec	de
;	genIfx
	ld	a,c
	or	a,b
	jp	z,00104$
;klibc.c:20: con_out ("0123456789abcdef"[(n >> (s -= 4)) & 15]);
;	genMinus
;	AOP_STK for _printnhex_s_1_1
	ld	a,-2(ix)
	add	a,#0xFC
	ld	c,a
	ld	a,-1(ix)
	adc	a,#0xFF
	ld	b,a
;	genAssign
;	AOP_STK for _printnhex_s_1_1
	ld	-2(ix),c
	ld	-1(ix),b
;	genRightShift
	ld	a,c
	inc	a
;	AOP_STK for 
	push	af
	ld	c,4(ix)
	ld	b,5(ix)
	pop	af
	jp	00112$
00111$:
	srl	b
	rr	c
00112$:
	dec	a
	jp	nz,00111$
;	genAnd
	ld	a,c
	and	a,#0x0F
	ld	c,a
	ld	b,#0x00
;	genPlus
;	Can't optimise plus by inc, falling back to the normal way
	ld	hl,#__str_0
	add	hl,bc
	ld	c,l
	ld	b,h
;	genPointerGet
	ld	a,(bc)
	ld	c,a
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 1 bcInUse: 0 deSending: 0
	push	de
	ld	a,c
	push	af
	inc	sp
;	genCall
	call	_con_out
	inc	sp
	pop	de
;	genGoto
	jp	00101$
;	genLabel
00104$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_printnhex_end::
__str_0:
	.ascii "0123456789abcdef"
	.db 0x00
;klibc.c:27: printndec (unsigned int n)
;	genLabel
;	genFunction
;	---------------------------------
; Function printndec
; ---------------------------------
_printndec_start::
_printndec:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-16
	add	hl,sp
	ld	sp,hl
;klibc.c:32: do {
;	genAddrOf
	ld	hl,#0x0004
	add	hl,sp
	ld	c,l
	ld	b,h
;	genAssign
;	AOP_STK for _printndec_i_1_1
	ld	-14(ix),#0x00
	ld	-13(ix),#0x00
;	genLabel
00101$:
;klibc.c:33: out[i++] = n % 10;
;	genAssign
;	AOP_STK for _printndec_i_1_1
	ld	e,-14(ix)
	ld	d,-13(ix)
;	genPlus
;	AOP_STK for _printndec_i_1_1
;	genPlusIncr
	inc	-14(ix)
	jp	nz,00114$
	inc	-13(ix)
00114$:
;	genPlus
;	AOP_STK for _printndec_sloc0_1_0
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,c
	add	a,e
	ld	-16(ix),a
	ld	a,b
	adc	a,d
	ld	-15(ix),a
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	ld	hl,#0x000A
	push	hl
;	genIpush
;	AOP_STK for 
	ld	l,4(ix)
	ld	h,5(ix)
	push	hl
;	genCall
	call	__moduint_rrx_s
	ld	d,h
	ld	e,l
	pop	af
	pop	af
	pop	bc
;	genCast
	ld	a,e
;	genAssign (pointer)
;	AOP_STK for _printndec_sloc0_1_0
;	isBitvar = 0
	ld	l,-16(ix)
	ld	h,-15(ix)
	ld	(hl),a
;klibc.c:34: n /= 10;
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	ld	hl,#0x000A
	push	hl
;	genIpush
;	AOP_STK for 
	ld	l,4(ix)
	ld	h,5(ix)
	push	hl
;	genCall
	call	__divuint_rrx_s
	ld	d,h
	ld	e,l
	pop	af
	pop	af
	pop	bc
;	genAssign
;	AOP_STK for 
	ld	4(ix),e
	ld	5(ix),d
;klibc.c:35: } while (n);
;	genIfx
;	AOP_STK for 
	ld	a,4(ix)
	or	a,5(ix)
	jp	nz,00101$
;klibc.c:37: while (i--)
;	genAssign
;	AOP_STK for _printndec_i_1_1
;	(registers are the same)
;	genLabel
00104$:
;	genAssign
;	AOP_STK for _printndec_i_1_1
	ld	e,-14(ix)
	ld	d,-13(ix)
;	genMinus
;	AOP_STK for _printndec_i_1_1
	ld	l,-14(ix)
	ld	h,-13(ix)
	dec	hl
	ld	-14(ix),l
	ld	-13(ix),h
;	genIfx
	ld	a,e
	or	a,d
	jp	z,00107$
;klibc.c:38: con_out (out[i] + '0');
;	genPlus
;	AOP_STK for _printndec_i_1_1
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,c
	add	a,-14(ix)
	ld	e,a
	ld	a,b
	adc	a,-13(ix)
	ld	d,a
;	genPointerGet
	ld	a,(de)
;	genPlus
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	e,a
	add	a,#0x30
	ld	e,a
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	ld	a,e
	push	af
	inc	sp
;	genCall
	call	_con_out
	inc	sp
	pop	bc
;	genGoto
	jp	00104$
;	genLabel
00107$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_printndec_end::
;klibc.c:43: printk (char *fmt, unsigned int v)
;	genLabel
;	genFunction
;	---------------------------------
; Function printk
; ---------------------------------
_printk_start::
_printk:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-2
	add	hl,sp
	ld	sp,hl
;klibc.c:49: while ((c = *fmt++) != 0) {
;	genAssign
;	AOP_STK for 
;	AOP_STK for _printk_sloc0_1_0
	ld	a,6(ix)
	ld	-2(ix),a
	ld	a,7(ix)
	ld	-1(ix),a
;	genLabel
00111$:
;	genAssign
;	AOP_STK for 
	ld	e,4(ix)
	ld	d,5(ix)
;	genPointerGet
	ld	a,(de)
	ld	c,a
;	genPlus
;	AOP_STK for 
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,e
	add	a,#0x01
	ld	4(ix),a
	ld	a,d
	adc	a,#0x00
	ld	5(ix),a
;	genAssign
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	b,c
	ld	a,b
	or	a,a
	jp	z,00114$
00124$:
;klibc.c:50: if (c != '%') {
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	a,b
	cp	a,#0x25
	jp	z,00102$
00125$:
;klibc.c:51: con_out (c);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	push	bc
	inc	sp
;	genCall
	call	_con_out
	inc	sp
;klibc.c:52: continue;
;	genGoto
	jp	00111$
;	genLabel
00102$:
;klibc.c:54: c = *fmt++;
;	genAssign
;	AOP_STK for 
	ld	e,4(ix)
	ld	d,5(ix)
;	genPointerGet
	ld	a,(de)
	ld	c,a
;	genPlus
;	AOP_STK for 
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,e
	add	a,#0x01
	ld	4(ix),a
	ld	a,d
	adc	a,#0x00
	ld	5(ix),a
;	genAssign
	ld	b,c
;klibc.c:55: switch (c) {
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	a,b
	cp	a,#0x64
	jp	z,00104$
00126$:
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	a,b
	cp	a,#0x6C
	jp	z,00104$
00127$:
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	a,b
	cp	a,#0x73
	jp	z,00105$
00128$:
;	genGoto
	jp	00109$
;klibc.c:57: case 'l':
;	genLabel
00104$:
;klibc.c:59: printndec ((unsigned int) d);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
;	AOP_STK for _printk_sloc0_1_0
	ld	l,-2(ix)
	ld	h,-1(ix)
	push	hl
;	genCall
	call	_printndec
	pop	af
;klibc.c:60: break;
;	genGoto
	jp	00111$
;klibc.c:62: case 's':
;	genLabel
00105$:
;klibc.c:63: s = (char*) v;
;	genCast
;	AOP_STK for 
	ld	e,6(ix)
	ld	d,7(ix)
;klibc.c:64: while ((c = *s++) != 0)
;	genAssign
;	(registers are the same)
;	genLabel
00106$:
;	genPointerGet
	ld	a,(de)
	ld	c,a
;	genPlus
;	genPlusIncr
	inc	de
;	genAssign
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	b,c
	ld	a,b
	or	a,a
	jp	z,00111$
00129$:
;klibc.c:65: con_out (c);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 1 bcInUse: 0 deSending: 0
	push	de
	push	bc
	inc	sp
;	genCall
	call	_con_out
	inc	sp
	pop	de
;	genGoto
	jp	00106$
;klibc.c:68: default:
;	genLabel
00109$:
;klibc.c:69: con_out ('%');
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	ld	a,#0x25
	push	af
	inc	sp
;	genCall
	call	_con_out
	inc	sp
	pop	bc
;klibc.c:70: con_out (c);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	push	bc
	inc	sp
;	genCall
	call	_con_out
	inc	sp
;klibc.c:71: }
;	genGoto
	jp	00111$
;	genLabel
00114$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_printk_end::
	.area _CODE
