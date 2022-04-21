; Dado un archivo en formato texto que contiene informacion sobre autos llamado listado.txt
; donde cada linea del archivo representa un registro de informacion de un auto con los campos: 
;   marca:							10 caracteres
;   modelo: 						15 caracteres
;   año de fabricacion:				4 caracteres
;   patente:						7 caracteres
;   precio:							7 caracteres
; Se pide codificar un programa en assembler intel que lea cada registro del archivo listado y guarde
; en un nuevo archivo en formato binario llamado seleccionados.dat las patentes de aquellos autos
; cuyo año de fabricación esté entre 2010 y 2019 inclusive
; Como los datos del archivo pueden ser incorrectos, se deberan validar mediante una rutina interna.
; Solamente se deberá validar Marca (que sea Fiat, Ford, Chevrolet o Peugeot) y año (que sea un valor
; numérico)


global	main
extern  puts
extern  fopen
extern  fclose
extern  fgets
extern  sscanf
extern  fwrite
extern  fread
extern  printf

section .data
    mensajeInicio       db "Iniciando programa...",0
    mensajeErrorOpen    db "Error al abrir el archivo...",0
    msg     db "%hi",10,0

    marcas		db	'Peugeot   Fiat      Ford      Chevrolet '

    fileName    db "listado.txt",0
    fileMode    db "r",0

    fileSelecc  db "seleccionados.dat",0
    seleccMode  db "ab",0

    anioString  db "****",0
    anioFormat  db "%hi",0
    anioInt     dw 0
    
    fileHandle   dq 0
    seleccHandle dq 0

    registro times 0  db  ''
     marca   times 10 db ' '
     modelo  times 15 db ' '
     anio    times 4  db ' '
     patente times 7  db ' '
     precio  times 7  db ' '

section .bss
    contador     resq 1


    registroValido resb 1


section .text
main:
    mov     rcx,mensajeInicio
    sub     rsp,32
    call    puts
    add     rsp,32

    call    abrirArch
    call    abrirSelecc
    cmp     qword[fileHandle],0
    jle     errorOpen 
    cmp     qword[seleccHandle],0
    jle     errorOpen

    leerReg:
    mov     rcx,registro
    mov     rdx,43
    mov     r8,1
    mov     r9,qword[fileHandle]
    sub     rsp,32
    call    fread
    add     rsp,32

    cmp     rax,0
    jle     closeFiles

    call    valReg
    cmp     byte[registroValido],'S'
    jne     leerReg
    call    agregarSelecc

    jmp     leerReg

    closeFiles:
    mov     rcx,[fileHandle]
    sub     rsp,32
    call    fclose
    add     rsp,32

    mov     rcx,[seleccHandle]
    sub     rsp,32
    call    fclose
    add     rsp,32


    jmp     endProg
    errorOpen:
    mov     rcx,mensajeErrorOpen
    sub     rsp,32
    call    puts
    add     rsp,32


    endProg:
ret


abrirArch:
    mov     rcx,fileName
    mov     rdx,fileMode
    sub     rsp,32
    call    fopen
    add     rsp,32

    mov     qword[fileHandle],rax
ret

abrirSelecc:
    mov     rcx,fileSelecc
    mov     rdx,seleccMode
    sub     rsp,32
    call    fopen
    add     rsp,32

    mov     qword[seleccHandle],rax
ret


valReg:
    mov     byte[registroValido],'N'
    mov     rcx,4
    mov     rbx,0
    leyendoMarca:
    mov     qword[contador],rcx
    mov     rcx,10
    lea     rsi,marca
    lea     rdi,[marcas + rbx]
    repe    cmpsb
    je      marcaValida

    add     rbx,10
    mov     rcx,qword[contador]
    loop    leyendoMarca
    jmp     invalido

    marcaValida:
    
    mov     rcx,4
    mov     rbx,0
    leyendoAnio:
    cmp     byte[anio+rbx],'0'
    jl      invalido
    cmp     byte[anio+rbx],'9'
    jg      invalido

    inc     rbx
    loop    leyendoAnio

    mov     byte[registroValido],'S'

    invalido:

ret

agregarSelecc:
    mov     rcx,4
    lea     rsi,anio
    lea     rdi,anioString
    rep     movsb

    mov     rcx,anioString
    mov     rdx,anioFormat
    mov     r8,anioInt
    sub     rsp,32
    call    sscanf
    add     rsp,32





    cmp     word[anioInt],2019
    jg      invalido2
    cmp     word[anioInt],2010
    jl      invalido2

    mov     rcx,registro
    mov     rdx,43
    mov     r8,1
    mov     r9,[seleccHandle]
    sub     rsp,32
    call    fwrite
    add     rsp,32

    invalido2:
ret