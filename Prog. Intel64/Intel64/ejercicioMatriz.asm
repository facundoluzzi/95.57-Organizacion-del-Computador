global main
extern puts
extern gets
extern printf

section     .data   
        msjIngFilCol        db "Ingrese fila (1 a 5) y columna (1 a 5): ",10,0
        matriz              dw  1,1,1,1,1
                            dw  2,2,2,2,2
                            dw  3,3,3,3,3
                            dw  4,4,4,4,4
                            dw  5,5,5,5,5

section     .bss
        inputFilCol     resb    50

section     .text
main:
    mov     rcx,msjIngFilCol
    sub     rsp,32
    call    printf
    add     rsp,32

    mov     rcx,inputFilCol
    sub     rsp,32
    call    gets
    add     rsp,32





    ret