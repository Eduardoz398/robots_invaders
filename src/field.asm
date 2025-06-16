section .data
    msg_begin db "WELCOME TO ROBOT INVADERS", 10
    green db 0x1B, '[32m'         ;Código ANSI para texto vermelho
    green_len equ $ - green       ; Comprimento do código
  
    
    

section .text

global _initialize_field
extern _clear


_initialize_field:
    
    
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




