;#####################################################
;#
;# Autor: JS
;#
;#####################################################

org 100h

section .data

; Tanque del jugador (verde)
player_x: dw 0
player_y: dw 0
player_sprite: dw player_sprite_f

; Tanques enemigos
enemy1_x: dw 0
enemy1_y: dw 0
enemy1_sprite: dw enemy1_sprite_f
enemy1_alive: db 1
enemy1_dir: db 0
enemy1_timer: db 0
enemy1_speed: db 4;5    ; 1=rapido, 10=lento
enemy1_bullet_x: dw -1
enemy1_bullet_y: dw -1
enemy1_bullet_dx: db 0
enemy1_bullet_dy: db 0
enemy1_bullet_active: db 0
enemy1_shoot_timer: db 0
enemy1_shoot_delay: db 180  

enemy2_x: dw 0
enemy2_y: dw 0
enemy2_sprite: dw enemy2_sprite_f
enemy2_alive: db 1
enemy2_dir: db 1
enemy2_timer: db 50
enemy2_speed: db 4;7    ; 1=rapido, 10=lento
enemy2_bullet_x: dw -1
enemy2_bullet_y: dw -1
enemy2_bullet_dx: db 0
enemy2_bullet_dy: db 0
enemy2_bullet_active: db 0
enemy2_shoot_timer: db 120   ; Random offset
enemy2_shoot_delay: db 180

enemy3_x: dw 0
enemy3_y: dw 0
enemy3_sprite: dw enemy3_sprite_f
enemy3_alive: db 1
enemy3_dir: db 2
enemy3_timer: db 100
enemy3_speed: db 4;6    ; 1=rapido, 10=lento
enemy3_bullet_x: dw -1
enemy3_bullet_y: dw -1
enemy3_bullet_dx: db 0
enemy3_bullet_dy: db 0
enemy3_bullet_active: db 0
enemy3_shoot_timer: db 120  ; Random offset
enemy3_shoot_delay: db 180

; Proyectil
bullet_x: dw -1
bullet_y: dw -1
bullet_active: db 0
bullet_dx: db 0
bullet_dy: db 0

; Estado del juego
game_over: db 0
player_lives: db 3  ; El jugador tiene 3 vidas
tanks_destroyed: db 0  ; Contador para Game Over
tanks: db 1 ;+2 9 Tanques a destruir

; Sprites del jugador (verde - 0Ah)
player_sprite_f:
    db 00011000b
    db 11011011b
    db 11111111b
    db 11100111b
    db 11100111b
    db 11111111b
    db 11111111b
    db 11000011b

player_sprite_r:
    db 11111110b
    db 11111110b
    db 01111100b
    db 01100111b
    db 01100111b
    db 01111100b
    db 11111110b
    db 11111110b

player_sprite_l:
    db 01111111b
    db 01111111b
    db 00111110b
    db 11100110b
    db 11100110b
    db 00111110b
    db 01111111b
    db 01111111b

player_sprite_b: 
    db 11000011b
    db 11111111b    
    db 11111111b
    db 11100111b
    db 11100111b
    db 11111111b   
    db 11011011b    
    db 00011000b

; Sprites enemigo 1 (rojo - 0Ch)
enemy1_sprite_f:
    db 00011000b
    db 11011011b
    db 11111111b
    db 11100111b
    db 11100111b
    db 11111111b
    db 11111111b
    db 11000011b

enemy1_sprite_r:
    db 11111110b
    db 11111110b
    db 01111100b
    db 01100111b
    db 01100111b
    db 01111100b
    db 11111110b
    db 11111110b

enemy1_sprite_l:
    db 01111111b
    db 01111111b
    db 00111110b
    db 11100110b
    db 11100110b
    db 00111110b
    db 01111111b
    db 01111111b

enemy1_sprite_b: 
    db 11000011b
    db 11111111b    
    db 11111111b
    db 11100111b
    db 11100111b
    db 11111111b   
    db 11011011b    
    db 00011000b

; Sprites enemigo 2 (amarillo - 0Eh)
enemy2_sprite_f:
    db 00011000b
    db 11011011b
    db 11111111b
    db 11100111b
    db 11100111b
    db 11111111b
    db 11111111b
    db 11000011b

enemy2_sprite_r:
    db 11111110b
    db 11111110b
    db 01111100b
    db 01100111b
    db 01100111b
    db 01111100b
    db 11111110b
    db 11111110b

enemy2_sprite_l:
    db 01111111b
    db 01111111b
    db 00111110b
    db 11100110b
    db 11100110b
    db 00111110b
    db 01111111b
    db 01111111b

enemy2_sprite_b: 
    db 11000011b
    db 11111111b    
    db 11111111b
    db 11100111b
    db 11100111b
    db 11111111b   
    db 11011011b    
    db 00011000b

; Sprites enemigo 3 (rosado - 0Dh)
enemy3_sprite_f:
    db 00011000b
    db 11011011b
    db 11111111b
    db 11100111b
    db 11100111b
    db 11111111b
    db 11111111b
    db 11000011b

enemy3_sprite_r:
    db 11111110b
    db 11111110b
    db 01111100b
    db 01100111b
    db 01100111b
    db 01111100b
    db 11111110b
    db 11111110b

enemy3_sprite_l:
    db 01111111b
    db 01111111b
    db 00111110b
    db 11100110b
    db 11100110b
    db 00111110b
    db 01111111b
    db 01111111b

enemy3_sprite_b: 
    db 11000011b
    db 11111111b    
    db 11111111b
    db 11100111b
    db 11100111b
    db 11111111b   
    db 11011011b    
    db 00011000b

; Otros sprites
borrar:    
    db 00000000b
    db 00000000b    
    db 00000000b
    db 00000000b
    db 00000000b
    db 00000000b    
    db 00000000b
    db 00000000b

bloque:    
    db 11000111b
    db 11011111b
    db 00011000b
    db 01100111b
    db 01110111b
    db 11111000b
    db 11111010b
    db 00111011b

hojas:    
    db 11100011b
    db 11010000b
    db 00011100b
    db 00100011b
    db 01100011b
    db 11111000b
    db 00100100b
    db 10001011b

token:    
    db 00000000b
    db 01000010b
    db 11100111b
    db 01111110b
    db 00111100b
    db 00011000b
    db 00011000b
    db 01111110b

bullet_sprite:
    db 00000000b
    db 00000000b
    db 00000000b
    db 00011000b
    db 00011000b
    db 00000000b
    db 00000000b
    db 00000000b

