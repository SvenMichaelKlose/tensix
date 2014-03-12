;--------------------------------------------------------
; File Created by SDCC : FreeWare ANSI-C Compiler
; Version 2.6.0 #4309 (Oct 17 2006)
; This file generated Thu Oct 19 04:08:14 2006
;--------------------------------------------------------
	.module bitmap
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _bitmap_seek
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
;bitmap.c:20: bitmap_seek (char *bitmap, size_t size, size_t b, size_t len)
;	genLabel
;	genFunction
;	---------------------------------
; Function bitmap_seek
; ---------------------------------
_bitmap_seek_start::
_bitmap_seek:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-11
	add	hl,sp
	ld	sp,hl
;bitmap.c:25: ASSERT(len > size, "bitmap_seek: Wanted len is greater than bitmap size.\n");
;	genCmpGt
;	AOP_STK for 
;	AOP_STK for 
	ld	a,6(ix)
	sub	a,10(ix)
	ld	a,7(ix)
	sbc	a,11(ix)
	jp	nc,00125$
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#__str_0
	push	hl
;	genCall
	call	_panic
	pop	af
;bitmap.c:27: while (b < (size - len)) {
;	genLabel
00125$:
;	genAssign
;	AOP_STK for 
	ld	c,4(ix)
	ld	b,5(ix)
;	genMinus
;	AOP_STK for 
;	AOP_STK for 
;	AOP_STK for _bitmap_seek_sloc0_1_0
	ld	a,6(ix)
	sub	a,10(ix)
	ld	-6(ix),a
	ld	a,7(ix)
	sbc	a,11(ix)
	ld	-5(ix),a
;	genAssign
;	AOP_STK for 
;	AOP_STK for _bitmap_seek_l_1_1
	ld	a,10(ix)
	ld	-2(ix),a
	ld	a,11(ix)
	ld	-1(ix),a
;	genAssign
;	AOP_STK for _bitmap_seek_sloc1_1_0
	ld	-8(ix),c
	ld	-7(ix),b
;	genLabel
00116$:
;	genCmpLt
;	AOP_STK for 
;	AOP_STK for _bitmap_seek_sloc0_1_0
	ld	a,8(ix)
	sub	a,-6(ix)
	ld	a,9(ix)
	sbc	a,-5(ix)
	jp	nc,00118$
;bitmap.c:28: if ((b % 8) && (BITMAP_BYTE(bitmap, b) == 255)) {
;	genAnd
;	AOP_STK for 
	ld	a,8(ix)
	and	a,#0x07
	jp	z,00104$
00132$:
;	genRightShift
;	AOP_STK for 
	ld	e,8(ix)
	ld	d,9(ix)
	srl	d
	rr	e
	srl	d
	rr	e
	srl	d
	rr	e
;	genPlus
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,c
	add	a,e
	ld	e,a
	ld	a,b
	adc	a,d
	ld	d,a
;	genPointerGet
	ld	a,(de)
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	e,a
	cp	a,#0xFF
	jp	z,00136$
00135$:
	jp	00104$
00136$:
;bitmap.c:29: b += 8;
;	genPlus
;	AOP_STK for 
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,8(ix)
	add	a,#0x08
	ld	8(ix),a
	ld	a,9(ix)
	adc	a,#0x00
	ld	9(ix),a
;bitmap.c:30: continue;
;	genGoto
	jp	00116$
;	genLabel
00104$:
;bitmap.c:34: if (BITMAP_GET(bitmap, b)) {
;	genRightShift
;	AOP_STK for 
	ld	e,8(ix)
	ld	d,9(ix)
	srl	d
	rr	e
	srl	d
	rr	e
	srl	d
	rr	e
;	genPlus
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,c
	add	a,e
	ld	e,a
	ld	a,b
	adc	a,d
	ld	d,a
;	genPointerGet
;	AOP_STK for _bitmap_seek_sloc2_1_0
	ld	a,(de)
	ld	-9(ix),a
;	genAnd
;	AOP_STK for 
	ld	a,8(ix)
	and	a,#0x07
	ld	d,a
	ld	e,#0x00
;	genLeftShift
	ld	a,d
	inc	a
	push	af
	ld	d,#0x01
	ld	e,#0x00
	pop	af
	jp	00140$
00139$:
	sla	d
	rl	e
00140$:
	dec	a
	jp	nz,00139$
;	genCast
; Removed redundent load
;	genAnd
;	AOP_STK for _bitmap_seek_sloc2_1_0
	ld	a,-9(ix)
	and	a,d
;	genIfx
	or	a,a
	jp	z,00107$
;bitmap.c:35: b++;
;	genAssign
;	AOP_STK for 
	ld	e,8(ix)
	ld	d,9(ix)
;	genPlus
;	AOP_STK for 
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,e
	add	a,#0x01
	ld	8(ix),a
	ld	a,d
	adc	a,#0x00
	ld	9(ix),a
;bitmap.c:36: continue;
;	genGoto
	jp	00116$
;	genLabel
00107$:
;bitmap.c:40: l = len;
;	genAssign
;	AOP_STK for _bitmap_seek_l_1_1
;	AOP_STK for _bitmap_seek_sloc3_1_0
	ld	a,-2(ix)
	ld	-11(ix),a
	ld	a,-1(ix)
	ld	-10(ix),a
;bitmap.c:41: i = b;
;	genAssign
;	AOP_STK for 
	ld	e,8(ix)
	ld	d,9(ix)
;	genAssign
;	AOP_STK for _bitmap_seek_i_1_1
	ld	-4(ix),e
	ld	-3(ix),d
;	genAssign
;	AOP_STK for _bitmap_seek_sloc3_1_0
;	(registers are the same)
;	genLabel
00110$:
;bitmap.c:42: BITMAP_GAP_LEN(bitmap, i, l);
;	genCmpGt
;	AOP_STK for _bitmap_seek_sloc3_1_0
	ld	a,#0x00
	sub	a,-11(ix)
	ld	a,#0x00
	sbc	a,-10(ix)
	jp	p,00113$
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	ld	hl,#0x0008
	push	hl
;	genIpush
;	AOP_STK for _bitmap_seek_i_1_1
	ld	l,-4(ix)
	ld	h,-3(ix)
	push	hl
;	genCall
	call	__divsint_rrx_s
	ld	d,h
	ld	e,l
	pop	af
	pop	af
	pop	bc
;	genPlus
;	AOP_STK for _bitmap_seek_sloc1_1_0
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,-8(ix)
	add	a,e
	ld	e,a
	ld	a,-7(ix)
	adc	a,d
	ld	d,a
;	genPointerGet
;	AOP_STK for _bitmap_seek_sloc2_1_0
	ld	a,(de)
	ld	-9(ix),a
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	ld	hl,#0x0008
	push	hl
;	genIpush
;	AOP_STK for _bitmap_seek_i_1_1
	ld	l,-4(ix)
	ld	h,-3(ix)
	push	hl
;	genCall
	call	__modsint_rrx_s
	ld	e,h
	ld	d,l
	pop	af
	pop	af
	pop	bc
;	genLeftShift
	ld	a,d
	inc	a
	push	af
	ld	d,#0x01
	ld	e,#0x00
	pop	af
	jp	00142$
00141$:
	sla	d
	rl	e
00142$:
	dec	a
	jp	nz,00141$
;	genCast
; Removed redundent load
;	genAnd
;	AOP_STK for _bitmap_seek_sloc2_1_0
	ld	a,-9(ix)
	and	a,d
;	genIfx
	or	a,a
	jp	nz,00113$
;	genPlus
;	AOP_STK for _bitmap_seek_i_1_1
;	genPlusIncr
	inc	-4(ix)
	jp	nz,00143$
	inc	-3(ix)
00143$:
;	genMinus
;	AOP_STK for _bitmap_seek_sloc3_1_0
	ld	l,-11(ix)
	ld	h,-10(ix)
	dec	hl
	ld	-11(ix),l
	ld	-10(ix),h
;	genGoto
	jp	00110$
;	genLabel
00113$:
;bitmap.c:45: if (l == 0)
;	genIfx
;	AOP_STK for _bitmap_seek_sloc3_1_0
	ld	a,-11(ix)
	or	a,-10(ix)
	jp	nz,00115$
;bitmap.c:46: return b; /* Yes. */
;	genAssign
;	AOP_STK for 
	ld	l,8(ix)
	ld	h,9(ix)
;	genRet
; Dump of IC_LEFT: type AOP_STR size 2
	jp	00119$
;	genLabel
00115$:
;bitmap.c:49: b = i + 1;
;	genPlus
;	AOP_STK for _bitmap_seek_i_1_1
;	AOP_STK for 
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,-4(ix)
	add	a,#0x01
	ld	8(ix),a
	ld	a,-3(ix)
	adc	a,#0x00
	ld	9(ix),a
;	genGoto
	jp	00116$
;	genLabel
00118$:
;bitmap.c:52: return 0; /* Nothing found. */
;	genRet
; Dump of IC_LEFT: type AOP_LIT size 2
	ld	hl,#0x0000
;	genLabel
00119$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_bitmap_seek_end::
__str_0:
	.ascii "bitmap_seek: Wanted len is greater than bitmap size."
	.db 0x0A
	.db 0x00
	.area _CODE
