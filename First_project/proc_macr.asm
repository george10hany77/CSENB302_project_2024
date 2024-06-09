;.model small
;.stack 100h
;
;.data
;
;    res dd 1d
;    i dw 5d
;    
;.code
;    main proc
;    mov ax, @data  
;    mov ds, ax
;    
;    MY_MACR
;        
;    ; Exit program properly
;    mov ah, 4Ch
;    int 21h
;
;main endp
;;end main 
;
;
;MY_FUNC proc
;    
;    mov ax, WORD PTR res 
;    
;    l1:  
;        mul i
;        mov res[0], ax
;        mov res[2], dx
;        dec i
;        jnz l1
;    
;    ret
;    MY_FUNC endp 
;
;MY_MACR macro
;    
;    mov ax, WORD PTR res 
;    
;    l2:  
;        mul i
;        mov res[0], ax
;        mov res[2], dx
;        dec i
;        jnz l2
;    
;    MY_MACR endm
;                  
;end   ; has to be at the end of the whole code

                                             



.model small
.stack 100h

.data
    res dd 1d
    i dw 5d
    
.code

MY_FUNC proc
    mov ax, WORD PTR res 
    
l1:
    mov cx, i
    mul cx
    mov WORD PTR res[0], ax
    mov WORD PTR res[2], dx
    dec i
    jnz l1
    
    ret
MY_FUNC endp

macro MY_MACR
    mov ax, WORD PTR res
    
l2:
    mov cx, i
    mul cx
    mov WORD PTR res[0], ax
    mov WORD PTR res[2], dx
    dec i
    jnz l2
endm

main proc
    mov ax, @data  
    mov ds, ax
    
    MY_MACR
    
    ; Exit program properly
    mov ah, 4Ch
    int 21h
main endp
                  
end main
