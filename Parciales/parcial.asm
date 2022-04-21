global main
extern puts
extern printf
extern gets
extern sscanf
extern fopen
extern fgets
extern fread
extern fclose

section .data
    ; MENSAJES
    mensajeError    db "Error al intentar abrir el archivo...",10,0
    mensaje         db "%c",0
    saltoLinea      db "",10,0
    ; ARCHIVO
    fileName    db "diago.dat",0
    fileMode    db "rb",0
    fileHandle  dq 0

    msg      db "%hi %hi %hi",10,0
    msg2     db "%hi",10,0
    ; VARIABLES
    string   db "                "
    format   db "%hi",0
    filaInt  dw 0
    columInt dw 0
    longInt  dw 0
    copia    dw 0

    contador dq 0
    total    dw 0
    contMatriz dw 0
    matriz      times 225 db " "


    registro times 0 db ""
     fila        dw ' '
     columna     dw ' '
     longitud    dw ' '
     simbolo     db ' '



section .bss
    regValido   resb 1
    longValida  resb 1

section .text
main:
    ; Abriendo archivo
    mov     rcx,fileName
    mov     rdx,fileMode
    sub     rsp,32
    call    fopen
    add     rsp,32

    cmp     rax,0
    jle     errorOpen
    mov     qword[fileHandle],rax
    ; Leyendo registros del archivo
    leerReg:
    call    limpiarValores

    mov     rcx,registro
    mov     rdx,7
    mov     r8,1
    mov     r9,qword[fileHandle]
    sub     rsp,32
    call    fread
    add     rsp,32

    cmp     rax,0
    jle     closeFiles

    call    pasarAEnteros
    ; Valido la informacion del registro
    call    VALREG
    cmp     byte[regValido],'S'
    jne     leerReg
    ; Agrego diagonal a la matriz
    call    addMatriz

    call    limpiarValores
    jmp     leerReg
    closeFiles:
    mov     rcx,qword[fileHandle]
    sub     rsp,32
    call    fclose
    add     rsp,32
    jmp     endProg
    errorOpen:
    mov     rcx,mensajeError
    sub     rsp,32
    call    puts
    add     rsp,32

    endProg:
    call    listarMatriz
ret

VALREG:
    ; Valido utilizando el Codigo ASCII. Los simbolos deseados se encuentran entre los valores [35,38] y [63,64]
    mov     byte[regValido],'N'
    cmp     word[filaInt],15
    jg      invalido
    cmp     word[filaInt],1
    jl      invalido
    
    cmp     word[columInt],15
    jg      invalido
    cmp     word[columInt],1
    jl      invalido 

    cmp     word[longInt],15
    jg      invalido
    cmp     word[longInt],1
    jl      invalido

    cmp     byte[simbolo],35
    jl      invalido
    cmp     byte[simbolo],38
    jg      segundaOpc
    jmp     valLongitud
    segundaOpc:
    cmp     byte[simbolo],63
    jl      invalido
    cmp     byte[simbolo],64
    jg      invalido
    ; Por algun motivo, valLongitud inserta unos bytes de memoria extraños en la primera fila. Lo verifique pero no pude solucionarlo, no me da el tiempo.
    valLongitud:
    mov     rcx,[columInt]
    sub     rcx,[longInt]
    mov     [total],rcx
    
    cmp     word[total],0
    jl      invalido
    ; EJ: Fila 14: 16 - 14 = 2 -> 2 - longitud DEBE SER mayor igual a 0. Lo que nos deja una longitud MAXIMA de 2. Si es mayor a 2, pasa al siguiente registro
    mov     rcx,16
    sub     rcx,[filaInt]
    sub     rcx,[longInt]
    mov     [total],rcx
    cmp     word[total],0
    jl      invalido

    valido:
    mov     byte[regValido],'S'
    invalido:
ret

pasarAEnteros:
    mov     rcx,2
    lea     rsi,fila
    lea     rdi,[string]
    repe    movsb

    mov     rcx,string
    mov     rdx,format
    mov     r8,filaInt
    sub     rsp,32
    call    sscanf
    add     rsp,32

    mov     rcx,2
    lea     rsi,columna
    lea     rdi,[string]
    repe    movsb

    mov     rcx,string
    mov     rdx,format
    mov     r8,columInt
    sub     rsp,32
    call    sscanf
    add     rsp,32

    mov     rcx,2
    lea     rsi,longitud
    lea     rdi,[string]
    repe    movsb

    mov     rcx,string
    mov     rdx,format
    mov     r8,longInt
    sub     rsp,32
    call    sscanf
    add     rsp,32
ret

listarMatriz:
    sub     rcx,rcx
    sub     rbx,rbx
    mov     rcx,225
    mov     rdi,0
    mov     rbx,1
    listando:
    push    rcx

    mov     rcx,mensaje
    mov     rdx,[matriz+rdi]
    sub     rsp,32
    call    printf
    add     rsp,32

    cmp     rbx,15
    je      saltoDeLinea
    jmp     continuarLoop
    saltoDeLinea:
    mov     rcx,saltoLinea
    sub     rsp,32
    call    printf
    add     rsp,32
    mov     rbx,0

    continuarLoop:
    inc     rbx
    inc     rdi
    pop     rcx
    loop    listando
ret

limpiarValores:
    mov     word[filaInt],0
    mov     word[columInt],0
    mov     word[longInt],0
    mov     qword[contador],0
    mov     word[copia],0
    mov     word[total],0
ret

addMatriz:
    sub     rax,rax
    sub     rbx,rbx
    ; CALCULO DESPLAZ
    sub     word[filaInt],1
    mov     ax,word[filaInt]
    mov     bx,15
    mul     bx
    mov     rsi,rax
    sub     word[columInt],1
    mov     ax,word[columInt]
    mov     bx,1
    mul     bx
    add     rax,rsi

    sub     rcx,rcx
    mov     rcx,[longInt]
    ; Agregando a Matriz
    agregarMatriz:
    mov     qword[contador],rcx
    sub     rbx,rbx
    mov     bl,byte[simbolo]
    mov     byte[matriz + rax],bl

    add     rax,14
    mov     rcx,qword[contador]
    loop    agregarMatriz
ret