;Criar uma matriz 
;Nome (indice) - pontuacao 
;A matriz vai ser limpa a cada processo, mas vai ser ler fo arquivo
;Ao final escrever no arquivo
;No inicio vai ter 
;ROBOT INVADERS em um laço infinito
;- How to play?
;- Historico
;- play!
sys_open equ 0x2
O_RDWR  equ 2  
rw_r__r__ equ 0o644
sys_write equ 0x01
sys_read equ 0x00
sys_close equ 0x03
desabilita equ 0 
habilita equ 1

sys_lseek equ 0x08

section .data
 ; Leitura e escrita    

    filename db "assets/config.txt", 0
    line_feed db 0xa

    msg_erro db "erro",10, 0

    ansi_move_center db 0x1B, "[12;68H", 0 
    ansi_move_center_len equ $ - ansi_move_center
    
    ansi_move_inf1 db 0x1B, "[13;70H", 0 
    ansi_move_inf1_len equ $ - ansi_move_inf1

    ansi_move_inf2 db 0x1B, "[14;70H", 0 
    ansi_move_inf2_len equ $ - ansi_move_inf2

    ansi_move_inf3 db 0x1B, "[15;70H", 0 
    ansi_move_inf3_len equ $ - ansi_move_inf3


    msg_central db "ROBOT INVADERS",10,0
    msg_central_len equ $ - msg_central

    msg_inf1 db "1 - How to play?", 10,0
    msg_inf1_len equ $ - msg_inf1

    msg_inf2 db "2 - History",10,0
    msg_inf2_len equ $ - msg_inf2

    msg_inf3 db "3 - play",10,0
    msg_inf3_len equ $ - msg_inf3
    msg_play db "enter your name: "
    msg_play_len equ $ - msg_play

    computer_battle_games db "You must act quickly.  Robot invaders of all kinds Robot are approaching.", 10, "You have plenty of weapons,  but for each type of Robot you must select",10, "exactly the right one for it to have anyeffect", 10, "Code symbols for each Robot will flash up on your screen",10, "Quickly press the  key with that symbol on it", 10,"-beware, some need the shift key too - and see how  many Robot invaders you candestroy",10,0
    computer_battle_games_len equ $ - computer_battle_games
    msg_return_lobby db "press any key to go back",10,0
    msg_return_lobby_len equ $ - msg_return_lobby


section .bss
    choice resb 8
    file_descriptor resb 8
    user resb 32
    var resb 1
    qtd_of_users resb 1
 
section .text
    
    global _lobby
    extern _echo
    extern _clear

_lobby:
    

    call _clear
    mov rsi, ansi_move_center
    mov rdx, ansi_move_center_len
    call write
  
    mov rsi, msg_central
    mov rdx, msg_central_len
    call write

    mov rsi, ansi_move_inf1
    mov rdx, ansi_move_inf1_len
    call write 

    mov rsi, msg_inf1
    mov rdx, msg_inf1_len
    call write

    mov rsi, ansi_move_inf2
    mov rdx, ansi_move_inf2_len
    call write

    mov rsi, msg_inf2
    mov rdx, msg_inf2_len
    call write


    mov rsi, ansi_move_inf3
    mov rdx, ansi_move_inf3_len
    call write

    mov rsi, msg_inf3
    mov rdx, msg_inf3_len
    call write

    mov rsi, desabilita
    call _echo

    mov rax, sys_read
    mov rdi, 0
    mov rsi, choice
    mov rdx, 1
    syscall 


   mov rax, [choice]
   
   cmp rax, '1'
   je manual

   cmp rax, '2'
   je history
   
   cmp rax,'3'
   je play
    
   jne _lobby
    
    
    

write:
    mov rax, sys_write
    mov rdi, 1
    syscall
    ret

manual:
    

    call _clear
    mov rsi, computer_battle_games
    mov rdx, computer_battle_games_len
    call write

   

    mov rsi, msg_return_lobby
    mov rdx, msg_return_lobby_len
    call write


    mov rax, sys_read
    mov rdi, 0
    mov rsi, var
    mov rdx, 1
    syscall

    mov rsi, habilita
    call _echo

    jmp _lobby
    

history:
    

    call _clear
    call open_file

    cmp rax, 0
    jl erro
    mov [file_descriptor], rax


    mov rax, sys_lseek
    mov rdi, [file_descriptor]
    mov rsi, 0          ; Offset 0
    mov rdx, 0          ; SEEK_SET
    syscall

    

loop:
    
    
    call read_from_file
    
    cmp rax, 0
    je end


    mov al, [var]
    cmp al, 0x7c ; if(var == '|') fim da informação de um usuário
    je separar

    ;cmp al, 0; if(var == 'eof') fim do arquivo
    ;je end isso não é possível,pois o eof é so retornado

    
    
    jmp print_user_informations

    
    
print_user_informations:
    mov rsi, var
    mov rdx, 1
    call write 
    jmp loop


read_from_file:
    mov rax, sys_read
    mov rdi, [file_descriptor]
    mov rsi, var
    mov rdx, 1
    syscall
    ret


end:
    mov rsi, line_feed
    mov rdx, 1
    call write
    
    mov rsi, msg_return_lobby
    mov rdx, msg_return_lobby_len
    call write
;segurar o código
    mov rax, sys_read
    mov rdi, 0
    mov rsi, var
    mov rdx, 1
    syscall

    mov rax, sys_close
    mov rdi, [file_descriptor]
    syscall 

    jmp _lobby

play:
    call _clear
    mov rsi, msg_play
    mov rdx, msg_play_len
    call write
    mov rsi, habilita
    call _echo
    mov r10, 0

loop_play1:
    ;ler o nome do usário na tela
    mov rax, sys_read
    mov rdi, 0
    mov rsi, var
    mov rdx, 1
    syscall

    mov al, [var]
    cmp al, 0xa
    je write_name_to_file 

    mov rbx, user
    add rbx, r10
    mov [rbx], al
    inc r10

    jmp loop_play1
    
    
write_name_to_file:

    call open_file
    
    cmp rax, 0
    jl erro
    mov [file_descriptor], rax
    
;chegando ao fim do arquivo
    mov rax, sys_lseek
    mov rdi, [file_descriptor]
    mov rsi, 0          ; Offset 0
    mov rdx, 2          ; SEEK_END
    syscall



insertion:
   

    mov rax, sys_write
    mov rdi, [file_descriptor]
    mov rsi, user 
    mov rdx, r10
    syscall

    mov rax, sys_close
    mov rdi, [file_descriptor]
    syscall

    mov rax, 0x3c
    mov rdi, 0
    syscall
    



open_file: 
    mov rax, sys_open
    mov rdi, filename
    mov rsi, O_RDWR
    mov rdx, 0o644
    syscall
    ret 

erro:
    mov rsi, msg_erro
    mov rdx, 6
    call write

    mov rax, 0x3c
    xor rdi,rdi
    syscall

separar:
    mov rsi, line_feed
    mov rdi, 1
    call write
    jmp loop