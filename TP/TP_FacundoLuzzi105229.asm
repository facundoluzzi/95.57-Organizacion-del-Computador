global main
extern puts
extern printf
extern gets
extern sscanf

section .data
    ; Mensajes
    mensajeIngreso              db  "A continuacion ingrese la opcion deseada: (1, 2, 3, 4)",0
    mensajeIngresoNumero        db  "Ingrese numero en el formato 'n'",0
    mensajeIngCoordenadas       db  "Ingrese coordenadas en el formato 'x y'",0
    mensajeIng                  db  "Ingrese un numero 'n', o coordenadas: ",0
    mensajeCoordenadas          db  "Las coordenadas correspondientes a su valor 'n' ingresado son (x, y): (%lli, %lli)",10,0
    mensajeMostrarPosicion      db  "El valor de N es: %lli",10,0
    mensajeValorCero            db  "El valor de N es: 0",0
    mensajeOrigenDeCoordenadas  db  "Las coordenadas correspondientes a su valor 'n' ingresado son (x, y) : (0, 0)",0
    mensajeCoordenadasInvalidas db  "Sus coordenadas ingresadas exceden a n <= 100. Reintente por favor...",0
    mensajeDistanciaEntrePuntos db  "La distancia entre los puntos ingresados es %lli",10,0
    ; Menu
    mensajeOpcionUno         db  "1) Determinar un punto de la espiral considerada, numerado por 'n'. Siendo 'n' un numero entero no negativo",0
    mensajeOpcionDos         db  "2) Determinar el entero no negativo 'n', correspondiente a un punto de coordenadas enteras (x, y). Para 'n' <= 100",0
    mensajeOpcionTres        db  "3) Dados dos puntos, hallar la distancia entre ambos",0
    mensajeOpcionCuatro      db  "4) Finalizar programa",0

    ; Variables
        ; Para hallar coord. en (x, y) (ej a)
    timer                  dq   1 ; Cantidad de veces que debo sumar/restar, cuando es 0, invierto la coordenada, y reseteo el timer
    vueltas                dq   0 ; Contador de vueltas (al llegar a 2, debe reiniciarse, e invertirse el signo)
    coordenada             db   0 ; Coordenada a sumar/restar (0-x, 1-y)
    coordenadaX            dq   0 ; Coordenada X
    coordenadaY            dq   0 ; Coordenada Y
    signo                  db   1 ; SIGNO ->       0-Negativo 1-Positivo
    cantVueltas            dq   0 ; Cantidad de vueltas totales dadas 
    ingresoOrigenCoord     db   0 ; Byte de verificacion para definir si el usuario ingresa 0, o coordenadas (0, 0)
        ; Para hallar n, respeto a coordenadas (ej b)
    valor                                    dq   1 ; Variable en la que se almacenara el valor de 'n' (nuestra incognita). Funciona como un contador
        ; Para hallar la distancia entre dos puntos (ej c)
    cantValoresIngresados                    db   0 ; Cantidad de puntos (valores) ingresados, debe llegar a un maximo de 2 en la opcion N°3
    posicionEncontrada                       db   0 ; 0 - POS no encontrada . 1 - POS encontrada

    ; Formato para el ingreso de numeros
    numFormat              db   "%hi",0
    opcionFormat           db   "%hi",0
    coordenadasFormat      db   "%lli %lli",0
    ; Otros
    continuarPrograma      db   1     ; Si se modifica a 0, finaliza el programa

section .bss
    ; Menu
    ingresarOpcion   resw 1
    opcion           resw 1
    ; Variables ej 1)
    stringNumber     resb 100
    n                resq 1
    copiaTimer       resq 1
    ; Variables ej 2)
    ingCoordenadas   resw 10
    x                resq 1
    y                resq 1
    recorrerLoop     resq 1     ; Valor para fijar un punto de coordenadas maximo: en el ejercicio B, recorrerLoop tendra un valor maximo de 100
    ; Variables ej 3)
    ingresoDeValores    resw 10
    ingresoDeValoresDos resw 10
    numeroUno           resq 1
    numeroDos           resq 1
    resultado           resq 1

; ---------------------------------------------  MAIN  --------------------------------------------------- ;
section .text
main:
    call    menuOpciones

    ret
