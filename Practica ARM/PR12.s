	.equ SWI_OpenArch, 0x66
	.equ SWI_CloseArch, 0x68
	.equ SWI_LeerInt, 0x6C
	.equ SWI_PrintInt, 0x6B
	.equ SWI_LeerStr, 0x6A
	.equ SWI_PrintStr, 0x69
	.equ SWI_Exit, 0x11

	.equ Stdout, 1
	@ movmi r0, #42        Mover si BIT NEG esta activo
	@ movpl r0, #42        Mover si BIT NEG no esta activo
	@ moveq r0, #42        Mover si BIT CERO esta activo
	@ movne r0, #42        Mover si BIT CERO no esta activo

	.data
	EOL:
		.asciz "\n"
		.align

	.text

	.global _start


.start:


	mov r0,#1
	mov r2,#8
	mov r3,#1

	iterar:
	mul r0,r0,r3

	add r3,r3,#1
	sub r2,r2,#1
	cmp r2,#0
	bne iterar

	mov r1,r0
	ldr r0, =Stdout
	swi SWI_PrintInt

	swi SWI_Exit
	.end