global main
extern puts
extern printf
extern gets
extern sscanf


section .data
    mensaje             db "%hi",0
    saltoDeLinea        db "",10,0
    matriz times 100    dw 0
section .bss

section .text
main:
    mov     word[matriz+38],1
    call    listarMatriz

ret


listarMatriz:
    mov     rcx,100
    mov     rbx,0
    mov     rdi,1
    listando:
    push    rcx

    mov     rcx,mensaje
    mov     rdx,[matriz + rbx]
    sub     rsp,32
    call    printf
    add     rsp,32

    cmp     rdi,20
    jne     continuarLoop

    mov     rdi,0
    mov     rcx,saltoDeLinea
    sub     rsp,32
    call    printf
    add     rsp,32

    continuarLoop:
    inc     rdi
    add     rbx,2
    pop     rcx
    loop    listando

ret