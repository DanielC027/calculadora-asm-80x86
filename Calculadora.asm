;***************************************
;*                                     *
;*      HECHO POR DANIEL CANELA        *
;*                                     *
;***************************************

PAGE 60,132
TITLE CALC.EXE
.MODEL SMALL
.STACK 64
;_________________________________
.DATA
    ; MENU PRINCIPAL
    MENU_PRIN DB 'MENU PRINCIPAL',0AH,0DH
              DB ' 1) Suma ',0AH,0DH
              DB ' 2) Resta',0AH,0DH
              DB ' 3) Multiplicacion',0AH,0DH
              DB ' 4) Division',0AH,0DH
              DB ' 5) Potencia',0AH,0DH
              DB ' 6) Graficar seno y coseno',0AH,0DH             
              DB ' 0) Salir',0AH,0DH
              DB 'Eliga una opcion: ','$'
              
    ; PEDIR 2 NUMEROS -> SUMA, RESTA, MULT, DIV
    MSG_NUM_1   DW 0AH,0DH
                DW ' solo numeros decimales de dos digitos',0AH,0DH
                DW 0AH,0DH,
                DW 'Introduce el primer numero: ','$'
                
    MSG_NUM_2   DW 0AH,0DH
                DW ' solo numeros decimales de dos digitos',0AH,0DH
                DW 0AH,0DH,    
                DW 'Introduce el segundo numero: ','$'
    
    ; TECLA CONTINUAR
    
    MSG_ENTER   DW 0AH,0DH,
                DW 'Presiona enter para continuar... ','$'
                
    ; PEDIR NUMEROS -> POT
    MSG_BASE_POT DW 'Introduce el numero base: ','$'
    MSG_EXP_POT DW 'Introduce el numero exponente: ','$'
        
    ; TITULOS
    SUMA_TITLE DW 'SUMA',0AH,0DH,'$'
               
    RESTA_TITLE DW 'RESTA',0AH,0DH,'$'
                
    MULT_TITLE DW 'MULTIPLICACION',0AH,0DH,'$'
               
    DIVISION_TITLE DW 'DIVISION',0AH,0DH,'$'
    
    POTENCIA_TITLE DW 'POTENCIA',0AH,0DH,'$'
    
    ; MENSAJE ERROR
    
    MSG_ERROR DW 0AH,0DH,
              DW 'Error, intente de nuevo... ','$'
    
    ;TABLAS SENO Y COSENO
    SENO DW  0, 12, 1, 8, 2, 4, 3, 2, 4, 0, 5, 0, 6, 0, 7, 2, 8, 5, 9, 9, 10, 13, 11, 17, 12, 20, 13, 23, 14, 24, 15, 24, 16, 23, 17, 21, 18, 18, 19, 14, 20, 10, 21, 6, 22, 3, 23, 1, 24, 0, 25, 0, 26, 1, 27, 4, 28, 7, 29, 11, 30, 15, 31, 19, 32, 22, 33, 24, 34, 24, 35, 24, 36, 22, 37, 20, 38, 16, 40, 12
    COSENO DW  0, 0, 1, 0, 2, 2, 3, 5, 4, 9, 5, 13, 6, 16, 7, 20, 8, 23, 9, 24, 10, 24, 11, 23, 12, 21, 13, 18, 14, 15, 15, 10, 16, 7, 17, 3, 18, 1, 19, 0, 20, 0, 21, 1, 22, 3, 23, 7, 24, 10, 25, 15, 26, 18, 27, 21, 28, 23, 29, 24, 30, 24, 31, 23, 32, 20, 33, 16, 34, 13, 35, 9, 36, 5, 37, 2, 38, 0, 40, 0
    
    CONST DW 80
    CONT DW 0    
    
    ; X    
    ; PEDIR DATOS CONTA VECES +1
    CONTA DB 1
    MSG DW 'Introduce un numero: ','$'
    MSG_IMPR DW 'Numeros ingresados: ','$'
    
    ;NUM ENTRADA, INGRESADOS, ESPACIO CARACT
    BUFFER DB 3,00,3 DUP ('0')           
    
    ;   2 DIG NUM 1, 2 DIG NUM 2
    NUMS 2 DUP ('0'),2 DUP ('0'),'$' 
    
    ; TITLE
    TITULO DB ?
    
    ; ASCII BIN
    BINVAL DW 0
    MULT10 DW 1 
    
    ; RESULTADO
    MSG_RESULT DW 'El resultado es: ','$'
    RESULTADO DB '  ','$'    
    
    
    
