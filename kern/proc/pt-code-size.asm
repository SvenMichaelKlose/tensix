;--------------------------------------------------------
; File Created by SDCC : FreeWare ANSI-C Compiler
; Version 2.6.0 #4309 (Oct 17 2006)
; This file generated Wed Oct 18 21:42:07 2006
;--------------------------------------------------------
	.module lock
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _lock_read_unref
	.globl _lock_write_ref
	.globl _lock_read_ref
	.globl _lock_wakeup
	.globl _lock_ref2
	.globl _lock_ref
	.globl _lock_ref_wait
	.globl _lock_unref
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
;lock.c:48: lock_ref2 (lock_t *lockp, bool do_wait)
;	genLabel
;	genFunction
;	---------------------------------
; Function lock_ref2
; ---------------------------------
_lock_ref2_start::
_lock_ref2:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-2
	add	hl,sp
	ld	sp,hl
;lock.c:50: struct proc *proc = CURRENT_PROC();
;	genAssign
;	AOP_STK for _lock_ref2_proc_1_1
	ld	hl,(_proc_current)
	ld	-2(ix),l
	ld	-1(ix),h
;lock.c:58: (*lockp)++;
;	genAssign
;	AOP_STK for 
	ld	e,4(ix)
	ld	d,5(ix)
;	genPointerGet
	ld	a,(de)
;	genPlus
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	c,a
	add	a,#0x01
;	genAssign (pointer)
;	isBitvar = 0
	ld	(de),a
