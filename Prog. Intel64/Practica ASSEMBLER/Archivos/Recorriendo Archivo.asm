global main
extern puts
extern gets
extern sscanf
extern fopen
extern fclose
extern fgets
extern fwrite

section     .data
    ; Parametros de inicio de archivo de listado
    fileListado     db  "listado.txt",0
    modeListado     db  "r",0
    handleListado   dq  0
    msjErrOpenLis   db  "Error en apertura de archivo",0
    ; Parametros de inicio de archivo de seleccion
    fileSeleccion   db  "seleccion.dat",0
    modeSeleccion   db  "ab+",0
    handleSeleccion dq  0
    msjErrorOpenSel db  "Error en apertura archivo de seleccion",0
    ; Mensaje para debug
    msjInicio       db  "Iniciando...",0
    msjAperturaOk   db  "El archivo se abrio correctamente",0
    msjLeyendo      db  "Leyendo...",0
    msjMarcaErr     db  "Marca Invalida",0
    msjAnioError    db  "Anio Invalido",0
    

    regListado  times   0   db  ""
     marca      times   10  db  " "
     modelo     times   15  db  " "
     anio       times   4   db  " "
     patente    times   7   db  " "
     precio     times   7   db  " "
     EOL        times   2   db  " "

    regSeleccion    times   0   db  ""
     patenteS       times   7   db  " "

    vecMarcas       db "Peugeot   Fiat      Ford      Chevrolet "

    anioStr         db  "****",0
    anioFormat      db  "%hi",0 ; 16bits / word
    anioNum         dw  0

section     .bss
    datoValido      resb 1
    registroValido  resb 1
    
section     .text
main:
    mov     rcx,msjInicio
    sub     rsp,32
    call    puts
    add     rsp,32
    ; Apertura de archivo listado
    mov     rcx,fileListado
    mov     rdx,modeListado
    sub     rsp,32
    call    fopen 
    add     rsp,32

    cmp     rax,0
    jle     errorOpenLis 
    mov     [handleListado],rax
    ;El archivo se abrio correctamente
    mov     rcx,msjAperturaOk
    sub     rsp,32
    call    puts
    add     rsp,32
    ; Apertura de archivo selecc.
    mov     rcx,fileSeleccion
    mov     rdx,modeSeleccion
    sub     rsp,32
    call    fopen 
    add     rsp,32

    cmp     rax,0
    jle     errorOpenSel
    mov     [handleSeleccion],rax
    ;El archivo se abrio correctamente
    mov     rcx,msjAperturaOk
    sub     rsp,32
    call    puts
    add     rsp,32

    ; Leo el archivo Listado
leerRegistro:
    mov     rcx,regListado
    mov     rdx,45
    mov     r8,[handleListado]
    call    fgets
    cmp     rax,0
    jle     closeFiles
    mov     rcx,msjLeyendo
    call    puts

    ; Valido registro
    call    validarRegistro
    cmp     byte[registroValido],'N'
    je      leerRegistro

    ; Convierto año a numerico
    mov     rcx,4
    mov     rsi,anio
    mov     rdi,anioStr
    rep     movsb

    mov     rcx,anioStr
    mov     rdx,anioFormat
    mov     r8,anioNum
    sub     rsp,32
    call    sscanf
    add     rsp,32

    ; Verifico si el año esta entre 2010-2019
    cmp     word[anioNum],2010
    jle     leerRegistro
    cmp     word[anioNum],2019
    jg      leerRegistro
    ;Copio patente al campo del registro
    mov     rcx,7
    mov     rsi,patente
    mov     rdi,patenteS
    rep     movsb
    ; Guardo registro en archivo Seleccion
    mov     rcx,regSeleccion
    mov     rdx,7
    mov     r8,1
    mov     r9,[handleSeleccion]
    call    fwrite

    jmp     leerRegistro

errorOpenLis:
    mov     rcx,msjErrOpenLis
    sub     rsp,32
    call puts   
    add     rsp,32
    jmp     endProg
errorOpenSel:
    mov     rcx,msjErrorOpenSel
    sub     rsp,32
    call puts
    add     rsp,32
    mov     rcx,[handleListado]
    call    fclose
    jmp     endProg
closeFiles:
    mov     rcx,[handleListado]
    call    fclose
    mov     rcx,[handleSeleccion]
    call    fclose
endProg:
ret

;-----------------------------------------------------------------
; Rutinas internas
validarRegistro:
    mov     byte[registroValido],'N'
    call    validarMarca
    cmp     byte[datoValido],'N'
    je      finValidarRegistro

    call    validarAnio
    cmp     byte[datoValido],'N'
    je      finValidarRegistro

    mov     byte[registroValido],'S'    

finValidarRegistro:
ret

validarMarca:
    mov     byte[datoValido],'S'

    mov     rbx,0
    mov     rcx,4
nextMarca:
    push    rcx
    mov     rcx,10
    lea     rsi,[marca]
    lea     rdi,[vecMarcas+rbx]
    repe cmpsb

    pop     rcx
    je      marcaOk
    add     rbx,10
    loop    nextMarca

    mov     byte[datoValido],'N'
    mov     rcx,msjMarcaErr
    sub     rsp,32
    call puts
    add     rsp,32

marcaOk:

ret


validarAnio:
    mov     byte[datoValido],'S'

    mov     rcx,4
    mov     rbx,0
nextDigito:
    cmp     byte[anio+rbx],'0'
    jl     anioError
    cmp     byte[anio+rbx],'9'
    jg      anioError
    inc     rbx
    loop    nextDigito
    jmp     anioOk

anioError:
    mov     byte[datoValido],'N'
    mov     rcx,msjAnioError
    sub     rsp,32
    call puts
    add     rsp,32
anioOk:
ret