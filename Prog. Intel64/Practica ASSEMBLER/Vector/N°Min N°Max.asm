global main
extern printf

section     .data
    vectorNum        dw  1,2,3,4,5,6,7,8
    mensajeMin       db  "Numero MINIMO ... %hi",10,0
    mensajeMax       db  "Numero MAXIMO ... %hi",10,0
    posicion         dq  1


    numeroMinimo    dw  10
    numeroMaximo    dw  0

section     .bss
    numeroActual    resw    1
    resultado       resw    1

section     .text
main:
	mov		rcx,[posicion]	;rcx = posicion
	dec		rcx				;(posicion-1)
	imul	ebx,ecx,2		;(posicion-1)*longElem

    mov     rcx,8

ciclo:
    push    rcx

    call    verificarMaximo
    call    verificarMinimo


    add     ebx,2
    pop     rcx
    loop    ciclo

    mov     rcx,mensajeMin
    mov     rdx,[numeroMinimo]
    sub     rsp,32
    call    printf
    add     rsp,32

    mov     rcx,mensajeMax
    mov     rdx,[numeroMaximo]
    sub     rsp,32
    call    printf
    add     rsp,32


ret

verificarMaximo:

    mov     rcx,[vectorNum+ebx]
    sub     rcx,[numeroMaximo]
    mov     [resultado],rcx

    cmp     word[resultado],0
    jge     intercambiarMaximo
    jle     final

    intercambiarMaximo:
        mov     rcx,[vectorNum+ebx]
        mov     [numeroMaximo],rcx
    final:
ret


verificarMinimo:
    mov     rcx,[vectorNum+ebx]
    sub     rcx,[numeroMinimo]
    mov     [resultado],rcx

    cmp     word[resultado],0
    jg      fin
    jle     intercambiarMinimo

    intercambiarMinimo:
        mov     rcx,[vectorNum+ebx]
        mov     [numeroMinimo],rcx

    fin:
ret