;#####################################################
;#
;# Autor: Jeffrey Isaac Salas Quiel
;#
;#####################################################

memoria_base:           equ 0xFC80
disparos:          equ memoria_base
tiempo_anterior:       equ memoria_base+0x0C
nivel:          equ memoria_base+0x10
vidas:          equ memoria_base+0x11
lista_sprites:        equ memoria_base+0x12

FILA_NAVE:       equ 0x5C*DESPLAZAMIENTO_X
ANCHO_X:        equ 0x0140
DESPLAZAMIENTO_X:       equ ANCHO_X*2
TAMANO_SPRITE:    equ 4

COLOR_NAVE:        equ 0x1C
COLOR_BARRERA:          equ 0x0A
COLOR_EXPLOSION_NAVE:   equ 0x0E
COLOR_EXPLOSION_INVASOR:        equ 0x0E
COLOR_PROYECTIL:           equ 0x0F
COLOR_INICIAL:    equ ((0xFC80+0x12+4-(0xFC80+2))/4+0x0F)

org 100h

jmp mostrar_menu

; #########################################
; Funciones de renderizado
; #########################################
evaluar_bit:    
        jc dibujar_pixel_proyectil

borrar_pixel:   
        xor ax, ax

dibujar_pixel_proyectil:
        mov [DI+ANCHO_X], ax
        stosw
        ret
; #########################################


; ########################################################
; Secuencia de renderizado de sprites
; ########################################################
renderizar_sprite:
        push cx
        push DI
        pushf

obtener_bitmap:    
        push ax
        mov bx, sprites_binarios
        cs xlat
        xchg ax, bx
        mov cx, 10
        clc

crea_sprites:    
        mov al, bh
        mov ah, bh
        call evaluar_bit
        shl bl, 1
        loop crea_sprites
        add DI, DESPLAZAMIENTO_X-20
        pop ax
        inc ax
        test al, 7
        jne obtener_bitmap
        popf
        pop DI
        pop cx
        ret
; ########################################################

; Datos de sprites
sprites_binarios:
        ; Nave
        db 00011000b
        db 00011000b
        db 00111100b
        db 01111110b
        db 11100111b
        db 11111111b
        db 10111101b
        db 00100100b

        ; Explosión
        db 00000000b
        db 00100100b
        db 00000000b
        db 00011000b
        db 00000000b
        db 01000010b
        db 00000000b
        db 00011000b

        ; Invasor frame 1
        db 00000000b
        db 00111100b
        db 01111110b
        db 11011011b
        db 11111111b
        db 00100100b
        db 01011010b
        db 10100101b

        ; Invasor frame 2
        db 00000000b
        db 00111100b
        db 01111110b
        db 11011011b
        db 11111111b
        db 01011010b
        db 10000001b
        db 01000010b

        ; Borrar
        db 00000000b
        db 00000000b
        db 00000000b
        db 00000000b
        db 00000000b
        db 00000000b
        db 00000000b
        db 00000000b

        ; barrera
        db 00000000b
        db 00000000b
        db 00000000b
        db 00011000b
        db 01111110b
        db 11111111b
        db 11111111b
        db 11100111b

mostrar_menu:
        ; Cambiar a modo texto 03h
        mov ax, 0x0003
        int 0x10

        ; Colocar cursor en fila 10, columna 20
        mov ah, 02h
        mov bh, 0
        mov dh, 10     ; fila
        mov dl, 15     ; columna
        int 10h

        ; Imprimir mensaje
        mov si, mensaje_menu
.next_char:
        lodsb
        cmp al, 0
        je esperar_tecla_menu
        mov ah, 0x0E
        int 0x10
        jmp .next_char

esperar_tecla_menu:
        mov ah, 0
        int 0x16
        cmp al, 27       ; ESC
        je finalizacion
        cmp al, ' '      ; SPACE
        jne esperar_tecla_menu

        ; Si se presiona SPACE, continuar al juego
        jmp inicio_programa

mensaje_menu:
        db "Presiona 'SPACE' para EMPEZAR o 'ESC' para SALIR", 0

; #######################################################################
; Inicio del programa
; #######################################################################
inicio_programa:
        mov ax, 0x13
        int 10h
        cld
        mov ax, 0xA000
        mov ds, ax
        mov es, ax
        mov ah, 04h
        mov [nivel], ax

; Se reinicia de este punto luego de ganar la partida
reiniciar_juego:
        mov byte [vidas], 2 ; 3 vidas
        xor ax, ax
        mov cx, nivel/2
        xor DI, DI
        rep
        stosw

        mov ax, [DI]
        inc ax
        inc ax
        stosw
        mov ah, al
        xchg ax, dx

        mov ax, COLOR_NAVE*0x100        ; Mueve color y tipo de nave a ax (el tipo de la nave indica si esta bien o destruida)
        stosw                           ; Lo guarda
        mov ax, FILA_NAVE+0x4C*2        
        stosw

        mov ax, 0x08*DESPLAZAMIENTO_X+0x28
        mov bx, COLOR_INICIAL*0x100+0x10

