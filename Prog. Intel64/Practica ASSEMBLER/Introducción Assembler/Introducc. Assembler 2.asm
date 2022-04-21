global main
extern gets
extern printf
extern puts
extern sscanf

section     .data
    variableNumero      db  "%hi",0
    msj2                db  "El numero es: %hi",10,0
section     .bss
    numero                 resb 50
    numeroAlmacenado       resw 1

section     .text
main:
    mov     rcx,numero
    sub		rsp,32
    call gets
    add     rsp,32

    mov     rcx,numero
    mov     rdx,variableNumero
    mov     r8,numeroAlmacenado     ; direccion
    sub		rsp,32
    call sscanf
    add		rsp,32

    cmp     word[numeroAlmacenado],2
    je      mensaje




ret

mensaje:
    mov     rcx,msj2
    mov     rdx,[numeroAlmacenado]
    sub		rsp,32    
    call printf
    add		rsp,32

    ret