; ---------------------------------------------  MENU  --------------------------------------------------- ;
menuOpciones:
    call    limpiarVariables

    mov     rcx,mensajeOpcionUno
    sub     rsp,32
    call    puts
    add     rsp,32

    mov     rcx,mensajeOpcionDos
    sub     rsp,32
    call    puts
    add     rsp,32

    mov     rcx,mensajeOpcionTres
    sub     rsp,32
    call    puts
    add     rsp,32

    mov     rcx,mensajeOpcionCuatro
    sub     rsp,32
    call    puts
    add     rsp,32

    mov     rcx,mensajeIngreso
    sub     rsp,32
    call puts
    add     rsp,32

    call    ingresoOpcion
    call    irALaOpcion

    cmp     byte[continuarPrograma],1
    je      menuOpciones

ret

ingresoOpcion:

    opcionIncorrecta:
    mov     rcx,ingresarOpcion
    sub     rsp,32
    call    gets
    add     rsp,32

    mov     rcx,ingresarOpcion
    mov     rdx,opcionFormat
    mov     r8,opcion
    sub     rsp,32
    call    sscanf
    add     rsp,32

    cmp     word[opcion],1
    jl      opcionIncorrecta
    cmp     word[opcion],4
    jg      opcionIncorrecta
ret

irALaOpcion:
    cmp     word[opcion],1
    je      opcionUno

    cmp     word[opcion],2
    je      opcionDos

    cmp     word[opcion],3
    je      opcionTres

    cmp     word[opcion],4
    je      opcionCuatro
ret
; ---------------------------------------------  OPCIONES MENU  --------------------------------------------------- ;
opcionUno:
    ingresarValor:
    mov     rcx,mensajeIngresoNumero
    sub     rsp,32
    call    puts
    add     rsp,32

    ; Ingreso de string principal
    mov     rcx,stringNumber
    sub     rsp,32
    call    gets
    add     rsp,32

    ; Verifico que haya ingresado un numero, y lo convierto
    mov     rcx,stringNumber
    mov     rdx,numFormat
    mov     r8,n
    sub     rsp,32
    call    sscanf
    add     rsp,32

    ; Verifico que n sea mayor que 0
    call    verificarIngresoValorCero
    cmp     byte[ingresoOrigenCoord],1
    je      finalizaOpcionUno
    ; Utilizo esta forma para solucionar el error de ingreso de un numero NEGATIVO: no pude solucionarlo de otro modo
    cmp     qword[n],10000
    jg      ingresarValor

    ; Si el usuario ingreso un numero mayor a 0, busco las coordenadas
    hallarCoordenadas:
    call    determinarPunto
    call    mostrarCoordenadas

    finalizaOpcionUno:
ret

opcionDos:
    ingresoInvalido:
    mov     rcx,mensajeIngCoordenadas
    sub     rsp,32
    call    puts
    add     rsp,32

    mov     rcx,ingCoordenadas
    sub     rsp,32
    call    gets
    add     rsp,32

    mov     rcx,ingCoordenadas
    mov     rdx,coordenadasFormat
    mov     r8,x
    mov     r9,y
    sub     rsp,32
    call    sscanf
    add     rsp,32

    cmp     rax,2
    jl      ingresoInvalido

    ; Verifico si el usuario ingreso coordenadas correspondientes al origen de coordenadas. En ese caso, imprimo 'n' = 0
    call    verificarIngresoOrigenDeCoord
    cmp     byte[ingresoOrigenCoord],1
    je      finalizaOpcionDos

    ; Almaceno el valor de 100 en recorrerLoop, para asi fijo un punto de coordenadas como mucho correspondiente a n <= 100
    mov     qword[recorrerLoop],100
    call    hallarValor
    ; Si hallo un punto con respecto a las coordenadas ingresadas, lo imprimo. Sino, las coordenadas ingresadas 
    ; corresponden a n > 100.  Doy aviso de esto, y finalizo el programa
    cmp     byte[posicionEncontrada],1
    jl      finalizaOpcionDos
    call    mostrarPosicion

    finalizaOpcionDos:
    call    verificarCoordenadasInvalidas
    call    limpiarVariables
ret

