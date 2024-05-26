.model small      ; Define memory model as 'small'
.stack 1000h       ; Define stack size

.data 

    index db 0
    ; I defined them as 1D array as they overlap when I assign them as 2D arrays
    state db 16 dup(?)       
    roundKey db 16 dup (?) 
    arrLen dw 16 
    row db -1
    col db -1  
    rowLen db 4
    colLen db 4
    
.code 

; Helper macro to give it i, j and it transforms it into single coordinate.

CONVERT MACRO i,j,ans 
    mov al, colLen
    mov ah, i
    mul ah
    add al, j 
    mov ans, al  
endm

FILLARR macro arr,val,len
    local initL ; declare initL lable as local
    
    ; init array
    
    mov cx, len
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
            
            CONVERT row, col, index
            ; beginning xor operation
            mov bl, index                                          
            mov bh, 0                                              
            mov al, [si][bx] ; taking value from sArr[row][column] mov [si][index], al
            xor al, [di][bx] ; taking value from rkArr[row][column]
            mov state[bx], al; store the value into sArr[row][column]
            jmp innerL    
                
endMacro:    
    endm

        
         
main PROC
    ; Set up data segment
    mov ax, @data ; Load data segment address into AX
    mov ds, ax    ; Move data segment address from AX to DS
    mov es, ax    ; Move data segment address from AX to ES (if needed)  
  
    
        
            
    
    ; My Code..........>>>>>
                
    
    FILLARR state,99h,16
    FILLARR roundKey, 87h, 16
                
    CONVERT 0,0,index
    mov bl, index
    mov state[bx], 29h            
    
    CONVERT 1,0,index
    mov bl, index
    mov state[bx], 29h            
    
    CONVERT 2,0,index
    mov bl, index
    mov state[bx], 29h            
    
    CONVERT 3,0,index
    mov bl, index
    mov state[bx], 29h
    
    CONVERT 0,1,index
    mov bl, index
    mov state[bx], 34h            
    
    CONVERT 1,1,index
    mov bl, index
    mov state[bx], 34h            
    
    CONVERT 2,1,index
    mov bl, index
    mov state[bx], 34h            
    
    CONVERT 3,1,index
    mov bl, index
    mov state[bx], 34h            
                
    CONVERT 0,2,index
    mov bl, index
    mov state[bx], 43h            
    
    CONVERT 1,2,index
    mov bl, index
    mov state[bx], 43h            
    
    CONVERT 2,2,index
    mov bl, index
    mov state[bx], 43h            
    
    CONVERT 3,2,index
    mov bl, index
    mov state[bx], 43h
    
    CONVERT 0,3,index
    mov bl, index
    mov state[bx], 76h            
    
    CONVERT 1,3,index
    mov bl, index
    mov state[bx], 76h            
    
    CONVERT 2,3,index
    mov bl, index
    mov state[bx], 76h            
    
    CONVERT 3,3,index
    mov bl, index
    mov state[bx], 76h
    
    
    ADDROUNDKEY state, roundKey, rowLen, colLen                          
              
    mov bx, 0
    mov ax, 0 
                      
    ; Exit program
    
    mov ax, 4C00h ; DOS interrupt for program termination
    int 21h       ; Call DOS interrupt
main ENDP         ; End of main procedure 



END main          ; End of program
 
 
 




























 
; .model small      ; Define memory model as 'small'
;.stack 1000h       ; Define stack size
;
;.data 
;
;    index db 0
;    state db 4 dup(4 dup (?))    
;    roundKey db 4 dup(4 dup (?)) 
;    arrLen dw 16   
;
;.code 
;
;; Helper macro to give it i, j and it transforms it into single coordinate.
;
;CONVERT MACRO i, j, ans 
;    mov al, 4
;    mov ah, i
;    mul ah
;    add al, j 
;    mov ans, al  
;endm
;
;; Corrected FILLARR macro
;FILLARR macro arr, val, len
;    mov cx, len      ; Load length into CX
;    mov si, OFFSET arr ; Load offset of the array into SI
;    initL:
;        mov BYTE PTR [si], val  ; Move the value into the array at [SI]
;        inc si                  ; Increment SI to point to the next element
;        loop initL              ; Loop until CX is 0
;endm    
;
;; Placeholder for ADDROUNDKEY macro
;ADDROUNDKEY macro sArr, rkArr
;    ; Macro body here
;endm
;
;main PROC
;    ; Set up data segment
;    mov ax, @data     ; Load data segment address into AX
;    mov ds, ax        ; Move data segment address from AX to DS
;    mov es, ax        ; Move data segment address from AX to ES (if needed)  
;    
;    ; My Code
;    CONVERT 3, 3, index
;    FILLARR state, 98h, arrLen                 
;    
;    ; Exit program
;    mov ax, 4C00h     ; DOS interrupt for program termination
;    int 21h           ; Call DOS interrupt
;main ENDP           ; End of main procedure 
;
;END main            ; End of program
;
       
       
       
       
       
       
       
       
       
       
       
       
     
     
     
    
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
     
     
     
     
     
     
     
     
