! tensix operating system project
! Copyright (C) 2002, 2003 Sven Klose <pixel@hugbox.org>
!
! i86 kernel startup function.
!
! $License$

.text
entry startup
entry _reboot
extern _main
startup:
    cli
    mov ax,cs
    mov ds,ax
    mov es,ax
    add ax,#$1000
    mov ss,ax
    mov ax,#$fffe
    mov sp,ax
    sti
    call _main
_reboot:
    jmpi #$fff0, #$f000
