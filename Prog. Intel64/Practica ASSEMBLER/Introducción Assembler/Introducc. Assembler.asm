global main
extern puts
extern gets
extern printf

section         .data      
    msjPresentacion db  "Por favor, a continuacion indique su nombre y apellido, luego su padron, y por ultimo sus anos",10,0
    msjAMostrar     db  "El alumno %s de ",0
    msjAMostrar2    db  "Padron %s tiene ",0
    msjAMostrar3    db  "%s anos ",10,0
section         .bss
    nombreApellido      resb 100
    padron              resb 100
    anios               resb 100

section         .text
main:
    mov rcx,msjPresentacion
    call puts

    mov rcx,nombreApellido
    call gets
    mov rcx,padron
    call gets   
    mov rcx,anios
    call gets


    mov rcx,msjAMostrar
    mov rdx,nombreApellido
    call printf

    mov rcx,msjAMostrar2
    mov rdx,padron
    call printf
 
    mov rcx,msjAMostrar3
    mov rdx,anios
    call printf

    ret