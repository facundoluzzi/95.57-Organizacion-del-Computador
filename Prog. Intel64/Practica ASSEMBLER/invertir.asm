;***************************************************************************
; invertir.asm
; Ejercicio que calcula la longitud de un string ingresado por teclado y lo imprime invertido
; 
;***************************************************************************
global  main
extern  gets
extern	puts
extern	printf

section     .data
	msjIngTexto		db	"Ingrese una palabra por teclado (10 caracteres)",0
    msjUdIngreso	db	"Usted ingreso: %s ",10,0
    msjLong			db	"La longitud es %lli",10,0
    msjTextoInv		db	"El texto invertido dice: %s",0    

section     .bss
    texto       resb 100
	textoInv	resb 100

section     .text
main:

ingresar:
    mov     rcx,msjIngTexto
    sub     rsp,32
    call    puts
    add     rsp,32

    mov     rcx,texto
    sub     rsp,32
    call    gets
    add     rsp,32

    mov     rcx,msjUdIngreso
    mov     rdx,texto
    sub     rsp,32
    call    printf
    add     rsp,32

    mov     rsi,0
verFin:
    cmp     byte[texto+rsi],0
    je      finString
    inc     rsi
    jmp     verFin


finString:

    mov     rcx,msjLong
    mov     rdx,rsi
    sub     rsp,32
    call    printf
    add     rsp,32

    mov     rdi,0

verFinCopia:    
    cmp     rsi,0
    je      finCopia

    mov     al,[texto+rsi-1]
    mov     [textoInv + rdi],al
    cmp     byte[textoInv + rdi],90
    jg      ingresar

    dec     rsi
    inc     rdi
    jmp     verFinCopia

finCopia:
	mov		byte[textoInv+rdi],10		;Agrego fin de linea
	mov		byte[textoInv+rdi+1],0	;Agrego fin de string

    mov     rcx,msjTextoInv
    mov     rdx,textoInv
    sub     rsp,32
    call    printf
    add     rsp,32

    ret