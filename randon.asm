section .text

global _randon
_randon:

    rdtsc 
    mov rcx, rsi ; recebe o intervalo que eu quero 
    xor rdx, rdx
    div rcx ; rax/rcx
    mov rax, rdx ; fazer a convenção do retorno ser em rax
    ret
    