bloque_coords:
    ;Bloques izquierda superior
    dw 16, 8
    dw 16, 16
    dw 24, 24
    dw 32, 32

    dw 64, 0

    ;Bloques derecha superior
    dw 296, 8
    dw 296, 16
    dw 288, 24
    dw 280, 32

    dw 248, 0

    ; Lineas verticales
    dw 48, 176  ;Izq
    dw 48, 184
    dw 48, 192

    dw 264, 176 ;Der
    dw 264, 184
    dw 264, 192


    dw 64, 72   ;Izq
    dw 64, 80
    dw 64, 88
    dw 64, 96
    dw 64, 104
    dw 64, 112

    dw 64, 136
    dw 64, 144


    dw 88, 40   ;Izq
    dw 88, 48
    dw 88, 56
    dw 88, 64
    dw 88, 72
    dw 88, 80
    dw 88, 88
    dw 88, 96
    dw 88, 104
    dw 88, 112
    dw 88, 136
    dw 88, 144

    dw 112, 40   ;Izq
    dw 112, 48
    dw 112, 56
    dw 112, 64
    dw 112, 72
    dw 112, 80
    dw 112, 88
    dw 112, 96


    dw 248, 72  ;Der
    dw 248, 80
    dw 248, 88
    dw 248, 96
    dw 248, 104
    dw 248, 112

    dw 248, 136
    dw 248, 144

    dw 224, 40  ;Der
    dw 224, 48
    dw 224, 56
    dw 224, 64
    dw 224, 72
    dw 224, 80
    dw 224, 88
    dw 224, 96
    dw 224, 104
    dw 224, 112
    dw 224, 136
    dw 224, 144

    dw 200, 40   ;Der
    dw 200, 48
    dw 200, 56
    dw 200, 64
    dw 200, 72
    dw 200, 80
    dw 200, 88
    dw 200, 96    

    ; Lineas horizontales izquierdas
    dw 0, 104
    dw 8, 104
    dw 32, 104    
    dw 40, 104

    dw 0, 176
    dw 8, 176
    dw 16, 176
    dw 24, 176
    dw 32, 176
    dw 40, 176
    dw 48, 176

    dw 120, 168

    ; Lineas horizontales derechas
    dw 312, 104
    dw 304, 104
    dw 280, 104    
    dw 272, 104
    
    ; Isla central
    dw 144,56
    dw 168,56
    dw 144,64
    dw 168,64
    dw 144,72
    dw 152,72
    dw 160,72
    dw 168,72

    dw 136,136
    dw 176,136
    dw 136,144
    dw 176,144

    dw 136,152
    dw 144,152    
    dw 152,152
    dw 160,152
    dw 168,152
    dw 176,152

    dw 136,160    
    dw 144,160
    dw 152,160
    dw 160,160
    dw 168,160
    dw 176,160

    ;Bloques inferiores
    dw 144, 176
    dw 152, 176
    dw 160, 176
    dw 168, 176

num_bloques equ ($ - bloque_coords) / 4

hojas_coords:
    ; Cúmulo superior izquierdo
    dw 16, 40
    dw 24, 40
    dw 16, 48
    dw 24, 48
    dw 16, 56
    dw 24, 56  
    dw 16, 64
    dw 24, 64      
    dw 32, 48 ;
    dw 32, 56
    dw 8, 56
    dw 24, 72

    ; Cúmulo superior derecho
    dw 272, 16
    dw 280, 16
    dw 272, 24
    dw 280, 24

    ; Cúmulo en el centro
    dw 152, 96
    dw 160, 96
    dw 152, 104
    dw 160, 104
    dw 152, 112
    dw 160, 112
    dw 168, 104 ;
    dw 168, 112    

    ; Cúmulo inferior derecho (ampliado y aleatorizado)
    dw 280, 168
    dw 288, 168
    dw 296, 168

    dw 280, 176
    dw 288, 176
    dw 296, 176
    dw 272, 176

    dw 280, 184

    dw 296, 184

    dw 288, 192
    dw 296, 192
    dw 280, 192

num_hojas equ ($ - hojas_coords) / 4

token_coords:
    dw 156, 192

 num_token equ ($ - token_coords) / 4

mensaje_menu: 
    db 13, 10,
    db 13, 10,
    db 13, 10,
    db "Presiona 'ENTER' para EMPEZAR o 'ESC' para SALIR", 13, 10 
    db 13, 10,"Presiona '1' para jugar MODO INFINITO $"
win_msg: db "  GANASTE!", 13, 10, "$"
lose_msg: db "GAME OVER!", 13, 10, "$"
tanks_msg: db "Tanques destruidos: $"
restart_msg: db "Presiona 'ENTER' para REINICIAR o 'ESC' para ir al MENU", 13, 10, "$"
msg_lives db 'V:$'
msg_destroyed db 'T.D:$'

section .text

menu:   ;------------------------------------------------------------------------------------------------------------------------------
    mov ax, 0003h
    int 10h

    mov ah, 09h
    mov dx, mensaje_menu
    int 21h  

esperar_tecla_menu:
    mov ah, 0
    int 16h
    cmp al, 27       ; ESC
    je finalizacion
    cmp al, 13       ; ENTER 
    je juego
    cmp al, '1'      ; 1 
    je juego.juego_1

    jmp menu



