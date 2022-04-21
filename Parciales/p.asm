global main
extern puts
extern printf
extern gets
extern sscanf
extern fopen
extern fgets
extern fread
extern fclose

; ---------------------------------------
; ---------------  TIPS  ----------------
; ---------------------------------------
; PARA COMPARAR directamente >> cmp     byte[matriz+rsi],0
; PARA LOOP                  >> usar mov qword[contador],rcx   si voy a salir del loop con JMP
; PARA COMPARAR ya definido >>>>>>> cmp word[entero],NUMERO
; PARA COMPARAR ing. x teclado >>>> cmp word[enteroIng],'2' >>> OOO lo paso a numero con sscanf, y luego lo de arriba

; --------- ARCHIVOS DE TEXTO ----------------
; Si quiero validar un NUMERO y esta definido NUM times 2 db ' '
; LO PASO A NUMERO por SSCANF, OOOOOO byte a byte cmp  word[NUM],'2'

section .data
    mensajeDebug    db "1) Buscando error...",10,0
    mensajeDebug2   db "2) Hallando error...",10,0
    mensaje         db "%c",0
    saltoLinea      db "",10,0

    fileName    db "diago.dat",0
    fileMode    db "rb",0

    msg      db "%hi %hi %hi",10,0
    msg2     db "%hi",10,0

    string   db "                "
    format   db "%hi",0
    filaInt  dw 0
    columInt dw 0
    longInt  dw 0
    copia    dw 0

    contador dq 0
    total    dw 0

    matriz      times 225 db "."


    registro times 0 db ""
     fila        dw ' '
     columna     dw ' '
     longitud    dw ' '
     simbolo     db ' '

    fileHandle   dq 0

section .bss
    regValido   resb 1
    longValida  resb 1

section .text
main:
    mov     rcx,fileName
    mov     rdx,fileMode
    sub     rsp,32
    call    fopen
    add     rsp,32

    cmp     rax,0
    jle     errorOpen
    mov     qword[fileHandle],rax



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

    call    valREG
    cmp     byte[regValido],'S'
    jne     leerReg

    call    validarLongitud
    cmp     byte[longValida],'S'
    jne     leerReg

    call    addMatriz

    call    limpiarValores
    jmp     leerReg
    closeFiles:
    mov     rcx,qword[fileHandle]
    sub     rsp,32
    call    fclose
    add     rsp,32
    jmp endProg
    errorOpen:
    mov     rcx,mensajeDebug
    sub     rsp,32
    call    puts
    add     rsp,32

    endProg:
    call    listarMatriz
ret

valREG:
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
    jmp     valido
    segundaOpc:
    cmp     byte[simbolo],63
    jl      invalido
    cmp     byte[simbolo],64
    jg      invalido

    valido:
    mov     byte[regValido],'S'

    invalido:
ret

validarLongitud:
    mov     byte[longValida],'N'
    mov     rcx,[columInt]
    sub     rcx,[longInt]
    mov     [total],rcx
    
    cmp     word[total],0
    jl      inval
    
    mov     rcx,16
    sub     rcx,[filaInt]
    sub     rcx,[longInt]
    mov     [total],rcx
    cmp     word[total],0
    jl      inval

    mov     byte[longValida],'S'

    inval:
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

    mov     rcx,[longInt]
    ; Agregando a Matriz
    agregarMatriz:
    mov     qword[contador],rcx
    mov     bl,byte[simbolo]
    mov     byte[matriz + rax],bl

    add     rax,14
    mov     rcx,qword[contador]
    loop    agregarMatriz

ret