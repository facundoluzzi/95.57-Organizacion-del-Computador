global main
extern puts
extern gets
extern printf

section .data
    ; Cantidad de veces que debo sumar/restar, cuando es 0, invierto la coordenada, y reseteo el timer
    timer       dw  2
    ; Contador de vueltas (al llegar a 2, debe reiniciarse, e invertirse el signo)
    vueltas     dw  0
    ; Coordenada a sumar/restar
    coordenada  dw  0
    ; SIGNO ->       0-Negativo 1-Positivo //
    signo       dw  0
    ; Cantidad de vueltas totales dadas 
    cantVueltas dw  0

    ; Mensajes
    mensajeIngreso  db  "Ingrese un numero por favor...",0
    mensaje         db  "El numero que ud. ingreso es el siguiente: %s",10,0



section .bss
    ; Numero ingresado por teclado
    numero      resw    1


section .text
main:
    mov rcx,mensajeIngreso
    sub rsp,32
    call puts
    add rsp,32

    mov rcx,numero
    sub rsp,32
    call gets
    add rsp,32

    mov rcx,mensaje
    mov rdx,numero
    sub rsp,32
    call printf
    add rsp,32

    ret
