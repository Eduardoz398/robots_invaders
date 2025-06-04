section .data   
    ansi_clear db 0x1B, "[2J", 0x1B, "[H", 0 
    ansi_clear_len equ $ - ansi_clear

section .bss
    __kernel_timespec resb 16


section .text

global _sleep_clear:

_sleep_clear:
sleep:
;nanosleep(0x23, struct __kernel_timespec *rqtp, struct __kernel_timespec *rmtp)

    mov qword [__kernel_timespec], 1 
    mov dword [__kernel_timespec + 8], 0
    mov rax, 0x23
    lea rdi, [__kernel_timespec]
    xor rsi, rsi
    syscall 

clear:
    mov rax, 1
    mov rdi, 1
    mov rsi, ansi_clear
    mov rdx, ansi_clear_len
    syscall
    ret