; _________________________________
.CODE
BEGIN PROC FAR
    MOV AX,@DATA
    MOV DS,AX
    
    CICLO_CALC:
        CALL PANTALLA
        
        MOV DX,0505H
        CALL CURSOR
        
        MOV DX, OFFSET MENU_PRIN
        CALL IMPRIME
        
        CALL TECLADO
        
        MOV AL,BUFFER[2]
        
        ; SALIR    
        CMP AL,30H
        JE SALIR
        
        ; MENOR DE 0    
        JB CALL_ERROR
            
        ;CALL SEN Y COSENO
        CMP AL,36H
        JE CALL_GRAFICAR
        
        ; MAYOR A 7     
        JA CALL_ERROR
        
        ;CALL SUMA 
        CMP AL,31H
        JE CALL_SUMA
        ;CALL RESTA                        
        CMP AL,32H
        JE CALL_RESTA
        ;CALL MULTIPLICACION 
        CMP AL,33H
        JE CALL_MULT
        ;CALL DIVISION  
        CMP AL,34H
        JE CALL_DIV    
        ;CALL POTENCIA
        CMP AL,35H
        JE CALL_POT
        
        CALL_SUMA: 
            CALL SUMA
            JMP CICLO_CALC
            
        CALL_RESTA: 
            CALL RESTA
            JMP CICLO_CALC 
            
        CALL_MULT: 
            CALL MULTIPLICACION
            JMP CICLO_CALC     
            
        CALL_DIV: 
            CALL DIVISION
            JMP CICLO_CALC
            
        CALL_POT: 
            CALL POTENCIA
            JMP CICLO_CALC
            
        CALL_GRAFICAR: 
            CALL GRAFICAR_FUNCIONES
            JMP CICLO_CALC
        
        CALL_ERROR: 
            CALL ERROR 
            CALL CONTINUAR
            JMP CICLO_CALC
            
    SALIR: MOV AX,4C00H
    INT 21H
    
BEGIN ENDP

; _________________________________
; PANTALLA
PANTALLA PROC NEAR
    MOV AX,0600H
    MOV BH,07H
    MOV CX,0000
    MOV DX,184FH
    INT 10H
    RET
PANTALLA ENDP    
; _________________________________

; _________________________________
; CURSOR    -> DX F,C
CURSOR PROC NEAR
    MOV AH,02H
    MOV BH,00
    INT 10H
    RET
CURSOR ENDP    
; _________________________________

; _________________________________
; IMPRIME
IMPRIME PROC NEAR
    MOV AH,09H
    INT 21H
    RET
IMPRIME ENDP    
; _________________________________   

; _________________________________
; ENTRADA
TECLADO PROC NEAR
    MOV AH,0AH
    LEA DX,BUFFER
    INT 21H
    RET
TECLADO ENDP    
; _________________________________       
     
; _________________________________
; PRESION TECLA CONTINUAR
CONTINUAR PROC NEAR
    MOV DX,OFFSET MSG_ENTER
    CALL IMPRIME
    CALL TECLADO
    RET
CONTINUAR ENDP    
; _________________________________       

     
; _________________________________
; PRESION TECLA CONTINUAR
ERROR PROC NEAR
    MOV DX,OFFSET MSG_ERROR
    CALL IMPRIME
    RET
ERROR ENDP    
; _________________________________       
    
                                    
; _________________________________
; GUARDAR BUFFER EN NUMS

BUFF_A_NUMS PROC NEAR
    MOV AL, [SI]    ; BUFFER  
    CALL CONV_A_DEC ; CONVERTIR A DECIMAL
    
    DEC SI          
    LOOP BUFF_A_NUMS 
    
    ; GUARDA EN NUMS    
    MOV CX,2
    LEA SI,BINVAL
        
    GUARD_NUM:   
        MOV AL,[SI]
        MOV [DI],AL
        INC SI
        INC DI
        LOOP GUARD_NUM
    
    MOV MULT10,1
    MOV BINVAL,0    
RET
BUFF_A_NUMS ENDP
; _________________________________
; CONVERTIR A DECIMAL

CONV_A_DEC PROC NEAR
    MOV BX,10
     
    AND AX,000FH    ; Se elimina la parte alta del caracter y queda la parte baja solamente                                
    
    MUL MULT10      ; Se multiplica por la pot que representa la posicion del caracter en el numero decimal                                  
    
    ADD BINVAL,AX   ; Se suma el numero binario resultante, ya ajustado en unidades, decenas y centenas por la multiplicacion anterior
    
    MOV AX, MULT10  ; Se carga el valor de mult10 para poder ajustar la posicion del numero decimal en la cadena                              
    
    MUL BX          ; Se multiplica la base por posicion del numero
    
    MOV MULT10,AX   ; se guarda el valor de la potencia de nuevo
    
