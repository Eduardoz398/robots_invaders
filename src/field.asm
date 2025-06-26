soundtrack equ 0
sys_fork equ 0x39

section .data
    msg_begin db "WELCOME TO ROBOT INVADERS", 10
    green db 0x1B, '[32m'         ;Código ANSI para texto vermelho
    green_len equ $ - green       ; Comprimento do código


section .bss 
    pid resb 8
    
    

section .text

global _initialize_field
extern _clear
extern _som


_initialize_field:
    
    call _clear
    mov rax, sys_fork
    syscall 
    mov [pid], rax
    
    cmp rax, 0
    jne pai
filho1:
    mov rsi, soundtrack
    jmp _som

pai:
    mov rax, 1
    mov rdi, 1
    mov rsi, green
    mov rdx, green_len
    syscall



    call _clear
    mov rsi, msg_begin 
    mov rdx, 25
    mov rax, 1
    mov rdi, 1
    syscall
    ret




