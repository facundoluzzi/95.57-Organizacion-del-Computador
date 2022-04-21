global main
extern puts
extern gets
extern printf
extern sscanf
extern fopen
extern fclose
extern fgets
extern fread
extern fwrite

section .data
    ; Mensaje para debug
    msjInicio           db  "Iniciando...",0
    mensajeErrorOpen    db  "Error al abrir el archivo, intente nuevamente...",0
    mensajeUno          db  "%hi",10,0

    fileName    db  "ENCUESTA.txt",0
    modeName    db  "r",0

    codCiudadStr    db "*",0
    codCiudadFormat db "%hi",0 ; Word
    codCiudadNum    dw 0

    contador        dq 0

    vectorCandidatos db "AFMMRLSM"

    vectorCiudades  db "Buenos Aires        ",0
                    db "Mendoza             ",0
                    db "Jujuy               ",0
                    db "Salta               ",0
                    db "Tierra del Fuego    ",0
                    db "Neuquen             ",0
                    db "Rio Negro           ",0
                    db "Cordoba             ",0
                    db "Entre Rios          ",0
                    db "Santiago del Estero ",0

    register times 0 db ""
     codCandidato   times 2 db " "
     codCiudad      times 1 db " "

    matrizEncuesta  dw  0,0,0,0
                    dw  0,0,0,0
                    dw  0,0,0,0
                    dw  0,0,0,0
                    dw  0,0,0,0
                    dw  0,0,0,0
                    dw  0,0,0,0
                    dw  0,0,0,0
                    dw  0,0,0,0
                    dw  0,0,0,0

    desplazamiento  dw 0
section .bss
    fileHandle    resq 1
    candValido    resb 1
    regValido     resb 1
    colCandidato  resw 1


section .text
main:
    mov     rcx,msjInicio
    sub     rsp,32
    call    puts
    add     rsp,32

    mov     rcx,fileName
    mov     rdx,modeName
    sub     rsp,32
    call    fopen
    add     rsp,32

    cmp     rax,0
    jle     errorOpen 

    mov     [fileHandle],rax

    leerReg:
    mov     rcx,register
    mov     rdx,3
    mov     r8,[fileHandle]
    sub     rsp,32
    call    fgets
    add     rsp,32

    cmp     rax,0
    jle     closeFiles

    ; Valido registro
    call    valReg
    cmp     byte[regValido],'N'
    je      leerReg

    call    sumarVoto
    jmp     leerReg

    errorOpen:
    mov     rcx,mensajeErrorOpen
    sub     rsp,32
    call    puts
    add     rsp,32
    jmp     endProg

    closeFiles:
    mov     rcx,[fileHandle]
    sub     rsp,32
    call    fclose
    add     rsp,32

    ;call    recorriendoMatriz

    endProg:
ret


; ---------------------------------------------------------
; Rutinas Internas
; ---------------------------------------------------------

valReg:
    mov     byte[candValido],'N'
    mov     byte[regValido],'N'
    mov     word[colCandidato],1

    mov     rcx,4
    mov     rbx,0
    verificarCandidato:
    
    mov		qword[contador],rcx
    
    mov     rcx,2
    mov     rsi,codCandidato
    lea     rdi,[vectorCandidatos + rbx]
    repe    cmpsb
    je      candidatoValido
    inc     word[colCandidato]

    jmp     endLoop
    candidatoValido:
    mov     byte[candValido],'S'
    mov     rcx,1
    jmp     endSinPop

    endLoop:
    mov		rcx,qword[contador]
    add     rbx,2
    endSinPop:
    loop    verificarCandidato

    cmp     byte[candValido],'S'
    jne     endValidacion
    
    verificarCiudad:
    ; Paso el codigo de ciudad a Numero
    mov     rcx,1
    mov     rsi,codCiudad
    mov     rdi,codCiudadStr
    rep     movsb

    mov     rcx,codCiudadStr
    mov     rdx,codCiudadFormat
    mov     r8,codCiudadNum
    sub     rsp,32
    call    sscanf
    add     rsp,32

    cmp     rax,0
    je      endValidacion
    ; Verifico que se encuentre entre 0 y 9
    cmp     word[codCiudadNum],9
    jg      endValidacion
    cmp     word[codCiudadNum],0
    jl      endValidacion

    mov     byte[regValido],'S'
    endValidacion:
ret

sumarVoto:
	mov		rax,0
	mov		rbx,0

    sub     word[codCiudadNum],1
    mov     ax,[codCiudadNum]
    mov     bx,8
    mul     bx

	mov		rdx,rax

    sub     word[colCandidato],1
    mov     ax,[colCandidato]
    mov     bx,2
    mul     bx

	add		rax,rdx			;sumo ambos desplaz. 

	mov		bx,word[matrizEncuesta + rax]	;obtengo la cantidad de actividades del dia en la matriz
	inc		bx						;sumar 1
	mov		word[matrizEncuesta + rax],bx	;volver a actualizar la cantidad del dia en la matriz
	
ret

recorriendoMatriz:
    mov     rcx,40
    mov     rsi,0
    recorriendo:
    push    rcx
    mov     rcx,mensajeUno
    mov     rdx,[matrizEncuesta + rsi]
    sub     rsp,32
    call    printf
    add     rsp,32

    add     rsi,2
    pop     rcx
    loop    recorriendo
ret