RET
CONV_A_DEC ENDP

; _________________________________
; _________________________________
; _________________________________
; _________________________________
; _________________________________
; _________________________________
; _________________________________
; _________________________________
; _________________________________
; _________________________________
                                                         
; _________________________________
; SUMAR

SUMA PROC NEAR        
    CALL PANTALLA
    
    ; ---------------------
    ; MOSTRAR TITULO
    MOV DX,0505H
    CALL CURSOR    
    
    MOV DX, OFFSET SUMA_TITLE
    CALL IMPRIME     
    
    ; PEDIR DATO 1
    MOV DX, OFFSET MSG_NUM_1
    CALL IMPRIME
    CALL TECLADO 
    
    LEA SI,BUFFER[2+1]
    LEA DI,NUMS[0]
    MOV CX,2
    CALL BUFF_A_NUMS

    CALL PANTALLA
    
    ; ---------------------
    
    ; MOSTRAR TITULO
    MOV DX,0505H
    CALL CURSOR
    MOV DX, OFFSET SUMA_TITLE
    CALL IMPRIME   
    
    ; PEDIR DATO2
    MOV DX, OFFSET MSG_NUM_2
    CALL IMPRIME
    CALL TECLADO
    
    LEA SI,BUFFER[2+1]
    LEA DI,NUMS[1]
    MOV CX,2
    CALL BUFF_A_NUMS
    
                    
    CALL PANTALLA   
    
    ; ---------------------   
    
    ; EFECTUAR OPERACION 

    XOR AX,AX
        
    MOV AL,NUMS[0]
    ADD AL,NUMS[1]  
    
    MOV RESULTADO[0],AL
                                             
    ; ---------------------
                               
    ; MOSTRAR TITULO
    MOV DX,0505H
    CALL CURSOR
    MOV DX, OFFSET SUMA_TITLE
    CALL IMPRIME           
    
    ; MOSTRAR RESULTADO
    MOV DX, OFFSET MSG_RESULT
    CALL IMPRIME   
    
    MOV DX, OFFSET RESULTADO
    CALL IMPRIME

    CALL CONTINUAR
    ; ---------------------
RET
SUMA ENDP    
    
; _________________________________
; _________________________________
; _________________________________
; _________________________________
; _________________________________
; _________________________________
; _________________________________
; _________________________________
; _________________________________
; _________________________________

; _________________________________
; RESTAR

RESTA PROC NEAR        
    CALL PANTALLA
    
    ; ---------------------
    ; MOSTRAR TITULO
    MOV DX,0505H
    CALL CURSOR    
    
    MOV DX, OFFSET RESTA_TITLE
    CALL IMPRIME     
    
    ; PEDIR DATO 1
    MOV DX, OFFSET MSG_NUM_1
    CALL IMPRIME
    CALL TECLADO 
    
    LEA SI,BUFFER[2+1]
    LEA DI,NUMS[0]
    MOV CX,2
    CALL BUFF_A_NUMS

    CALL PANTALLA
    
    ; ---------------------
    
    ; MOSTRAR TITULO
    MOV DX,0505H
    CALL CURSOR
    MOV DX, OFFSET RESTA_TITLE
    CALL IMPRIME   
    
    ; PEDIR DATO2
    MOV DX, OFFSET MSG_NUM_2
    CALL IMPRIME
    CALL TECLADO
    
    LEA SI,BUFFER[2+1]
    LEA DI,NUMS[1]
    MOV CX,2
    CALL BUFF_A_NUMS
    
                    
    CALL PANTALLA   
    
    ; ---------------------   
    
    ; EFECTUAR OPERACION 

    XOR AX,AX
        
    MOV AL,NUMS[0]
    SUB AL,NUMS[1]  
    
    MOV RESULTADO[0],AL
                                             
    ; ---------------------
                               
    ; MOSTRAR TITULO
    MOV DX,0505H
    CALL CURSOR
    MOV DX, OFFSET RESTA_TITLE
    CALL IMPRIME           
    
    ; MOSTRAR RESULTADO
    MOV DX, OFFSET MSG_RESULT
    CALL IMPRIME   
    
    MOV DX, OFFSET RESULTADO
    CALL IMPRIME

    CALL CONTINUAR
    ; ---------------------
RET
RESTA ENDP    
    
; _________________________________
; _________________________________
; _________________________________
; _________________________________
; _________________________________
; _________________________________
; _________________________________
; _________________________________
; _________________________________
; _________________________________
                                       
; _________________________________
; MULTIPLICACION

