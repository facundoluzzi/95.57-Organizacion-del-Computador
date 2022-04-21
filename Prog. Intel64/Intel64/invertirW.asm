global  main
extern  gets
extern	puts
extern	printf

section     .data
	msjIngTexto		db	"Ingrese un texto por teclado (max 99 caracteres)",0
    msjUdIngreso	db	"Usted ingreso: %s ",10,0 
    msjLong         db  "La longitud es %lli",10,0
    msjInvert       db  "La palabra invertida es: %lli",10,0

section     .bss
    texto           resb 100
    textoInv        resb 100 

section     .text
main:
    mov     rcx,msjIngTexto
    call    puts

    mov     rcx,texto
    call    gets

    mov     rcx,msjUdIngreso
    mov     rdx,texto
    call    printf

    mov     rsi,0

verFin:

    cmp     byte[texto+rsi],0
    je      finString
    inc     rsi
    jmp     verFin

finString:

    mov     rcx,msjLong
    mov     rdx,rsi
    call    printf

    mov     rdi,0

verFinCopia:
    cmp     rsi,0
    je      finCopia

    mov     al,[texto+rsi-1]
    mov     [textoInv + rdi],al
    dec     rsi
    inc     rdi
    jmp     verFinCopia

finCopia:
    mov     byte[textoInv+rdi],10 ; Agrego fin de linea
    mov     byte[textoInv+rdi+1],0 ; Agrego fin de string

    mov     rcx,msjInvert
    mov     rdx,textoInv
    call printf
    

    ret