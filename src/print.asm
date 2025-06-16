; nasm -f elf64 -o teste.o teste.asm && ld -o teste teste.o && ./teste

section .data
    line_feed: db 0xA

section .bss
    num: resb 4
    ant: resb 4

section .text

global _print
    ASCII EQU 0x30
    LF EQU 0xA
_print:

    mov rax, rsi
    cmp rax, 9
    jl print_end
    mov rcx, 1
    xor rdx, rdx

loop:
    cmp rax, rcx
    jg multiply
    jmp divide

multiply:
    push rcx
    imul rcx, rcx, 10
    jmp loop

divide:
    pop rcx
    xor rdx, rdx
    div rcx

    add eax, ASCII
    mov dword [num], eax

    push rdx
    push rcx
    mov rsi, num
    mov rdx, 4
    call print

    pop rcx
    pop rdx
    mov rax, rdx

    cmp rcx, 1
    je end
    xor rdx, rdx
    jmp divide


print:
    mov rax, 1      ; syscall: write
    mov rdi, 1      ; stdout
    syscall
    ret

end:
    ret

print_end:
    add rax, ASCII
    mov [num], rax
    mov rax, 1      ; syscall: write
    mov rdi, 1      ; stdout
    mov rsi, num
    mov rdx, 4
    syscall
    ret