juego:  ; ----------------------------------------------------------------------------------------------------------------------------
    mov dx, 0 ; Modo de juego: 9 tanques
    jmp .continue

    .juego_1: ; Modo de juego: infinito
        mov dx, 1

    .continue:
    ; Modo de video
    mov ax, 0013h
    int 10h
    cld
    mov ax, 0xA000
    mov es, ax 

    ; Posición inicial del jugador
    mov [player_x], word 120
    mov [player_y], word 192

    ; Cantidad de tanques a destruir (se le suman 2)
    mov [tanks], byte 127
    cmp dx, 1
    je .inf_tanques
    ; Cantidad de tanques a destruir (se le suman 2)
    mov [tanks], byte 7
    .inf_tanques:
    ; Inicia enemigos
    mov [enemy1_x], word 40
    mov [enemy1_y], word 16
    mov [enemy2_x], word 160
    mov [enemy2_y], word 16
    mov [enemy3_x], word 280
    mov [enemy3_y], word 16
    
    ; Reinicia estado de enemigos
    mov [enemy1_alive], byte 1
    mov [enemy2_alive], byte 1
    mov [enemy3_alive], byte 1
    
    ; Inicia proyectil
    mov [bullet_x], word -1
    mov [bullet_y], word -1
    mov [bullet_active], byte 0
    
    ; Vidas
    mov [player_lives], byte 3
    
    ; Reinicia game over
    mov [game_over], byte 0
    
    ; Reinicia el contador de tanques destruidos
    mov [tanks_destroyed], byte 0

    .loop_juego:
        ; Chequea game over
        cmp byte [game_over], 1
        je game_end

        call clear_screen
        call draw_all
        call update_enemies
        call update_enemy_bullets
        call update_bullet
        call check_bullet_collisions
        call check_enemy_bullet_vs_player
        call check_enemy_respawn

        mov ah, 1
        int 16h
        jz .loop_juego  ; continuar loop_juego
        
        ; Detecta si hay alguna tecla presionada
        mov ah, 0
        int 16h
        
        cmp ah, 4Bh         ; Left arrow
        je .mover_izq
        cmp ah, 4Dh         ; Right arrow
        je .mover_der
        cmp ah, 48h         ; Up arrow
        je .mover_arriba
        cmp ah, 50h         ; Down arrow
        je .mover_abajo
        cmp al, 32          ; SPACE - shoot
        je .shoot
        cmp al, 27          ; ESC
        je menu
        
       jmp .loop_juego

    .shoot:
        cmp byte [bullet_active], 1
        je .loop_juego
        
        ; Crea proyectil en posicion del jugador
        mov ax, [player_x]
        mov [bullet_x], ax
        mov ax, [player_y]
        mov [bullet_y], ax
        mov byte [bullet_active], 1
        
        ; direccion del proyectil
        mov ax, [player_sprite]
        cmp ax, player_sprite_f
        je .bullet_up
        cmp ax, player_sprite_b
        je .bullet_down
        cmp ax, player_sprite_l
        je .bullet_left
        ; Default derecha
        mov byte [bullet_dx], 4
        mov byte [bullet_dy], 0
        jmp .loop_juego
        
    .bullet_up:
        mov byte [bullet_dx], 0
        mov byte [bullet_dy], -4
        jmp .loop_juego
        
    .bullet_down:
        mov byte [bullet_dx], 0
        mov byte [bullet_dy], 4
        jmp .loop_juego
        
    .bullet_left:
        mov byte [bullet_dx], -4
        mov byte [bullet_dy], 0
        jmp .loop_juego
    
    .mover_izq:
        mov word [player_sprite], player_sprite_l
        mov ax, [player_x]
        sub ax, 2
        cmp ax, 0
        jl .loop_juego
        mov bx, ax
        mov cx, [player_y]        
        call can_move
        cmp dl, 1
        je .loop_juego
        mov [player_x], ax
        jmp .loop_juego
    
    .mover_der:
        mov word [player_sprite], player_sprite_r
        mov ax, [player_x]
        add ax, 2
        cmp ax, 312
        jg .loop_juego
        mov bx, ax
        mov cx, [player_y]
        call can_move
        cmp dl, 1
        je .loop_juego
        mov [player_x], ax
        jmp .loop_juego
    
    .mover_arriba:
        mov word [player_sprite], player_sprite_f
        mov ax, [player_y]
        sub ax, 2
        cmp ax, 0
        jl .loop_juego
        mov cx, ax
        mov bx, [player_x]
        call can_move
        cmp dl, 1
        je .loop_juego
        mov [player_y], ax
        jmp .loop_juego   
    
    .mover_abajo:
        mov word [player_sprite], player_sprite_b
        mov ax, [player_y]
        add ax, 2
        cmp ax, 192
        jg .loop_juego
        mov cx, ax
        mov bx, [player_x]
        call can_move
        cmp dl, 1
        je .loop_juego
        mov [player_y], ax
        jmp .loop_juego

; Fin de la partida----------------------------------------------------------------------------------------
game_end:
    ; compara si se gano/perdio
    cmp byte [player_lives], 0
    je show_game_over
    
    mov al, [enemy1_alive]
    add al, [enemy2_alive]
    add al, [enemy3_alive]
    cmp al, 0
    je show_win
    jmp show_game_over

; Pantalla Victoria----------------------------------------------------------------------------------------    
show_win:
    mov ax, 0003h
    int 10h
    
    ; Posicion de cursor para GAME OVER
    mov ah, 2
    mov bh, 0
    mov dh, 10
    mov dl, 25
    int 10h
    
    mov ah, 09h
    mov dx, win_msg
    int 21h
    
    ; Tanques destruidos
    mov ah, 2
    mov bh, 0
    mov dh, 12
    mov dl, 20
    int 10h
    
    mov ah, 09h
    mov dx, tanks_msg
    int 21h
    
    mov al, [tanks_destroyed]
    add al, '0'  ; Conversion a ASCII
    mov ah, 0eh
    int 10h
    
    ; Posición de cursor para mensaje reiniciar
    mov ah, 2
    mov bh, 0
    mov dh, 14
    mov dl, 20
    int 10h
    
    mov ah, 09h
    mov dx, restart_msg
    int 21h
    
    .wait_restart:
        mov ah, 0
        int 16h
        cmp al, 13  ; ENTER
        je juego    
        cmp al, 27  ; ESC
        je menu     
        jmp .wait_restart

; Muestra pantalla Game Over    
show_game_over:
    mov ax, 0003h
    int 10h
    
    ; Posicion de cursor para GAME OVER
    mov ah, 2
    mov bh, 0
    mov dh, 10
    mov dl, 25
    int 10h
    
    mov ah, 09h
    mov dx, lose_msg
    int 21h
    
    ; Tanques destruidos
    mov ah, 2
    mov bh, 0
    mov dh, 12
    mov dl, 20
    int 10h
    
    mov ah, 09h
    mov dx, tanks_msg
    int 21h
    
    mov al, [tanks_destroyed]
    add al, '0'  ; Conversion a ASCII
    mov ah, 0eh
    int 10h
    
    ; Posición de cursor para mensaje reiniciar
    mov ah, 2
    mov bh, 0
    mov dh, 14
    mov dl, 20
    int 10h
    
    mov ah, 09h
    mov dx, restart_msg
    int 21h
    
    .wait_restart:
        mov ah, 0
        int 16h
        cmp al, 13  ; ENTER
        je juego    
        cmp al, 27  ; ESC
        je menu     
        jmp .wait_restart

