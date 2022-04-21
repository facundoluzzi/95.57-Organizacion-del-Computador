	.data
EOL:
	.asciz "\n"
	.text

	.global _start
_start:
	mov	r0,#2
	mov r1,#1

	add	r2,r0,r1
	sub r3,r0,r1
	mul r4,r0,r1
	and r5,r0,r1
	eor r6,r0,r1
	orr r7,r0,r1
	mov r8,r0,lsl #2
	mov r9,r0,lsr #2
	mov r10,r0,asr #2



	swi 0x11


.end