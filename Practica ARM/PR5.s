	.equ Stdout, 1

	.data
fileName:
	.asciz "dos_enteros.txt"

eol:	
	.asciz "\n"
	.align

inFileHandle:
	.word 0

	.text
	.global _start

_start:
	@ Apertura de archivo
	ldr r0,=fileName
	mov r1,#0
	swi 0x66
	bcs inFileError
	@ Guardo el manejador de archivo
	ldr r1, =inFileHandle
	str r0,[r1]

read_loop:
	@ Leo entero del archivo
	@ PRE: r0 manejador de archivo
	@ POS: r0 entero
	ldr r0, =inFileHandle
	ldr r0,[r0]
	swi 0x6C
	bcs endFile

	mov r2,r0

	mov r1,r2
	bl 	printInt
	mov r3, #-1
	EOR r1, r2, r3
	bl 	printInt
	b 	read_loop

printInt:
	stmfd sp!, {lr}
	ldr r0, =Stdout
	swi 0x6B
	ldr r1, =eol
	swi 0x69
	ldmfd sp!, {pc}
inFileError:
endFile:
	ldr r0, =inFileHandle
	swi 0x68

	swi 0x11
	.end


