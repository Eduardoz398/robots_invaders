section .data
tty_path db "/dev/tty", 0

section .bss
termios resb 60          ; struct termios

section .text
global _echo

_echo:

    push rsi

    ;open(2, const char *filename, int flags, umode_t mode)
    mov rax, 2         
    mov rdi, tty_path
    mov rsi, 2            
    mov rdx, 0            
    syscall
    mov r12, rax 

    ;ioctl(16, fd, TCGETS, &termios)
    mov rax, 16          
    mov rdi, r12          
    mov rsi, 0x5401       
    mov rdx, termios
    syscall

    pop rsi
    cmp rsi, 0
    je disable_echo
    jmp enable_echo

enable_echo:
    
    mov eax, dword [termios + 12]
    or eax, 0x00000008 ;ativar o echo novamente
    mov dword [termios + 12], eax
    
    ;ioctl(16,fd, TCSETS, &termios)
    mov rax, 16      
    mov rdi, r12          
    mov rsi, 0x5402      
    mov rdx, termios
    syscall
    call close
    ret
    

disable_echo:
    mov eax, dword [termios + 12]
    and eax, 0xFFFFFFF7 ;ativar o echo novamente
    
    ;Disable ICANON - estado onde a entrada do utilizador é armazenada em um buffer até que seja pressionada a tecla Enter
    ;Sem isso, o programa vai exibir o que eu teclei no terminal mesmo com o echo desativado
    ; Já que o echo, no modo canonico mostra as teclas que foram enviadas, se eu desativa-lo nao vai mostrar nenhuma.
    ; vai continuar exibindo, pois eu ainda nao mandei as teclas através do enter
    ; Tanto é que se eu teclar e dar enter o programa funciona
    and eax, ~0x00000002      
    mov dword [termios + 12], eax
    
    ;ioctl(16,fd, TCSETS, &termios)
    mov rax, 16          
    mov rdi, r12          
    mov rsi, 0x5402      
    mov rdx, termios
    syscall
    call close
    ret


close:
;close(unsigned int fd)
    mov rax, 3         
    mov rdi, r12
    syscall
    ret


