.model small

.data  

str0 db "BLACKJACK"
     db "",13,10
     db "",13,10
     db "$",13,10

opcion db 13,10, "Presiona 1 para pedir carta"
       db 13,10, "Presiona 0 para quedarte"
       db 13,10, "$" 


str1 db '$$$$$'

shstr db "[Menu]",13,10
      db "",13,10
      db "Blackjack",13,10 
      db "",13,10
      db "",13,10
      db "",13,10
      db "Presiona 1 para empezar",13,10
      db "Presiona 0 para salir",13,10
      db "",13,10 
      db "numero: $"
            
numero db 13,10,"num: $"

load db 13,10,""
     db 13,10,"[CARGANDO...]$"
     
jugador db  13, 10, "Cartas del Jugador:"
        db  13, 10, "$"

point_j db "Tus puntos: $"

point_r db "Puntos repartidor: $" 

repartidor db  13, 10, "Cartas del Repartidor:"
           db  13, 10, "$"
           
won_s db "GANASTE!",13,10
      db "",13,10
      db "",13,10
      db "Tu puntaje: $"
      
won_sr db 13,10,""
       db 13,10,"Puntaje de repartidor: $"
       
lost_s db "Perdiste  :[",13,10
       db "",13,10
       db "",13,10
       db "Tu puntaje: $"
      
lost_sr db 13,10,""
        db 13,10,"Puntaje de repartidor: $"
              

final db "BLACKJACK FIN$"
           
si_rec dw 0 ; Recuperar valor de SI de la carta 2 del repartidor

si_val dw 0 ; Volver al valor de SI


; Definicion de simbolos (CP437)
SPADE   equ 06h   ; pica
HEART   equ 03h   ; corazon
DIAMOND equ 04h   ; diamante
CLUB    equ 05h   ; trebol

; Mazo ordenado: cada carta = 2 bytes (valor, palo)
mazo db  'A',SPADE, '2',SPADE, '3',SPADE, '4',SPADE, '5',SPADE, '6',SPADE, 
     db  '7',SPADE, '8',SPADE, '9',SPADE, 'T',SPADE, 'J',SPADE, 'Q',SPADE, 'K',SPADE
     
     db  'A',HEART, '2',HEART, '3',HEART, '4',HEART, '5',HEART, '6',HEART, 
     db  '7',HEART, '8',HEART, '9',HEART, 'T',HEART, 'J',HEART, 'Q',HEART, 'K',HEART
     
     db  'A',DIAMOND, '2',DIAMOND, '3',DIAMOND, '4',DIAMOND, '5',DIAMOND, '6',DIAMOND, 
     db  '7',DIAMOND, '8',DIAMOND, '9',DIAMOND, 'T',DIAMOND, 'J',DIAMOND, 'Q',DIAMOND, 'K',DIAMOND
     
     db  'A',CLUB, '2',CLUB, '3',CLUB, '4',CLUB, '5',CLUB, '6',CLUB, 
     db  '7',CLUB, '8',CLUB, '9',CLUB, 'T',CLUB, 'J',CLUB, 'Q',CLUB, 'K',CLUB
      

.stack 100h

.code      

    mov ax, @data
    mov ds, ax    
       
menu:
    mov sp, 100h
    call disp_refresh
        
    lea bx, str1   ; [BX es el indice de str1]
    
    lea dx, shstr  ; Muestra el Menu
    mov ah, 09h
    int 21h
    
    mov ah, 08h    ; Lee caracter y lo agrega en AL
    int 21h 
    sub al, 30h    ; valor en HEX en AL 
    cmp al, 0
    je endprogram
    
    call game      ; Llama al Juego
    call menu



    