; Dibujar interfaz inferior izquierda: vidas y tanques destruidos
draw_ui:
    pusha

    ; Línea 1: "Lives: X"
    mov ah, 02h         ; Mover cursor
    mov bh, 0
    mov dh, 23          ; Fila 23 (una antes de la última)
    mov dl, 0           ; Columna 0
    int 10h

    mov ah, 09h
    mov dx, msg_lives
    int 21h

    mov al, [player_lives]
    add al, '0'
    mov ah, 0Eh
    int 10h

    ; Línea 2: "Destroyed: Y"
    mov ah, 02h
    mov bh, 0
    mov dh, 24          ; Fila 24 (última línea)
    mov dl, 0           ; Columna 0
    int 10h

    mov ah, 09h
    mov dx, msg_destroyed
    int 21h

    mov al, [tanks_destroyed]
    add al, '0'
    mov ah, 0Eh
    int 10h

    popa
    ret

; Movimiento de enemigos y direccion de su proyectil----------------------------------------------------------------------------------------
update_enemies:
    ; Actualizar enemigo 1 (rojo)
    cmp byte [enemy1_alive], 0
    je .skip_enemy1
    
    ; Timer de movimiento
    inc byte [enemy1_timer]
    mov al, [enemy1_speed]
    cmp [enemy1_timer], al
    jl .no_move1
    mov byte [enemy1_timer], 0
    
    ; IA simple enemigo 1............................................
    mov al, [enemy1_dir]
    cmp al, 0
    je .enemy1_up
    cmp al, 1
    je .enemy1_down
    cmp al, 2
    je .enemy1_left
    ; Derecha
    mov word [enemy1_sprite], enemy1_sprite_r
    mov ax, [enemy1_x]
    add ax, 4
    cmp ax, 312
    jg .enemy1_change_dir
    mov bx, ax
    mov cx, [enemy1_y]
    call can_move
    cmp dl, 1
    je .enemy1_change_dir
    mov [enemy1_x], ax
    jmp .no_move1
    
    .enemy1_up:
        mov word [enemy1_sprite], enemy1_sprite_f
        mov ax, [enemy1_y]
        sub ax, 4
        cmp ax, 0
        jl .enemy1_change_dir
        mov cx, ax
        mov bx, [enemy1_x]
        call can_move
        cmp dl, 1
        je .enemy1_change_dir
        mov [enemy1_y], ax
        jmp .no_move1
        
    .enemy1_down:
        mov word [enemy1_sprite], enemy1_sprite_b
        mov ax, [enemy1_y]
        add ax, 4
        cmp ax, 192
        jg .enemy1_change_dir
        mov cx, ax
        mov bx, [enemy1_x]
        call can_move
        cmp dl, 1
        je .enemy1_change_dir
        mov [enemy1_y], ax
        jmp .no_move1
        
    .enemy1_left:
        mov word [enemy1_sprite], enemy1_sprite_l
        mov ax, [enemy1_x]
        sub ax, 4
        cmp ax, 0
        jl .enemy1_change_dir
        mov bx, ax
        mov cx, [enemy1_y]
        call can_move
        cmp dl, 1
        je .enemy1_change_dir
        mov [enemy1_x], ax
        jmp .no_move1
        
    .enemy1_change_dir:         ; Cambia de dirección contando de 1 a 3
        inc byte [enemy1_dir]
        and byte [enemy1_dir], 3

    ; Disparo de enemigo 1   
    .no_move1:       
        inc byte [enemy1_shoot_timer]
        mov al, [enemy1_shoot_delay]
        cmp [enemy1_shoot_timer], al
        jl .skip_enemy1
        
        ; Disparar si no hay proyectil activo
        cmp byte [enemy1_bullet_active], 1
        je .skip_enemy1
        
        ; Crear proyectil en posicion del enemigo
        mov ax, [enemy1_x]
        mov [enemy1_bullet_x], ax
        mov ax, [enemy1_y]
        mov [enemy1_bullet_y], ax
        mov byte [enemy1_bullet_active], 1
        
        ; Direccion del proyectil
        mov ax, [enemy1_sprite]
        cmp ax, enemy1_sprite_f
        je .enemy1_bullet_up
        cmp ax, enemy1_sprite_b
        je .enemy1_bullet_down
        cmp ax, enemy1_sprite_l
        je .enemy1_bullet_left
        ; Default derecha
        mov byte [enemy1_bullet_dx], 4
        mov byte [enemy1_bullet_dy], 0
        jmp .reset_timer1
        
    .enemy1_bullet_up:
        mov byte [enemy1_bullet_dx], 0
        mov byte [enemy1_bullet_dy], -4
        jmp .reset_timer1
        
    .enemy1_bullet_down:
        mov byte [enemy1_bullet_dx], 0
        mov byte [enemy1_bullet_dy], 4
        jmp .reset_timer1
        
    .enemy1_bullet_left:
        mov byte [enemy1_bullet_dx], -4
        mov byte [enemy1_bullet_dy], 0
        
    .reset_timer1:
        mov byte [enemy1_shoot_timer], 0

    ; IA para enemigo 2............................................    
    .skip_enemy1:
        cmp byte [enemy2_alive], 0
        je .skip_enemy2
        
        inc byte [enemy2_timer]
        mov al, [enemy2_speed]
        cmp [enemy2_timer], al
        jl .no_move2
        mov byte [enemy2_timer], 0
        
        mov al, [enemy2_dir]
        cmp al, 0
        je .enemy2_up
        cmp al, 1
        je .enemy2_down
        cmp al, 2
        je .enemy2_left
        
        mov word [enemy2_sprite], enemy2_sprite_r
        mov ax, [enemy2_x]
        add ax, 4
        cmp ax, 312
        jg .enemy2_change_dir
        mov bx, ax
        mov cx, [enemy2_y]
        call can_move
        cmp dl, 1
        je .enemy2_change_dir
        mov [enemy2_x], ax
        jmp .no_move2
        
    .enemy2_up:
        mov word [enemy2_sprite], enemy2_sprite_f
        mov ax, [enemy2_y]
        sub ax, 4  
        cmp ax, 0
        jl .enemy2_change_dir
        mov cx, ax
        mov bx, [enemy2_x]
        call can_move
        cmp dl, 1
        je .enemy2_change_dir
        mov [enemy2_y], ax
        jmp .no_move2
        
    .enemy2_down:
        mov word [enemy2_sprite], enemy2_sprite_b
        mov ax, [enemy2_y]
        add ax, 4  
        cmp ax, 192
        jg .enemy2_change_dir
        mov cx, ax
        mov bx, [enemy2_x]
        call can_move
        cmp dl, 1
        je .enemy2_change_dir
        mov [enemy2_y], ax
        jmp .no_move2
        
    .enemy2_left:
        mov word [enemy2_sprite], enemy2_sprite_l
        mov ax, [enemy2_x]
        sub ax, 4  
        cmp ax, 0
        jl .enemy2_change_dir
        mov bx, ax
        mov cx, [enemy2_y]
        call can_move
        cmp dl, 1
        je .enemy2_change_dir
        mov [enemy2_x], ax
        jmp .no_move2
        
    .enemy2_change_dir:
        mov ah, 2ch
        int 21h     ; Randomizacion de movimiento con tiempo
        mov al, dl  ; centesimas
        add al, dh  ; segundos
        and al, 3   ; 0-3 direcciones
        ; Debe ser diferente a direccion actual
        cmp al, [enemy2_dir]
        jne .set_enemy2_dir
        inc al
        and al, 3
    .set_enemy2_dir:
        mov [enemy2_dir], al
        
    .no_move2:
        ; Cambio de dirección frecuente
        mov ah, 2ch
        int 21h
        mov al, dl
        and al, 99
        cmp al, 0
        jne .no_random_change2
        
        ; cambio de direccon con bias a exploracion
        mov al, dh  ; segundos
        add al, dl  ; centesimas
        and al, 3

        cmp al, [enemy2_dir]
        jne .set_new_dir2
        inc al
        and al, 3
        cmp al, [enemy2_dir]
        jne .set_new_dir2
        inc al
        and al, 3
    .set_new_dir2:
        mov [enemy2_dir], al

    ; Disparo de enemigo 2    
    .no_random_change2:
        inc byte [enemy2_shoot_timer]
        mov al, [enemy2_shoot_delay]
        cmp [enemy2_shoot_timer], al
        jl .skip_enemy2
        
        cmp byte [enemy2_bullet_active], 1
        je .skip_enemy2
        
        mov ax, [enemy2_x]
        mov [enemy2_bullet_x], ax
        mov ax, [enemy2_y]
        mov [enemy2_bullet_y], ax
        mov byte [enemy2_bullet_active], 1
        
        ; direccion de disparo
        mov ax, [enemy2_sprite]
        cmp ax, enemy2_sprite_f
        je .enemy2_bullet_up
        cmp ax, enemy2_sprite_b
        je .enemy2_bullet_down
        cmp ax, enemy2_sprite_l
        je .enemy2_bullet_left
        ; Default derecha
        mov byte [enemy2_bullet_dx], 4
        mov byte [enemy2_bullet_dy], 0
        jmp .reset_timer2
        
    .enemy2_bullet_up:
        mov byte [enemy2_bullet_dx], 0
        mov byte [enemy2_bullet_dy], -4
        jmp .reset_timer2
        
    .enemy2_bullet_down:
        mov byte [enemy2_bullet_dx], 0
        mov byte [enemy2_bullet_dy], 4
        jmp .reset_timer2
        
    .enemy2_bullet_left:
        mov byte [enemy2_bullet_dx], -4
        mov byte [enemy2_bullet_dy], 0
        
    .reset_timer2:
        mov byte [enemy2_shoot_timer], 0

    ; IA enemigo 3............................................   
    .skip_enemy2:        
        cmp byte [enemy3_alive], 0
        je .skip_enemy3
        
        inc byte [enemy3_timer]
        mov al, [enemy3_speed]
        cmp [enemy3_timer], al
        jl .no_move3
        mov byte [enemy3_timer], 0
        
        mov al, [enemy3_dir]
        cmp al, 0
        je .enemy3_up
        cmp al, 1
        je .enemy3_down
        cmp al, 2
        je .enemy3_left
        
        mov word [enemy3_sprite], enemy3_sprite_r
        mov ax, [enemy3_x]
        add ax, 4
        cmp ax, 312
        jg .enemy3_change_dir
        mov bx, ax
        mov cx, [enemy3_y]
        call can_move
        cmp dl, 1
        je .enemy3_change_dir
        mov [enemy3_x], ax
        jmp .no_move3
        
    .enemy3_up:
        mov word [enemy3_sprite], enemy3_sprite_f
        mov ax, [enemy3_y]
        sub ax, 4
        cmp ax, 0
        jl .enemy3_change_dir
        mov cx, ax
        mov bx, [enemy3_x]
        call can_move
        cmp dl, 1
        je .enemy3_change_dir
        mov [enemy3_y], ax
        jmp .no_move3
        
    .enemy3_down:
        mov word [enemy3_sprite], enemy3_sprite_b
        mov ax, [enemy3_y]
        add ax, 4
        cmp ax, 192
        jg .enemy3_change_dir
        mov cx, ax
        mov bx, [enemy3_x]
        call can_move
        cmp dl, 1
        je .enemy3_change_dir
        mov [enemy3_y], ax
        jmp .no_move3
        
    .enemy3_left:
        mov word [enemy3_sprite], enemy3_sprite_l
        mov ax, [enemy3_x]
        sub ax, 4
        cmp ax, 0
        jl .enemy3_change_dir
        mov bx, ax
        mov cx, [enemy3_y]
        call can_move
        cmp dl, 1
        je .enemy3_change_dir
        mov [enemy3_x], ax
        jmp .no_move3

    ; Cambio de dirección enemigo 3    
    .enemy3_change_dir:
        mov ah, 2ch
        int 21h
        mov al, dh  ; Usa segundos para randomizar (diferente al en2)
        and al, 3   ; 0-3 direcciones
        mov [enemy3_dir], al
        
    .no_move3:
        ; Cambio de direccion (10%)
        mov ah, 2ch
        int 21h
        mov al, dh
        and al, 9  ; 0-9
        cmp al, 1   ; 1 de 10
        jne .no_random_change3
        
        ; cambio de direccion random
        mov al, dl
        and al, 3
        mov [enemy3_dir], al

    ; Disparo de enemigo 3   
    .no_random_change3:        
        inc byte [enemy3_shoot_timer]
        mov al, [enemy3_shoot_delay]
        cmp [enemy3_shoot_timer], al
        jl .skip_enemy3
        
        cmp byte [enemy3_bullet_active], 1
        je .skip_enemy3
        
        mov ax, [enemy3_x]
        mov [enemy3_bullet_x], ax
        mov ax, [enemy3_y]
        mov [enemy3_bullet_y], ax
        mov byte [enemy3_bullet_active], 1
        
        ; direccion de proyectil
        mov ax, [enemy3_sprite]
        cmp ax, enemy3_sprite_f
        je .enemy3_bullet_up
        cmp ax, enemy3_sprite_b
        je .enemy3_bullet_down
        cmp ax, enemy3_sprite_l
        je .enemy3_bullet_left
        ; Default derecha
        mov byte [enemy3_bullet_dx], 4
        mov byte [enemy3_bullet_dy], 0
        jmp .reset_timer3
        
    .enemy3_bullet_up:
        mov byte [enemy3_bullet_dx], 0
        mov byte [enemy3_bullet_dy], -4
        jmp .reset_timer3
        
    .enemy3_bullet_down:
        mov byte [enemy3_bullet_dx], 0
        mov byte [enemy3_bullet_dy], 4
        jmp .reset_timer3
        
    .enemy3_bullet_left:
        mov byte [enemy3_bullet_dx], -4
        mov byte [enemy3_bullet_dy], 0
        
    .reset_timer3:
        mov byte [enemy3_shoot_timer], 0
        
    .skip_enemy3:
        ret

