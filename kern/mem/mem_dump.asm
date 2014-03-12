;--------------------------------------------------------
; File Created by SDCC : FreeWare ANSI-C Compiler
; Version 2.6.0 #4309 (Oct 17 2006)
; This file generated Thu Oct 19 04:08:17 2006
;--------------------------------------------------------
	.module mem_dump
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _mem_dump
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
;mem_dump.c:26: mem_dump ()
;	genLabel
;	genFunction
;	---------------------------------
; Function mem_dump
; ---------------------------------
_mem_dump_start::
_mem_dump:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-6
	add	hl,sp
	ld	sp,hl
;mem_dump.c:29: int c = 0;
;	genAssign
;	AOP_STK for _mem_dump_c_1_1
	ld	-4(ix),#0x00
	ld	-3(ix),#0x00
;mem_dump.c:37: printk ("page map: *=locked, 0-3=page or frag, []=multipage, .=free\n", 0);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0x0000
	push	hl
;	genIpush
	ld	hl,#__str_0
	push	hl
;	genCall
	call	_printk
	pop	af
	pop	af
;mem_dump.c:38: for (i = 0; i < NUM_PAGES; i++) {
;	genAssign
;	AOP_STK for _mem_dump_i_1_1
	ld	-2(ix),#0x00
	ld	-1(ix),#0x00
;	genLabel
00118$:
;	genCast
;	AOP_STK for _mem_dump_i_1_1
	ld	c,-2(ix)
	ld	b,-1(ix)
	ld	a,b
	rla	
	sbc	a,a
	ld	e,a
	ld	d,a
;	genCmpLt
	ld	a,c
	sub	a,#0x00
	ld	a,b
	sbc	a,#0x01
	ld	a,e
	sbc	a,#0x00
	ld	a,d
	sbc	a,#0x00
	jp	p,00121$
;mem_dump.c:39: ct = PAGE_CONT(i);
;	genPlus
;	AOP_STK for _mem_dump_i_1_1
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
	ld	c,a
;	genCast
;	AOP_STK for _mem_dump_ct_1_1
	ld	-6(ix),c
	ld	-5(ix),#0x00
;mem_dump.c:40: if (!(i % 16) && i != 0)
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0x0010
	push	hl
;	genIpush
;	AOP_STK for _mem_dump_i_1_1
	ld	l,-2(ix)
	ld	h,-1(ix)
	push	hl
;	genCall
	call	__modsint_rrx_s
	ld	d,h
	ld	e,l
	pop	af
	pop	af
;	genIfx
	ld	a,e
	or	a,d
	jp	nz,00102$
;	genCmpEq
;	AOP_STK for _mem_dump_i_1_1
; genCmpEq: left 2, right 2, result 0
	ld	a,-2(ix)
	or	a,-1(ix)
	jp	z,00102$
00144$:
;mem_dump.c:41: printk ("\n", 0);
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
;	genLabel
00102$:
;mem_dump.c:42: if (!(i % 16)) {
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0x0010
	push	hl
;	genIpush
;	AOP_STK for _mem_dump_i_1_1
	ld	l,-2(ix)
	ld	h,-1(ix)
	push	hl
;	genCall
	call	__modsint_rrx_s
	ld	d,h
	ld	e,l
	pop	af
	pop	af
;	genIfx
	ld	a,e
	or	a,d
	jp	nz,00105$
;mem_dump.c:43: printnhex (PAGESIZE * i, 4);
;	genLeftShift
;	AOP_STK for _mem_dump_i_1_1
	ld	d,-2(ix)
	ld	e,#0x00
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
;mem_dump.c:44: printk (": ", 0);
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
;	genLabel
00105$:
;mem_dump.c:46: if (PAGE_LOCKED(i)) {
;	genPlus
;	AOP_STK for _mem_dump_i_1_1
;	Can't optimise plus by inc, falling back to the normal way
	ld	iy,#_page_list
	ld	a,0(iy)
	add	a,-2(ix)
	ld	e,a
	ld	a,1(iy)
	adc	a,-1(ix)
	ld	d,a
;	genPointerGet
	ld	a,(de)
;	genAnd
	ld	e,a
	and	a,#0x04
	jp	z,00113$
00145$:
;	genAnd
	ld	a,e
	and	a,#0x03
	jp	z,00113$
00146$:
;mem_dump.c:47: printk ("* ", 0);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0x0000
	push	hl
;	genIpush
	ld	hl,#__str_3
	push	hl
;	genCall
	call	_printk
	pop	af
	pop	af
;mem_dump.c:48: ct = 0;
;	genAssign
;	AOP_STK for _mem_dump_ct_1_1
	ld	-6(ix),#0x00
	ld	-5(ix),#0x00
;	genGoto
	jp	00114$
;	genLabel
00113$:
;mem_dump.c:49: } else if (PAGE_USED(i)) {
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0x0008
	push	hl
;	genIpush
;	AOP_STK for _mem_dump_i_1_1
	ld	l,-2(ix)
	ld	h,-1(ix)
	push	hl
;	genCall
	call	__divsint_rrx_s
	ld	d,h
	ld	e,l
	pop	af
	pop	af
;	genPlus
;	Can't optimise plus by inc, falling back to the normal way
	ld	iy,#_page_map
	ld	a,0(iy)
	add	a,e
	ld	e,a
	ld	a,1(iy)
	adc	a,d
	ld	d,a
;	genPointerGet
	ld	a,(de)
	ld	e,a
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 1 bcInUse: 0 deSending: 0
	push	de
	ld	hl,#0x0008
	push	hl
;	genIpush
;	AOP_STK for _mem_dump_i_1_1
	ld	l,-2(ix)
	ld	h,-1(ix)
	push	hl
;	genCall
	call	__modsint_rrx_s
	ld	c,h
	ld	d,l
	pop	af
	pop	af
	ld	a,d
	pop	de
;	genLeftShift
	ld	d,a
	inc	a
	push	af
	ld	d,#0x01
	ld	c,#0x00
	pop	af
	jp	00148$
00147$:
	sla	d
	rl	c
00148$:
	dec	a
	jp	nz,00147$
;	genCast
; Removed redundent load
;	genAnd
	ld	a,e
	and	a,d
;	genIfx
	or	a,a
	jp	z,00110$
;mem_dump.c:50: if (FRAGLOG(i) == 0)
;	genPlus
;	AOP_STK for _mem_dump_i_1_1
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
	and	a,#0x03
	ld	c,a
;	genIfx
	xor	a,a
	or	a,c
	jp	nz,00107$
;mem_dump.c:51: printk (ct ? (!c ? "[ " : "X ") : (c ? "] " : "0 "), 0);
;	genIfx
;	AOP_STK for _mem_dump_ct_1_1
	ld	a,-6(ix)
	or	a,-5(ix)
	jp	z,00124$
;	genNot
;	AOP_STK for _mem_dump_c_1_1
	ld	a,-4(ix)
	or	a,-3(ix)
	sub	a,#0x01
	ld	a,#0x00
	rla
;	genIfx
	ld	b,a
	or	a,a
	jp	z,00126$
;	genAssign
	ld	de,#__str_4
;	genGoto
	jp	00127$
;	genLabel
00126$:
;	genAssign
	ld	de,#__str_5
;	genLabel
00127$:
;	genAssign
;	(registers are the same)
;	genGoto
	jp	00125$
;	genLabel
00124$:
;	genIfx
;	AOP_STK for _mem_dump_c_1_1
	ld	a,-4(ix)
	or	a,-3(ix)
	jp	z,00128$
;	genAssign
	ld	bc,#__str_6
;	genGoto
	jp	00129$
;	genLabel
00128$:
;	genAssign
	ld	bc,#__str_7
;	genLabel
00129$:
;	genAssign
	ld	e,c
	ld	d,b
;	genLabel
00125$:
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0x0000
	push	hl
;	genIpush
	push	de
;	genCall
	call	_printk
	pop	af
	pop	af
;	genGoto
	jp	00114$
;	genLabel
00107$:
;mem_dump.c:53: printk ("%d ", FRAGLOG(i));
;	genCast
; Removed redundent load
	ld	b,#0x00
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	push	bc
;	genIpush
	ld	hl,#__str_8
	push	hl
;	genCall
	call	_printk
	pop	af
	pop	af
;	genGoto
	jp	00114$
;	genLabel
00110$:
;mem_dump.c:55: printk (". ", 0); /* free */
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0x0000
	push	hl
;	genIpush
	ld	hl,#__str_9
	push	hl
;	genCall
	call	_printk
	pop	af
	pop	af
;	genLabel
00114$:
;mem_dump.c:56: if ((i % 4) == 3)
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0x0004
	push	hl
;	genIpush
;	AOP_STK for _mem_dump_i_1_1
	ld	l,-2(ix)
	ld	h,-1(ix)
	push	hl
;	genCall
	call	__modsint_rrx_s
	ld	b,h
	ld	c,l
	pop	af
	pop	af
;	genCmpEq
; genCmpEq: left 2, right 2, result 0
	ld	a,c
	cp	a,#0x03
	jp	nz,00149$
	ld	a,b
	or	a,a
	jp	z,00150$
00149$:
	jp	00117$
00150$:
;mem_dump.c:57: printk (" ", 0);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0x0000
	push	hl
;	genIpush
	ld	hl,#__str_10
	push	hl
;	genCall
	call	_printk
	pop	af
	pop	af
;	genLabel
00117$:
;mem_dump.c:58: c = ct;
;	genAssign
;	AOP_STK for _mem_dump_ct_1_1
;	AOP_STK for _mem_dump_c_1_1
	ld	a,-6(ix)
	ld	-4(ix),a
	ld	a,-5(ix)
	ld	-3(ix),a
;mem_dump.c:38: for (i = 0; i < NUM_PAGES; i++) {
;	genPlus
;	AOP_STK for _mem_dump_i_1_1
;	genPlusIncr
	inc	-2(ix)
	jp	nz,00151$
	inc	-1(ix)
00151$:
;	genGoto
	jp	00118$
;	genLabel
00121$:
;mem_dump.c:72: printk ("\n%d bytes free.\n", (int) (PAGESIZE * mem_num_pages_free));
;	genLeftShift
	ld	iy,#_mem_num_pages_free
	ld	b,0(iy)
	ld	c,#0x00
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	push	bc
;	genIpush
	ld	hl,#__str_11
	push	hl
;	genCall
	call	_printk
	pop	af
	pop	af
;	genLabel
00122$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_mem_dump_end::
__str_0:
	.ascii "page map: *=locked, 0-3=page or frag, []=multipage, .=free"
	.db 0x0A
	.db 0x00
__str_1:
	.db 0x0A
	.db 0x00
__str_2:
	.ascii ": "
	.db 0x00
__str_3:
	.ascii "* "
	.db 0x00
__str_4:
	.ascii "[ "
	.db 0x00
__str_5:
	.ascii "X "
	.db 0x00
__str_6:
	.ascii "] "
	.db 0x00
__str_7:
	.ascii "0 "
	.db 0x00
__str_8:
	.ascii "%d "
	.db 0x00
__str_9:
	.ascii ". "
	.db 0x00
__str_10:
	.ascii " "
	.db 0x00
__str_11:
	.db 0x0A
	.ascii "%d bytes free."
	.db 0x0A
	.db 0x00
	.area _CODE