game proc ; ------------------------------------------------------------------------------------------------------------------------ 
    call disp_refresh         
    call shuffle_mazo   ; Randomizacion de cartas
    
    lea dx, str0        ; Print Blackjack
    mov ah, 09h  
    int 21h
    
    ; Reparte cartas al jugador........................................................................................  
    ; Salto de linea
    mov dl, 0Ah
    mov ah, 02h
    int 21h
    mov dl, 0Dh
    mov ah, 02h
    int 21h
    
    lea dx, jugador        
    mov ah, 09h  
    int 21h
    
    xor si, si          ; si = 0
    mov ax, 0
    mov dx, 0
    mov cx, 2            
    repartir_j:     
        call carta      ; Imprime carta
        
        ; Debe reconocer si es "A, T(10), J, Q, K" y asignar el valor correspondiente
        mov dl, [mazo+si]
        cmp dl, "9"
        jg assign  
        sub dl, 30h       ; ASCII a hexadecimal        
        add al, dl        ; suma el valor de las cartas
        jmp value
        
        assign:
            cmp dl, "A"
            je AS
            add al, 10    ; Ah = T, J, Q, K
            jmp value
            
        AS:
            cmp al, 10
            jg uno
            add al, 11    ; Bh = A
            jmp value
           
            uno:
                add al, 1 ; = A
            
        value:
            add si, 2     ; siguiente carta (2 bytes)
        
            loop repartir_j
            
        push ax
    
        ; Imprime puntos del jugador                           
        ; DH = fila, DL = col
        mov dh, 06h
        mov dl, 00h
        mov ah, 02h
        int 10h
                                 
        lea dx, point_j   
        mov ah, 09h
        int 21h
        pop ax
                    
        call points
            
    push ax    
    
    ; Reparte cartas al repartidor ...............................................................
    ; Salto de linea
    mov dl, 0Ah
    mov ah, 02h
    int 21h
    mov dl, 0Dh
    mov ah, 02h
    int 21h
    
    lea dx, repartidor    ; Imprime texto
    mov ah, 09h
    int 21h
    
    call carta            ; Imprime carta 3
    
    ; Realiza suma de las cartas del repartidor en BL
    mov bx, 0
    mov cx, 2
                
    suma_r:    
        mov dl, [mazo+si]
        cmp dl, "9"
        jg assign_r
        sub dl, 30h
        add bl, dl
        jmp value_r
        
        assign_r:
            cmp dl, "A"
            je AS_r
            add bl, 10    ; Ah = T, J, Q, K
            jmp value_r
            
        AS_r:
            cmp bl, 10
            jg uno_r
            add bl, 11    ; Bh = A
            jmp value_r
           
            uno_r:
                add bl, 1 ; = A
            
        value_r:
            mov [si_rec], si ;GUARDA EL SI PARA LA CARTA NO MOSTRADA DEL REP
            add si, 2
        
        loop suma_r
        
    push bx
    
    ;NEXT: CARTA 5    
    ; Funcion para pedir cartas o quedarse........................................................................    
    ; Salto de linea
    mov dl, 0Ah
    mov ah, 02h
    int 21h
    mov dl, 0Dh
    mov ah, 02h
    int 21h
    
    pop bx
    pop ax
    push ax
    push bx

    cmp al, 21 ; Blackjack jugador
    je blackjack_j
    
    cmp bl, 21 ; Blackjack repartidor
    je blackjack_r
    
    lea dx, opcion  ; print pedir o quedarse
    mov ah, 09h  
    int 21h
    
    ; Mueve el cursor a las cartas del jugador    
    push ax                       
    ; DH = fila, DL = col
    mov dh, 05h
    mov dl, 06h
    mov ah, 02h
    int 10h
    pop ax
        
    iter_j1:             
        mov ah, 08h ; Lee caracter y lo agrega en AL
        int 21h 
        
        sub al, 30h 
        cmp al, 0   ; Con '0' deja de repartir cartas al jugador
        je continue ; Continua con las cartas del repartidor
                        
        call carta  
                          
        pop bx ;Valor suma de cartas anterior repartidor (3 y 4)
        pop ax ;Valor suma de cartas anterior jugador (1 y 2)
        
        ; Reconoce si es "A, T(10), J, Q, K" y asigna 
        ;  el valor correspondiente.
        mov dl, [mazo+si]
        cmp dl, "9"
        jg assign_j1  
        sub dl, 30h         ; ASCII a hexadecimal        
        add al, dl          ; Suma el valor de las cartas
        jmp value_j1
        
        assign_j1:
            cmp dl, "A"
            je AS_j1
            add al, 10      ; Ah = T, J, Q, K
            jmp value_j1
            
        AS_j1:
            cmp al, 10
            jg uno_j1
            add al, 11      ; Bh = A
            jmp value_j1
           
            uno_j1:
                add al, 1   ;= A
            
        value_j1:
            add si, 2       ; CARTA >= 6                    
            cmp al, 21
            jg recount
            
            done:            
                ; Imprime los puntos del jugador...
                push ax
                push bx
                mov ah, 03h
                mov bh, 0
                int 10h
                push dx              
                                    
                ; DH = fila, DL = col
                mov dh, 06h
                mov dl, 0Ch
                mov ah, 02h
                int 10h
                pop dx
                pop bx
                pop ax
                
                call points
                
                push ax
                mov ah, 02h
                int 10h
                pop ax
                ;..................................
                mov dx, 0    
                push ax
                push bx
                
                cmp al, 21  ;21 sin BlackJack
                je continue
                cmp al, 21
                jg lost
                                                                    
                jmp iter_j1:
          
    ret 
    