; Actualiza proyectil del jugador----------------------------------------------------------------------------------------
update_bullet:
    cmp byte [bullet_active], 0
    je .no_bullet
    
    ; Mover proyectil
    mov al, [bullet_dx]
    cbw
    add [bullet_x], ax
    mov al, [bullet_dy]
    cbw
    add [bullet_y], ax
    
    ; Chequea limites del mapa
    cmp word [bullet_x], 0
    jl .remove_bullet
    cmp word [bullet_x], 312
    jg .remove_bullet
    cmp word [bullet_y], 0
    jl .remove_bullet
    cmp word [bullet_y], 200
    jg .remove_bullet
    
    ; Chequea bloques
    mov bx, [bullet_x]
    mov cx, [bullet_y]
    call can_move
    cmp dl, 1
    je .remove_bullet
    jmp .no_bullet
    
    .remove_bullet:
        mov byte [bullet_active], 0
        mov word [bullet_x], -1
        
    .no_bullet:
        ret

; Detecta colision de proyectil con los enemigos----------------------------------------------------------------------------------------
check_bullet_collisions:
    cmp byte [bullet_active], 0
    je .no_collision

    ; Enemigo 1
    cmp byte [enemy1_alive], 0
    je .check_enemy2

    mov ax, [bullet_x]
    mov bx, [enemy1_x]
    sub bx, 4
    cmp ax, bx
    jl .check_enemy2
    mov bx, [enemy1_x]
    add bx, 4
    cmp ax, bx
    jg .check_enemy2

    mov ax, [bullet_y]
    mov bx, [enemy1_y]
    sub bx, 4
    cmp ax, bx
    jl .check_enemy2
    mov bx, [enemy1_y]
    add bx, 4
    cmp ax, bx
    jg .check_enemy2

    ; Choca con enemigo 1
    mov byte [enemy1_alive], 0
    mov byte [bullet_active], 0
    inc byte [tanks_destroyed]

