desabilita equ 0
habilita equ 1
section .data
    green db 0x1B, '[32m'         ;Código ANSI para texto vermelho
    green_len equ $ - green       ; Comprimento do código
    msg_timeout db "you missed", 10, 0
    msg_acertou db "acertou!!", 10, 0

section .bss
    buffer resb 256     ; buffer para armazenar a entrada do usuário
    key resb 1
    

section .text

global _start
extern _echo
extern _monitorar
extern _cordinate_randon
extern _spaw
extern _sleep_clear

_start:
    mov rax, 1
    mov rdi, 1
    mov rsi, green
    mov rdx, green_len
    syscall

    

loop: 
    call _sleep_clear
    
    mov rsi, desabilita
    call _echo

    call _cordinate_randon
    call _spaw

    mov [key], al
    
    call _monitorar
    cmp rax, 0
    je timeout


    ;read(0, unsigned int fd,const char *buf, size_t count)
    mov rax, 0        
    mov rdi, 0          
    mov rsi, buffer     
    mov rdx, 256        
    syscall
    
    mov al, [key]
    cmp [buffer], al
    je loop         

timeout:
    mov rsi, habilita
    call _echo

    ;write(1, unsigned int fd,const char *buf,size_t count)
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_timeout
    mov rdx, 11
    syscall
    jmp loop        