game endp ; ----------------------------------------------------------------------------------------------------


blackjack_j proc
    push ax    
    ; Mueve el cursor a las cartas del repartidor                           
    ; DH = fila, DL = col
    mov dh, 09h
    mov dl, 03h
    mov ah, 02h
    int 10h 
    pop ax
    
    mov [si_val], si
    
    mov si, [si_rec]
                  
    call carta  ; Imprime carta NO mostrada del repartidor
    
    call won
    
blackjack_j endp


blackjack_r proc
    push ax    
    ; Mueve el cursor a las cartas del repartidor                           
    mov dh, 09h
    mov dl, 03h
    mov ah, 02h
    int 10h 
    pop ax
    
    mov [si_val], si
    
    mov si, [si_rec]
                  
    call carta  ; Imprime carta NO mostrada del repartidor
    
    call lost
    
blackjack_r endp
 
; Logica del Repartidor para tomar nuevas cartas
continue proc 
    push ax    
    ; Mueve el cursor a las cartas del repartidor                           
    ; DH = fila, DL = col
    mov dh, 09h
    mov dl, 03h
    mov ah, 02h
    int 10h 
    pop ax
    
    mov [si_val], si    
    mov si, [si_rec]                  
    call carta   ; Imprime carta NO mostrada del repartidor
    mov si, [si_val]
    
    pop bx ; Valor anterior de suma cartas repartidor
    pop ax ; Valor anterior de suma cartas jugador
    
    ; COMPARACION BL 
    cmp bl, 21
    je lost
    
    cmp bl, 17
    jge recount_r
    
    ; Si no hay As no toma mas cartas
    ; Si hay As toma cartas
    ;>21, 20-17, BL<17
    done_r:   
        cmp bl, 21        ; BL > 21: Gana el jugador
        jg won
        
        cmp bl, 21        ; BL = 21: Pierde jugador
        je lost
        
        cmp bl, 17        ; Deja de tomar cartas si BL>=17
        jge compare                 
        
        ; Caso cuando BL < 17 
        ; tomando en cuenta las As                         
        call carta        ;Imprime nueva carta de repartidor
        
        mov dl, [mazo+si]
        cmp dl, "9"
        jg assign_r1  
        sub dl, 30h       ; ASCII a hexadecimal        
        add bl, dl        ; suma el valor de las cartas
        jmp value_r1
        
        assign_r1:
            cmp dl, "A"
            je AS_r1
            add bl, 10    ; Ah = T, J, Q, K
            jmp value_r1
            
        AS_r1:
            cmp bl, 10
            jg uno_r1
            add bl, 11    ; Bh = A
            jmp value_r1
           
            uno_r1:
                add bl, 1 ; = A
            
        value_r1:
            add si, 2     ; Siguiente CARTA
            jmp done_r
        
        compare:    
            cmp bl, al    ; BL >= AL (Cartas<22)
            jge lost
            
            jmp won
                                                  
    ret
    
continue endp


; Revisa las 2 primeras cartas del jugador para cambiar
;  el valor de un As de 11 a 1 si es necesario.
recount proc
    push si
    
    xor si, si
    cmp cx, 10
    je return
    mov cx, 2
    count:
        mov dl, [mazo+si]
        cmp dl,"A"
        je subs 
        add si, 2    
        loop count
        mov cx, 10
        jmp return
    
    subs:
        sub al, 10 ; Si hay As se le resta 10: As=1
        
    return:
        pop si
        mov cx, 10   
        jmp done
        
recount endp


; Revisa las 2 primeras cartas del repartidor para cambiar
;  el valor de un As de 11 a 1 si es necesario.
recount_r proc
    push si
    
    mov si, 4
    cmp cx, 11
    je return_r
    mov cx, 2
    count_r:
        mov dl, [mazo+si]
        cmp dl,"A"
        je subs_r 
        add si, 2    
        loop count_r
        jmp return_r
    
    subs_r:
        sub bl, 10 ; Si hay As se le resta 10: As=1
        
    return_r:
        pop si
        mov cx, 11   
        jmp done_r
        
recount_r endp


; Pantalla de victoria con puntos finales
won proc
    push ax
    mov ah, 08h
    int 21h
    pop ax
    
    call disp_refresh
    mov cx, ax    
    lea dx, won_s
    mov ah, 09h
    int 21h
    mov ax, cx    
    call points
    
    mov cx, bx
    lea dx, won_sr
    mov ah, 09h
    int 21h
    mov ax, cx
    call points    
    
    mov ah, 08h
    int 21h 
    jmp disp_final         
    ret
    