num_invasores:    
        mov cl, 11

invasores_fila:    
        stosw
        add ax, 0x0B*2
        xchg ax, bx
        stosw
        inc ah
        xchg ax, bx
        loop invasores_fila
        add ax, 0x09*DESPLAZAMIENTO_X-0x000B*0x000B*2
        cmp bh, COLOR_INICIAL+44
        jne num_invasores

        ; Barreras
        mov DI, 0x55*0x280+0x1F*2       ; Posición vertical y horizontal de barreras
        mov cl, 4       ; Cantidad de barreras
barreras:
        mov ax, COLOR_BARRERA*0x0100+0x2C
        call renderizar_sprite
        add DI, 0x1E*2  ; Espaciamiento entre barreras
        loop barreras

invasores_inicio:
        mov si, lista_sprites+TAMANO_SPRITE

procesar_invasor:
        cmp byte [si+2], 0x20 ; Detecta si el invasor está vivo o muerto
        jc invasor_animacion  ; Si el valor es menor a 0x20, el invasor sigue vivo y se hace la animacion de movimiento
        inc ch
        cmp ch, 44            ; Cuenta la cantidad de invasores en pantalla
        je reiniciar_juego    ; si llega a 44 reinicia el juego

dibujar_invasor:        ; Se cargan los invasores para dibujarlos
        lodsw           
        xchg ax, DI
        lodsw
        cmp al, 0x28          ; Si el tipo es 0x28 el invasor fue impactado y explota
        je siguiente_invasor
        cmp al, 0x20          ; Si el tipo es 0x20 el invasor está muerto
        jne sprite_valido     ; Si el invasor está vivo se dibuja en pantalla
        mov byte [si-2], 0x28 ; Esto marca al invasor como destruido, usando 0x28

sprite_valido:   
        call renderizar_sprite

siguiente_invasor:   
        cmp si, lista_sprites+45*TAMANO_SPRITE  ; Si SI aún no llega al final, salta de nuevo a procesar_invasor
        jne procesar_invasor

        mov al, dh  ; Esta sección controla la direccion de movimiento de los invasores
        sub al, 2
        jc invasores_inicio
        xor al, 1
        mov dl, al
        mov dh, al
        jmp invasores_inicio

invasor_animacion:
        xor byte [si+2], 8 ; cambia entre frame 1 y 2 del invasor
        inc bp             ; contador de ciclos
        and bp, 7
        push dx
        push si
        push bp
        jne colision_invasores ; cada 8 ciclos salta a esta funcion

esperar_reloj:
        mov ah, 0           
        int 0x1A
        cmp dx, [tiempo_anterior]
        je esperar_reloj
        mov [tiempo_anterior], dx

colision_invasores:
        mov si, disparos
        mov cx, 4           ; cantidad de disparos máximos de invasores en pantalla
        lodsw
        cmp ax, ANCHO_X
        xchg ax, DI
        jc eliminar_proyectil  ; elimina el proyectil si esta fuera de la pantalla

        call borrar_pixel      ; borra el proyectil anterior en pantalla
        sub DI, ANCHO_X+2
        mov al, [DI]           ; lee el color del pixel impactado
        sub al, 0x0F           ; si el color impactado es menor a 0x0F el proyectil sigue
        jc mover_proyectil

        push si
        push DI   
        ; Si se detecta una colision, se obtiene el indice del invasor con el color leido
        mov ah, TAMANO_SPRITE
        mul ah
        add si, ax
        lodsw
        xchg ax, DI
        mov byte [si], 0x20             ; Se marca el invasor como muerto
        mov ax, COLOR_EXPLOSION_INVASOR*0x0100+0x08 ; Se coloca la animacion de explosion
        call renderizar_sprite
        pop DI
        pop si
        jmp eliminar_proyectil ; Se elimina el proyectil cuando colisiona con un invasor

procesar_proyectil_invasor:
        lodsw
        or ax, ax              
        je continuar_proyectil 
        cmp ax, 0x60*DESPLAZAMIENTO_X ; Elimina el proyectil si está fuera de la pantalla
        xchg ax, DI
        jnc eliminar_proyectil

        call borrar_pixel       ; Movimiento de los proyectiles de enemigos
        add DI, ANCHO_X-2
mover_proyectil:
        mov ax, COLOR_PROYECTIL*0x0100+COLOR_PROYECTIL
        mov [si-2], DI
        cmp byte [DI+ANCHO_X], COLOR_BARRERA  ; Revisa si debajo del proyectil hay una barrera
        jne verificar_colision          ; Si no hay barrera pasa a verificar colisión

eliminar_proyectil: ; Elimina el proyectil (generalmente se llama cuando hay colision)
        xor ax, ax
        mov [si-2], ax

