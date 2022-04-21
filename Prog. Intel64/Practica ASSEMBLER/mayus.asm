global main
extern sscanf
extern printf
extern puts
extern gets


section .data
    mensajeUno          db  "%lli",10,0
    mensajeInicio       db  "Bienvenido, ingrese una palabra de 10 caracteres en Mayusculas, por favor",0
    mensajeColumnas     db  "Columna Inicial: %lli .... Columna Final: %lli",10,0
    mensajePalabra      db  "Ud. ingreso: %s",10,0
    mensajePalabra2     db  "Letra: %s",10,0
    formatoPalabra      db  "%s",0
    
    posicionLetra          dq  0
    columnaInicial         dq  0
    columnaFinal           dq  0

    valorEspacio           dq  0

    desplaz                dq  0
    asterisco              dq  '*'

    matriz          times 360 dq " "
section .bss
    palabra         resb    100
    palabraIng      resb    100
    letraActual     resb    100
    esValido        resb    1


section .text
main:
ingresarPalabra:

    mov     rcx,mensajeInicio
    sub     rsp,32
    call    puts
    add     rsp,32

    mov     rcx,palabraIng
    sub     rsp,32
    call    gets
    add     rsp,32

    call    VAL
    cmp     byte[esValido],1
    je      ingresarPalabra

ret

VAL:
    mov     byte[esValido],0

    mov     rsi,0
verFinal:
    cmp     byte[palabraIng+rsi],0
    je      finPalabra
    inc     rsi
    jmp     verFinal
finPalabra:

    cmp     rsi,10
    je      cantLetrasVerificadas
    mov     byte[esValido],1
    jmp     end
    
    cantLetrasVerificadas:
    mov     rcx,10
    mov     rsi,0

    analizandoPalabra:
    push    rcx
    mov     byte[letraActual],""
    mov     al,[palabraIng + rsi]
    mov     [letraActual],al

    ; Verifico que la palabra sea MAYUSCULA con el codigo ASCII: X > 90, minuscula X < 65, no es letra
    cmp     byte[letraActual],90
    jg      letraMinuscula

    cmp     byte[letraActual],65
    jl      letraMinuscula

    inc     byte[valorEspacio]
    inc     byte[posicionLetra]
    cmp     byte[letraActual],'D'
    je      editarMatriz

    jmp     pasar
    editarMatriz:
    call    editMatriz

    pasar:
    jmp     continuarAnalisis
    letraMinuscula:
    pop     rcx
    mov     rcx,0
    jmp     finalizarAnalisis

    continuarAnalisis:
    inc     rsi
    pop     rcx
    loop    analizandoPalabra

    jmp     end

    finalizarAnalisis:
    mov     byte[esValido],1

    end:

ret


editMatriz:
    cmp     qword[posicionLetra],1
    je      primera


    mov     rcx,qword[posicionLetra]     ; POS LETRA ej: 2
    dec     rcx                     ; RCX = 1
    imul    rcx,rcx,5               ; 1 * 5 = 5
    add     rcx,[valorEspacio]      ; (1*5) + 2 = 7 EMPIEZA EN COLUMNA 7 -> [RCX] = 7

    mov     qword[columnaInicial],rcx
    mov     rcx,qword[columnaInicial]
    add     rcx,4
    mov     [columnaFinal],rcx
    call    dibujarMatriz

    jmp     finalizar
    primera:
    mov     rcx,1
    mov     qword[columnaInicial],rcx
    mov     rcx,qword[columnaInicial]
    add     rcx,4
    mov     qword[columnaFinal],rcx
    call    dibujarMatriz

    finalizar:
ret

dibujarMatriz:
;  [(fila-1)*longFila]  + [(columna-1)*longElemento]
;  longFila = longElemento * cantidad columnas
    mov     rcx,6   ; Cantidad de filas a dibujar
    mov     rsi,1   ; Fila actual
    lineaPrincipal:
    push    rcx
    mov     rcx,rsi
    dec     rcx
    imul    rcx,rcx,480
    mov     qword[desplaz],rcx
    mov     rcx,[columnaInicial]
    dec     rcx
    imul    rcx,rcx,8
    add     qword[desplaz],rcx

    mov     rbx,[desplaz]
    mov     qword[matriz + rbx],1

    mov     rcx,mensajeUno
    mov     rdx,[matriz + rbx]
    sub     rsp,32
    call    printf
    add     rsp,32

    pop     rcx
    loop    lineaPrincipal



ret


recorriendoMatriz:
    mov     rcx,360
    mov     rsi,0
    recorriendo:
    push    rcx
    mov     rcx,mensajeUno
    mov     rdx,[matriz + rsi]
    sub     rsp,32
    call    printf
    add     rsp,32

    add     rsi,8
    pop     rcx
    loop    recorriendo

ret