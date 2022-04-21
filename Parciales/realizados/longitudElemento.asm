global main
extern puts
extern printf
extern gets
extern sscanf

section .data

section .bss

section .text
main:

    mov     rsi,0
    proximaLetra:
    cmp     byte[string+rsi],0
    je      finalElemento
    inc     rsi
    jmp     proximaLetra
    finalElemento:

ret