global 	main
extern 	printf
extern	gets
extern  puts
extern 	sscanf

section .data
    mensajeInicio   db "Ingrese una palabra en mayuscula de 10 letras en total. Ej [MAYUSCULAS]",0     
    mensajeMatriz   db "%c",0
    mensajeRandom   db "",10,0
    mensajeLetraD   db "%lli",10,0
    columnaLetraAct dq 0
    matriz  times 360 db " "
section .bss
    ingresoMayus    resb 100
    letraActual     resb 1
    palabraValida   resb 1
    guardarRsi      resq 1

section .text
main: 
    ingresarPal:
    mov     rcx,mensajeInicio
    sub     rsp,32
    call    puts
    add     rsp,32

    mov     rcx,ingresoMayus
    sub     rsp,32
    call    gets
    add     rsp,32

    call    VALCAR
    cmp     byte[palabraValida],'S'
    jne     ingresarPal

    call    dibujarMatriz
    call    mostrarMatriz
ret

VALCAR:
    mov     byte[palabraValida],'N'

    mov     rsi,0
    hallarLong:
    cmp     byte[ingresoMayus+rsi],0
    je      finalString
    inc     rsi
    jmp     hallarLong

    finalString:
    cmp     rsi,10
    jne     endVAL

    mov     rcx,10
    mov     rdi,0
    verificarLetra:
    mov     bl,byte[ingresoMayus+rdi]
    cmp     rbx,90
    jg      endVAL
    cmp     rbx,65
    jl      endVAL

    inc     rdi
    loop    verificarLetra

    mov     byte[palabraValida],'S'
    endVAL:
ret

dibujarMatriz:

    mov     rcx,10
    mov     rdi,0
    mov     rsi,1
    continuarLetraSig:
    push    rcx
    mov     qword[columnaLetraAct],0
    cmp     byte[ingresoMayus+rdi],'D'
    jne     siguiente

    mov     qword[guardarRsi],rsi
    mov     qword[columnaLetraAct],rsi
    sub     rsi,1
    imul    rsi,rsi,5
    add     qword[columnaLetraAct],rsi

    mov     rsi,qword[guardarRsi]
    call    dibujarArryAbj
    siguiente:
    inc     rdi
    inc     rsi
    pop     rcx
    loop    continuarLetraSig
ret

dibujarArryAbj:
    mov     rax,qword[columnaLetraAct]
    sub     rax,1
    imul    rax,rax,1
    mov     rbx,rax

    mov     rcx,5
    dibujandoArriba:
    push    rcx

    mov     al,[matriz+rbx]
    mov     al,'*'
    mov     [matriz+rbx],al

    add     rbx,1
    pop     rcx
    loop    dibujandoArriba

    mov     rax,qword[columnaLetraAct]
    sub     rax,1
    imul    rax,rax,1
    mov     rbx,rax

    mov     rax,5
    imul    rax,rax,60
    add     rbx,rax

    mov     rcx,5
    dibujandoAbajo:
    push    rcx

    mov     al,[matriz+rbx]
    mov     al,'*'
    mov     [matriz+rbx],al    

    add     rbx,1
    pop     rcx
    loop    dibujandoAbajo

    mov     rax,qword[columnaLetraAct]
    add     rax,2
    sub     rax,1
    imul    rax,rax,1
    mov     rbx,rax
    
    mov     rcx,6
    dibujandoPrimeraLineaAb:
    push    rcx

    mov     al,[matriz+rbx]
    mov     al,'*'
    mov     [matriz+rbx],al    
    add     rbx,60
    pop     rcx
    loop    dibujandoPrimeraLineaAb

    mov     rax,qword[columnaLetraAct]
    add     rax,4
    sub     rax,1
    imul    rax,rax,1
    mov     rbx,rax
    
    mov     rcx,6
    dibujandoSegundaLineaAr:
    push    rcx

    mov     al,[matriz+rbx]
    mov     al,'*'
    mov     [matriz+rbx],al    
    add     rbx,60
    pop     rcx
    loop    dibujandoSegundaLineaAr
ret

mostrarMatriz:
    sub     rcx,rcx
    mov     rcx,360
    mov     rsi,0
    mov     rdi,0
    seeMatrix:
    push    rcx
    mov     rax,[matriz+rsi]

    mov     rcx,mensajeMatriz
    mov     rdx,rax
    sub     rsp,32
    call    printf
    add     rsp,32

    cmp     rdi,59
    je      separarLinea
    jmp     noSeparar

    separarLinea:
    mov     rcx,mensajeRandom
    sub     rsp,32
    call    printf
    add     rsp,32
    mov     rdi,-1

    noSeparar:
    inc     rdi
    add     rsi,1
    pop     rcx
    loop    seeMatrix
ret 