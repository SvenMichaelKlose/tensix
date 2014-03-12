;--------------------------------------------------------
; File Created by SDCC : FreeWare ANSI-C Compiler
; Version 2.6.0 #4309 (Oct 17 2006)
; This file generated Thu Oct 19 04:08:19 2006
;--------------------------------------------------------
	.module proc
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _procs_sleeping
	.globl _procs_running
	.globl _proc_pool
	.globl _proc_id
	.globl _proc_holographic
	.globl _proc_context
	.globl _proc_current
	.globl _proc_init
	.globl _proc_create
	.globl _proc_exec
	.globl _proc_startup
	.globl _proc_kill
	.globl _exit
	.globl _proc_funexec
	.globl _proc_sleep
	.globl _proc_wakeup
	.globl _sleep
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
;  ram data
;--------------------------------------------------------
	.area _DATA
_proc_current::
	.ds 2
_proc_context::
	.ds 2
_proc_holographic::
	.ds 40
_proc_id::
	.ds 1
_proc_pool::
	.ds 11
_procs_running::
	.ds 4
_procs_sleeping::
	.ds 4
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
;proc.c:54: proc_init ()
;	genLabel
;	genFunction
;	---------------------------------
; Function proc_init
; ---------------------------------
_proc_init_start::
_proc_init:
;proc.c:58: proc_id = -1; /* Holographic proc id must be -1! */
;	genAssign
	ld	iy,#_proc_id
	ld	0(iy),#0xFF
;proc.c:61: p = POOL_CREATE(&proc_pool, PROC_MAX, struct proc);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0x0028
	push	hl
;	genIpush
	ld	hl,#0x0010
	push	hl
;	genIpush
	ld	hl,#_proc_pool
	push	hl
;	genCall
	call	_pool_create
	ld	b,h
	ld	c,l
	pop	af
	pop	af
	pop	af
;	genAssign
;	(registers are the same)
;proc.c:62: IASSERT(p == NULL, "proc: no mem");
;	genCmpEq
; genCmpEq: left 2, right 2, result 0
	ld	a,c
	or	a,b
	jp	z,00107$
00106$:
	jp	00102$
00107$:
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#__str_0
	push	hl
;	genCall
	call	_panic
	pop	af
;	genLabel
00102$:
;proc.c:65: DEQUEUE_WIPE(&procs_sleeping);
;	genPlus
;	genPlusIncr
	ld	bc,#_procs_sleeping + 2
;	genAssign (pointer)
;	isBitvar = 0
	ld	l,c
	ld	h,b
	ld	(hl),#0x00
	inc	hl
	ld	(hl),#0x00
;	genAssign (pointer)
;	isBitvar = 0
	ld	hl,#_procs_sleeping
	ld	(hl),#0x00
	inc	hl
	ld	(hl),#0x00
;proc.c:66: DEQUEUE_WIPE(&procs_running);
;	genPlus
;	genPlusIncr
	ld	bc,#_procs_running + 2
;	genAssign (pointer)
;	isBitvar = 0
	ld	l,c
	ld	h,b
	ld	(hl),#0x00
	inc	hl
	ld	(hl),#0x00
;	genAssign (pointer)
;	isBitvar = 0
	ld	hl,#_procs_running
	ld	(hl),#0x00
	inc	hl
	ld	(hl),#0x00
;proc.c:70: proc_current->name = "holographic";
;	genAssign
	ld	bc,(_proc_current)
;	genPlus
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,c
	add	a,#0x26
	ld	c,a
	ld	a,b
	adc	a,#0x00
	ld	b,a
;	genAssign (pointer)
;	isBitvar = 0
	ld	l,c
	ld	h,b
	ld	(hl),#<__str_1
	inc	hl
	ld	(hl),#>__str_1
;proc.c:79: proc_context = NULL; /* Do not switch! */
;	genAssign
	ld	iy,#_proc_context
	ld	0(iy),#0x00
	ld	1(iy),#0x00
