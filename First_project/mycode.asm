;.model small
;.stack 100h
;
;.data
;    num1 dw 32d    
;    num2 dw 202d     
;    res dd ? 
;
;.code
;main proc
;    mov ax, @data  
;    mov ds, ax     
;    mov ax, 0
;    ; my code........           
;               
;    mov ax, num1
;    mul num2
;    mov res[0], ax
;    mov res[2], dx        
;    
;    ; Exit program properly
;    mov ah, 4Ch
;    int 21h
;
;main endp
;end main 


.model small
.stack 100h

.data
    num1 dw 32d    
    num2 dw 202d     
    res dd ? 

.code
    main proc
        mov ax, @data  
        mov ds, ax     
        mov ax, 0
        ; my code........           
                   
        call addFunc        
        
        ; Exit program properly
        mov ah, 4Ch
        int 21h
    
    main endp
    
    addFunc proc 
                
        mov ax, 0
        add ax, num1
        add ax, num2
        mov word ptr res, ax 
        
    ret
    endp

end main
