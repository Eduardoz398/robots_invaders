section .bss
    pollfd resb 8
    time resb 4

section .text


global _monitorar
extern _randon
_monitorar:
    mov rsi, 5000
    call _randon

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