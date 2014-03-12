! tensix operating system project
! Copyright (C) 2002 Sven Klose <pixel@copei.de>
!
! i86 task switcher
!
! $License$

.data
extern _proc_current
extern _proc_context

.text
entry _machdep_switch
_machdep_switch:
    pushf
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push bp

    ! Avoid nested switches.
    cli

    ! Get pointer to current process info.
    mov si,_proc_context

    ! Save stack pointer.
    mov ax,sp
    mov [si+4],ax

    ! Get pointer to next process.
    mov si,[si+2]
    mov _proc_current, si
    mov _proc_context, si

    ! Get the new stack pointer.
    mov ax,[si+4]
    mov sp,ax

    ! Allow interrupts again.
    sti

    ! Restore context of next process.
    pop bp
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    popf

    ret
