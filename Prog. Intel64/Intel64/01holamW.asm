;******************************************************
; Ejercicio para imprimir "Hola mundo!" por pantalla
; Objetivos
;	- hacer el primer programa en asm linux 64 bits
;	- aprender la estructura de un programa
;	- mostrar mensaje por pantalla usando puts de C
; - aprender los comandos de ensamblado y linkedicion
;		nasm -fwin64 pgm.asm 
;       gcc pgm.obj -o pgm
;       pgm
;******************************************************
global	main
extern printf
extern	puts
section		.data
	mensaje		db			"Numero    %hi ",10,0		;campo con el string a imprimir.  Debe finalizar con 0 binario
	numero		dw		10
	numeroDos	dw		50

section		.bss

	num			resw	1

section		.text
main:
	mov		rcx,[numero]
	sub		rcx,[numeroDos]
	mov		[num],rcx

    mov     rcx,mensaje
    mov     rdx,[numero]
    sub     rsp,32
    call    printf
    add     rsp,32

    mov     rcx,mensaje
    mov     rdx,[num]
    sub     rsp,32
    call    printf
    add     rsp,32


	ret
