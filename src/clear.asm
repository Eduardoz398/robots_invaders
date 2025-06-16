section .data   
    ansi_clear db 0x1B, "[2J", 0x1B, "[H", 0 
    ansi_clear_len equ $ - ansi_clear
section .text
    global _clear
    
_clear:
    mov rax, 1
    mov rdi, 1
    mov rsi, ansi_clear
    mov rdx, ansi_clear_len
    syscall
    ret