.check_enemy2:
    cmp byte [bullet_active], 0
    je .no_collision
    cmp byte [enemy2_alive], 0
    je .check_enemy3

    mov ax, [bullet_x]
    mov bx, [enemy2_x]
    sub bx, 4
    cmp ax, bx
    jl .check_enemy3
    mov bx, [enemy2_x]
    add bx, 4
    cmp ax, bx
    jg .check_enemy3

    mov ax, [bullet_y]
    mov bx, [enemy2_y]
    sub bx, 4
    cmp ax, bx
    jl .check_enemy3
    mov bx, [enemy2_y]
    add bx, 4
    cmp ax, bx
    jg .check_enemy3

    ; Choca con enemigo 2
    mov byte [enemy2_alive], 0
    mov byte [bullet_active], 0
    inc byte [tanks_destroyed]

.check_enemy3:
    cmp byte [bullet_active], 0
    je .no_collision
    cmp byte [enemy3_alive], 0
    je .no_collision

    mov ax, [bullet_x]
    mov bx, [enemy3_x]
    sub bx, 4
    cmp ax, bx
    jl .no_collision
    mov bx, [enemy3_x]
    add bx, 4
    cmp ax, bx
    jg .no_collision

    mov ax, [bullet_y]
    mov bx, [enemy3_y]
    sub bx, 4
    cmp ax, bx
    jl .no_collision
    mov bx, [enemy3_y]
    add bx, 4
    cmp ax, bx
    jg .no_collision

    ; Choca con enemigo 3
    mov byte [enemy3_alive], 0
    mov byte [bullet_active], 0
    inc byte [tanks_destroyed]

.no_collision:
    ret

; Actualiza proyectil de enemigos----------------------------------------------------------------------------------------
update_enemy_bullets:
    ; Proyectil de enemigo 1
    cmp byte [enemy1_bullet_active], 0
    je .no_enemy1_bullet
    
    mov al, [enemy1_bullet_dx]
    cbw
    add [enemy1_bullet_x], ax
    mov al, [enemy1_bullet_dy]
    cbw
    add [enemy1_bullet_y], ax
    
    ; limites de mapa
    cmp word [enemy1_bullet_x], 0
    jl .remove_enemy1_bullet
    cmp word [enemy1_bullet_x], 312
    jg .remove_enemy1_bullet
    cmp word [enemy1_bullet_y], 0
    jl .remove_enemy1_bullet
    cmp word [enemy1_bullet_y], 200
    jg .remove_enemy1_bullet
    
    ; choque con bloques
    mov bx, [enemy1_bullet_x]
    mov cx, [enemy1_bullet_y]
    call can_move
    cmp dl, 1
    je .remove_enemy1_bullet
    jmp .no_enemy1_bullet
    
    .remove_enemy1_bullet:
        mov byte [enemy1_bullet_active], 0

    ; Proyectil de enemigo 2    
    .no_enemy1_bullet:
        cmp byte [enemy2_bullet_active], 0
        je .no_enemy2_bullet
        
        mov al, [enemy2_bullet_dx]
        cbw
        add [enemy2_bullet_x], ax
        mov al, [enemy2_bullet_dy]
        cbw
        add [enemy2_bullet_y], ax
        
        ; limites de mapa
        cmp word [enemy2_bullet_x], 0
        jl .remove_enemy2_bullet
        cmp word [enemy2_bullet_x], 312
        jg .remove_enemy2_bullet
        cmp word [enemy2_bullet_y], 0
        jl .remove_enemy2_bullet
        cmp word [enemy2_bullet_y], 200
        jg .remove_enemy2_bullet
        
        ; choca con bloques
        mov bx, [enemy2_bullet_x]
        mov cx, [enemy2_bullet_y]
        call can_move
        cmp dl, 1
        je .remove_enemy2_bullet
        jmp .no_enemy2_bullet
        
    .remove_enemy2_bullet:
        mov byte [enemy2_bullet_active], 0

    ; Proyectil de enemigo 3    
    .no_enemy2_bullet:        
        cmp byte [enemy3_bullet_active], 0
        je .no_enemy3_bullet
        
        mov al, [enemy3_bullet_dx]
        cbw
        add [enemy3_bullet_x], ax
        mov al, [enemy3_bullet_dy]
        cbw
        add [enemy3_bullet_y], ax
        
        ; limites de mapa
        cmp word [enemy3_bullet_x], 0
        jl .remove_enemy3_bullet
        cmp word [enemy3_bullet_x], 312
        jg .remove_enemy3_bullet
        cmp word [enemy3_bullet_y], 0
        jl .remove_enemy3_bullet
        cmp word [enemy3_bullet_y], 200
        jg .remove_enemy3_bullet
        
        ; Choca con bloques
        mov bx, [enemy3_bullet_x]
        mov cx, [enemy3_bullet_y]
        call can_move
        cmp dl, 1
        je .remove_enemy3_bullet
        jmp .no_enemy3_bullet
        
    .remove_enemy3_bullet:
        mov byte [enemy3_bullet_active], 0
        
    .no_enemy3_bullet:
        ret

