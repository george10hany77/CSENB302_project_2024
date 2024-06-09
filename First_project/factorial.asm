; without loop

;.model small
;.stack 100h
;
;.data
;
;    res dd 1d
;    i dw 8d
;    
;.code
;    main proc
;    mov ax, @data  
;    mov ds, ax
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
;    ; Exit program properly
;    mov ah, 4Ch
;    int 21h
;
;main endp
;end main    

        
        
        
        
        
        
;; with loop
;
;.model small
;.stack 100h
;
;.data
;
;    res dd 1d
;    i dw 8d 
;   
;    
;.code
;    main proc
;    mov ax, @data  
;    mov ds, ax
;    
;    mov ax, WORD PTR res  
;    mov cx, i
;    
;    l1:  
;        mul cx
;        mov res[0], ax
;        mov res[2], dx
;        loop l1
;        
;    ; Exit program properly
;    mov ah, 4Ch
;    int 21h
;
;main endp
;end main    



; without loop

.model small
.stack 100h

.data

    res dd 1d
    i dw 9d
    
.code
    main proc
    mov ax, @data  
    mov ds, ax
    
    mov ax, i 
    
    l1: 
        mov ax, i 
        mul res
        mov res[0], ax
        mov res[2], dx
        dec i
        jnz l1
        
    ; Exit program properly
    mov ah, 4Ch
    int 21h

main endp
end main