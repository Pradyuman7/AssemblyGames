// Simple looking complexly designed 2 players tic tac toe, obviously human vs human

section .data
    new_line db 13, 10, "$"
    
    game_draw db "_|_|_", 13, 10
              db "_|_|_", 13, 10
              db "_|_|_", 13, 10, "$"    
                  
    game_pointer db 9 DUP(?)  
    
    win_flag db 0 
    player db "0$" 
    
    game_over_message db "FIM DE JOGO", 13, 10, "$"    
    game_start_message db "JOGO DA VELHA (TIC TAC TOE) by Roberto Luiz Debarba", 13, 10, "$"
    player_message db "PLAYER $"   
    win_message db " WIN!$"   
    type_message db "TYPE A POSITION: $"

section .bss
    dw   128  dup(?)


section .text
	global _start

_start:
    ; set segment registers
    mov     ax, data
    mov     ds, ax
    mov     ax, extra
    mov     es, ax

    ; game start   
    call    set_game_pointer    
            
main_loop:  
    call    clear_screen   
    
    lea     dx, game_start_message 
    call    print
    
    lea     dx, new_line
    call    print                      
    
    lea     dx, player_message
    call    print
    lea     dx, player
    call    print  
    
    lea     dx, new_line
    call    print    
    
    lea     dx, game_draw
    call    print    
    
    lea     dx, new_line
    call    print    
    
    lea     dx, type_message    
    call    print            
                        
    ; read draw position                   
    call    read_keyboard
                       
    ; calculate draw position                   
    sub     al, 49               
    mov     bh, 0
    mov     bl, al                                  
                                  
    call    update_draw                                    
                                                          
    call    check  
                       
    ; check if game ends                   
    cmp     win_flag, 1  
    je      game_over  
    
    call    change_player 
            
    jmp     main_loop   


change_player:   
    lea     si, player    
    xor     ds:[si], 1 
    
    ret
      
 
update_draw:
    mov     bl, game_pointer[bx]
    mov     bh, 0
    
    lea     si, player
    
    cmp     ds:[si], "0"
    je      draw_x     
                  
    cmp     ds:[si], "1"
    je      draw_o              
                  
    draw_x:
    mov     cl, "x"
    jmp     update

    draw_o:          
    mov     cl, "o"  
    jmp     update    
          
    update:         
    mov     ds:[bx], cl
      
    ret 
       
       
check:
    call    check_line
    ret     
       
       
check_line:
    mov     cx, 0
    
    check_line_loop:     
    cmp     cx, 0
    je      first_line
    
    cmp     cx, 1
    je      second_line
    
    cmp     cx, 2
    je      third_line  
    
    call    check_column
    ret    
        
    first_line:    
    mov     si, 0   
    jmp     do_check_line   

    second_line:    
    mov     si, 3
    jmp     do_check_line
    
    third_line:    
    mov     si, 6
    jmp     do_check_line        

    do_check_line:
    inc     cx
  
    mov     bh, 0
    mov     bl, game_pointer[si]
    mov     al, ds:[bx]
    cmp     al, "_"
    je      check_line_loop
    
    inc     si
    mov     bl, game_pointer[si]    
    cmp     al, ds:[bx]
    jne     check_line_loop 
      
    inc     si
    mov     bl, game_pointer[si]  
    cmp     al, ds:[bx]
    jne     check_line_loop
                 
                         
    mov     win_flag, 1
    ret         
       
       
       
check_column:
    mov     cx, 0
    
    check_column_loop:     
    cmp     cx, 0
    je      first_column
    
    cmp     cx, 1
    je      second_column
    
    cmp     cx, 2
    je      third_column  
    
    call    check_diagonal
    ret    
        
    first_column:    
    mov     si, 0   
    jmp     do_check_column   

    second_column:    
    mov     si, 1
    jmp     do_check_column
    
    third_column:    
    mov     si, 2
    jmp     do_check_column       
