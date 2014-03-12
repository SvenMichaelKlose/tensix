! tensix operating system project
! Copyright (C) 2002 Sven Klose <pixel@hugbox,org>
!
! i86-pc bios wrapper for the console driver.
!
! $License$

_con_bios_in:
	xor	ah, ah
	int	0x16
	xor	ah, ah
	ret

	export	_con_bios_in

_con_bios_out:
	mov	bx, #0x7
	mov	ah, #0xe
	int	0x10
	ret

	export	_con_bios_out
