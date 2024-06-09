.model small
.stack 100h
    
    
extern printLetter:proc    
    
.data

        
.code

    mov ax, @data
    mov ds, ax
    mov ax, 0
    
    
    call printLetter
    
    
    mov ah, 4Ch
    int 21h
    end