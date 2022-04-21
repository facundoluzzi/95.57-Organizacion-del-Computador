global main
extern puts
extern gets
extern printf

section         .data      
    msjAMostrar db  "Organizacion del Computador",0

section         .bss

section         .text
main:
    mov     rcx,msjAMostrar
    call puts


    ret