;proc.c:81: VERBOSE_BOOT_PRINTK("proc: %d tasks.\n", PROC_MAX);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0x0010
	push	hl
;	genIpush
	ld	hl,#__str_2
	push	hl
;	genCall
	call	_printk
	pop	af
	pop	af
;	genLabel
00103$:
;	genEndFunction
	ret
_proc_init_end::
__str_0:
	.ascii "proc: no mem"
	.db 0x00
__str_1:
	.ascii "holographic"
	.db 0x00
__str_2:
	.ascii "proc: %d tasks."
	.db 0x0A
	.db 0x00
;proc.c:91: proc_create (struct proc **proc, char *name)
;	genLabel
;	genFunction
;	---------------------------------
; Function proc_create
; ---------------------------------
_proc_create_start::
_proc_create:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-2
	add	hl,sp
	ld	sp,hl
;proc.c:99: p = POOL_SALLOC(&proc_pool);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#_proc_pool
	push	hl
;	genCall
	call	_pool_salloc
	ld	b,h
	ld	c,l
	pop	af
;	genAssign
;	(registers are the same)
;	genAssign
;	(registers are the same)
;proc.c:100: ERRCHK(p == NULL, ENOMEM);
;	genCmpEq
; genCmpEq: left 2, right 2, result 0
	ld	a,c
	or	a,b
	jp	z,00113$
00112$:
	jp	00102$
00113$:
;	genRet
; Dump of IC_LEFT: type AOP_LIT size 2
	ld	hl,#0x0001
	jp	00107$
;	genLabel
00102$:
;proc.c:101: p->name = name;
;	genPlus
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,c
	add	a,#0x26
	ld	e,a
	ld	a,b
	adc	a,#0x00
	ld	d,a
;	genAssign (pointer)
;	AOP_STK for 
;	isBitvar = 0
	ld	l,e
	ld	h,d
	ld	a,6(ix)
	ld	(hl),a
	inc	hl
	ld	a,7(ix)
	ld	(hl),a
;proc.c:102: p->state = 0;
;	genPlus
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,c
	add	a,#0x20
	ld	e,a
	ld	a,b
	adc	a,#0x00
	ld	d,a
;	genAssign (pointer)
;	isBitvar = 0
	ld	a,#0x00
	ld	(de),a
;proc.c:104: p->ticks_run = 0;
;	genPlus
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,c
	add	a,#0x23
	ld	e,a
	ld	a,b
	adc	a,#0x00
	ld	d,a
;	genAssign (pointer)
;	isBitvar = 0
	ld	l,e
	ld	h,d
	ld	(hl),#0x00
	inc	hl
	ld	(hl),#0x00
;proc.c:106: p->id = proc_id;
;	genPlus
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,c
	add	a,#0x25
	ld	e,a
	ld	a,b
	adc	a,#0x00
	ld	d,a
;	genAssign (pointer)
;	isBitvar = 0
	ld	iy,#_proc_id
	ld	a,0(iy)
	ld	(de),a
;proc.c:109: proc_id++;
;	genPlus
;	genPlusIncr
	inc	0(iy)
;proc.c:110: if (proc_id == 0)
;	genIfx
	xor	a,a
	or	a,0(iy)
	jp	nz,00104$
;proc.c:111: proc_id = 1;
;	genAssign
	ld	0(iy),#0x01
;	genLabel
00104$:
;proc.c:114: mem_init_proc (p);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	push	bc
;	genCall
	call	_mem_init_proc
	pop	af
	pop	bc
;proc.c:118: err = fs_init_proc (p);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	push	bc
;	genCall
	call	_fs_init_proc
	ld	d,h
	ld	e,l
	pop	af
	pop	bc
;	genAssign
;	AOP_STK for _proc_create_err_1_1
	ld	-2(ix),e
	ld	-1(ix),d
