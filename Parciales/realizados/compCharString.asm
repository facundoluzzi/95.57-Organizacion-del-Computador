global main
extern puts
extern printf
extern gets
extern sscanf

section .data
    caracter      db 'D'
    cant          db "Total ocurrencias dentro del string: %lli",10,0
    cantidadTotal dq 0
section .bss
    string  resb 1
section .text
main:
    mov     rcx,string
    sub     rsp,32
    call    gets
    add     rsp,32

    mov     rsi,0
    verFinal:
    cmp     byte[string+rsi],0
    je      finalString
    inc     rsi
    jmp     verFinal
    finalString:

    mov     rcx,rsi
    mov     rbx,0
    hallarCantidad:
    push    rcx
    mov     rcx,1
    lea     rsi,caracter
    lea     rdi,[string+rbx]
    repe    cmpsb
    jne     continuarLoop
    inc     qword[cantidadTotal]

    continuarLoop:
    pop     rcx
    inc     rbx
    loop    hallarCantidad

    mov     rcx,cant
    mov     rdx,[cantidadTotal]
    sub     rsp,32
    call    printf
    add     rsp,32

ret