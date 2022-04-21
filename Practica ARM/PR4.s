.data

fileName:
	.asciz "archivo.txt"
	.align
inFileHandle:
	.word 0

.text

.global _start

.start:

	ldr r0, =fileName
	mov r1,#0
	swi 0x66
	bcs inFileError
	ldr r1, =inFileHandle
	str r0,[r1]

	ldr r0, =inFileHandle
	ldr r0,[r0]
	swi 0x6C

	ldr r0, =inFileHandle
	ldr r0,[r0]
	swi 0x68

	swi 0x11

.end