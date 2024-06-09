.model small
.stack 100h

.data
    num1 db 32h    
    num2 dw 1B58h   
    res dd ? ; to reserve 2 words or 4 bytes

.code
main proc
    mov ax, @data  
    mov ds, ax     
    mov ax, 0
    ; my code........           
               
        
    mov al, BYTE PTR num1+1 
                  
            
    ; Exit program properly
    mov ah, 4Ch
    int 21h

main endp
end main
