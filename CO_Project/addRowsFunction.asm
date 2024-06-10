.model small      ; Define memory model as 'small'
.stack 100h       ; Define stack size

.data 

    index db 0
    ; I defined them as 1D array as they overlap when I assign them as 2D arrays
    
    ;state db 16 dup(?)       
    state db 4h, 0e0h, 48h, 28h, 66h, 0cbh, 0f8h, 06h, 81h, 19h, 0d3h, 26h, 0e5h, 9ah, 7ah, 4ch 
    ;roundKey db 16 dup (?) 
    roundKey db 0a0h, 88h, 23h, 2ah, 0fah, 54h, 0a3h, 6ch, 0feh, 2ch, 39h, 76h, 17h, 0b1h, 39h, 05h 
    arrLen dw 16 
    row db -1
    col db -1  
    rowLen db 4
    colLen db 4
    
.code 
 
 
; Helper macro to give it i, j and it transforms it into single coordinate.

CONVERT MACRO i, j, ans, localColumnLength 
    mov al, localColumnLength
    mov ah, i
    mul ah
    add al, j 
    mov ans, al  
endm
 
  
; Helper macro to fill the array with specific values
  
FILLARR macro arr, val, localRowLength, localColumnLength
    local initL ; declare initL lable as local
    
    mov ax, 0
    mov bx, 0
    
    ; init array
    mov al, localRowLength
    mov bl, localColumnLength 
    mul bl ; to store the length of the whole 1D array into the AX
    
    mov cx, ax
    dec cx  ; to match the index of the array 
    mov di, offset arr ; to get the ofset address in memory
    
    initL:
        mov bx, cx
        mov byte ptr [di][bx], val  ; it will work without 'byte ptr' also :)
        dec cx
        jns initL 
    
endm    
        
            
         
; ADDROUNDKEY macro.................  

ADDROUNDKEY macro sArr, rkArr, localRowLength, localColumnLength
    
    local outerL, innerL, endMacro ; declare outerL and innerL lables as local
    
    ; CX will hold the offset of the sArr, DX will hold the offset of the rkArr
    mov si, offset sArr
    mov di, offset rkArr
    
    ;mov col, -1
    outerL:
        inc col
        mov bl, col
        cmp bl, localColumnLength
        jz endMacro
        
        
        mov row, -1
        innerL:
            inc row
            mov bh, row
            cmp bh, localRowLength
            jz outerL
            
            CONVERT row, col, index, rowLen, colLen
            ; beginning xor operation
            mov bl, index                                          
            mov bh, 0                                              
            mov al, [si][bx] ; taking value from sArr[row][column] mov [si][index], al
            xor al, [di][bx] ; taking value from rkArr[row][column]
            mov [si][bx], al; store the value into sArr[row][column]
            jmp innerL    
                
endMacro:
    mov index, 0
    mov row, -1
    mov col, -1    
    endm

        
         
main PROC
    ; Set up data segment
    mov ax, @data ; Load data segment address into AX
    mov ds, ax    ; Move data segment address from AX to DS
    mov es, ax    ; Move data segment address from AX to ES (if needed)  
  
    ; My Code..........>>>>>
                
    ;The actual function of addRoundKey
    
    ADDROUNDKEY state, roundKey, rowLen, colLen                          
    
    ; end of the macro          
  
                      
    ; Exit program
    
    mov ax, 4C00h ; DOS interrupt for program termination
    int 21h       ; Call DOS interrupt
main ENDP         ; End of main procedure 



END main          ; End of program
 
 
 

















     
     
    
;    ; CX will hold the offset of the sArr, DX will hold the offset of the rkArr
;    mov si, offset state
;    mov di, offset roundKey
;    
;    outerL:
;        inc col
;        mov bl, col
;        cmp colLen, bl
;        jz endMacro
;        
;        
;        mov row, -1
;        innerL:
;            inc row
;            mov bh, row
;            cmp rowLen, bh 
;            jz outerL
;            
;            CONVERT row, col, index
;            ; beginning xor operation
;            mov bl, index 
;            mov bh, 0
;            mov al, [si][bx] ; taking value from sArr[row][column]
;            xor al, [di][bx] ; taking value from rkArr[row][column]
;            
;            mov state[bx], al
;           
;            jmp innerL                
;    
;endMacro:    
;    end 
     
     
     
     
     
     
     
     
