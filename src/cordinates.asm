section .data
    ansi_move db 0x1B, "[00;00H", 0
    ansi_len equ 8 
    ansi_clear db 0x1B, "[2J", 0x1B, "[H", 0 
    ansi_clear_len equ $ - ansi_clear

section .text
global _cordinate_randon
extern _randon
ASCII equ 0x30

converte_ascii:
    xor rdx, rdx               
    mov rcx, 10               
    div rcx              
    add al, ASCII        
    add dl, ASCII         
    mov [rbx], al        
    mov [rbx+1], dl     
    ret

_cordinate_randon:
    ; Gera linha (0-23)
    mov rsi, 24
    call _randon
    mov rbx, ansi_move + 2  ; "[ 0 0 ; 0 0 H", 0
    call converte_ascii     ;  0 1 2 3 4 5 6

    ; Gera coluna (0-79)
    mov rsi, 80
    call _randon
    mov rbx, ansi_move + 5  ; "[ 0 0 ; 0 0 H", 0
    call converte_ascii     ;  0 1 2 3 4 5 6

    ; Move cursor
    mov rax, 1
    mov rdi, 1
    mov rsi, ansi_move
    mov rdx, ansi_len
    syscall
    ret