verificar_colision:                     
        cmp byte [DI], COLOR_NAVE       ; Revisa si el proyectil colisiona con el color de la nave del jugador
        jne dibujar_proyectil           ; si no hay colisión se dibuja el proyectil
        mov word [lista_sprites], COLOR_EXPLOSION_NAVE*0x0100+0x38 ; Si hay colisión explota la nave del jugador

dibujar_proyectil:
        call dibujar_pixel_proyectil

continuar_proyectil:   
        loop procesar_proyectil_invasor ; Luego de manejar la lógica de los proyectiles se mueve la nave

        mov si, lista_sprites           ; Carga el sprite de la nave del jugador
        lodsw
        or al, al
        je manejar_nave
        add al, 0x08            ; Si el sprite aun no ha terminado la animacion de explosion, se continua
        jne manejar_nave
        mov ah, COLOR_NAVE
        dec byte [vidas]        ; Se resta una vida al jugador
        js mostrar_menu         ; Si no quedan vidas se termina el juego

; Movimiento de la nave del jugador
manejar_nave:   
        mov [si-2], ax          ; Guarda el sprite actual en la lista de sprites
        mov DI, [si]            ; Posicion x de la nave
        call renderizar_sprite  ; Dibuja la nave
        jne procesar_entrada    ; Si no ha terminado la explosion de la nave pasa a procesar_entrada

        mov ah, 0x01
        int 0x16                ; Verifica si hay una tecla presionada
        jz leer_teclas
        
        mov ah, 0               ; Si hay una tecla presionada la lee
        int 0x16
        cmp al, 27              ; Si se presiona la tecla ESC termina el juego
        je mostrar_menu

        cmp ah, 0x4B            ; Si se presiona la flecha izquierda la nave se mueve 2 pixeles a esa direccion
        jne tecla_derecha       ; Flecha derecha
        dec DI
        dec DI
        jmp verificar_disparo

; Si se presiona la flecha derecha la nave se mueve 2 pixeles a esa direccion
tecla_derecha:   
        cmp ah, 0x4D
        jne verificar_disparo   ; Si no se presionan direccion salta a verificar_disparo
        inc DI
        inc DI

; Disparo de la nave del jugador
verificar_disparo:
        cmp ah, 0x39            ; Si se presiona el SPACE dispara la nave
        jne leer_teclas
        cmp word [disparos], 0  ; Solo se permite un disparo
        jne leer_teclas
        lea ax, [DI+(0x04*2)]   ; Si no hay proyectil, coloca uno sobre la nave
        mov [disparos], ax

; Verifica si la posición nueva de la nave está dentro del limite horizontal de la pantalla
leer_teclas:
        xchg ax, DI
        cmp ax, FILA_NAVE-2
        je procesar_entrada
        cmp ax, FILA_NAVE+0x0132
        je procesar_entrada

; Guarda la posición de la nave
actualizar_posicion:   
        mov [si], ax

; Movimiento de los invasores
procesar_entrada:
        pop bp
        pop si
        pop dx
        mov ax, [si]            ; Posición actual del invasor
        cmp dl, 1               ; Si los invasores van en dirección horizontal se mueven lateralmente
        jbe mover_invasor
        add ax, 0x0140          ; Se mueven los invasores hacia abajo 140h
        cmp ax, 0x55*0x280      ; Detecta si llegaron al limite inferior
        jc actualizar_invasor

; Finaliza el juego
finalizacion:
        mov ax, 0x0003
        int 0x10
        int 0x20

; Mueve lateralmente los invasores
mover_invasor:    
        dec ax
        dec ax
        jc calcular_borde
        add ax, 4

; Calcula los bordes de la pantalla
calcular_borde:   
        push ax
        shr ax, 1
        mov cl, 0xA0
        div cl
        dec ah
        cmp ah, 0x94
        pop ax
        jb actualizar_invasor
        or dh, 22               ; Si toca el borde, se marca bandera para cambio de dirección

; Guarda la nueva posicion del invasor
actualizar_invasor:    
        mov [si], ax
        add ax, 0x06*0x280+0x03*2       ; Calculo del disparo del invasor
        xchg ax, bx                     ; La dirección del disparo del invasor se guarda en BX

        mov cx, 3
        in al, (0x40)                   ; Lee del temporizador del sistema
        cmp al, 0xFC                    ; Solo dispara cuando AL >= 0xFC (1/16 Probabilidad)
        jc invasores_disparo            

        mov DI, disparos+2

; Busca un espacio libre para guardar el nuevo disparo del invasor
buscar_slot_libre:   
        cmp word [DI], 0        ; Hay 4 espacios, se buscan espacios donde el valor sea 0 y se guarda
        je asignar_disparo
        scasw
        loop buscar_slot_libre

; Almacena la posición del disparo enemigo en la tabla de disparos
asignar_disparo:
        mov [DI], bx

; Regresa al ciclo principal para seguir procesando el siguiente invasor
invasores_disparo:
        jmp dibujar_invasor