opcionTres:
    mov     qword[numeroUno],0
    mov     qword[numeroDos],0
    mov     qword[resultado],0
    mov     byte[cantValoresIngresados],0
    ingresar:
    ; Ingreso de puntos de la espiral
    mov     qword[recorrerLoop],10000
    call    limpiarVariables
    mov     rcx,mensajeIng
    sub     rsp,32
    call    puts
    add     rsp,32

    mov     rcx,ingresoDeValores
    sub     rsp,32
    call    gets
    add     rsp,32    

    mov     rcx,ingresoDeValores
    mov     rdx,coordenadasFormat
    mov     r8,x
    mov     r9,y
    sub     rsp,32
    call    sscanf
    add     rsp,32
    ; Si no fue posible convertir 2 valores (x, y), entonces convierto intento convertir en uno solo
    cmp     rax,2
    jl      convertirEnNumero
    ; Almaceno valor de 'n' con respecto a las coordenadas entregadas
    call    hallarValor
    cmp     byte[cantValoresIngresados],1
    jl      almacenarPrimerPunto
    jmp     almacenarSegundoPunto

    convertirEnNumero:
    mov     rcx,ingresoDeValores
    mov     rdx,numFormat
    mov     r8,n
    sub     rsp,32
    call    sscanf
    add     rsp,32
    ; Utilizo esta forma para solucionar el error de ingreso de un numero NEGATIVO: no pude solucionarlo de otro modo
    cmp     qword[n],10000
    jg      ingresar
    ; Si no ingreso un numero, pido que reingrese uno por teclado
    cmp     rax,1
    jl      ingresar

    cmp     byte[cantValoresIngresados],1
    je      almacenarSegundoPunto

    ; Almaceno el valor de cada punto, en las variables numeroUno y numeroDos
    almacenarPrimerPunto:
    mov     rcx,[n]
    mov     [numeroUno],rcx
    call    limpiarVariables
    mov     qword[valor],1
    mov     byte[cantValoresIngresados],1
    jmp     ingresoCorrecto
    almacenarSegundoPunto:
    mov     rcx,[n]
    mov     [numeroDos],rcx
    inc     byte[cantValoresIngresados]
    
    ; Verifico si ya se ingresaron los dos puntos, si se ingreso uno solo, pido que ingrese el otro
    ingresoCorrecto:
    cmp     byte[cantValoresIngresados],2
    jl      ingresar

    ; Calculo distancia entre ambos puntos
    call    hallarDistancia
ret

opcionCuatro:
    dec     byte[continuarPrograma]

ret
; --------------------------------------------- OPERACIONES EJERCICIO NUMERO UNO --------------------------------------------------- ;
; Genero una copia del Timer
determinarPunto:

    mov     rcx,[timer]
    mov     [copiaTimer],rcx
    
    mov     rcx,[n]
    while:
    push    rcx

    call    verificarCoordenada
    call    verificarSigno
    call    sumar
    call    restar

    pop     rcx
    loop    while

ret

sumar:
    cmp     byte[signo],1
    jl      finalizaSuma
    dec     qword[copiaTimer]

    mov     rcx,1

    cmp     byte[coordenada],0
    jg      sumarACoordY
    add     [coordenadaX],rcx

    sumarACoordY:
    cmp     byte[coordenada],1
    jl      finalizaSuma
    add     [coordenadaY],rcx

    finalizaSuma:
ret

restar:
    cmp     byte[signo],0
    jg      finalizaResta
    dec     qword[copiaTimer]

    mov     rcx,-1

    cmp     byte[coordenada],0
    jg      restarACoordY
    add     [coordenadaX],rcx

    restarACoordY:
    cmp     byte[coordenada],1
    jl      finalizaResta
    add     [coordenadaY],rcx

    finalizaResta:
ret

; Verifico el timer, y invierto la coordenada
verificarCoordenada: 
    cmp     qword[copiaTimer],0
    jg      finalizaVerificacion

    cmp     byte[coordenada],0
    jg      invertirCoordX
    mov     byte[coordenada],1
    jmp     incrementarTimer

    invertirCoordX:
    cmp     byte[coordenada],1
    jl      incrementarTimer
    mov     byte[coordenada],0

    incrementarTimer:
    mov     rcx,[timer]
    mov     [copiaTimer],rcx
    inc     qword[vueltas]

    finalizaVerificacion:
ret

; Verifico el signo, y lo invierto
verificarSigno:                 
    cmp     qword[vueltas],2
    jl      finalizaVerificacionSigno

    ; Reinicio cant. de vueltas
    mov     rcx,0               
    mov     [vueltas],rcx
    ; Incremento en 1 la cantidad de Vueltas
    inc     qword[cantVueltas]  

    mov     rcx,1
    add     rcx,[cantVueltas]
    mov     [timer],rcx

    mov     rcx,[timer]
    mov     [copiaTimer],rcx
    
    cmp     byte[signo],1
    jl      invertirSignoX
    mov     byte[signo],0
    jmp     finalizaVerificacionSigno

    invertirSignoX:
    cmp     byte[signo],0
    jg      finalizaVerificacionSigno
    mov     byte[signo],1

    finalizaVerificacionSigno:
ret

; Mostrar coordenadas respecto a un cierto numero entero 'n' ingresado
mostrarCoordenadas:
    mov     rcx,mensajeCoordenadas
    mov     rdx,[coordenadaX]
    mov     r8,[coordenadaY]
    sub     rsp,32
    call    printf
    add     rsp,32
