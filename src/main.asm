desabilita equ 0
habilita equ 1
standard_time equ 2
change_score equ 0
final_score equ 1
sys_fork equ 0x39
sys_wait4 equ 0x3d

section .bss
    rodadas resb 1


section .data
    msg_timeout db "you missed", 10, 0

section .bss
    buffer resb 256   
    key resb 1
    environ resb 8
    pid resb 8
    

section .text

global _start

global environ
extern _echo
extern _monitorar
extern _cordinate_randon
extern _spaw
extern _sleep
extern _clear
extern _score
extern _initialize_field
extern _som


_start:
    ; Recuperar endereço de environ
    ; ver System V Application Binary Interface
    ;x86-64TM Architecture Processor Supplement
    ;Draft Version 0.21
    
    mov rbx, rsp             ; rbx = rsp 
    add rbx, 8               ; pular argc
.next_arg:
    mov rax, [rbx]
    add rbx, 8
    cmp rax, 0
    jnz .next_arg            ; pular os argv até achar NULL
    ; agora rbx aponta para envp[0], ou seja, environ
    mov [environ], rbx              ; r8 = environ (terceiro argumento de execve)


    call _initialize_field

loop: 
    mov al, 1
    add [rodadas], al
    mov al, [rodadas]
    cmp al, 11
    je end


    mov rsi, desabilita
    call _echo

    mov rsi, standard_time
    call _sleep

    call _clear
    call _cordinate_randon
    call _spaw


    mov [key], al
    call _monitorar
    
    cmp rax, 0
    je timeout

    mov rsi, buffer     
    mov rdx, 256  
    call read     
    
    mov al, [key]
    cmp [buffer], al
    je hit         


timeout:

    call _clear
    mov rsi, habilita
    call _echo

   
    mov rsi, msg_timeout
    mov rdx, 11
    call write

    jmp loop        


hit:
    
    
    mov rax, sys_fork
    syscall 
    mov [pid], rax
    
    cmp rax, 0
    jne pai

    jmp _som



pai:
    mov rax, sys_wait4
    mov rdi, [pid]
    xor rsi, rsi
    xor rdx, rdx
    xor r10, r10
    syscall

    mov rsi, change_score
    call _score
    jmp loop



write:
    mov rax, 1
    mov rdi, 1
    syscall
    ret


read:
    mov rax, 0        
    mov rdi, 0 
    syscall
    ret 

end:
    mov rsi, final_score
    call _score

    mov rax, 0x3c
    xor rbx, rbx
    syscall

   