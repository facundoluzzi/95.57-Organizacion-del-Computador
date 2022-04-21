global main
extern puts
extern printf
extern gets
extern sscanf


section .data
    ; ------------------------------
    ; DECLARO MATRIZ ---------------
    ; ------------------------------
    matriz times 40 db "." ; SE PUEDE REEMPLAZAR POR ESPACIO EN BLANCO
    mensaje         db "%c",0
    saltoLinea      db "",10,0
section .bss

section .text
main:
    mov     byte[matriz+9],'*'
    call    listarMatriz

ret
; ----------------------------------------------------------
; Muestro matriz de 4 FIL 10 COLUMNAS con SALTO DE LINEA ---
; ----------------------------------------------------------
listarMatriz:
    mov     rcx,40
    mov     rdi,0
    mov     rbx,1
    listando:
    push    rcx

    mov     rcx,mensaje
    mov     rdx,[matriz+rdi]
    sub     rsp,32
    call    printf
    add     rsp,32

    cmp     rbx,10
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