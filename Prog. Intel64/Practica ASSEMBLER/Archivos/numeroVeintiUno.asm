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

    fileName    db  "ENCUESTA.txt",0
    modeName    db  "r",0

    codCiudadStr    db "*",0
    codCiudadFormat db "%hi",0 ; Word
    codCiudadNum    dw 0

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
section .bss
    fileHandle    resq 1
    candValido    resb 1
    regValido     resb 1
    colCandidato  resw 1

    desplazamiento  resw    1

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
    jmp     closeFiles

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

    endProg:
ret


; ---------------------------------------------------------
; Rutinas Internas
; ---------------------------------------------------------

valReg:
    mov     byte[candidatoValido],'N'
    mov     byte[regValido],'N'
    mov     word[colCandidato],1

    mov     rcx,4
    mov     rbx,0
    verificarCandidato:
    push    rcx
    mov     rcx,2
    lea     rsi,[codCandidato]
    lea     rdi,[vectorCandidatos + rbx]
    repe    cmpsb
    je      candidatoValido

    jmp     endLoop
    candidatoValido:
    pop     rcx
    mov     byte[candidatoValido],'S'
    mov     rcx,1
    jmp     endLoop

    pop     rcx
    endLoop:
    loop    verificarCandidato

    cmp     byte[candidatoValido],'N'
    je      endValidacion
    
    verificarCiudad:
    ; Paso el codigo de ciudad a Numero
    mov     rcx,1
    mov     rdi,[codCiudad]
    mov     rsi,[codCiudadStr]
    rep     movsb

    mov     rcx,codCiudadStr
    mov     rdx,codCiudadFormat
    mov     r8,codCiudadNum
    sub     rsp,32
    call    sscanf
    add     rsp,32
    ; Verifico que se encuentre entre 0 y 9
    cmp     word[codCiudadNum],9
    jg      endValidacion
    cmp     word[codCiudadNum],0
    jl      endValidacion

    mov     byte[regValido],'S'
    endValidacion:
ret

sumarVoto:
    mov     bx,[codCiudadNum]
    sub     bx,1
    imul    bx,bx,8
    mov     word[desplazamiento],bx

    mov     bx,[colCandidato]
    sub     bx,1
    imul    bx,bx,2
    add     word[desplazamiento],bx

    mov     cx,word[desplazamiento]
    add     word[matrizEncuesta + rcx],1
ret