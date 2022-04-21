global main
extern puts
extern print
extern sscanf
extern fopen
extern fclose
extern fgets
extern fwrite

;; Archivos de TEXTO o .DAT
;; fileName, modeName      (.txt -> r), (.dat -> rb)
;; registro times 0 dia times "bits" db " "
;; fileHandle 
;; call abrirArchivo --- call leerArchivo (dejar en registro la informacion)


section     .data
    ; Parametros de inicio de archivo de listado
    fileListado     db  "listado.txt",0
    modeListado     db  "r",0           ;; .txt se lee en r

    regListado  times   0   db  ""
     marca      times   10  db  " "
     modelo     times   15  db  " "
     anio       times   4   db  " "
     patente    times   7   db  " "
     precio     times   7   db  " "
     EOL        times   2   db  " "

    ; Parametros de inicio de archivo de seleccion
    fileSeleccion   db  "seleccion.dat",0
    modeSeleccion   db  "ab+",0         ;; .bat se lee en BINARIO (a = sobreescritura, 
                                        ;;                         b = binary, 
                                        ;;                         + = escritura)
    ; Defino matriz 6x7 
    matriz      times 42    dw 0



section     .bss

section     .text
main:





ret

;; Apertura de archivo
abrirArch:
    mov     rcx,fileName
    mov     rdx,modeName
    sub     rsp,32
    call    fopen
    add     rsp,32

    mov     [fileHandle],rax
ret

leerArch:
    mov     rcx,registro                ; Parametro 1: dir area de memoria donde se copia   
    mov     rdx,23                      ; Parametro 2: longitud del registro
    mov     r8,1                        ; Parametro 3: cantidad de registros
    mov     r9,qword[fileHandle]        ; Parametro 4: handle del archivo
    sub     rsp,32
    call    fread
    add     rsp,32

    cmp     rax,0
    jle     eof

ret