; Colisión de proyectil con jugador----------------------------------------------------------------------------------------
check_enemy_bullet_vs_player:
    cmp byte [enemy1_bullet_active], 0
    je .check_enemy2_bullet

    mov ax, [enemy1_bullet_x]
    mov bx, [player_x]
    sub bx, 4
    cmp ax, bx
    jl .check_enemy2_bullet
    mov bx, [player_x]
    add bx, 4
    cmp ax, bx
    jg .check_enemy2_bullet

    mov ax, [enemy1_bullet_y]
    mov bx, [player_y]
    sub bx, 4
    cmp ax, bx
    jl .check_enemy2_bullet
    mov bx, [player_y]
    add bx, 4
    cmp ax, bx
    jg .check_enemy2_bullet

    ; Choca con jugador - respawn
    call respawn_player
    mov byte [enemy1_bullet_active], 0
    ret

.check_enemy2_bullet:
    cmp byte [enemy2_bullet_active], 0
    je .check_enemy3_bullet

    mov ax, [enemy2_bullet_x]
    mov bx, [player_x]
    sub bx, 4
    cmp ax, bx
    jl .check_enemy3_bullet
    mov bx, [player_x]
    add bx, 4
    cmp ax, bx
    jg .check_enemy3_bullet

    mov ax, [enemy2_bullet_y]
    mov bx, [player_y]
    sub bx, 4
    cmp ax, bx
    jl .check_enemy3_bullet
    mov bx, [player_y]
    add bx, 4
    cmp ax, bx
    jg .check_enemy3_bullet

    call respawn_player
    mov byte [enemy2_bullet_active], 0
    ret

.check_enemy3_bullet:
    cmp byte [enemy3_bullet_active], 0
    je .no_hit

    mov ax, [enemy3_bullet_x]
    mov bx, [player_x]
    sub bx, 4
    cmp ax, bx
    jl .no_hit
    mov bx, [player_x]
    add bx, 4
    cmp ax, bx
    jg .no_hit

    mov ax, [enemy3_bullet_y]
    mov bx, [player_y]
    sub bx, 4
    cmp ax, bx
    jl .no_hit
    mov bx, [player_y]
    add bx, 4
    cmp ax, bx
    jg .no_hit

    call respawn_player
    mov byte [enemy3_bullet_active], 0

.no_hit:
    ret

; Reinicia al jugador luego de perder una vida----------------------------------------------------------------------------------------
respawn_player:
    ; Disminuye 1 vida
    dec byte [player_lives]
    cmp byte [player_lives], 0
    je .game_over
    
    mov [player_x], word 120
    mov [player_y], word 192    
    
    mov byte [bullet_active], 0
    ret
    ; Si se pierden todas las vidas hay Game Over    
    .game_over:
        mov byte [game_over], 1
        ret

; Revisa si los enemigos estan muertos----------------------------------------------------------------------------------------
check_enemy_respawn:    
    mov al, [tanks]
    cmp byte [tanks_destroyed], al
    jge .destroyed  

    mov al, [enemy1_alive]
    cmp al, 0
    jne .skip_1
    call respawn_enemy1

    .skip_1:
    mov al, [enemy2_alive]
    cmp al, 0
    jne .skip_2
    call respawn_enemy2

    .skip_2:
    mov al, [enemy3_alive]
    cmp al, 0
    jne .skip
    call respawn_enemy3

    .skip:
        ret
    
    .destroyed:   
        mov al, [enemy1_alive]
        add al, [enemy2_alive] 
        add al, [enemy3_alive]
        cmp al, 0           
        je game_end
        ret

; Halla posicion segura para enemigo 1--------------------------------------------
respawn_enemy1:
    .find_safe_pos1:
        mov ah, 2ch
        int 21h
        
        mov al, dh  ; Usa segundos
        and al, 31
        mov bl, 8
        mul bl
        add ax, 24
        mov bx, ax
        
        mov al, dl  ; Usa centesimas
        and al, 7
        mov bl, 16
        mul bl
        add ax, 16
        mov cx, ax
        
        call can_move
        cmp dl, 1
        je .find_safe_pos1
        
        ; Reinicio de enemigo 1
        mov [enemy1_x], bx
        mov [enemy1_y], cx
        mov [enemy1_alive], byte 1
        mov [enemy1_bullet_active], byte 0
        mov [enemy1_timer], byte 0
        mov [enemy1_shoot_timer], byte 0
        ret
; Halla posicion segura para enemigo 2--------------------------------------------
respawn_enemy2:
    .find_safe_pos2:
        mov ah, 2ch
        int 21h
        
        mov al, dh
        add al, 10  ; Offset para posicion diferente
        and al, 31
        mov bl, 8
        mul bl
        add ax, 24
        mov bx, ax
        
        mov al, dl
        add al, 5
        and al, 7
        mov bl, 16
        mul bl
        add ax, 16
        mov cx, ax
        
        call can_move
        cmp dl, 1
        je .find_safe_pos2
        
        ; Reinicio de enemigo 2
        mov [enemy2_x], bx
        mov [enemy2_y], cx
        mov [enemy2_alive], byte 1
        mov [enemy2_bullet_active], byte 0
        mov [enemy2_timer], byte 50
        mov [enemy2_shoot_timer], byte 60
        ret