MULTIPLICACION PROC NEAR        
    CALL PANTALLA
    
    ; ---------------------
    ; MOSTRAR TITULO
    MOV DX,0505H
    CALL CURSOR    
    
    MOV DX, OFFSET MULT_TITLE
    CALL IMPRIME     
    
    ; PEDIR DATO 1
    MOV DX, OFFSET MSG_NUM_1
    CALL IMPRIME
    CALL TECLADO 
    
    LEA SI,BUFFER[2+1]
    LEA DI,NUMS[0]
    MOV CX,2
    CALL BUFF_A_NUMS

    CALL PANTALLA
    
    ; ---------------------
    
    ; MOSTRAR TITULO
    MOV DX,0505H
    CALL CURSOR
    MOV DX, OFFSET MULT_TITLE
    CALL IMPRIME   
    
    ; PEDIR DATO2
    MOV DX, OFFSET MSG_NUM_2
    CALL IMPRIME
    CALL TECLADO
    
    LEA SI,BUFFER[2+1]
    LEA DI,NUMS[1]
    MOV CX,2
    CALL BUFF_A_NUMS
    
                    
    CALL PANTALLA   
    
    ; ---------------------   
    
    ; EFECTUAR OPERACION 

    XOR AX,AX
        
    MOV AL,NUMS[0]
    MOV BL,NUMS[1]  
    MUL BL
    
    MOV RESULTADO[0],AL
                                             
    ; ---------------------
                               
    ; MOSTRAR TITULO
    MOV DX,0505H
    CALL CURSOR
    MOV DX, OFFSET MULT_TITLE
    CALL IMPRIME           
    
    ; MOSTRAR RESULTADO
    MOV DX, OFFSET MSG_RESULT
    CALL IMPRIME   
    
    MOV DX, OFFSET RESULTADO
    CALL IMPRIME

    CALL CONTINUAR
    ; ---------------------
RET
MULTIPLICACION ENDP    
    
; _________________________________
; _________________________________
; _________________________________
; _________________________________
; _________________________________
; _________________________________
; _________________________________
; _________________________________
; _________________________________
; _________________________________

; _________________________________
; DIVISION

DIVISION PROC NEAR        
    CALL PANTALLA
    
    ; ---------------------
    ; MOSTRAR TITULO
    MOV DX,0505H
    CALL CURSOR    
    
    MOV DX, OFFSET DIVISION_TITLE
    CALL IMPRIME     
    
    ; PEDIR DATO 1
    MOV DX, OFFSET MSG_NUM_1
    CALL IMPRIME
    CALL TECLADO 
    
    LEA SI,BUFFER[2+1]
    LEA DI,NUMS[0]
    MOV CX,2
    CALL BUFF_A_NUMS

    CALL PANTALLA
    
    ; ---------------------
    
    ; MOSTRAR TITULO
    MOV DX,0505H
    CALL CURSOR
    MOV DX, OFFSET DIVISION_TITLE
    CALL IMPRIME   
    
    ; PEDIR DATO2
    MOV DX, OFFSET MSG_NUM_2
    CALL IMPRIME
    CALL TECLADO
    
    LEA SI,BUFFER[2+1]
    LEA DI,NUMS[1]
    MOV CX,2
    CALL BUFF_A_NUMS
    
                    
    CALL PANTALLA   
    
    ; ---------------------   
    
    ; EFECTUAR OPERACION 

    XOR AX,AX
        
    MOV AL,NUMS[0]
    MOV BL,NUMS[1]  
    DIV BL
    
    MOV RESULTADO[0],AL
                                             
    ; ---------------------
                               
    ; MOSTRAR TITULO
    MOV DX,0505H
    CALL CURSOR
    MOV DX, OFFSET DIVISION_TITLE
    CALL IMPRIME           
    
    ; MOSTRAR RESULTADO
    MOV DX, OFFSET MSG_RESULT
    CALL IMPRIME   
    
    MOV DX, OFFSET RESULTADO
    CALL IMPRIME

    CALL CONTINUAR
    ; ---------------------
RET
DIVISION ENDP    
    
; _________________________________
; _________________________________
; _________________________________
; _________________________________
; _________________________________
; _________________________________
; _________________________________
; _________________________________
; _________________________________
; _________________________________
                                   

; _________________________________
; POTENCIA

