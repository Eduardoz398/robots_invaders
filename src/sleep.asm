standard_time equ 2
section .bss
    __kernel_timespec resb 16

section .text

global _sleep
extern _randon

_sleep:
    cmp rsi, standard_time
    jmp standard

    mov rsi, 5
    call _randon
    jmp nanosleep

standard:
    mov rax, rsi
    ;retorno vem em rax
    
nanosleep:
;nanosleep(0x23, struct __kernel_timespec *rqtp, struct __kernel_timespec *rmtp)
    mov qword [__kernel_timespec], rax
    mov dword [__kernel_timespec + 8], 0
    mov rax, 0x23
    lea rdi, [__kernel_timespec]
    xor rsi, rsi
    syscall 
    ret


