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

section     .data
    fileName    db  "CALEN.dat",0
    modeName    db  "rb",0

    matriz      times 42    dw  0
    dias                    db  "DOLUMAMIJUVISA"  
    formato                 db  "%li",0          


    ; Mensaje para debug
    msjInicio       db  "Iniciando...",0
    msjSemana       db  "Ingrese la semana.. (1 - 6)",10,13,0
    msjErrorOpen    db  "Error al intentar abrir el archivo, finalizando programa...",10,0
    msjEnc          db  "Dia de calendario -- Act",10,13,0
    msgCant         db  "%d",10,13,0

    diasImp     db  "Domingo        ",0
                db  "Lunes          ",0
                db  "Martes         ",0
                db  "Miercoles      ",0
                db  "Jueves         ",0
                db  "Viernes        ",0
                db  "Sabado         ",0

    registro    times 0     db ""
     dia        times 2     db " "
     semana                 db  0
     descrip    times 20    db " "

section     .bss
    fileHandle      resq    1
    esValido        resb    1
    contador        resq    1
    diabin          resb    1
    nroIng          resd    1
    buffer          resb    10

section     .text
main:
    mov     rcx,msjInicio
    sub     rsp,32
    call    puts
    add     rsp,32

    call    abrirArch

    cmp     qword[fileHandle],0
    jle     errorOpen

    call    leerArch
    call    listarArch

endProg:

ret

errorOpen:
    mov     rcx,msjErrorOpen
    sub     rsp,32
    call    printf
    add     rsp,32

    jmp     endProg

abrirArch:
    mov     rcx,fileName
    mov     rdx,modeName
    sub     rsp,32
    call    fopen
    add     rsp,32

    mov     qword[fileHandle],rax
ret

leerArch:

leerReg:
    mov     rcx,registro                ; Parametro 1: dir area de memoria donde se copia   
    mov     rdx,23                      ; Parametro 2: longitud del registro
    mov     r8,1                        ; Parametro 3: cantidad de registros
    mov     r9,qword[fileHandle]        ; Parametro 4: handle del archivo
    sub     rsp,32
    call    fread
    add     rsp,32

    cmp     rax,0
    jle     eof

    call    VALCAL

    cmp     byte[esValido],'S'
    jne     leerReg                     ; Parametro JNE != 'S'

    ; Actualizar la actividad leida del archivo en la matriz

    call    sumarAct

    jmp     leerReg

eof:

    ; Cierro archivo cuando llega a su fin
    mov     rcx,qword[fileHandle]
    sub     rsp,32
    call    fclose
    add     rsp,32

ret


VALCAL:

    mov     rbx,0
    mov     rcx,7
    mov     rax,0
compDia:
    inc     rax
    mov     qword[contador],rcx
    mov     rcx,2
    lea     rsi,[dia]
    lea     rdi,[dias + rbx]
    repe    movsb
    
    je      diaValido
    add     rbx,2
    mov     rcx,qword[contador]
    loop    compDia

    jmp     invalido

diaValido:
    mov     byte[diabin],al
    cmp     byte[semana],1
    jl      invalido
    cmp     byte[semana],6
    jg      invalido
valido:
    mov     byte[esValido],'S'

finValidar:
ret

invalido:
    mov     byte[esValido],'N'
    jmp     finValidar


sumarAct:
    mov     rax,0

    sub     byte[diabin],1
    mov     al,byte[diabin]

    mov     bl,2
    mul     bl                  ; mul bl -> ax = al * bl
    
    mov     rdx,rax

    sub     byte[semana],1
    mov     al,byte[semana]

    mov     bl,14
    mul     bl

    add     rax,rdx

    mov     bx,word[matriz + rax]       ;; Utilizo el desplazamiento para llegar a la posicion en la matriz
    inc     bx
    mov     word[matriz + rax],bx

ret


listarArch:

listar:
    mov     rcx,msjSemana
    sub     rsp,32
    call    printf
    add     rsp,32

    mov     rcx,buffer
    sub     rsp,32
    call    gets
    add     rsp,32

    mov     rcx,buffer
    mov     rdx,formato
    mov     r8,nroIng
    sub     rsp,32
    call    sscanf
    add     rsp,32

    cmp     rax,1           ; 1 VALIDO, MENOR QUE 1 INVALIDO
    jl      listar
    
    cmp     dword[nroIng],1
    jl      listar
    cmp     dword[nroIng],6
    jg      listar


    mov     rax,0
    sub     dword[nroIng],1

    mov     eax,dword[nroIng]       ; (fil - 1 ) * longElem * cantColumnas

    mov     bl,14
    mul     bl

    mov     rdi,rax           ; Guardo en RDI el desplazamiento de filas


    mov     rcx,msjEnc
    sub     rsp,32
    call    printf
    add     rsp,32

    mov     rcx,7
    mov     rbx,0
    mov     rsi,0
mostrarDias:
    push    rcx

    lea     rcx,[diasImp + rsi]     
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
    add     rsi,16      ;; 15 bits, y 1 extra por el 0 binario

    pop     rcx
    loop    mostrarDias

ret