ret

; --------------------------------------------- OPERACIONES EJERCICIO NUMERO DOS --------------------------------------------------- ;
hallarValor:    
    mov     qword[valor],1
    mov     rcx,[recorrerLoop]

    buscandoValorPosicion:
    push    rcx
    call    limpiarVariables

    mov     rcx,[valor]
    mov     [n],rcx

    call    determinarPunto
    
    mov     rcx,[x]
    sub     [coordenadaX],rcx
    cmp     qword[coordenadaX],0
    jne     pasarPosicion

    mov     rcx,[y]
    sub     [coordenadaY],rcx
    cmp     qword[coordenadaY],0
    jne     pasarPosicion

    ; Posicion encontrada: finalizo loop.-
    pop     rcx
    add     byte[posicionEncontrada],1
    mov     rcx,1
    jmp     finLoop

    pasarPosicion:
    add     qword[valor],1
    pop     rcx
    
    finLoop:
    loop    buscandoValorPosicion
    
ret

; Mostrar posicion 'n' correspondiente a un punto de coordenadas ingresado
mostrarPosicion:
    mov     rcx,mensajeMostrarPosicion
    mov     rdx,[n]
    sub     rsp,32
    call    printf
    add     rsp,32
ret

; --------------------------------------------- OPERACIONES EJERCICIO NUMERO TRES --------------------------------------------------- ;
hallarDistancia:
    mov     rcx,[numeroUno]
    sub     rcx,[numeroDos]
    cmp     rcx,0
    jl      invertirResta
    mov     [resultado],rcx
    jmp     mostrarResultado

    invertirResta:
    mov     rcx,[numeroDos]
    sub     rcx,[numeroUno]
    mov     [resultado],rcx

    mostrarResultado:
    mov     rcx,mensajeDistanciaEntrePuntos
    mov     rdx,[resultado]
    sub     rsp,32
    call    printf
    add     rsp,32
ret

; --------------------------------------------- VALIDACIONES GENERALES ------------------------------------------------------------- ;
; Para el ejercicio A. Verifico si el usuario ingresa el numero 0, y si lo hace, imprimo sus respectivas coordenadas: (0, 0)
verificarIngresoValorCero:
    cmp     qword[n],0
    je      origenDeCoordEnCoordenadas

    jmp     finalizaVerifIngNulo
    origenDeCoordEnCoordenadas:
    mov     rcx,mensajeOrigenDeCoordenadas
    sub     rsp,32
    call    puts
    add     rsp,32
    add     byte[ingresoOrigenCoord],1

    finalizaVerifIngNulo:
ret

; Para el ejercicio B. Verifico si el usuario ingresa coordenadas (0, 0), y si lo hace, imprimo su respectivo valor 'n': 0
verificarIngresoOrigenDeCoord:
    cmp     qword[x],0
    je      verificarCoordenadaY
    jmp     finalizaVerifIngOrigen
    verificarCoordenadaY:

    cmp     qword[y],0
    je      origenDeCoordEnNumero

    jmp     finalizaVerifIngOrigen
    origenDeCoordEnNumero:
    mov     rcx,mensajeValorCero
    sub     rsp,32
    call    puts
    add     rsp,32
    add     byte[ingresoOrigenCoord],1

    finalizaVerifIngOrigen:
ret
; En caso de que en el ejercicio N°2 ingresen coordenadas correspondientes a un 'n' > 100, verifico y imprimo mensaje de coordenadas incorrectas
verificarCoordenadasInvalidas:
    cmp byte[posicionEncontrada],0
    jg  coordenadasValidas

    mov     rcx,mensajeCoordenadasInvalidas
    sub     rsp,32
    call    puts
    add     rsp,32

    coordenadasValidas:
ret

; --------------------------------------------- LIMPIEZA DE VARIABLES GENERALES PARA SU PROXIMA UTILIZACION ------------------------------------------------------------- ;
; Reacomodar valores para un nuevo uso del programa
limpiarVariables:
    mov     qword[timer],1
    mov     qword[vueltas],0
    mov     byte[coordenada],0
    mov     qword[coordenadaX],0
    mov     qword[coordenadaY],0
    mov     byte[signo],1
    mov     qword[cantVueltas],0
    mov     qword[n],0
    mov     byte[ingresoOrigenCoord],0
    mov     byte[posicionEncontrada],0
    mov     qword[recorrerLoop],0
ret
; -------------------------------------------- FIN DEL PROGRAMA -------------------------------------------------------------------------------;