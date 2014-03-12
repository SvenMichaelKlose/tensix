;--------------------------------------------------------
; File Created by SDCC : FreeWare ANSI-C Compiler
; Version 2.6.0 #4309 (Oct 17 2006)
; This file generated Thu Oct 19 04:12:00 2006
;--------------------------------------------------------
	.module string
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _strncmp
	.globl _strcmp
	.globl _strcat
	.globl _strcpy
	.globl _strlen
	.globl _memcmp
	.globl _memcpy
	.globl _bzero
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
;string.c:13: bzero (void *dest, size_t len)
;	genLabel
;	genFunction
;	---------------------------------
; Function bzero
; ---------------------------------
_bzero_start::
_bzero:
	push	ix
	ld	ix,#0
	add	ix,sp
;string.c:15: while (len--)
;	genAssign
;	AOP_STK for 
	ld	c,6(ix)
	ld	b,7(ix)
;	genLabel
00101$:
;	genAssign
	ld	e,c
	ld	d,b
;	genMinus
	dec	bc
;	genIfx
	ld	a,e
	or	a,d
	jp	z,00104$
;string.c:16: *(u8_t *) dest++ = 0;
;	genAssign
;	AOP_STK for 
;	genAssign
;	AOP_STK for 
	ld	e,4(ix)
	ld	d,5(ix)
;	genAssign (pointer)
;	isBitvar = 0
	ld	a,#0x00
	ld	(de),a
;	genGoto
	jp	00101$
;	genLabel
00104$:
;	genEndFunction
	pop	ix
	ret
_bzero_end::
;string.c:20: memcpy (void *dest, void *src, size_t len)
;	genLabel
;	genFunction
;	---------------------------------
; Function memcpy
; ---------------------------------
_memcpy_start::
_memcpy:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-2
	add	hl,sp
	ld	sp,hl
;string.c:22: while (len--)
;	genAssign
;	AOP_STK for 
	ld	c,8(ix)
	ld	b,9(ix)
;	genLabel
00101$:
;	genAssign
	ld	e,c
	ld	d,b
;	genMinus
	dec	bc
;	genIfx
	ld	a,e
	or	a,d
	jp	z,00104$
;string.c:23: *(u8_t *) dest++ = *(u8_t *) src++;
;	genAssign
;	AOP_STK for 
;	AOP_STK for _memcpy_sloc0_1_0
	ld	a,4(ix)
	ld	-2(ix),a
	ld	a,5(ix)
	ld	-1(ix),a
;	genAssign
;	AOP_STK for _memcpy_sloc0_1_0
;	AOP_STK for 
	ld	a,-2(ix)
	ld	4(ix),a
	ld	a,-1(ix)
	ld	5(ix),a
;	genAssign
;	AOP_STK for 
;	genAssign
;	AOP_STK for 
	ld	e,6(ix)
	ld	d,7(ix)
;	genPointerGet
	ld	a,(de)
;	genAssign (pointer)
;	AOP_STK for _memcpy_sloc0_1_0
;	isBitvar = 0
	ld	l,-2(ix)
	ld	h,-1(ix)
	ld	(hl),a
;	genGoto
	jp	00101$
;	genLabel
00104$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_memcpy_end::
;string.c:33: memcmp (void *s1, void *s2, size_t len)
;	genLabel
;	genFunction
;	---------------------------------
; Function memcmp
; ---------------------------------
_memcmp_start::
_memcmp:
	push	ix
	ld	ix,#0
	add	ix,sp
