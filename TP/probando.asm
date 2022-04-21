global main
extern printf
extern sscanf
extern gets

section     .data
    msg     db  "RES: %lli",10,0
    msg2    db  "RES2: %lli",10,0
    numFormat   db  "%lli",0
section     .bss
    resultado       resq    1
    x               resq    1
    y               resq    1
    xx              resq    1
    yy              resq    1
    n               resq    1
section     .text
main:
    cambiar:

    mov     rcx,x
    sub     rsp,32
    call    gets
    add     rsp,32

    mov     rcx,y
    sub     rsp,32
    call    gets
    add     rsp,32
    ; Convierto a numero
    mov     rcx,x
    mov     rdx,numFormat
    mov     r8,xx
    sub     rsp,32
    call    sscanf
    add     rsp,32

    mov     rcx,y
    mov     rdx,numFormat
    mov     r8,yy
    sub     rsp,32
    call    sscanf
    add     rsp,32

    mov     rcx,[xx]
    sub     rcx,[yy]
    mov     [n],rcx

    mov     rcx,[yy]
    sub     rcx,[xx]
    mov     [xx],rcx

    cmp     qword[n],0
    jl      mensaje

    cmp     qword[xx],0
    jl      mensaje2



    mensaje:
    mov     rcx,msg
    mov     rdx,[n]
    sub     rsp,32
    call    printf
    add     rsp,32
    jmp     end

    mensaje2:
    mov     rcx,msg2
    mov     rdx,[xx]
    sub     rsp,32
    call    printf
    add     rsp,32


    end:



ret