.model small
.stack 100h

.data
    num1 db 0x32h    
    num2 dw 0x1B58h   
    res dw ?,? ; to reserve 2 words or 4 bytes

.code
main proc
    mov ax, @data  
    mov ds, ax     
    mov ax, 0
    ; my code........           
               
        
    mov al, num1
    mul num2
                           
                           
    mov res[0],  ax
                
    mov res[2],  dx  
 
       
    
            
    ; Exit program properly
    mov ah, 4Ch
    int 21h

main endp
end main
