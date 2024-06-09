.model small

.data
    
    
.code
    
    ;mov ax, @data
    ;mov ds, ax
    ;mov ax, 0
    
    ;call printLetter
    
    ;mov ah, 4Ch
    ;int 21h     
   
                 
    printLetter proc
        
        mov ah, 2
        mov dl, 'G'
        int 21h
        ret
        
    printLetter endp 
    end 