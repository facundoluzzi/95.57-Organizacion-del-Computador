global  main   
extern puts
extern printf
extern gets
extern sscanf


section     .data
    msjInicio               db  "Bienvenido, ingrese numero de fila (1 a 15)",0
    msjBajada               db  "La bajada es %hi",10,0
    msjSubida               db  "La subida es %hi",10,0
    msjSumatoria            db  "La sumatoria total es: %hi",10,0
    matriz      dw  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
                dw  2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
                dw  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
                dw  2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
                dw  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
                dw  2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
                dw  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
                dw  2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
                dw  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
                dw  2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
                dw  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
                dw  2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
                dw  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
                dw  2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
                dw  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1

    formatoFila             db  "%hi",0
    columnaBase             dw  1

section     .bss
    fila        resw    1
    filaIng     resw    1
    sumatoria   resq    1
    totalAbajo  resq    1
    totalArriba resq    1
    desplaz     resw    1

section     .text
main:
    mov     rcx,msjInicio
    sub     rsp,32
    call    puts
    add     rsp,32

    mov     rcx,fila
    sub     rsp,32
    call    gets
    add     rsp,32

    call    validarFila

    call    calcularBajada          ; Calculo cuanto tengo que bajar en la matriz
    call    calcularSubida          ; Calculo cuanto tengo que subir en la matriz, a partir del punto minimo

    call    calcularDesplazamientoPrincipal

    ; No funciona la sumatoria para la diagonal que va para arriba
    ;call    sumarDiagonalAb      ; Sumo la diagonal para abajo


    call    calcularDesplazamientoFinal  ; Calculo el desplazamiento, para ubicar la matriz en el punto minimo    
    call    sumarDiagonalAr      ; Sumo la diagonal para arriba a partir del punto minimo





    mov     rcx,msjSumatoria
    mov     rdx,[sumatoria]
    sub     rsp,32
    call    printf
    add     rsp,32




ret

validarFila:
    mov     rcx,fila
    mov     rdx,formatoFila
    mov     r8,filaIng
    sub     rsp,32
    call    sscanf
    add     rsp,32

    cmp     rax,1
    jl      main
    
    cmp     word[filaIng],1
    jl      main
    cmp     word[filaIng],15
    jg      main
ret

calcularBajada:
    mov     qword[totalAbajo],0
    sub     rcx,rcx
    
    mov     rcx,16
    sub     rcx,[filaIng]
    mov     [totalAbajo],rcx
ret

calcularSubida:
    mov     qword[totalArriba],0
    sub     rcx,rcx

    mov     rcx,14
    sub     rcx,[totalAbajo]
    mov     [totalArriba],rcx
ret


sumarDiagonalAb:
    mov     rcx,[totalAbajo]
    mov     rax,0
    sub     bx,bx
    mov     bx,[desplaz]
bajandoEnMatriz:
    push    rcx
    sub     rcx,rcx


    mov     cx,word[matriz + rax + rbx]
    add     rcx,[sumatoria]
    mov     [sumatoria],rcx
    
    add     rax,32               ; Avanzo en la matriz 16 posiciones, 32 bits, 2 por posicion
    pop     rcx 
    loop    bajandoEnMatriz

ret

sumarDiagonalAr:
    mov     rcx,[totalArriba]
    mov     rax,-28               ; Retrocedo en la matriz 14 posiciones, 28 bits, 2 por posicion
    sub     bx,bx
    mov     bx,[desplaz]
subiendoEnMatriz:
    push    rcx
    sub     rcx,rcx

    
    mov     cx,word[matriz + rax + rbx]
    add     rcx,[sumatoria]
    mov     [sumatoria],rcx

    sub     rax,-28
    pop     rcx
    loop    subiendoEnMatriz

ret

calcularDesplazamientoPrincipal:
	mov		bx,[filaIng]
	sub		bx,1
	imul	bx,bx,30     ; longElem * cantColumnas = 30	

	mov		[desplaz],bx

	mov		bx,[columnaBase]
	dec		bx
	imul	bx,bx,2	    ;  longElem

	add		[desplaz],bx	
ret

calcularDesplazamientoFinal:
    mov     word[desplaz],0
	mov		rbx,[totalAbajo]
    imul    rbx,2
	sub		rbx,1
	imul	rbx,rbx,30      ; longElem * cantColumnas = 30		

	mov 	[desplaz],bx

	mov		rbx,[totalAbajo] ;
	dec		rbx
	imul	rbx,rbx,2			

	add		[desplaz],bx	
ret


