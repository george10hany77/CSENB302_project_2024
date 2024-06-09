;.model small
;.stack 100h
;
;.data
;    arr db 23, 12, 54, 77
;    size dw 4
;    ans dw 0
;.code
;    mov ax, @data  
;    mov ds, ax     
;    mov ax, 0
;    
;    
;    mov si, 0
;    l1:
;        cmp size, si
;        jz term
;        mov al, arr[si]
;        add ans, ax
; 
;        inc si
;        jmp l1
;    
;    ; Exit program properly
;    mov ah, 4Ch
;    int 21h
;    
;    term:
;        end    
   
   
   
      
;.model small                
;.stack 100h                
;                           
;.data                      
;    arr db 23h, 12h, 54h, 77h, 31h  
;    size dw 5             
;    ans dw 0               
;.code                      
;    mov ax, @data          
;    mov ds, ax             
;    mov ax, 0              
;    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;                       
;    ; bl is the temp                       
;    mov si, 0
;    mov di, size
;    shr size, 1
;    
;    l1: 
;        
;        cmp size, si
;        jz term
;        mov bl, arr[si]
;        dec di
;        mov bh, arr[di]
;        mov arr[si], bh
;        mov byte ptr arr[di], bl
;        inc si
;        jmp l1
;                     
;    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;                       
;    ; Exit program properly
;    mov ah, 4Ch            
;    int 21h                
;                           
;    term:                  
;        end 




;.model small                
;.stack 100h                
;                           
;.data                      
;    arr db 23h, 12h, 54h, 77h, 31h  
;    size dw 5             
;    ans dw 0
;    string db 'george loves tofi$'               
;.code                      
;    mov ax, @data          
;    mov ds, ax             
;    mov ax, 0              
;    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;                       
;    
;    mov si, 0
;    l1:
;        cmp string[si], '$'
;        jz term
;        inc si     
;        inc ans
;        jmp l1             
;    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;                       
;    ; Exit program properly
;    mov ah, 4Ch            
;    int 21h                
;                           
;    term:                  
;        end 




;.model small                                       
;.stack 100h                          
;                                     
;.data                                
;                             
;    string1 db 'George loves tof$'
;    string2 db 'George loves tof$'
;    ans db 0
;       
;.code                                
;    mov ax, @data                    
;    mov ds, ax                       
;    mov ax, 0                        
;    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  this algorithm checks letter by letter it assumes that the strings are equal in length.
;    
;    
;    mov si, 0
;    l1: 
;        cmp string1[si], '$'
;        mov ans, -1
;        jz term
;        cmp string2[si], '$'
;        mov ans, 1
;        jz term
;        mov al, string1[si]
;        mov ah, string2[si]
;        inc si 
;        cmp al, ah
;        jz l1 ; if equal : continue
;        js lSign ;if s1 > s2
;        mov ans, 1  ;else (s2 > s1)
;        jmp term
;    lSign:
;        mov ans, -1
;        jmp term
;                           
;    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
;    ; Exit program properly          
;    mov ah, 4Ch                      
;    int 21h                          
;                                     
;    term:                            
;        end  




.model small                                       
.stack 100h                          
                                     
.data                                
  
    ans dw 56
       
.code                                
    mov ax, @data                    
    mov ds, ax                       
    mov ax, 0                        
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  this algorithm checks letter by letter it assumes that the strings are equal in length.
    
    mov ax, 106
    div ans
                             
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
    ; Exit program properly          
    mov ah, 4Ch                      
    int 21h                          
                                     
    term:                            
        end                         