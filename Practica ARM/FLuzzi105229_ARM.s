	.equ SWI_OpenArch, 0x66
	.equ SWI_CloseArch, 0x68
	.equ SWI_LeerInt, 0x6C
	.equ SWI_PrintInt, 0x6B
	.equ SWI_LeerStr, 0x6A
	.equ SWI_PrintStr, 0x69
	.equ SWI_Exit, 0x11

	.equ Stdout, 1

	.data
	EOL:
		.asciz "\n"
		.align
	vector:
		.word 2,4,3,6,8,7

	vectorResultado:
		.word 0,0,0
	.text

	.global _start

@ Codificar un programa en assembler ARM de 32 bits que recorra un vector de enteros y genere un nuevo vector 
@ formado por elementos que resultan de sumar pares de elementos del vector original. 
@ Ej. vector original {1,2,5,6}, vector nuevo {3,11}




.start:
	ldr r0, =vector
	ldr r1, =vectorResultado
	mov r2,#0
	mov r6, #3

recorriendoVector:
	add r2, r2, #1      @ Aumento el contador en 1
	ldr r3, [r0]
	ldr r4, [r1]

	add r4, r4, r3
	add r0, r0, #4
	ldr r3, [r0]
	add r4, r4, r3
	str r4, [r1]

	bl imprimirSuma
	@ Paso a la siguiente dupla en el vector
	add r0, r0, #4
	add r1, r1, #4
	sub r6, r6, #1
	cmp r6, #0
	beq finalizar
	b recorriendoVector

imprimirSuma:
	stmfd sp!, {r0, r1, r2, r3, lr}
	ldr r0, =Stdout
	mov r1, r4
	swi SWI_PrintInt
	ldr r1, =EOL
	swi SWI_PrintStr
	ldmfd sp!, {r0, r1, r2, r3, pc}

finalizar:

	swi SWI_Exit
	.end