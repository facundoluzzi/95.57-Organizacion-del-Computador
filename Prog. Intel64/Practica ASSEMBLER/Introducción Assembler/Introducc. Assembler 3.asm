global main
extern puts
extern printf
extern sscanf


section     .data
    mensaje     db  "Calculando sumatoria de la traza de una matriz 3x3....",0
    mensajeDos  db  "La sumatoria de la traza es: %hi",10,0

    matriz  dw  1,1,1
            dw  2,4,2
            dw  3,3,5
section     .bss
    sumatoria   resd    1

section     .text
main:
    mov     rcx,mensaje
    sub     rsp,32
    call puts
    add     rsp,32

    mov     rcx,3
    mov     ebx,0
sumarTraza:
    push    rcx
    sub     rcx,rcx
    mov     cx,[matriz + ebx]
    add     cx,[sumatoria]
    mov     [sumatoria],cx

    add     ebx,8

    pop     rcx   
    loop sumarTraza


    mov     rcx,mensajeDos
    mov     rdx,[sumatoria]
    sub     rsp,32
    call    printf
    add     rsp,32
 
    


ret