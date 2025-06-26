final_score equ 1
habilita equ 1
section .bss
    pontuacao resb 8


section .data
    msg_end1 db "FIM! SUA PONTUACAO FOI ", 0
    msg_end2 db "/25", 0
    msg_hit db "a hit", 10, 0
    line_feed db 0xA



section .text

global _score

extern _print
extern _clear
extern _echo

_score:
    

    cmp rsi, final_score
    je _final_score
    jmp change_score
    

_final_score:
    call _clear

    mov rsi, msg_end1
    mov rdx, 23
    call write
    
    mov rsi, [pontuacao]
    call _print
    
    mov rsi, msg_end2
    mov rdx, 3
    call write

    mov rsi, line_feed
    mov rdx, 1
    call write
    ret 

change_score:
    call _clear
    mov rsi, habilita
    call _echo
    
    mov rbx, 1
    add [pontuacao], rbx 

    mov rsi, msg_hit
    mov rdx, 5
    call write
    ret



write:
    mov rax, 1
    mov rdi, 1
    syscall
    ret

