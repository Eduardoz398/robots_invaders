section .bss
    pollfd resb 8
    time resb 4

section .text


global _monitorar
extern rodadas
extern _randon
_monitorar:
    mov rax, [rodadas]
    imul rax, rax, 155

    mov rsi, 4000
    sub rsi, rax

    mov rax, rsi 


    mov [time], rax

    mov dword [pollfd + 0], 0 ; descritor de arquivo padrão, terminal
    mov word [pollfd + 4], 0x0001 ; estou dizendo que quero monitorar a entrada padrão do terminal

    ; poll(7, struct pollfd *ufds, unsigned int nfds, int timeout)
    mov rax, 7         
    mov rdi, pollfd  
    mov rsi, 1         
    mov rdx, [time]  
    syscall     
    ret