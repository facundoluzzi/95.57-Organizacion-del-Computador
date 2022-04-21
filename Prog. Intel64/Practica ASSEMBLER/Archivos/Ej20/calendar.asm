; Se dispone de una matriz C que representa un calendario de actividades de una persona. 
; La matriz C está formada por 7 columnas (que corresponden a los días de la semana) 
; y por 6 filas (que corresponden a las semanas que puede tener como máximo un mes en un calendario).
; Cada elemento de la matriz es un BPF S/Signo de 2 bytes (word) 
; representa la cantidad de actividades que realizará dicho día en la semana.
; Además se dispone de un archivo de entrada llamado CALEN.DAT donde cada registro tiene el siguiente formato:
; - Día de la semana: Carácter de 2 bytes (DO, LU, MA, MI, JU, VI, SA)
; - Semana: Binario de 1 byte (1..6)
; - Actividad: Caracteres de longitud 20 con la descripción.
; Como la información leída del archivo puede ser errónea, 
; se dispone de una rutina interna llamada VALCAL para su validación.
; Se pide realizar un programa assembler Intel x86 que actualice la matriz C con aquellos registros válidos. 
; Al finalizar la actualización se solicitará el ingreso por teclado de una semana 
; y se debe generar un listado indicando “Dia de la Semana – Cantidad de Actividades”.

global 	main
extern 	printf
extern	gets
extern 	sscanf
extern	fopen
extern	fread
extern	fclose
extern  fgets
extern  puts

section .data
    mensajeInicio       db "Iniciando programa...",0
    mensajeErrorOpen    db "Error al abrir archivo...",0
    mensajeAperturaOk   db "Archivo abierto correctamente",0
    mensajeDiaCant      db "Dia        -       Cant Act.",10,0
    mensajeIngreso      db "Ingrese semana.. [1, 6]",0
    msgCant				db	'%hi',10,13,0

    vectorDias          db "Domingo        ",0
                        db "Lunes          ",0
                        db "Martes         ",0
                        db "Miercoles      ",0
                        db "Jueves         ",0
                        db "Viernes        ",0
                        db "Sabado         ",0

    fileName            db "CALEN.dat",0
    fileMode            db "rb",0

    dias                db "DOLUMAMIJUVISA"

    matriz     times 42 dw 0

    registro   times 0  db ""
     dia       times 2  db " "
     semana             db 0
     actividad times 20 db " "


    numFormat db "%hi",0

section .bss
    fileHandle          resq 1
    registroValido      resb 1
    contador            resq 1
    diabin              resb 1
    diaV                resb 1
    ingresoSemana       resb 1
    numeroIngresado     resw 1
section .text
main:
    mov     rcx,mensajeInicio
    sub     rsp,32
    call    puts
    add     rsp,32

    call    abrirArch
    cmp     qword[fileHandle],0
    jle     msgError
    call    aperturaExitosa

leerReg:
    mov     rcx,registro
    mov     rdx,23
    mov     r8,1
    mov     r9,qword[fileHandle]
    sub     rsp,32
    call    fread
    add     rsp,32

    cmp     rax,0
    jle     ingresar

    call    VALCAL
    cmp     byte[registroValido],'S'
    jne     leerReg
    call    addMatriz
    jmp     leerReg
    ingresar:
    mov     rcx,mensajeIngreso
    sub     rsp,32
    call    puts
    add     rsp,32

    mov     rcx,ingresoSemana
    sub     rsp,32
    call    gets
    add     rsp,32

    mov     rcx,ingresoSemana
    mov     rdx,numFormat
    mov     r8,numeroIngresado
    sub     rsp,32
    call    sscanf
    add     rsp,32

    cmp     byte[numeroIngresado],1
    jl      ingresar
    cmp     byte[numeroIngresado],6
    jg      ingresar

    closeFiles:
    mov     rcx,qword[fileHandle]
    sub     rsp,32
    call    fclose
    add     rsp,32

    jmp     endProgr
    msgError:
    mov     rcx,mensajeErrorOpen
    sub     rsp,32
    call    puts
    add     rsp,32

    endProgr:
    call    listarArchivo
ret

abrirArch:
    mov     rcx,fileName
    mov     rdx,fileMode
    sub     rsp,32
    call    fopen
    add     rsp,32
    mov     qword[fileHandle],rax
ret

aperturaExitosa:
    mov     rcx,mensajeAperturaOk
    sub     rsp,32
    call    puts
    add     rsp,32
ret


VALCAL:
    mov     rcx,7
    mov     rbx,0
    mov     rax,0
    validarDia:
    inc     rax
    mov     qword[contador],rcx
	mov		rcx,2
	mov		rsi,dia
	lea     rdi,[dias + rbx]
    rep     cmpsb
    je      diaValido
    jmp     continuarLoop

    diaValido:
    mov     [diabin],rax
    mov     byte[diaV],'S'
    

    continuarLoop:
    add     rbx,2
    mov     rcx,qword[contador]
    loop    validarDia

    cmp     byte[diaV],'S'
    jne     invalido
    
    validarSemana:
    cmp     byte[semana],1
    jl      invalido
    cmp     byte[semana],6
    jg      invalido
    mov     byte[registroValido],'S'

    invalido:
ret

addMatriz:
    sub     byte[semana],1
    mov     al,byte[semana]
    mov     bl,14
    mul     bl

    mov     rcx,rax

    sub     byte[diabin],1
    mov     al,byte[diabin]
    mov     bl,2
    mul     bl
    add     rax,rcx

    sumarAct:
    mov     rsi,[matriz + rax]
    inc     rsi
    mov     [matriz + rax],rsi
ret


listarArchivo:
    sub     word[numeroIngresado],1
    mov     ax,word[numeroIngresado]
    mov     bx,14
    mul     bx

    mov     rdi,rax

	mov		rcx,mensajeDiaCant			;Parametro 1: direccion de memoria del campo a imprimir
	sub		rsp,32
	call	printf				;Muestro encabezado del listado por pantalla
	add		rsp,32

    mov     rcx,7
    mov     rsi,0
    leyendo:
    push    rcx
    lea     rcx,[vectorDias + rsi]
    sub     rsp,32
    call    printf
    add     rsp,32

    mov     bx,word[matriz + rdi]

    mov     rcx,msgCant
    mov     rdx,rbx
    sub     rsp,32
    call    printf
    add     rsp,32
    
    add     rdi,2
    add     rsi,16
    pop     rcx
    loop    leyendo

ret