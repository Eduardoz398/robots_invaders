O_WRONLY equ 0x01
STDOUT_FILENO equ 1
STDERR_FILENO equ 2
sys_open equ 2
sys_dup2 equ 33
sys_execve equ 59

section .data
    path        db "/dev/null", 0
    path_aplay  db "/usr/bin/aplay", 0
    path_som    db "assets/hitHurt.wav", 0
    aplay       db "aplay", 0
    argv        dq aplay, path_som, 0  ; char *argv[] = {"aplay", "/.../random.wav", NULL}

section .bss
    return_fd   resq 1                 ; para guardar o descritor do /dev/null
section .text
    global _som
    extern environ

_som:

    ;----------------------------
    ; open("/dev/null", O_WRONLY)
    
    mov rax, sys_open             
    mov rdi, path           
    mov rsi, O_WRONLY        ; int flags
    xor rdx, rdx             ; mode = 0
    syscall
    mov [return_fd], rax     

  
    ; dup2(fd, STDOUT_FILENO)
    mov rax, sys_dup2            
    mov rdi, [return_fd]
    mov rsi, STDOUT_FILENO
    syscall

  
    ; dup2(fd, STDERR_FILENO)

    mov rax, sys_dup2             
    mov rdi, [return_fd]
    mov rsi, STDERR_FILENO
    syscall

   
    ; execve("/usr/bin/aplay", argv, environ)
    mov rax, sys_execve           
    mov rdi, path_aplay      ; filename
    mov rsi, argv            ; argv
    mov rdx, [environ]              ; environ - primeiro endereço 
    syscall
    
    mov rax, 60
    xor rbx, rbx 
    syscall

    
