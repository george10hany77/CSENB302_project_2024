.model small  
.stack 100h
 .data

TempC dw 04h 
Arr db 0Ah,0Bh,0Ch,0Dh,0Eh,0Fh,11h,22h,33h,44h,55h,66h,77h,88h,99h,10h

.code     
 
SHIFtROWS MACRO shRarr
    mov cx, 04h
    mov si, offset shRarr
LoopBig:
    mov TempC, 04h
    mov bx, TempC
    sub bx, cx
    mov TempC, bx
    shl bx, 2  ; shifting by 2 instead of 3 for bytes
    cmp TempC, 0h
LoopSmall:
    jz EN
    mov al, [si + bx]       ; load byte from [si + bx]
    mov dl, [si + 1 + bx]   ; load byte from [si + 1 + bx]
    mov [si + bx], dl       ; store byte to [si + bx]

    mov dl, [si + 2 + bx]   ; load byte from [si + 2 + bx]
    mov [si + 1 + bx], dl   ; store byte to [si + 1 + bx]

    mov dl, [si + 3 + bx]   ; load byte from [si + 3 + bx]
    mov [si + 2 + bx], dl   ; store byte to [si + 2 + bx]

    mov [si + 3 + bx], al   ; store byte to [si + 3 + bx]

    dec TempC
    cmp TempC, 0
    jnz LoopSmall

    mov bx, TempC
    cmp bx, 0h
    je EN
EN:
    dec cx
    jnz LoopBig
ENDM
 
    
mov ax,@data
mov ds,ax

    SHIFTROWS Arr      
     
mov ah, 4ch
int 21h
end
