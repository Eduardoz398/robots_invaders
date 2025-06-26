O_WRONLY equ 0x01
STDOUT_FILENO equ 1
STDERR_FILENO equ 2
sys_open equ 2
sys_dup2 equ 33
sys_execve equ 59
soundtrack equ 0
sound_hit equ 1
section .data
    path        db "/dev/null", 0
    path_aplay  db "/usr/bin/aplay", 0
    path_som_track db "assets/soundtrack.wav", 0
    argv_track dq aplay, path_som_track, 0 
    path_som_hit    db "assets/hitHurt.wav", 0
    aplay       db "aplay", 0
    argv_hit        dq aplay, path_som_hit, 0  ; char *argv[] = {"aplay", "/.../random.wav", NULL}


section .bss
    return_fd   resq 1                 ; para guardar o descritor do /dev/null
section .text
    global _som
    extern environ

_som:

    push rsi ; aqui vai o argumento
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

    pop rsi
    cmp rsi, sound_hit
    je som_hit
    jmp som_track

som_hit:

    ; execve("/usr/bin/aplay", argv, environ)
    mov rax, sys_execve           
    mov rdi, path_aplay      ; filename
    mov rsi, argv_hit            ; argv
    mov rdx, [environ]              ; environ - primeiro endereço 
    syscall
    
    mov rax, 60
    xor rbx, rbx 
    syscall

som_track:

  ; execve("/usr/bin/aplay", argv, environ)
    mov rax, sys_execve           
    mov rdi, path_aplay      ; filename
    mov rsi, argv_track           ; argv
    mov rdx, [environ]              ; environ - primeiro endereço 
    syscall
    
    mov rax, 60
    xor rbx, rbx 
    syscall
