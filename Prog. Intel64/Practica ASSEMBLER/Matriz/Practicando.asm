global main
extern printf
extern puts
extern gets
extern sscanf

section     .data
    msjInputFilCol          db      "Ingrese fila (1 a 5) y columna (1 a 5)",0
    msjSumatoria            db      "La sumatoria total da: %hi",10,0
    formatoInputFilCol      db      "%hi %hi",0

	matriz	dw	1,1,1,1,1
			dw  2,2,2,2,2
			dw	3,3,3,3,3
			dw	4,4,4,4,4
			dw	5,5,5,5,5
section     .bss
    inputFilCol     resw    50
    inputValido     resb    1
    fila            resw    1
    columna         resw    1
    desplaz         resw    1

    sumatoria       resq    1
section     .text
main:
    mov     rcx,msjInputFilCol
    sub     rsp,32
    call    puts
    add     rsp,32

    mov     rcx,inputFilCol
    sub     rsp,32
    call    gets
    add     rsp,32

    call    validarFyC

    cmp     byte[inputValido],'N'
    je      main

    call    calcDesplazamiento

    call    calcSumatoria

    mov     rcx,msjSumatoria
    mov     rdx,[sumatoria]
    sub     rsp,32
    call    printf
    add     rsp,32



ret

validarFyC:
	mov		byte[inputValido],'N'

    mov     rcx,inputFilCol
    mov     rdx,formatoInputFilCol
    mov     r8,fila
    mov     r9,columna
    sub     rsp,32
    call    sscanf
    add     rsp,32

    cmp     rax,2
    jl      invalido

    cmp     word[fila],1
    jl      invalido
    cmp     word[fila],5
    jg      invalido
    
    cmp     word[columna],1
    jl      invalido
    cmp     word[columna],5
    jg      invalido

    mov     byte[inputValido],'S'

    invalido:

ret

calcDesplazamiento:
    mov     bx,[fila]
    dec     bx
    imul    bx,bx,10

    mov     [desplaz],bx

    mov     bx,[columna]
    dec     bx
    imul    bx,bx,2

    add     [desplaz],bx
ret

calcSumatoria:

    mov     dword[sumatoria],0

    sub     ebx,ebx
    mov     bx,[desplaz]

    sub     rcx,rcx
    mov     cx,6
    sub     cx,[columna]
loopeando:
    push    cx
    sub     rcx,rcx
    mov     cx,[matriz+ebx]
    add     [sumatoria],ecx

    pop     cx
    add     ebx,2
    loop    loopeando

ret