won endp


; Pantalla de derrota con puntos finales
lost proc
    push ax
    mov ah, 08h
    int 21h
    pop ax
    
    call disp_refresh
    mov cx, ax    
    lea dx, lost_s
    mov ah, 09h
    int 21h
    mov ax, cx    
    call points
    
    mov cx, bx
    lea dx, lost_sr
    mov ah, 09h
    int 21h
    mov ax, cx
    call points    
    
    mov ah, 08h
    int 21h 
    jmp disp_final             
    ret
    
lost endp


; Imprime puntos del jugador y repartidor
points proc 
    push ax
    push bx
    push dx

    xor ah, ah     ; limpiar AH porque AX = AL antes de DIV
    mov bl, 10
    div bl         ; AX / 10 ? AL = decenas, AH = unidades (residuo)

    ; GUARDAR AH (residuo) en otro registro seguro
    mov cl, ah     ; CL = unidades
                   ; AH se va a sobreescribir con int 21h

    ; Imprimir decenas (AL)
    add al, 30h
    mov dl, al
    mov ah, 02h
    int 21h

    ; Imprimir unidades (CL)
    mov al, cl     ; recuperar el residuo original
    add al, 30h
    mov dl, al
    mov ah, 02h
    int 21h

    pop dx
    pop bx
    pop ax
    ret    
    
points endp


; Borra lo que se encuentre en la consola
disp_refresh proc
    push ax
    push bx
    push cx
    push dx
    
    mov ah, 06h    ; funcion: scroll up
    mov al, 0      ; numero de lineas: 0 = borrar toda la pantalla
    mov bh, 07h    ; atributo del fondo (gris claro sobre negro)
    mov cx, 0      ; esquina superior izquierda (fila 0, col 0)
    mov dx, 184Fh  ; esquina inferior derecha (fila 24, col 79)
    int 10h        ; llama BIOS
            
    mov ah, 02h    ; función BIOS: Set Cursor Position
    mov bh, 0      ; página de video (normalmente 0)
    mov dh, 0      ; fila = 0
    mov dl, 0      ; columna = 0
    int 10h        ; ejecutar
    
    pop dx
    pop cx
    pop bx
    pop ax    
      
    ret  

disp_refresh endp                 


; Imprime pantalla final                 
disp_final proc
    call disp_refresh
    lea dx, final
    mov ah, 09h    ; muestra DS:DX (Texto de Resultado)
    int 21h
    
    mov cx, 200
    show:
        add ax, ax
        loop show
    
    call disp_refresh
    jmp menu

disp_final endp     


; Entrada: El mazo esta en [mazo], 52 cartas (2 bytes cada una)
; Salida: El arreglo se baraja en el mismo, sin repeticiones
shuffle_mazo proc
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    
    lea dx, load   ; Pantalla de carga
    mov ah, 09h
    int 21h

    mov cx, 52
    dec cx

    shuffle_loop:
        push cx
    
        mov si, cx
        shl si, 1
    
        ; Random basado en INT 1Ah
        mov ah, 00h
        int 1Ah    ; DX = contador de ticks desde medianoche
    
        mov ax, dx ; usar AX como semilla
        xor dx, dx
    
        pop cx     ; Recuperar CX antes de usar para loop
        mov bx, cx
        inc bx
    
        div bx     ; AX / BX ? residuo en DX ? [0, CX]
    
        mov di, dx
        shl di, 1
    
        ; Swap cartas[i] y cartas[j]
        mov al, [mazo + si]
        mov ah, [mazo + di]
        mov [mazo + si], ah
        mov [mazo + di], al
    
        mov al, [mazo + si + 1]
        mov ah, [mazo + di + 1]
        mov [mazo + si + 1], ah
        mov [mazo + di + 1], al
    
        loop shuffle_loop
        
    call disp_refresh

    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    
    ret
    
shuffle_mazo endp


; Imprime las cartas en consola
carta proc
    push ax
    push bx
    push cx
    push dx

    ; Imprimir valor de la carta
    mov dl, [mazo + si]
    mov ah, 02h
    int 21h

    ; Imprimir palo de la carta
    mov dl, [mazo + si + 1]
    mov ah, 02h
    int 21h

    ; Imprimir espacio separador
    mov dl, ' '
    mov ah, 02h
    int 21h
    
    pop dx
    pop cx
    pop bx
    pop ax
    
    ret
    
carta endp


; Detiene el programa
endprogram:
    mov ah, 04Ch 
    int 21h
    end