;lock.c:61: if (do_wait == FALSE && *lockp == 1) {
;	genIfx
;	AOP_STK for 
	xor	a,a
	or	a,6(ix)
	jp	nz,00102$
;	genPointerGet
	ld	a,(de)
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	c,a
	cp	a,#0x01
	jp	z,00116$
00115$:
	jp	00102$
00116$:
;lock.c:63: return;
;	genRet
	jp	00109$
;	genLabel
00102$:
;lock.c:67: proc->lock = lockp;
;	genPlus
;	AOP_STK for _lock_ref2_proc_1_1
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,-2(ix)
	add	a,#0x21
	ld	c,a
	ld	a,-1(ix)
	adc	a,#0x00
	ld	b,a
;	genAssign (pointer)
;	isBitvar = 0
	ld	l,c
	ld	h,b
	ld	(hl),e
	inc	hl
	ld	(hl),d
;lock.c:70: do {
;	genAssign
;	(registers are the same)
;	genLabel
00106$:
;lock.c:71: sleep (); /* Sleep. Will put switching on again. */
;	genCall
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	call	_sleep
	pop	bc
;lock.c:74: if (proc->lock == NULL) {
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
	jp	z,00118$
00117$:
	jp	00106$
00118$:
;lock.c:75: printk ("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&", 0);
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
;lock.c:78: } while (1);
;	genLabel
00109$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_lock_ref2_end::
__str_0:
	.ascii "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
	.ascii "&&&&&&&&&&&&&&&&&&&&&&"
	.db 0x00
;lock.c:82: lock_ref (lock_t *lockp)
;	genLabel
;	genFunction
;	---------------------------------
; Function lock_ref
; ---------------------------------
_lock_ref_start::
_lock_ref:
	push	ix
	ld	ix,#0
	add	ix,sp
;lock.c:84: lock_ref2 (lockp, FALSE);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	a,#0x00
	push	af
	inc	sp
;	genIpush
;	AOP_STK for 
	ld	l,4(ix)
	ld	h,5(ix)
	push	hl
;	genCall
	call	_lock_ref2
	pop	af
	inc	sp
;	genLabel
00101$:
;	genEndFunction
	pop	ix
	ret
_lock_ref_end::
;lock.c:88: lock_ref_wait (lock_t *lockp)
;	genLabel
;	genFunction
;	---------------------------------
; Function lock_ref_wait
; ---------------------------------
_lock_ref_wait_start::
_lock_ref_wait:
	push	ix
	ld	ix,#0
	add	ix,sp
;lock.c:90: lock_ref2 (lockp, TRUE);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	a,#0xFF
	push	af
	inc	sp
;	genIpush
;	AOP_STK for 
	ld	l,4(ix)
	ld	h,5(ix)
	push	hl
;	genCall
	call	_lock_ref2
	pop	af
	inc	sp
;	genLabel
00101$:
;	genEndFunction
	pop	ix
	ret
_lock_ref_wait_end::
;lock.c:94: lock_wakeup (lock_t *lockp)
;	genLabel
;	genFunction
;	---------------------------------
; Function lock_wakeup
; ---------------------------------
_lock_wakeup_start::
_lock_wakeup:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-2
	add	hl,sp
	ld	sp,hl
;lock.c:97: struct proc *i_proc = (struct proc *) CURRENT_PROC();
;	genAssign
;	AOP_STK for _lock_wakeup_i_proc_1_1
	ld	hl,(_proc_current)
	ld	-2(ix),l
	ld	-1(ix),h
;lock.c:99: do {
;	genLabel
00103$:
;lock.c:100: if (i_proc->lock != lockp) {
;	genPlus
;	AOP_STK for _lock_wakeup_i_proc_1_1
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,-2(ix)
	add	a,#0x21
	ld	e,a
	ld	a,-1(ix)
	adc	a,#0x00
	ld	d,a
;	genPointerGet
	ld	l,e
	ld	h,d
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
;	genCmpEq
;	AOP_STK for 
; genCmpEq: left 2, right 2, result 0
	ld	a,4(ix)
	cp	c
	jp	nz,00110$
	ld	a,5(ix)
	cp	b
	jp	z,00102$
00110$:
;lock.c:101: i_proc = (struct proc*) i_proc->next;
;	genPlus
;	AOP_STK for _lock_wakeup_i_proc_1_1
;	genPlusIncr
	ld	c,-2(ix)
	ld	b,-1(ix)
	inc	bc
	inc	bc
;	genPointerGet
	ld	l,c
	ld	h,b
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
;	genAssign
;	AOP_STK for _lock_wakeup_i_proc_1_1
	ld	-2(ix),c
	ld	-1(ix),b
;lock.c:102: continue;
;	genGoto
	jp	00104$
;	genLabel
00102$:
;lock.c:106: i_proc->lock = NULL;
;	genAssign (pointer)
;	isBitvar = 0
	ld	l,e
	ld	h,d
	ld	(hl),#0x00
	inc	hl
	ld	(hl),#0x00
;lock.c:109: proc_wakeup (i_proc);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
;	AOP_STK for _lock_wakeup_i_proc_1_1
	ld	l,-2(ix)
	ld	h,-1(ix)
	push	hl
;	genCall
	call	_proc_wakeup
	pop	af
;lock.c:111: break;
;	genGoto
	jp	00106$
;	genLabel
00104$:
;lock.c:112: } while (i_proc != CURRENT_PROC());
;	genCmpEq
;	AOP_STK for _lock_wakeup_i_proc_1_1
; genCmpEq: left 2, right 2, result 0
	ld	iy,#_proc_current
	ld	a,0(iy)
	cp	-2(ix)
	jp	nz,00111$
	ld	a,1(iy)
	cp	-1(ix)
	jp	z,00112$
00111$:
	jp	00103$
00112$:
;	genLabel
00106$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_lock_wakeup_end::
;lock.c:120: lock_unref (lock_t *lockp)
;	genLabel
;	genFunction
;	---------------------------------
; Function lock_unref
; ---------------------------------
_lock_unref_start::
_lock_unref:
	push	ix
	ld	ix,#0
	add	ix,sp
;lock.c:126: if (lockp == NULL)
;	genAssign
;	AOP_STK for 
	ld	c,4(ix)
	ld	b,5(ix)
;	genCmpEq
; genCmpEq: left 2, right 2, result 0
	ld	a,c
	or	a,b
	jp	z,00113$
00112$:
	jp	00102$
00113$:
;lock.c:127: panic ("lock_unref(): NULL ptr arg");
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	ld	hl,#__str_1
	push	hl
;	genCall
	call	_panic
	pop	af
	pop	bc
;	genLabel
00102$:
;lock.c:134: if (*lockp == 0) {
;	genPointerGet
	ld	a,(bc)
;	genIfx
	or	a,a
	jp	nz,00104$
;lock.c:136: panic ("Lock underflow.");
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	ld	hl,#__str_2
	push	hl
;	genCall
	call	_panic
	pop	af
	pop	bc
;	genLabel
00104$:
;lock.c:141: (*lockp)--;
;	genPointerGet
	ld	a,(bc)
	ld	e,a
;	genMinus
	dec	e
;	genAssign (pointer)
;	isBitvar = 0
	ld	a,e
	ld	(bc),a
;lock.c:144: if (*lockp != 0)
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	a,e
	or	a,a
	jp	z,00107$
00114$:
;lock.c:145: lock_wakeup (lockp);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	push	bc
;	genCall
	call	_lock_wakeup
	pop	af
;	genLabel
00107$:
;	genEndFunction
	pop	ix
	ret
_lock_unref_end::
__str_1:
	.ascii "lock_unref(): NULL ptr arg"
	.db 0x00
__str_2:
	.ascii "Lock underflow."
	.db 0x00
;lock.c:151: lock_read_ref (struct rwlock_t *lockp)
;	genLabel
;	genFunction
;	---------------------------------
; Function lock_read_ref
; ---------------------------------
_lock_read_ref_start::
_lock_read_ref:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-2
	add	hl,sp
	ld	sp,hl
;lock.c:158: while (1) {
;	genAssign
;	AOP_STK for 
;	AOP_STK for _lock_read_ref_sloc0_1_0
	ld	a,4(ix)
	ld	-2(ix),a
	ld	a,5(ix)
	ld	-1(ix),a
;	genPlus
;	AOP_STK for _lock_read_ref_sloc0_1_0
;	genPlusIncr
	ld	e,-2(ix)
	ld	d,-1(ix)
	inc	de
;	genLabel
00104$:
;lock.c:160: if (!lockp->lock) {
;	genPointerGet
	ld	a,(de)
;	genIfx
	or	a,a
	jp	nz,00102$
;lock.c:161: lockp->passed++;
;	genPointerGet
;	AOP_STK for _lock_read_ref_sloc0_1_0
	ld	l,-2(ix)
	ld	h,-1(ix)
	ld	c,(hl)
;	genPlus
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,c
	add	a,#0x01
;	genAssign (pointer)
;	AOP_STK for _lock_read_ref_sloc0_1_0
;	isBitvar = 0
	ld	l,-2(ix)
	ld	h,-1(ix)
	ld	(hl),a
;lock.c:162: break;
;	genGoto
	jp	00106$
;	genLabel
00102$:
;lock.c:166: lock_ref (&lockp->lock);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 1 bcInUse: 0 deSending: 0
	push	de
	push	de
;	genCall
	call	_lock_ref
	pop	af
	pop	de
;lock.c:167: lock_unref (&lockp->lock);
;	genPlus
;	AOP_STK for _lock_read_ref_sloc0_1_0
;	genPlusIncr
	ld	c,-2(ix)
	ld	b,-1(ix)
	inc	bc
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 1 bcInUse: 0 deSending: 0
	push	de
	push	bc
;	genCall
	call	_lock_unref
	pop	af
	pop	de
;	genGoto
	jp	00104$
;	genLabel
00106$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_lock_read_ref_end::
;lock.c:175: lock_write_ref (struct rwlock_t *lockp)
;	genLabel
;	genFunction
;	---------------------------------
; Function lock_write_ref
; ---------------------------------
_lock_write_ref_start::
_lock_write_ref:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-2
	add	hl,sp
	ld	sp,hl
;lock.c:182: if (lockp->passed) {
;	genAssign
;	AOP_STK for 
	ld	c,4(ix)
	ld	b,5(ix)
;	genPointerGet
	ld	a,(bc)
;	genIfx
	or	a,a
	jp	z,00102$
;lock.c:183: lockp->lock++;
;	genPlus
;	AOP_STK for _lock_write_ref_sloc0_1_0
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,c
	add	a,#0x01
	ld	-2(ix),a
	ld	a,b
	adc	a,#0x00
	ld	-1(ix),a
;	genPointerGet
;	AOP_STK for _lock_write_ref_sloc0_1_0
	ld	l,-2(ix)
	ld	h,-1(ix)
	ld	e,(hl)
;	genPlus
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,e
	add	a,#0x01
;	genAssign (pointer)
;	AOP_STK for _lock_write_ref_sloc0_1_0
;	isBitvar = 0
	ld	l,-2(ix)
	ld	h,-1(ix)
	ld	(hl),a
;lock.c:184: lock_ref (&lockp->lock);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
;	AOP_STK for _lock_write_ref_sloc0_1_0
	ld	l,-2(ix)
	ld	h,-1(ix)
	push	hl
;	genCall
	call	_lock_ref
	pop	af
	pop	bc
;lock.c:185: lockp->lock--;
;	genPlus
;	AOP_STK for _lock_write_ref_sloc0_1_0
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,c
	add	a,#0x01
	ld	-2(ix),a
	ld	a,b
	adc	a,#0x00
	ld	-1(ix),a
;	genPointerGet
;	AOP_STK for _lock_write_ref_sloc0_1_0
	ld	l,-2(ix)
	ld	h,-1(ix)
	ld	e,(hl)
;	genMinus
	ld	a,e
	add	a,#0xFF
;	genAssign (pointer)
;	AOP_STK for _lock_write_ref_sloc0_1_0
;	isBitvar = 0
	ld	l,-2(ix)
	ld	h,-1(ix)
	ld	(hl),a
;	genGoto
	jp	00104$
;	genLabel
00102$:
;lock.c:187: lock_ref (&lockp->lock);
;	genPlus
;	genPlusIncr
	inc	bc
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	push	bc
;	genCall
	call	_lock_ref
	pop	af
;	genLabel
00104$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_lock_write_ref_end::
;lock.c:196: lock_read_unref (struct rwlock_t *lockp)
;	genLabel
;	genFunction
;	---------------------------------
; Function lock_read_unref
; ---------------------------------
_lock_read_unref_start::
_lock_read_unref:
	push	ix
	ld	ix,#0
	add	ix,sp
;lock.c:202: if (lockp == NULL)
;	genCmpEq
;	AOP_STK for 
; genCmpEq: left 2, right 2, result 0
	ld	a,4(ix)
	or	a,5(ix)
	jp	z,00115$
00114$:
	jp	00102$
00115$:
;lock.c:203: panic ("lock_read_unref(): NULL ptr arg");
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#__str_3
	push	hl
;	genCall
	call	_panic
	pop	af
;	genLabel
00102$:
;lock.c:210: if (lockp->passed == 0) {
;	genAssign
;	AOP_STK for 
	ld	c,4(ix)
	ld	b,5(ix)
;	genPointerGet
	ld	a,(bc)
;	genIfx
	or	a,a
	jp	nz,00104$
;lock.c:212: panic ("Read lock underflow.");
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	ld	hl,#__str_4
	push	hl
;	genCall
	call	_panic
	pop	af
	pop	bc
;	genLabel
00104$:
;lock.c:216: if ((!--lockp->passed) && (lockp->lock))
;	genPointerGet
	ld	a,(bc)
;	genMinus
	ld	e,a
	add	a,#0xFF
;	genAssign (pointer)
;	isBitvar = 0
	ld	(bc),a
;	genIfx
	or	a,a
	jp	nz,00108$
;	genPlus
;	genPlusIncr
	inc	bc
;	genPointerGet
	ld	a,(bc)
;	genIfx
	or	a,a
	jp	z,00108$
;lock.c:217: lock_wakeup (&lockp->lock);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	push	bc
;	genCall
	call	_lock_wakeup
	pop	af
;	genLabel
00108$:
;	genEndFunction
	pop	ix
	ret
_lock_read_unref_end::
__str_3:
	.ascii "lock_read_unref(): NULL ptr arg"
	.db 0x00
__str_4:
	.ascii "Read lock underflow."
	.db 0x00
	.area _CODE