;string.c:37: while (len--) {
;	genAssign
;	AOP_STK for 
	ld	c,8(ix)
	ld	b,9(ix)
;	genLabel
00103$:
;	genAssign
	ld	e,c
	ld	d,b
;	genMinus
	dec	bc
;	genIfx
	ld	a,e
	or	a,d
	jp	z,00105$
;string.c:38: r = *(u8_t *) s2 - *(u8_t *) s1;
;	genAssign
;	(operands are equal 3)
;	genPointerGet
;	AOP_STK for 
	ld	l,6(ix)
	ld	h,7(ix)
	ld	d,(hl)
;	genAssign
;	(operands are equal 3)
;	genPointerGet
;	AOP_STK for 
	ld	l,4(ix)
	ld	h,5(ix)
	ld	e,(hl)
;	genMinus
	ld	a,d
	sub	a,e
;	genAssign
;	(registers are the same)
;string.c:39: if (r != 0)
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	e,a
	or	a,a
	jp	z,00102$
00111$:
;string.c:40: return r;
;	genCast
	ld	l,e
	ld	a,l
	rla	
	sbc	a,a
	ld	h,a
;	genRet
; Dump of IC_LEFT: type AOP_STR size 2
	jp	00106$
;	genLabel
00102$:
;string.c:41: s1++;
;	genAssign
;	(operands are equal 4)
;string.c:42: s2++;
;	genAssign
;	(operands are equal 4)
;	genGoto
	jp	00103$
;	genLabel
00105$:
;string.c:45: return 0;
;	genRet
; Dump of IC_LEFT: type AOP_LIT size 2
	ld	hl,#0x0000
;	genLabel
00106$:
;	genEndFunction
	pop	ix
	ret
_memcmp_end::
;string.c:49: strlen (char *p)
;	genLabel
;	genFunction
;	---------------------------------
; Function strlen
; ---------------------------------
_strlen_start::
_strlen:
	push	ix
	ld	ix,#0
	add	ix,sp
;string.c:53: while (*p++)
;	genAssign
	ld	bc,#0x0000
;	genAssign
;	AOP_STK for 
	ld	e,4(ix)
	ld	d,5(ix)
;	genLabel
00101$:
;	genPointerGet
	ld	a,(de)
;	genPlus
;	genPlusIncr
	inc	de
;	genIfx
	or	a,a
	jp	z,00103$
;string.c:54: len++;
;	genPlus
;	genPlusIncr
	inc	bc
;	genGoto
	jp	00101$
;	genLabel
00103$:
;string.c:56: return len;
;	genRet
; Dump of IC_LEFT: type AOP_REG size 2
;	 reg = bc
	ld	l,c
	ld	h,b
;	genLabel
00104$:
;	genEndFunction
	pop	ix
	ret
_strlen_end::
;string.c:60: strcpy (char *dest, char *src)
;	genLabel
;	genFunction
;	---------------------------------
; Function strcpy
; ---------------------------------
_strcpy_start::
_strcpy:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-4
	add	hl,sp
	ld	sp,hl
;string.c:62: char *ret = dest;
;	genAssign
;	AOP_STK for 
;	AOP_STK for _strcpy_ret_1_1
	ld	a,4(ix)
	ld	-2(ix),a
	ld	a,5(ix)
	ld	-1(ix),a
;string.c:64: while ((*dest++ = *src++) != 0);
;	genAssign
;	AOP_STK for 
	ld	e,6(ix)
	ld	d,7(ix)
;	genAssign
;	AOP_STK for _strcpy_ret_1_1
;	AOP_STK for _strcpy_sloc0_1_0
	ld	a,-2(ix)
	ld	-4(ix),a
	ld	a,-1(ix)
	ld	-3(ix),a
;	genLabel
00101$:
;	genPointerGet
	ld	a,(de)
	ld	c,a
;	genPlus
;	genPlusIncr
	inc	de
;	genAssign (pointer)
;	AOP_STK for _strcpy_sloc0_1_0
;	isBitvar = 0
	ld	l,-4(ix)
	ld	h,-3(ix)
	ld	(hl),c
;	genPlus
;	AOP_STK for _strcpy_sloc0_1_0
;	genPlusIncr
	inc	-4(ix)
	jp	nz,00109$
	inc	-3(ix)
00109$:
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	a,c
	or	a,a
	jp	z,00111$
00110$:
	jp	00101$
00111$:
;string.c:66: return ret;
;	genRet
;	AOP_STK for _strcpy_ret_1_1
; Dump of IC_LEFT: type AOP_STK size 2
;	 aop_stk -2
	ld	l,-2(ix)
	ld	h,-1(ix)
;	genLabel
00104$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_strcpy_end::
;string.c:70: strcat (char *dest, char *src)
;	genLabel
;	genFunction
;	---------------------------------
; Function strcat
; ---------------------------------
_strcat_start::
_strcat:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-4
	add	hl,sp
	ld	sp,hl
;string.c:72: char *ret = dest;
;	genAssign
;	AOP_STK for 
;	AOP_STK for _strcat_ret_1_1
	ld	a,4(ix)
	ld	-2(ix),a
	ld	a,5(ix)
	ld	-1(ix),a
;string.c:74: while (*dest != 0)
;	genAssign
;	AOP_STK for _strcat_ret_1_1
	ld	e,-2(ix)
	ld	d,-1(ix)
;	genLabel
00101$:
;	genPointerGet
	ld	a,(de)
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	c,a
	or	a,a
	jp	z,00111$
00115$:
;string.c:75: dest++;
;	genPlus
;	genPlusIncr
	inc	de
;	genGoto
	jp	00101$
;string.c:77: while ((*dest++ = *src++) != 0);
;	genLabel
00111$:
;	genAssign
;	AOP_STK for 
;	AOP_STK for _strcat_sloc0_1_0
	ld	a,6(ix)
	ld	-4(ix),a
	ld	a,7(ix)
	ld	-3(ix),a
;	genAssign
;	(registers are the same)
;	genLabel
00104$:
;	genPointerGet
;	AOP_STK for _strcat_sloc0_1_0
	ld	l,-4(ix)
	ld	h,-3(ix)
	ld	c,(hl)
;	genPlus
;	AOP_STK for _strcat_sloc0_1_0
;	genPlusIncr
	inc	-4(ix)
	jp	nz,00116$
	inc	-3(ix)
00116$:
;	genAssign (pointer)
;	isBitvar = 0
	ld	a,c
	ld	(de),a
;	genPlus
;	genPlusIncr
	inc	de
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	a,c
	or	a,a
	jp	z,00118$
00117$:
	jp	00104$
00118$:
;string.c:79: return ret;
;	genRet
;	AOP_STK for _strcat_ret_1_1
; Dump of IC_LEFT: type AOP_STK size 2
;	 aop_stk -2
	ld	l,-2(ix)
	ld	h,-1(ix)
;	genLabel
00107$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_strcat_end::
;string.c:89: strcmp (char *s1, char *s2)
;	genLabel
;	genFunction
;	---------------------------------
; Function strcmp
; ---------------------------------
_strcmp_start::
_strcmp:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-2
	add	hl,sp
	ld	sp,hl
;string.c:93: while (1) {
;	genAssign
;	AOP_STK for 
	ld	c,4(ix)
	ld	b,5(ix)
;	genAssign
;	AOP_STK for 
;	AOP_STK for _strcmp_sloc0_1_0
	ld	a,6(ix)
	ld	-2(ix),a
	ld	a,7(ix)
	ld	-1(ix),a
;	genLabel
00106$:
;string.c:95: r = *s2 - *s1;
;	genPointerGet
;	AOP_STK for _strcmp_sloc0_1_0
	ld	l,-2(ix)
	ld	h,-1(ix)
	ld	e,(hl)
;	genPointerGet
	ld	a,(bc)
	ld	d,a
;	genMinus
	ld	a,e
	sub	a,d
;	genAssign
;	(registers are the same)
;string.c:98: if (r != 0)
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	e,a
	or	a,a
	jp	z,00102$
00113$:
;string.c:99: return r;
;	genCast
	ld	l,e
	ld	a,l
	rla	
	sbc	a,a
	ld	h,a
;	genRet
; Dump of IC_LEFT: type AOP_STR size 2
	jp	00108$
;	genLabel
00102$:
;string.c:102: if (*s1 == 0)
;	genIfx
	xor	a,a
	or	a,d
	jp	z,00107$
;string.c:106: s1++;
;	genPlus
;	genPlusIncr
	inc	bc
;string.c:107: s2++;
;	genPlus
;	AOP_STK for _strcmp_sloc0_1_0
;	genPlusIncr
	inc	-2(ix)
	jp	nz,00114$
	inc	-1(ix)
00114$:
;	genGoto
	jp	00106$
;	genLabel
00107$:
;string.c:110: return 0; /* Strings matched. */
;	genRet
; Dump of IC_LEFT: type AOP_LIT size 2
	ld	hl,#0x0000
;	genLabel
00108$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_strcmp_end::
;string.c:114: strncmp (char *s1, char *s2, size_t len)
;	genLabel
;	genFunction
;	---------------------------------
; Function strncmp
; ---------------------------------
_strncmp_start::
_strncmp:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-4
	add	hl,sp
	ld	sp,hl
;string.c:118: while (len--) {
;	genAssign
;	AOP_STK for 
	ld	c,4(ix)
	ld	b,5(ix)
;	genAssign
;	AOP_STK for 
;	AOP_STK for _strncmp_sloc1_1_0
	ld	a,6(ix)
	ld	-4(ix),a
	ld	a,7(ix)
	ld	-3(ix),a
;	genAssign
;	AOP_STK for 
;	AOP_STK for _strncmp_sloc0_1_0
	ld	a,8(ix)
	ld	-2(ix),a
	ld	a,9(ix)
	ld	-1(ix),a
;	genLabel
00105$:
;	genAssign
;	AOP_STK for _strncmp_sloc0_1_0
	ld	e,-2(ix)
	ld	d,-1(ix)
;	genMinus
;	AOP_STK for _strncmp_sloc0_1_0
	ld	l,-2(ix)
	ld	h,-1(ix)
	dec	hl
	ld	-2(ix),l
	ld	-1(ix),h
;	genIfx
	ld	a,e
	or	a,d
	jp	z,00107$
;string.c:120: r = *s2 - *s1;
;	genPointerGet
;	AOP_STK for _strncmp_sloc1_1_0
	ld	l,-4(ix)
	ld	h,-3(ix)
	ld	e,(hl)
;	genPointerGet
	ld	a,(bc)
	ld	d,a
;	genMinus
	ld	a,e
	sub	a,d
;	genAssign
;	(registers are the same)
;string.c:123: if (r != 0)
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	e,a
	or	a,a
	jp	z,00102$
00114$:
;string.c:124: return r;
;	genCast
	ld	l,e
	ld	a,l
	rla	
	sbc	a,a
	ld	h,a
;	genRet
; Dump of IC_LEFT: type AOP_STR size 2
	jp	00108$
;	genLabel
00102$:
;string.c:127: if (*s1 == 0)
;	genIfx
	xor	a,a
	or	a,d
	jp	z,00107$
;string.c:131: s1++;
;	genPlus
;	genPlusIncr
	inc	bc
;string.c:132: s2++;
;	genPlus
;	AOP_STK for _strncmp_sloc1_1_0
;	genPlusIncr
	inc	-4(ix)
	jp	nz,00115$
	inc	-3(ix)
00115$:
;	genGoto
	jp	00105$
;	genLabel
00107$:
;string.c:135: return 0; /* Strings matched. */
;	genRet
; Dump of IC_LEFT: type AOP_LIT size 2
	ld	hl,#0x0000
;	genLabel
00108$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_strncmp_end::
	.area _CODE
