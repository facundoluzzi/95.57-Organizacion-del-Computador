global main
extern puts
extern printf
extern gets
extern sscanf


section .data
    mensajeTS   db "La matriz es triangular superior",0
    mensajeTI   db "La matriz es triangular inferior",0


    totalInf   dq 0
    totalBajar dq 1
    copiaBajar dq 0
    copiaRBX   dq 0

    matriz  dw 1,2,2,1,4
            dw 0,2,3,1,4
            dw 0,0,1,4,2
            dw 0,0,0,1,4
            dw 0,0,0,0,1
section .bss
    contador resq 1
    totalSup resb 1
section .text
main:
    mov     byte[totalSup],'N'
    mov     rcx,4
    mov     rbx,8
    calculandoTriangularInf:
    mov     qword[contador],rcx
    
    mov     rcx,[totalBajar]
    mov     qword[copiaBajar],rcx
    mov     qword[copiaRBX],rbx

    loopeandoAndo:
    cmp     qword[copiaBajar],0
    je      next
    add     rbx,2

    cmp     word[matriz+rbx],0
    je      continuar

    
    jmp     verificarTriang
    continuar:
    sub     qword[copiaBajar],1
    jmp     loopeandoAndo    


    next:
    inc     qword[totalBajar]
    mov     rbx,qword[copiaRBX]
    add     rbx,10
    mov     rcx,qword[contador]
    loop    calculandoTriangularInf

    mov     byte[totalSup],'S'    

    verificarTriang:
    
    cmp     byte[totalSup],'S'
    jne     endProg

    mov     rcx,mensajeTS
    sub     rsp,32
    call    puts
    add     rsp,32

    endProg:
ret
