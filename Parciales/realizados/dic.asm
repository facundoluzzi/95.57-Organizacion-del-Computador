;   Ejercicio examen parcial primera oportunidad 2do cuatrimestre 2020
;Dada una matriz (M) de 15x15 cuyos elementos son binarios de punto fijo con signo de 16 bits, 
;se pide desarrollar un programa en assembler INTEL que pida el ingreso por teclado de un número de fila i, 
;que  deberá validarlo mediante el uso de una rutina interna, y muestre por pantalla la sumatoria 
;de los elementos de la diagonal que va desde (i,1) hasta (15,k) junto con los elementos de la diagonal 
;que va desde (15,k) hasta (r,15)

global main
extern puts
extern printf
extern gets
extern sscanf

section .data
    mensajeIngreso  db "Ingrese N. de fila [1, 15]",0
    mensajeAbAr     db "Abajo: %hi Arriba: %hi",10,0
    mensajeSum      db "Sumatoria: %hi",10,0

    numFormat       db "%hi",0
    numValido       db 0

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



section .bss
    numeroIngreso resb 1
    numeroInt     resb 1
    contador      resw 1

    totalAb       resq 1
    totalAr       resq 1


section .text
main:
    ingresoNumero:
    mov     rcx,mensajeIngreso
    sub     rsp,32
    call    puts
    add     rsp,32

    mov     rcx,numeroIngreso
    sub     rsp,32
    call    gets
    add     rsp,32

    call    valNumber
    cmp     byte[numValido],0
    je      ingresoNumero
    call    calcAbajoArriba
    call    calcularSumatoria

    mov     rcx,mensajeSum
    mov     rdx,[contador]
    sub     rsp,32
    call    printf
    add     rsp,32
ret

valNumber:
    mov     rcx,numeroIngreso
    mov     rdx,numFormat
    mov     r8,numeroInt
    sub     rsp,32
    call    sscanf
    add     rsp,32

    cmp     rax,1
    jl      endVAL

    cmp     byte[numeroInt],1
    jl      endVAL
    cmp     byte[numeroInt],15
    jg      endVAL

    mov     byte[numValido],1
    
    endVAL:
ret

calcAbajoArriba:
    mov     rcx,16
    sub     rcx,[numeroInt]
    mov     [totalAb],rcx

    mov     rcx,15
    sub     rcx,[totalAb]
    mov     [totalAr],rcx
ret

calcularSumatoria:
abajo:
    sub     byte[numeroInt],1
    mov     al,[numeroInt]
    mov     bl,30
    mul     bl
    mov     rbx,rax


    mov     rcx,[totalAb]
    
    bajandoEnMatriz:
    push    rcx
    mov     rsi,[matriz + rbx]
    add     [contador],rsi

    add     rbx,32
    
    pop     rcx
    loop    bajandoEnMatriz


    mov     rax,15
    sub     rax,[totalAr]
    sub     rax,1
    mov     rbx,30
    mul     rbx
    mov     rbx,rax

    mov     rax,15
    sub     rax,1
    mov     rbx,2
    mul     rbx

    add     rax,rbx


    mov     rcx,[totalAr]
    cmp     rcx,0
    je      finalizarSumatoria
    subiendoEnMatriz:
    push    rcx
    mov     rsi,[matriz + rax]
    add     [contador],rsi

    add     rax,28
    pop     rcx
    loop    subiendoEnMatriz

    finalizarSumatoria:
ret