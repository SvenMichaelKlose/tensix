! tensix operating system project
! Copyright (C) 2002 Sven Klose <pixel@copei.de>
!
! i86-pc bios wrapper for the floppy driver.
!
! $License$

! int fd_bios_read (buffer. drv, cyl, head, sec, num)
export _fd_bios_read
_fd_bios_read:
  mov   ax,bx
  mov   dl,4[bp]
  mov   ch,6[bp]
  mov   dh,8[bp]
  mov   dl,10[bp]
  mov	ah,#$02
  ! ah=2, al=1, dl=drv, ch=cyl, dh=head, cl=sec, es:bx=buffer.
  int	$13
  jc	.1
  xor ax,ax
  ret
.1:
  mov al,1
  ret
