;                to count 'e's in any word
;.data
;    
;    str db 'exercise'            
;    len dw 8h 
;    counter db 0h
;    
;.code
;    
;    mov si, -1d
;    l1: inc si
;        cmp len, si
;        jz en 
;        cmp str[si], 'e'
;        jnz l1
;        inc counter
;        jmp l1
;    en: 
;        end
;         
  
  
.model small
.stack 100h          
.data    

    counter db 0
    len dw 32d
    str db 'This is a great but strange test#'
    currChar db '0'
    isCharAVowel db 1  ; if is vowel it will be 1 else 0  
    vowels db 'AaEeOoUuIi#'
    vowelLen dw 10d 
  
.code
       
    mov ax, @data  
    mov ds, ax     
    mov ax, 0
    ; my code........
        
    mov si, -1
    l1: 
        mov isCharAVowel, 0 
        inc si 
        ;cmp len, si
        cmp currChar, '#' ; length Independent
        jz terminate ; if si reached the end of the string  
        mov al, str[si]
        mov currChar, al ; for the procedure
        call isVowel 
        cmp isCharAvowel, 0
        jz l1
        inc counter
        jmp l1
        
    ; Exit program properly
    mov ah, 4Ch
    int 21h
    
    isVowel proc
        mov di, -1
        l2:
            inc di
            ;cmp vowelLen, di
            cmp vowels[di], '#' ; length Independent
            jz endFunc ; if di reached the end of the vowels string
            mov bl, vowels[di]
            cmp currChar, bl 
            jnz l2
            mov isCharAVowel, 1 
            ret      
        
    endFunc:    
        ret
        endp    
        
    terminate:
        end
     
