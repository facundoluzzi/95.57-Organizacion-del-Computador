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

	fileName:
		.asciz "enteros.txt"

	fileHandle:
		.word 0

	.text

	.global _start


.start:
	@Abro archivo
	ldr r0, =fileName
	mov r1,#0            @ Modo: entrada
	swi SWI_OpenArch
	bcs InFileError      @ chequear si hubo error
	ldr r1, =fileHandle
	str r0,[r1]          @ r1 direccion inicio archivo

	mov r6, #1

	recorriendoArray:
	@ Leo entero de archivo
	ldr r0, =fileHandle      @ Dejo en r0 el contenido de la direcc. apuntada por r0
	ldr r0, [r0]        
	swi SWI_LeerInt
	bcs endFile

	cmp r0,#0
	bmi proximoEntero
	mul r6, r6, r0

proximoEntero:
	b 	recorriendoArray

	
InFileError:
endFile:
	ldr r0, =fileHandle
	swi SWI_CloseArch

print_Productoria:
	stmfd sp!, {lr}
	ldr r0, =Stdout
	mov r1, r6
	swi SWI_PrintInt
	ldmfd sp!, {pc}

	swi SWI_Exit
	.end