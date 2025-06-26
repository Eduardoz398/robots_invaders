
section .bss
    num resb 1

section .text
global _spaw
extern _randon
extern _echo

desabilita equ 0
habilita equ 1
ASCII equ 0x30
intervalo equ 0x30
write equ 0x1



extern _echo
_spaw:
    mov rsi, habilita
    call _echo

    mov rsi, intervalo
    call _randon

    add al, ASCII
    mov [num], al

    mov rax, write
    mov rdi, 1
    mov rsi, num
    mov rdx, 1
    syscall

    mov rsi, desabilita
    call _echo

    mov rax, [num] ; retorno
    ret