; Halla posicion segura para enemigo 3--------------------------------------------
respawn_enemy3:    
    .find_safe_pos3:
        mov ah, 2ch
        int 21h
        
        mov al, dh
        add al, 20  ; Diferente offset
        and al, 31
        mov bl, 8
        mul bl
        add ax, 24
        mov bx, ax
        
        mov al, dl
        add al, 15
        and al, 7
        mov bl, 16
        mul bl
        add ax, 16
        mov cx, ax
        
        call can_move
        cmp dl, 1
        je .find_safe_pos3
        
        ; Reinicio de enemigo 3
        mov [enemy3_x], bx
        mov [enemy3_y], cx
        mov [enemy3_alive], byte 1
        mov [enemy3_bullet_active], byte 0
        mov [enemy3_timer], byte 100
        mov [enemy3_shoot_timer], byte 120
        ret

; Dibuja todo lo que se ve en pantalla----------------------------------------------------------------------------------------
draw_all:
    ; Dibuja UI
    call draw_ui
    
    ; Dibuja jugador
    mov bx, [player_x]
    mov cx, [player_y]
    mov si, [player_sprite]
    mov dl, 0Ah  ; verde
    call draw_sprite

    ; Dibuja enemigos
    cmp byte [enemy1_alive], 0
    je .skip_enemy1
    mov bx, [enemy1_x]
    mov cx, [enemy1_y]
    mov si, [enemy1_sprite]
    mov dl, 0Ch  ; rojo
    call draw_sprite
    
    .skip_enemy1:
        cmp byte [enemy2_alive], 0
        je .skip_enemy2
        mov bx, [enemy2_x]
        mov cx, [enemy2_y]
        mov si, [enemy2_sprite]
        mov dl, 0Eh  ; amarillo
        call draw_sprite
        
    .skip_enemy2:
        cmp byte [enemy3_alive], 0
        je .skip_enemy3
        mov bx, [enemy3_x]
        mov cx, [enemy3_y]
        mov si, [enemy3_sprite]
        mov dl, 0Dh  ; rosado
        call draw_sprite

    ; Dibuja bloques    
    .skip_enemy3:       
        mov bp, bloque_coords
        mov di, num_bloques

    .draw_blocks:
        mov bx, [bp]
        mov cx, [bp+2]
        mov si, bloque
        mov dl, 08h  ; Color de bloques
        call draw_sprite
        add bp, 4
        dec di
        jnz .draw_blocks

    ; Dibuja hojas
        mov bp, hojas_coords
        mov di, num_hojas    
    .draw_hojas:
        mov bx, [bp]
        mov cx, [bp+2]
        mov si, hojas
        mov dl, 02h  ; Color de hojas
        call draw_sprite
        add bp, 4
        dec di
        jnz .draw_hojas

        ; Dibuja hojas
        mov bp, token_coords
        mov di, num_token    
    .draw_token:
        mov bx, [bp]
        mov cx, [bp+2]
        mov si, token
        mov dl, 07h  ; Color de token
        call draw_sprite

        ; Dibuja proyectil
        cmp byte [bullet_active], 0
        je .no_bullet
        mov bx, [bullet_x]
        mov cx, [bullet_y]
        mov si, bullet_sprite
        mov dl, 0Fh  ; White
        call draw_sprite
        
    ; Dibuja proyectil de enemigos
    .no_bullet:       
        cmp byte [enemy1_bullet_active], 0
        je .no_enemy1_bullet
        mov bx, [enemy1_bullet_x]
        mov cx, [enemy1_bullet_y]
        mov si, bullet_sprite
        mov dl, 0Ch  ; Red
        call draw_sprite
        
    .no_enemy1_bullet:
        cmp byte [enemy2_bullet_active], 0
        je .no_enemy2_bullet
        mov bx, [enemy2_bullet_x]
        mov cx, [enemy2_bullet_y]
        mov si, bullet_sprite
        mov dl, 0Eh  ; Yellow
        call draw_sprite
        
    .no_enemy2_bullet:
        cmp byte [enemy3_bullet_active], 0
        je .no_enemy3_bullet
        mov bx, [enemy3_bullet_x]
        mov cx, [enemy3_bullet_y]
        mov si, bullet_sprite
        mov dl, 0Dh  ; Pink
        call draw_sprite
        
    .no_enemy3_bullet:
        ret

; Borra la pantalla----------------------------------------------------------------------------------------
clear_screen:
    xor di, di
    mov cx, 320*200
    xor ax, ax
    rep stosb
    ret

; Revisa si hay colision con bloque y evita el paso----------------------------------------------------------------------------------------
check_collision:
    .next_block:
        mov dx, [bp]     ; block_x
        mov si, [bp+2]   ; block_y

        ; revisa overlap
        mov ax, dx
        add ax, 8
        cmp bx, ax
        jge .no_overlap

        mov ax, bx
        add ax, 8
        cmp ax, dx
        jle .no_overlap

        mov ax, si
        add ax, 8
        cmp cx, ax
        jge .no_overlap

        mov ax, cx
        add ax, 8
        cmp ax, si
        jle .no_overlap

        ; Colision
        mov dl, 1
        ret

    .no_overlap:
        add bp, 4
        dec di
        jnz .next_block
        mov dl, 0
        ret

; Indica si se puede mover el tanque----------------------------------------------------------------------------------------
can_move:
    push ax
    push si
    push bp
    push di

    mov bp, bloque_coords
    mov di, num_bloques
    call check_collision

    pop di
    pop bp
    pop si
    pop ax
    ret

; Dibuja un sprite----------------------------------------------------------------------------------------
draw_sprite:
    push di
    push ax
    call get_screen_offset

    mov cx, 8

    .next_row:
        push cx
        lodsb
        mov bl, al
        mov cx, 8

    .next_pixel:
        shl bl, 1
        jc .draw_pixel
        jmp .skip

    .draw_pixel:
        mov [es:di], dl  ; Usac color en DL

    .skip:
        inc di
        loop .next_pixel
        add di, 320 - 8
        pop cx
        loop .next_row

        pop ax
        pop di
        ret

; Calcula offset segun el tamaño de la pantalla----------------------------------------------------------------------------------------
get_screen_offset:
    push ax
    push bx
    push cx

    mov ax, cx        ; AX = Y
    mov di, ax        ; DI = Y
    shl ax, 6         ; AX = Y * 64
    shl di, 8         ; DI = Y * 256
    add di, ax        ; DI = Y * 320
    add di, bx        ; DI += X

    pop cx
    pop bx
    pop ax
    ret

; Termina el programa del juego----------------------------------------------------------------------------------------
finalizacion:
    mov ax, 0003h
    int 10h
    mov ax, 4C00h
    int 21h
