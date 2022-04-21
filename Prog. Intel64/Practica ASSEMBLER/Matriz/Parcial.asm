global  main   
extern puts
extern printf
extern gets
extern sscanf


section     .data
    msjInicio               db  "Bienvenido, ingrese numero de fila (1 a 15)",0
    msjBajada               db  "La bajada es %lli",10,0
    msjSubida               db  "La subida es %lli",10,0
    mensajeUno              db  "%hi",0
    msjSumatoria            db  "La sumatoria total es: %li",10,0
    msj                     db  ".......: %lli",10,0
    matriz      dw  2,1,1,1,1,1,1,1,1,1,1,1,1,1,1
                dw  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
                dw  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
                dw  4,1,1,1,1,1,1,1,1,1,1,1,1,1,1
                dw  1,2,1,1,1,1,1,1,1,1,1,1,1,1,1
                dw  1,1,3,1,1,1,1,1,1,1,1,1,1,1,1
                dw  1,1,1,4,1,1,1,1,1,1,1,1,1,1,1
                dw  1,1,1,1,5,1,1,1,1,1,1,1,1,1,1
                dw  1,1,1,1,1,6,1,1,1,1,1,1,1,1,1
                dw  1,1,1,1,1,1,7,1,1,1,1,1,1,1,1
                dw  1,1,1,1,1,1,1,5,1,1,1,1,1,1,1
                dw  1,1,1,1,1,1,1,1,7,1,1,1,1,1,1
                dw  5,1,1,1,1,1,1,1,1,5,1,1,1,1,1
                dw  4,1,1,1,1,1,1,1,1,1,6,1,1,7,1
                dw  1,2,6,1,1,1,1,1,1,1,1,2,1,1,1

    formatoFila             db  "%hi",0
    columnaBase             dw  1
              

section     .bss
    fila        resw    1
    filaIng     resw    1
    filaFinal   resw   1
    sumatoria   resd    1
    desplaz     resw    1
    totalAb     resq    1
    totalAr     resq    1

    desplazFinal    resw    1

section     .text
main:
    call    ingresarFila
    call    calcularAbajo
    call    calcularArriba

    call    calcularUbicacionInicial
    call    calcularUbicacionFinal

    call    bajar
    call    subir

    call    recorriendoMatriz

    mov     rcx,msjSumatoria
    mov     rdx,[sumatoria]
    sub     rsp,32
    call    printf
    add     rsp,32
ret

ingresarFila:
    invalido:
    mov     rcx,msjInicio
    sub     rsp,32
    call    puts
    add     rsp,32

    mov     rcx,fila
    sub     rsp,32
    call    gets
    add     rsp,32

    mov     rcx,fila
    mov     rdx,formatoFila
    mov     r8,filaIng
    sub     rsp,32
    call    sscanf
    add     rsp,32

    cmp     rax,1
    jl      invalido
    
    cmp     word[filaIng],1
    jl      invalido
    cmp     word[filaIng],15
    jg      invalido
ret


calcularAbajo:
    mov     rcx,16
    sub     rcx,[filaIng]
    mov     [totalAb],rcx
ret

calcularArriba:
    mov     rcx,16
    sub     rcx,[filaIng]
    mov     [filaFinal],rcx

    mov     rcx,15
    sub     rcx,[totalAb]
    mov     [totalAr],rcx

ret 

calcularUbicacionInicial:
    mov     bx,[filaIng]
    sub     bx,1
    imul    bx,bx,30

    mov     word[desplaz],bx


    mov     bx,[columnaBase]
    sub     bx,1
    imul    bx,bx,2

    add     word[desplaz],bx
ret

calcularUbicacionFinal:
    mov     bx,[filaFinal]
    sub     bx,1
    imul    bx,bx,30

    mov     word[desplazFinal],bx

    mov     bx,15
    sub     bx,1
    imul    bx,bx,2

    add     word[desplazFinal],bx
ret



bajar:
    mov     rcx,[totalAb]
    mov     rax,0
    sub     bx,bx
    mov     bx,[desplaz]

    bajandoEnMatriz:
    push    rcx
    sub     rcx,rcx
    mov     cx,word[matriz + rbx + rax]
    add     rcx,[sumatoria]
    mov     [sumatoria],rcx


    add     rax,32
    pop     rcx
    loop    bajandoEnMatriz

ret

subir:
    cmp     qword[totalAr],0
    je      finalizarSubida

    mov     rcx,[totalAr]
    mov     rax,0
    sub     bx,bx
    mov     bx,[desplazFinal]

    subiendoEnMatriz:
    push    rcx
    sub     rcx,rcx

    mov     cx,word[matriz + rbx + rax]
    add     rcx,[sumatoria]
    mov     [sumatoria],rcx
    
    add     rax,28
    pop     rcx
    loop    subiendoEnMatriz

    finalizarSubida:
ret


recorriendoMatriz:
    mov     rcx,225
    mov     rsi,0
    recorriendo:
    push    rcx
    mov     rcx,mensajeUno
    mov     rdx,[matriz + rsi]
    sub     rsp,32
    call    printf
    add     rsp,32

    add     rsi,2
    pop     rcx
    loop    recorriendo

ret