;proc.c:119: if (err != ENONE) {
;	genCmpEq
;	AOP_STK for _proc_create_err_1_1
; genCmpEq: left 2, right 2, result 0
	ld	a,-2(ix)
	or	a,-1(ix)
	jp	z,00106$
00114$:
;proc.c:121: POOL_SFREE(&proc_pool, p);
;	genPlus
;	genPlusIncr
	ld	de,#_proc_pool + 4
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	push	bc
;	genIpush
	push	de
;	genCall
	call	_dequeue_push
	pop	af
	pop	af
;proc.c:122: return err;
;	genRet
;	AOP_STK for _proc_create_err_1_1
; Dump of IC_LEFT: type AOP_STK size 2
;	 aop_stk -2
	ld	l,-2(ix)
	ld	h,-1(ix)
	jp	00107$
;	genLabel
00106$:
;proc.c:127: CLIST_INSERT(&procs_sleeping, p);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	push	bc
;	genIpush
	ld	hl,#_procs_sleeping
	push	hl
;	genCall
	call	_clist_insert
	pop	af
	pop	af
	pop	bc
;proc.c:129: *proc = p;
;	genAssign
;	AOP_STK for 
	ld	e,4(ix)
	ld	d,5(ix)
	push	de
	pop	iy
;	genAssign (pointer)
;	isBitvar = 0
	ld	0(iy),c
	ld	1(iy),b
;proc.c:131: return ENONE;
;	genRet
; Dump of IC_LEFT: type AOP_LIT size 2
	ld	hl,#0x0000
;	genLabel
00107$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_proc_create_end::
;proc.c:143: proc_exec (struct proc *proc, void *entry)
;	genLabel
;	genFunction
;	---------------------------------
; Function proc_exec
; ---------------------------------
_proc_exec_start::
_proc_exec:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-2
	add	hl,sp
	ld	sp,hl
;proc.c:152: if (proc->stacksize != 0) {
;	genAssign
;	AOP_STK for 
	ld	c,4(ix)
	ld	b,5(ix)
;	genPlus
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,c
	add	a,#0x0E
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
;	genCmpEq
; genCmpEq: left 2, right 2, result 0
	ld	a,e
	or	a,d
	jp	z,00104$
00110$:
;proc.c:153: proc->stack = pmalloc (proc->stacksize, proc);
;	genPlus
;	AOP_STK for _proc_exec_sloc1_1_0
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,c
	add	a,#0x0C
	ld	-2(ix),a
	ld	a,b
	adc	a,#0x00
	ld	-1(ix),a
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	push	bc
;	genIpush
	push	de
;	genCall
	call	_pmalloc
	ld	d,h
	ld	e,l
	pop	af
	pop	af
	pop	bc
;	genAssign (pointer)
;	AOP_STK for _proc_exec_sloc1_1_0
;	isBitvar = 0
	ld	l,-2(ix)
	ld	h,-1(ix)
	ld	(hl),e
	inc	hl
	ld	(hl),d
;proc.c:154: ERRCGOTO(proc->stack == NULL, ENOMEM, error1);
;	genAssign
;	AOP_STK for 
	ld	e,4(ix)
	ld	d,5(ix)
;	genPlus
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,e
	add	a,#0x0C
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
;	genCmpEq
; genCmpEq: left 2, right 2, result 0
	ld	a,e
	or	a,d
	jp	z,00105$
00111$:
;	genLabel
00104$:
;proc.c:158: proc->machdep = pmalloc (PAGESIZE * 4, proc);
;	genPlus
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,c
	add	a,#0x1E
	ld	e,a
	ld	a,b
	adc	a,#0x00
	ld	d,a
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 1 bcInUse: 0 deSending: 0
	push	de
	push	bc
;	genIpush
	ld	hl,#0x0400
	push	hl
;	genCall
	call	_pmalloc
	ld	b,h
	ld	c,l
	pop	af
	pop	af
	pop	de
;	genAssign (pointer)
;	isBitvar = 0
	ld	l,e
	ld	h,d
	ld	(hl),c
	inc	hl
	ld	(hl),b
;proc.c:160: machdep_proc_enter (proc, entry);
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
	call	_machdep_proc_enter
	pop	af
	pop	af
;proc.c:164: proc_wakeup (proc);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
;	AOP_STK for 
	ld	l,4(ix)
	ld	h,5(ix)
	push	hl
;	genCall
	call	_proc_wakeup
	pop	af
;proc.c:165: MANUAL_SWITCH();
;	genCall
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	call	_machdep_switch
;proc.c:169: return ENONE;
;	genRet
; Dump of IC_LEFT: type AOP_LIT size 2
	ld	hl,#0x0000
	jp	00106$
;proc.c:171: error1:
;	genLabel
00105$:
;proc.c:172: return err;
;	genRet
; Dump of IC_LEFT: type AOP_LIT size 2
	ld	hl,#0x0001
;	genLabel
00106$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_proc_exec_end::
;proc.c:181: proc_startup (void *func)
;	genLabel
;	genFunction
;	---------------------------------
; Function proc_startup
; ---------------------------------
_proc_startup_start::
_proc_startup:
	push	ix
	ld	ix,#0
	add	ix,sp
;proc.c:187: proc_context = CURRENT_PROC(); /* XXX explain this. */
;	genAssign
	ld	hl,(_proc_current)
	ld	iy,#_proc_context
	ld	0(iy),l
	ld	1(iy),h
;proc.c:188: ASSERT(func == NULL, "proc_startup: no entry\n");
;	genCmpEq
;	AOP_STK for 
; genCmpEq: left 2, right 2, result 0
	ld	a,4(ix)
	or	a,5(ix)
	jp	z,00107$
00106$:
	jp	00102$
00107$:
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#__str_3
	push	hl
;	genCall
	call	_panic
	pop	af
;	genLabel
00102$:
;proc.c:189: ((func_t) func) ();
;	genAssign
;	AOP_STK for 
	ld	c,4(ix)
	ld	b,5(ix)
;	genPcall
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	ld	hl,#00108$
	push	hl
	ld	l,c
	ld	h,b
	jp	(hl)
00108$:
	pop	bc
;proc.c:191: exit (ENONE);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0x0000
	push	hl
;	genCall
	call	_exit
	pop	af
;	genLabel
00103$:
;	genEndFunction
	pop	ix
	ret
_proc_startup_end::
__str_3:
	.ascii "proc_startup: no entry"
	.db 0x0A
	.db 0x00
;proc.c:196: proc_kill (struct proc *proc)
;	genLabel
;	genFunction
;	---------------------------------
; Function proc_kill
; ---------------------------------
_proc_kill_start::
_proc_kill:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-2
	add	hl,sp
	ld	sp,hl
;proc.c:205: LOCK_KILL_PROC(proc);
;	genAssign
;	AOP_STK for 
	ld	c,4(ix)
	ld	b,5(ix)
;	genPlus
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,c
	add	a,#0x21
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
;	genIfx
	ld	a,e
	or	a,d
	jp	z,00102$
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	push	de
;	genCall
	call	_lock_unref
	pop	af
	pop	bc
;	genLabel
00102$:
;proc.c:209: fs_kill_proc (proc);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	push	bc
;	genCall
	call	_fs_kill_proc
	pop	af
;proc.c:212: mem_kill_proc (proc);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
;	AOP_STK for 
	ld	l,4(ix)
	ld	h,5(ix)
	push	hl
;	genCall
	call	_mem_kill_proc
	pop	af
;proc.c:216: proc_wakeup (proc);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
;	AOP_STK for 
	ld	l,4(ix)
	ld	h,5(ix)
	push	hl
;	genCall
	call	_proc_wakeup
	pop	af
;proc.c:221: next = (struct proc *) proc->next;
;	genAssign
;	AOP_STK for 
	ld	c,4(ix)
	ld	b,5(ix)
;	genPlus
;	genPlusIncr
	ld	e,c
	ld	d,b
	inc	de
	inc	de
;	genPointerGet
	ld	l,e
	ld	h,d
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
;	genAssign
;	AOP_STK for _proc_kill_next_1_1
	ld	-2(ix),e
	ld	-1(ix),d
;proc.c:222: if (next == proc_current)
;	genCmpEq
;	AOP_STK for _proc_kill_next_1_1
; genCmpEq: left 2, right 2, result 0
	ld	iy,#_proc_current
	ld	a,0(iy)
	cp	-2(ix)
	jp	nz,00119$
	ld	a,1(iy)
	cp	-1(ix)
	jp	z,00120$
00119$:
	jp	00104$
00120$:
;proc.c:223: next = NULL;
;	genAssign
;	AOP_STK for _proc_kill_next_1_1
	ld	-2(ix),#0x00
	ld	-1(ix),#0x00
;	genLabel
00104$:
;proc.c:226: CLIST_REMOVE(&procs_running, proc);
;	genAssign
	ld	e,c
	ld	d,b
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	push	de
;	genIpush
	ld	hl,#_procs_running
	push	hl
;	genCall
	call	_clist_remove
	pop	af
	pop	af
	pop	bc
;proc.c:234: POOL_SFREE(&proc_pool, proc);
;	genAssign
;	AOP_STK for 
	ld	4(ix),c
	ld	5(ix),b
;	genPlus
;	genPlusIncr
	ld	de,#_proc_pool + 4
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
;	AOP_STK for 
	ld	l,4(ix)
	ld	h,5(ix)
	push	hl
;	genIpush
	push	de
;	genCall
	call	_dequeue_push
	pop	af
	pop	af
	pop	bc
;proc.c:237: if (proc == proc_current) {
;	genCmpEq
; genCmpEq: left 2, right 2, result 0
	ld	iy,#_proc_current
	ld	a,0(iy)
	cp	c
	jp	nz,00121$
	ld	a,1(iy)
	cp	b
	jp	z,00122$
00121$:
	jp	00109$
00122$:
;proc.c:238: if (next != NULL)
;	genCmpEq
;	AOP_STK for _proc_kill_next_1_1
; genCmpEq: left 2, right 2, result 0
	ld	a,-2(ix)
	or	a,-1(ix)
	jp	z,00106$
00123$:
;proc.c:239: proc_current = (struct proc *) next->prev;
;	genPointerGet
;	AOP_STK for _proc_kill_next_1_1
	ld	l,-2(ix)
	ld	h,-1(ix)
	ld	a,(hl)
	ld	iy,#_proc_current
	ld	0(iy),a
	inc	hl
	ld	a,(hl)
	ld	1(iy),a
;	genGoto
	jp	00109$
;	genLabel
00106$:
;proc.c:241: proc_current = next;
;	genAssign
;	AOP_STK for _proc_kill_next_1_1
	ld	a,-2(ix)
	ld	iy,#_proc_current
	ld	0(iy),a
	ld	a,-1(ix)
	ld	1(iy),a
;	genLabel
00109$:
;proc.c:246: if (proc_current == NULL)
;	genCmpEq
; genCmpEq: left 2, right 2, result 0
	ld	iy,#_proc_current
	ld	a,0(iy)
	or	a,1(iy)
	jp	z,00125$
00124$:
	jp	00112$
00125$:
;proc.c:247: shutdown ();
;	genCall
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	call	_shutdown
;	genLabel
00112$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_proc_kill_end::
;proc.c:257: exit (int code)
;	genLabel
;	genFunction
;	---------------------------------
; Function exit
; ---------------------------------
_exit_start::
_exit:
	push	ix
	ld	ix,#0
	add	ix,sp
;proc.c:259: proc_kill (proc_current);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,(_proc_current)
	push	hl
;	genCall
	call	_proc_kill
	pop	af
;proc.c:262: SWITCH();
;	genCall
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	call	_machdep_switch
;proc.c:265: panic ("proc_startup() shouldn't return!");
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#__str_4
	push	hl
;	genCall
	call	_panic
	pop	af
;	genLabel
00101$:
;	genEndFunction
	pop	ix
	ret
_exit_end::
__str_4:
	.ascii "proc_startup() shouldn't return!"
	.db 0x00
;proc.c:275: proc_funexec (struct proc ** ret, void *func, size_t codesize, size_t datasize, size_t stacksize, char *name)
;	genLabel
;	genFunction
;	---------------------------------
; Function proc_funexec
; ---------------------------------
_proc_funexec_start::
_proc_funexec:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-2
	add	hl,sp
	ld	sp,hl
;proc.c:280: err = proc_create (ret, name);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
;	AOP_STK for 
	ld	l,14(ix)
	ld	h,15(ix)
	push	hl
;	genIpush
;	AOP_STK for 
	ld	l,4(ix)
	ld	h,5(ix)
	push	hl
;	genCall
	call	_proc_create
	ld	b,h
	ld	c,l
	pop	af
	pop	af
;	genAssign
;	(registers are the same)
;proc.c:281: ERRCODE(err);
;	genCmpEq
; genCmpEq: left 2, right 2, result 0
	ld	a,c
	or	a,b
	jp	z,00102$
00112$:
;	genRet
; Dump of IC_LEFT: type AOP_REG size 2
;	 reg = bc
	ld	l,c
	ld	h,b
	jp	00107$
;	genLabel
00102$:
;proc.c:282: p = *ret;
;	genAssign
;	AOP_STK for 
	ld	c,4(ix)
	ld	b,5(ix)
	push	bc
	pop	iy
;	genPointerGet
	ld	e,0(iy)
	ld	d,1(iy)
;	genAssign
;	AOP_STK for _proc_funexec_p_1_1
	ld	-2(ix),e
	ld	-1(ix),d
;proc.c:284: p->codesize = codesize;
;	genPlus
;	AOP_STK for _proc_funexec_p_1_1
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,-2(ix)
	add	a,#0x12
	ld	e,a
	ld	a,-1(ix)
	adc	a,#0x00
	ld	d,a
;	genAssign (pointer)
;	AOP_STK for 
;	isBitvar = 0
	ld	l,e
	ld	h,d
	ld	a,8(ix)
	ld	(hl),a
	inc	hl
	ld	a,9(ix)
	ld	(hl),a
;proc.c:285: p->datasize = datasize;
;	genPlus
;	AOP_STK for _proc_funexec_p_1_1
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,-2(ix)
	add	a,#0x16
	ld	e,a
	ld	a,-1(ix)
	adc	a,#0x00
	ld	d,a
;	genAssign (pointer)
;	AOP_STK for 
;	isBitvar = 0
	ld	l,e
	ld	h,d
	ld	a,10(ix)
	ld	(hl),a
	inc	hl
	ld	a,11(ix)
	ld	(hl),a
;proc.c:286: if (stacksize < 4096)
;	genCmpLt
;	AOP_STK for 
	ld	a,12(ix)
	sub	a,#0x00
	ld	a,13(ix)
	sbc	a,#0x10
	jp	nc,00104$
;proc.c:287: stacksize = 4096;
;	genAssign
;	AOP_STK for 
	ld	12(ix),#0x00
	ld	13(ix),#0x10
;	genLabel
00104$:
;proc.c:288: p->stacksize = stacksize;
;	genPlus
;	AOP_STK for _proc_funexec_p_1_1
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,-2(ix)
	add	a,#0x0E
	ld	e,a
	ld	a,-1(ix)
	adc	a,#0x00
	ld	d,a
;	genAssign (pointer)
;	AOP_STK for 
;	isBitvar = 0
	ld	l,e
	ld	h,d
	ld	a,12(ix)
	ld	(hl),a
	inc	hl
	ld	a,13(ix)
	ld	(hl),a
;proc.c:290: err = proc_exec (p, func);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
;	AOP_STK for 
	ld	l,6(ix)
	ld	h,7(ix)
	push	hl
;	genIpush
;	AOP_STK for _proc_funexec_p_1_1
	ld	l,-2(ix)
	ld	h,-1(ix)
	push	hl
;	genCall
	call	_proc_exec
	ld	d,h
	ld	e,l
	pop	af
	pop	af
;	genAssign
	ld	c,e
	ld	b,d
;proc.c:291: if (err != ENONE) {
;	genCmpEq
; genCmpEq: left 2, right 2, result 0
	ld	a,c
	or	a,b
	jp	z,00106$
00113$:
;proc.c:292: proc_kill (p);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
;	AOP_STK for _proc_funexec_p_1_1
	ld	l,-2(ix)
	ld	h,-1(ix)
	push	hl
;	genCall
	call	_proc_kill
	pop	af
	pop	bc
;	genLabel
00106$:
;proc.c:295: return err;
;	genRet
; Dump of IC_LEFT: type AOP_REG size 2
;	 reg = bc
	ld	l,c
	ld	h,b
;	genLabel
00107$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_proc_funexec_end::
;proc.c:302: proc_sleep (struct proc *proc)
;	genLabel
;	genFunction
;	---------------------------------
; Function proc_sleep
; ---------------------------------
_proc_sleep_start::
_proc_sleep:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-5
	add	hl,sp
	ld	sp,hl
;proc.c:310: if ((proc->state & PROC_RUNNING) == FALSE) {
;	genAssign
;	AOP_STK for 
	ld	c,4(ix)
	ld	b,5(ix)
;	genPlus
;	AOP_STK for _proc_sleep_sloc1_1_0
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,c
	add	a,#0x20
	ld	-5(ix),a
	ld	a,b
	adc	a,#0x00
	ld	-4(ix),a
;	genPointerGet
;	AOP_STK for _proc_sleep_sloc1_1_0
;	AOP_STK for _proc_sleep_sloc0_1_0
	ld	l,-5(ix)
	ld	h,-4(ix)
	ld	a,(hl)
	ld	-3(ix),a
;	genAnd
;	AOP_STK for _proc_sleep_sloc0_1_0
	ld	a,-3(ix)
	and	a,#0x01
	jp	z,00108$
00113$:
;proc.c:318: if (proc->lock != NULL)
;	genPlus
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,c
	add	a,#0x21
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
;	genCmpEq
; genCmpEq: left 2, right 2, result 0
	ld	a,e
	or	a,d
	jp	z,00115$
00114$:
	jp	00108$
00115$:
;proc.c:323: proc->state &= ~PROC_RUNNING;
;	genAnd
;	AOP_STK for _proc_sleep_sloc0_1_0
	ld	a,-3(ix)
	and	a,#0xFE
;	genAssign (pointer)
;	AOP_STK for _proc_sleep_sloc1_1_0
;	isBitvar = 0
	ld	l,-5(ix)
	ld	h,-4(ix)
	ld	(hl),a
;proc.c:324: next = (struct proc *) proc->next;
;	genPlus
;	genPlusIncr
	ld	e,c
	ld	d,b
	inc	de
	inc	de
;	genPointerGet
	ld	l,e
	ld	h,d
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
;	genAssign
;	AOP_STK for _proc_sleep_next_1_1
	ld	-2(ix),e
	ld	-1(ix),d
;proc.c:327: CLIST_REMOVE(&procs_running, proc);
;	genAssign
	ld	e,c
	ld	d,b
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	push	de
;	genIpush
	ld	hl,#_procs_running
	push	hl
;	genCall
	call	_clist_remove
	pop	af
	pop	af
	pop	bc
;proc.c:328: CLIST_INSERT(&procs_sleeping, proc);
;	genAssign
	ld	e,c
	ld	d,b
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	push	de
;	genIpush
	ld	hl,#_procs_sleeping
	push	hl
;	genCall
	call	_clist_insert
	pop	af
	pop	af
	pop	bc
;proc.c:333: if (proc == proc_current) {
;	genCmpEq
; genCmpEq: left 2, right 2, result 0
	ld	iy,#_proc_current
	ld	a,0(iy)
	cp	c
	jp	nz,00116$
	ld	a,1(iy)
	cp	b
	jp	z,00117$
00116$:
	jp	00106$
00117$:
;proc.c:335: proc_current = (struct proc *) next->prev;
;	genPointerGet
;	AOP_STK for _proc_sleep_next_1_1
	ld	l,-2(ix)
	ld	h,-1(ix)
	ld	a,(hl)
	ld	iy,#_proc_current
	ld	0(iy),a
	inc	hl
	ld	a,(hl)
	ld	1(iy),a
;proc.c:336: SWITCH();
;	genCall
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	call	_machdep_switch
;	genLabel
00106$:
;proc.c:341: return;
;	genRet
;proc.c:342: end:
;	genLabel
00108$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_proc_sleep_end::
;proc.c:350: proc_wakeup (struct proc *proc)
;	genLabel
;	genFunction
;	---------------------------------
; Function proc_wakeup
; ---------------------------------
_proc_wakeup_start::
_proc_wakeup:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-1
	add	hl,sp
	ld	sp,hl
;proc.c:358: if (proc->state & PROC_RUNNING) {
;	genAssign
;	AOP_STK for 
	ld	c,4(ix)
	ld	b,5(ix)
;	genPlus
;	genPlusIncr
;	Can't optimise plus by inc, falling back to the normal way
	ld	a,c
	add	a,#0x20
	ld	e,a
	ld	a,b
	adc	a,#0x00
	ld	d,a
;	genPointerGet
;	AOP_STK for _proc_wakeup_sloc0_1_0
	ld	a,(de)
	ld	-1(ix),a
;	genAnd
;	AOP_STK for _proc_wakeup_sloc0_1_0
	ld	a,-1(ix)
	and	a,#0x01
	jp	z,00108$
00107$:
	jp	00104$
00108$:
;proc.c:365: proc->state |= PROC_RUNNING;
;	genOr
;	AOP_STK for _proc_wakeup_sloc0_1_0
	ld	a,-1(ix)
	or	a,#0x01
;	genAssign (pointer)
;	isBitvar = 0
	ld	(de),a
;proc.c:368: CLIST_REMOVE(&procs_sleeping, proc);
;	genAssign
	ld	e,c
	ld	d,b
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	push	de
;	genIpush
	ld	hl,#_procs_sleeping
	push	hl
;	genCall
	call	_clist_remove
	pop	af
	pop	af
	pop	bc
;proc.c:369: CLIST_INSERT(&procs_running, proc);
;	genAssign
;	(registers are the same)
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	push	bc
;	genIpush
	ld	hl,#_procs_running
	push	hl
;	genCall
	call	_clist_insert
	pop	af
	pop	af
;proc.c:372: already_up:
;	genLabel
00104$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_proc_wakeup_end::
;proc.c:380: sleep ()
;	genLabel
;	genFunction
;	---------------------------------
; Function sleep
; ---------------------------------
_sleep_start::
_sleep:
;proc.c:386: proc_sleep (proc_current);
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,(_proc_current)
	push	hl
;	genCall
	call	_proc_sleep
	pop	af
;	genLabel
00101$:
;	genEndFunction
	ret
_sleep_end::
	.area _CODE
