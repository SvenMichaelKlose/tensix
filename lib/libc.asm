;--------------------------------------------------------
; File Created by SDCC : FreeWare ANSI-C Compiler
; Version 2.6.0 #4309 (Oct 17 2006)
; This file generated Thu Oct 19 04:08:14 2006
;--------------------------------------------------------
	.module libc
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _libc_printndec
	.globl _libc_con
	.globl _libc_init
	.globl _libc_close
	.globl _printf
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
;  ram data
;--------------------------------------------------------
	.area _DATA
_libc_con::
	.ds 2
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
;libc.c:20: libc_init ()
;	genLabel
;	genFunction
;	---------------------------------
; Function libc_init
; ---------------------------------
_libc_init_start::
_libc_init:
;libc.c:22: int err = open (&libc_con, "/con");
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#__str_0
	push	hl
;	genIpush
	ld	hl,#_libc_con
	push	hl
;	genCall
	call	_open
	ld	b,h
	ld	c,l
	pop	af
	pop	af
;	genAssign
;	(registers are the same)
;libc.c:23: if (err != ENONE) {
;	genCmpEq
; genCmpEq: left 2, right 2, result 0
	ld	a,c
	or	a,b
	jp	z,00103$
00106$:
;libc.c:24: printk ("libc: fatal error: can't open /con\n", 0);
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
;libc.c:25: exit (-1);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0xFFFFFFFF
	push	hl
;	genCall
	call	_exit
	pop	af
;	genLabel
00103$:
;	genEndFunction
	ret
_libc_init_end::
__str_0:
	.ascii "/con"
	.db 0x00
__str_1:
	.ascii "libc: fatal error: can't open /con"
	.db 0x0A
	.db 0x00
;libc.c:30: libc_close ()
;	genLabel
;	genFunction
;	---------------------------------
; Function libc_close
; ---------------------------------
_libc_close_start::
_libc_close:
;libc.c:32: close (libc_con);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,(_libc_con)
	push	hl
;	genCall
	call	_close
	pop	af
;	genLabel
00101$:
;	genEndFunction
	ret
_libc_close_end::
;libc.c:47: libc_printndec (char ** whereto, unsigned int n)
;	genLabel
;	genFunction
;	---------------------------------
; Function libc_printndec
; ---------------------------------
_libc_printndec_start::
_libc_printndec:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-20
	add	hl,sp
	ld	sp,hl
;libc.c:49: char *to = *whereto;
;	genAssign
;	AOP_STK for 
;	AOP_STK for _libc_printndec_sloc1_1_0
	ld	a,4(ix)
	ld	-20(ix),a
	ld	a,5(ix)
	ld	-19(ix),a
;	genPointerGet
;	AOP_STK for _libc_printndec_sloc1_1_0
	ld	l,-20(ix)
	ld	h,-19(ix)
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
;	genAssign
;	AOP_STK for _libc_printndec_to_1_1
	ld	-2(ix),e
	ld	-1(ix),d
;libc.c:53: do {
;	genAddrOf
;	AOP_STK for _libc_printndec_sloc0_1_0
	ld	hl,#0x0006
	add	hl,sp
	ld	-18(ix),l
	ld	-17(ix),h
;	genAssign
;	AOP_STK for _libc_printndec_i_1_1
	ld	-16(ix),#0x00
	ld	-15(ix),#0x00
;	genLabel
00101$:
;libc.c:54: out[i++] = n % 10;
;	genAssign
;	AOP_STK for _libc_printndec_i_1_1
	ld	e,-16(ix)
	ld	d,-15(ix)
;	genPlus
;	AOP_STK for _libc_printndec_i_1_1
;	genPlusIncr
	inc	-16(ix)
	jp	nz,00114$
	inc	-15(ix)
00114$:
;	genPlus
;	AOP_STK for _libc_printndec_sloc0_1_0
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,-18(ix)
	add	a,e
	ld	e,a
	ld	a,-17(ix)
	adc	a,d
	ld	d,a
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 1 bcInUse: 0 deSending: 0
	push	de
	ld	hl,#0x000A
	push	hl
;	genIpush
;	AOP_STK for 
	ld	l,6(ix)
	ld	h,7(ix)
	push	hl
;	genCall
	call	__moduint_rrx_s
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
;libc.c:55: n /= 10;
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0x000A
	push	hl
;	genIpush
;	AOP_STK for 
	ld	l,6(ix)
	ld	h,7(ix)
	push	hl
;	genCall
	call	__divuint_rrx_s
	ld	b,h
	ld	c,l
	pop	af
	pop	af
;	genAssign
;	AOP_STK for 
	ld	6(ix),c
	ld	7(ix),b
;libc.c:56: } while (n);
;	genIfx
;	AOP_STK for 
	ld	a,6(ix)
	or	a,7(ix)
	jp	nz,00101$
;libc.c:58: while (i--)
;	genAssign
;	AOP_STK for _libc_printndec_to_1_1
	ld	c,-2(ix)
	ld	b,-1(ix)
;	genAssign
;	AOP_STK for _libc_printndec_i_1_1
;	(registers are the same)
;	genLabel
00104$:
;	genAssign
;	AOP_STK for _libc_printndec_i_1_1
	ld	e,-16(ix)
	ld	d,-15(ix)
;	genMinus
;	AOP_STK for _libc_printndec_i_1_1
	ld	l,-16(ix)
	ld	h,-15(ix)
	dec	hl
	ld	-16(ix),l
	ld	-15(ix),h
;	genIfx
	ld	a,e
	or	a,d
	jp	z,00106$
;libc.c:59: *to++ = out[i] + '0';
;	genPlus
;	AOP_STK for _libc_printndec_sloc0_1_0
;	AOP_STK for _libc_printndec_i_1_1
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,-18(ix)
	add	a,-16(ix)
	ld	e,a
	ld	a,-17(ix)
	adc	a,-15(ix)
	ld	d,a
;	genPointerGet
	ld	a,(de)
;	genPlus
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	e,a
	add	a,#0x30
;	genAssign (pointer)
;	isBitvar = 0
	ld	(bc),a
;	genPlus
;	genPlusIncr
	inc	bc
;	genGoto
	jp	00104$
;	genLabel
00106$:
;libc.c:61: *whereto = to;
;	genAssign (pointer)
;	AOP_STK for _libc_printndec_sloc1_1_0
;	isBitvar = 0
	ld	l,-20(ix)
	ld	h,-19(ix)
	ld	(hl),c
	inc	hl
	ld	(hl),b
;	genLabel
00107$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_libc_printndec_end::
;libc.c:66: printf (char *fmt, unsigned int v)
;	genLabel
;	genFunction
;	---------------------------------
; Function printf
; ---------------------------------
_printf_start::
_printf:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-8
	add	hl,sp
	ld	sp,hl
;libc.c:75: err = bref (&buf, libc_con, 0, IO_CREATE);
;	genAddrOf
	ld	hl,#0x0006
	add	hl,sp
	ld	c,l
	ld	b,h
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	a,#0x01
	push	af
	inc	sp
;	genIpush
	ld	hl,#0x0000
	push	hl
;	genIpush
	ld	hl,(_libc_con)
	push	hl
;	genIpush
	push	bc
;	genCall
	call	_bref
	ld	b,h
	ld	c,l
	pop	af
	pop	af
	pop	af
	inc	sp
;	genAssign
;	(registers are the same)
;libc.c:76: if (err != ENONE) {
;	genCmpEq
; genCmpEq: left 2, right 2, result 0
	ld	a,c
	or	a,b
	jp	z,00102$
00127$:
;libc.c:77: printk ("printf: fatal error: can't get console buffer\n", 0);
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
;libc.c:78: exit (-1);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0xFFFFFFFF
	push	hl
;	genCall
	call	_exit
	pop	af
;	genLabel
00102$:
;libc.c:80: p = buf->data;
;	genAssign
;	AOP_STK for _printf_buf_1_1
	ld	c,-2(ix)
	ld	b,-1(ix)
;	genPlus
;	genPlusIncr
	inc	bc
	inc	bc
	inc	bc
	inc	bc
	inc	bc
;	genPointerGet
	ld	l,c
	ld	h,b
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
;	genAssign
;	AOP_STK for _printf_p_1_1
	ld	-4(ix),c
	ld	-3(ix),b
;libc.c:82: while ((c = *fmt++) != 0) {
;	genAssign
;	AOP_STK for 
;	AOP_STK for _printf_sloc0_1_0
	ld	a,6(ix)
	ld	-6(ix),a
	ld	a,7(ix)
	ld	-5(ix),a
;	genLabel
00113$:
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
	jp	z,00115$
00128$:
;libc.c:83: if (c != '%') {
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	a,b
	cp	a,#0x25
	jp	z,00104$
00129$:
;libc.c:84: *p++ = c;
;	genAssign
;	AOP_STK for _printf_p_1_1
	ld	e,-4(ix)
	ld	d,-3(ix)
;	genAssign (pointer)
;	isBitvar = 0
	ld	a,b
	ld	(de),a
;	genPlus
;	AOP_STK for _printf_p_1_1
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,e
	add	a,#0x01
	ld	-4(ix),a
	ld	a,d
	adc	a,#0x00
	ld	-3(ix),a
;libc.c:85: continue;
;	genGoto
	jp	00113$
;	genLabel
00104$:
;libc.c:87: c = *fmt++;
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
;libc.c:88: switch (c) {
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	a,b
	cp	a,#0x64
	jp	z,00106$
00130$:
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	a,b
	cp	a,#0x6C
	jp	z,00106$
00131$:
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	a,b
	cp	a,#0x73
	jp	z,00107$
00132$:
;	genGoto
	jp	00111$
;libc.c:90: case 'l':
;	genLabel
00106$:
;libc.c:92: libc_printndec (&p, (unsigned int) d);
;	genAddrOf
	ld	hl,#0x0004
	add	hl,sp
	ld	e,l
	ld	d,h
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
;	AOP_STK for _printf_sloc0_1_0
	ld	l,-6(ix)
	ld	h,-5(ix)
	push	hl
;	genIpush
	push	de
;	genCall
	call	_libc_printndec
	pop	af
	pop	af
;libc.c:93: break;
;	genGoto
	jp	00113$
;libc.c:95: case 's':
;	genLabel
00107$:
;libc.c:96: s = (char*) v;
;	genCast
;	AOP_STK for 
	ld	b,6(ix)
	ld	d,7(ix)
;libc.c:97: while ((c = *s++) != 0)
;	genAssign
;	AOP_STK for _printf_p_1_1
	ld	c,-4(ix)
	ld	e,-3(ix)
;	genAssign
;	AOP_STK for _printf_sloc1_1_0
	ld	-8(ix),b
	ld	-7(ix),d
;	genLabel
00108$:
;	genPointerGet
;	AOP_STK for _printf_sloc1_1_0
	ld	l,-8(ix)
	ld	h,-7(ix)
	ld	d,(hl)
;	genPlus
;	AOP_STK for _printf_sloc1_1_0
;	genPlusIncr
	inc	-8(ix)
	jp	nz,00133$
	inc	-7(ix)
00133$:
;	genAssign
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	b,d
	ld	a,b
	or	a,a
	jp	z,00113$
00134$:
;libc.c:98: *p++ = c;
;	genAssign (pointer)
;	isBitvar = 0
	ld	l,c
	ld	h,e
	ld	(hl),b
;	genPlus
;	genPlusIncr
	inc	c
	jp	nz,00135$
	inc	e
00135$:
;	genAssign
;	AOP_STK for _printf_p_1_1
	ld	-4(ix),c
	ld	-3(ix),e
;	genGoto
	jp	00108$
;libc.c:101: default:
;	genLabel
00111$:
;libc.c:102: *p++ = '%';
;	genAssign
;	AOP_STK for _printf_p_1_1
	ld	e,-4(ix)
	ld	d,-3(ix)
;	genAssign (pointer)
;	isBitvar = 0
	ld	a,#0x25
	ld	(de),a
;	genPlus
;	AOP_STK for _printf_p_1_1
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,e
	add	a,#0x01
	ld	-4(ix),a
	ld	a,d
	adc	a,#0x00
	ld	-3(ix),a
;libc.c:103: *p++ = c;
;	genAssign
;	AOP_STK for _printf_p_1_1
	ld	e,-4(ix)
	ld	d,-3(ix)
;	genAssign (pointer)
;	isBitvar = 0
	ld	a,b
	ld	(de),a
;	genPlus
;	AOP_STK for _printf_p_1_1
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,e
	add	a,#0x01
	ld	-4(ix),a
	ld	a,d
	adc	a,#0x00
	ld	-3(ix),a
;libc.c:104: }
;	genGoto
	jp	00113$
;	genLabel
00115$:
;libc.c:107: buf->len = (size_t) POINTER_SUB(p, buf->data);
;	genAssign
;	AOP_STK for _printf_buf_1_1
	ld	c,-2(ix)
	ld	b,-1(ix)
;	genPlus
;	AOP_STK for _printf_sloc1_1_0
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,c
	add	a,#0x0B
	ld	-8(ix),a
	ld	a,b
	adc	a,#0x00
	ld	-7(ix),a
;	genCast
;	AOP_STK for _printf_p_1_1
;	AOP_STK for _printf_sloc0_1_0
	ld	a,-4(ix)
	ld	-6(ix),a
	ld	a,-3(ix)
	ld	-5(ix),a
;	genPlus
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,c
	add	a,#0x05
	ld	e,a
	ld	a,b
	adc	a,#0x00
	ld	d,a
;	genPointerGet
	ld	l,e
	ld	h,d
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
;	genCast
;	genMinus
;	AOP_STK for _printf_sloc0_1_0
	ld	a,-6(ix)
	sub	a,e
	ld	e,a
	ld	a,-5(ix)
	sbc	a,d
	ld	d,a
;	genCast
;	genCast
;	genAssign (pointer)
;	AOP_STK for _printf_sloc1_1_0
;	isBitvar = 0
	ld	l,-8(ix)
	ld	h,-7(ix)
	ld	(hl),e
	inc	hl
	ld	(hl),d
;libc.c:108: BDIRTY(buf);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	push	bc
;	genCall
	call	__bdirty
	pop	af
;libc.c:109: bunref (buf);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
;	AOP_STK for _printf_buf_1_1
	ld	l,-2(ix)
	ld	h,-1(ix)
	push	hl
;	genCall
	call	_bunref
	pop	af
;	genLabel
00116$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_printf_end::
__str_2:
	.ascii "printf: fatal error: can't get console buffer"
	.db 0x0A
	.db 0x00
	.area _CODE