POTENCIA PROC NEAR        
    CALL PANTALLA
    
    ; ---------------------
    ; MOSTRAR TITULO
    MOV DX,0505H
    CALL CURSOR    
    
    MOV DX, OFFSET POTENCIA_TITLE
    CALL IMPRIME     
    
    ; PEDIR DATO 1
    MOV DX, OFFSET MSG_BASE_POT
    CALL IMPRIME
    CALL TECLADO 
    
    LEA SI,BUFFER[2+1]
    LEA DI,NUMS[0]
    MOV CX,2
    CALL BUFF_A_NUMS

    CALL PANTALLA
    
    ; ---------------------
    
    ; MOSTRAR TITULO
    MOV DX,0505H
    CALL CURSOR
    MOV DX, OFFSET POTENCIA_TITLE
    CALL IMPRIME   
    
    ; PEDIR DATO2
    MOV DX, OFFSET MSG_EXP_POT
    CALL IMPRIME
    CALL TECLADO
    
    LEA SI,BUFFER[2+1]
    LEA DI,NUMS[1]
    MOV CX,2
    CALL BUFF_A_NUMS
    
                    
    CALL PANTALLA   
    
    ; ---------------------   
    
    ; EFECTUAR OPERACION 

    XOR AX,AX
    XOR BX,BX
        
    MOV AL,NUMS[0]  ; BASE
    MOV BL,NUMS[1]  ; POTENCIA
    
    MOV CX,BX       ; VECES A MULTIPLICAR - 1
    DEC CX
    MOV BL,AL       ; BASE POR BASE
        
    ELEVAR:
        MUL BX        
        LOOP ELEVAR      
    
    
    MOV RESULTADO[0],AH
    MOV RESULTADO[1],AL
                                             
    ; ---------------------
                               
    ; MOSTRAR TITULO
    MOV DX,0505H
    CALL CURSOR
    MOV DX, OFFSET POTENCIA_TITLE
    CALL IMPRIME           
    
    ; MOSTRAR RESULTADO
    MOV DX, OFFSET MSG_RESULT
    CALL IMPRIME   
    
    MOV DX, OFFSET RESULTADO
    CALL IMPRIME

    CALL CONTINUAR
    ; ---------------------
RET
POTENCIA ENDP    
    
; _________________________________
; _________________________________
; _________________________________
; _________________________________
; _________________________________
; _________________________________
; _________________________________
; _________________________________
; _________________________________
; _________________________________

; _________________________________
; GRAFICAR

;-----------------------------------

GRAFICAR_FUNCIONES PROC NEAR
                      
    MOV AH, 0FH        ; Interrupcion que pide el modo de video actual
    INT 10H                         
    PUSH AX            ; Guarda en pila el modo de video
    CALL GRAPHMODE     ; Ajusta el modo de video             
    
    MOV SI,OFFSET SENO
    
    CALL C10DISP       ; Imprime lineas
    
    MOV DX,0510H
    CALL CURSOR
                 
    CALL CONTINUAR        ; Pide una tecla para continuar             
    
    POP AX             ; Pide de la pila el valor anterior de video             
    MOV AH, 00H                     
    INT 10H            ; Ajusta el modo de video de nuevo
RET                          
GRAFICAR_FUNCIONES ENDP                          
;-----------------------------------
GRAPHMODE PROC NEAR                 
    MOV AH, 00H  ; Ajusta modo de video                   
    MOV AL, 13H  ; Modo grafico 320x200, 256 colores                   
    INT 10H      ; Cambia modo de video                   
    MOV AH, 0CH ; Modo para imprimir pixel                     
    MOV BH, 00  ; Pagina de video 0                    
    MOV BL, 07H ; Color gris                    
    INT 10H     ; Dibuja pixel                    
    RET                             
GRAPHMODE ENDP                      
;-----------------------------------
C10DISP PROC NEAR                   
    MOV BX, 0015    ; Selecciona color blanco
    XOR AX,AX 
    
    CICLO:       
        CMP AX,40
        JE CAMBIAR_COLOR
        
        CONTIN:
            MOV CX, [SI]      ; Coordenada x                      
            INC SI
            INC SI
            
            MOV DX, [SI]      ; Coordenada y                      
            INC SI
            INC SI
                                            
            MOV AH, 0CH     ; Modo para imprimir pixel                
            MOV AL, BL      ; Pone color del pixel
            INT 10H                         
            
            INC CONT
            MOV AX,CONT        
            CMP AX,CONST
            JB CICLO   
            JE REGRESAR
                    
    CAMBIAR_COLOR:
        MOV BX,000CH    ; C ROJO BRILL, A VERDE BRILL       
        JMP CONTIN
        
    REGRESAR: RET                             
C10DISP ENDP                           
    
; _________________________________
; _________________________________
; _________________________________
; _________________________________
; _________________________________
; _________________________________
; _________________________________
; _________________________________
; _________________________________
; _________________________________
                                              
                                       
END BEGIN
