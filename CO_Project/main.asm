org 100h
.data
s_box  DB 63H,7cH,77H,7bH,0f2H,6bH,6fH,0c5H,30H,01H,67H,2bH,0feH,0d7H,0abH,76H
       DB 0caH,82H,0c9H,7dH,0faH,59H,47H,0f0H,0adH,0d4H,0a2H,0afH,9cH,0a4H,72H,0c0H
       DB 0b7H,0fdH,93H,26H,36H,3fH,0f7H,0ccH,34H,0a5H,0e5H,0f1H,71H,0d8H,31H,15H
       DB 04H,0c7H,23H,0c3H,18H,96H,05H,9aH,07H,12H,80H,0e2H,0ebH,27H,0b2H,75H
       DB 09H,83H,2cH,1aH,1bH,6eH,5aH,0a0H,52H,3bH,0d6H,0b3H,29H,0e3H,2fH,84H
       DB 53H,0d1H,00H,0edH,20H,0fcH,0b1H,5bH,6aH,0cbH,0beH,39H,4aH,4cH,58H,0cfH
       DB 0d0H,0efH,0aaH,0fbH,43H,4dH,33H,85H,45H,0f9H,02H,7fH,50H,3cH,9fH,0a8H
       DB 51H,0a3H,40H,8fH,92H,9dH,38H,0f5H,0bcH,0b6H,0daH,21H,10H,0ffH,0f3H,0d2H
       DB 0cdH,0cH,13H,0ecH,5fH,97H,44H,17H,0c4H,0a7H,7eH,3dH,64H,5dH,19H,73H
       DB 60H,81H,4fH,0dcH,22H,2aH,90H,88H,46H,0eeH,0b8H,14H,0deH,5eH,0bH,0dbH
       DB 0e0H,32H,3aH,0aH,49H,06H,24H,5cH,0c2H,0d3H,0acH,62H,91H,95H,0e4H,79H
       DB 0e7H,0c8H,37H,6dH,8dH,0d5H,4eH,0a9H,6cH,56H,0f4H,0eaH,65H,7aH,0aeH,08H
       DB 0baH,78H,25H,2eH,1cH,0a6H,0b4H,0c6H,0e8H,0ddH,74H,1fH,4bH,0bdH,8bH,8aH
       DB 70H,3eH,0b5H,66H,48H,03H,0f6H,0eH,61H,35H,57H,0b9H,86H,0c1H,1dH,9eH
       DB 0e1H,0f8H,98H,11H,69H,0d9H,8eH,94H,9bH,1eH,87H,0e9H,0ceH,55H,28H,0dfH
       DB 8cH,0a1H,89H,0dH,0bfH,0e6H,42H,68H,41H,99H,2dH,0fH,0b0H,54H,0bbH,16H

;state db 4h, 0e0h, 48h, 28h, 66h, 0cbh, 0f8h, 06h, 81h, 19h, 0d3h, 26h, 0e5h, 9ah, 7ah, 4ch

;test state
state db 32h,88h,31h,0e0h,43h,5ah,31h,37h,0f6h,30h,98h,07h,0a8h,8dh,0a2h,34h
 
;;;;;;;;;;;;;;;;;;;; 

roundKey db 0a0h, 88h, 23h, 2ah, 0fah, 54h, 0a3h, 6ch, 0feh, 2ch, 39h, 76h, 17h, 0b1h, 39h, 05h
arrLen dw 16 
indexAddRound db 0
rowAddRound db -1
colAddRound db -1  
rowLenAddRound db 4
colLenAddRound db 4

;;;;;;;;;;;;;;;;;;;;;
 
indexSubByte db 0

;;;;;;;;;;;;;;;;;;;;;

tempCharShR dw 0

;;;;;;;;;;;;;;;;;;;;;

MULTIPLY DB 02,03,01,01,01,02,03,01,01,01,02,03,03,01,01,02 
MIXPOINTER DB 16 DUP(?)
TOTALMIX DB 0
MIXINNERCOUNTER DB 0
MIXOUTERCOUNTER DB 0
COLUMNDONE DB 0
NUMCOLUMN DW 0

.stack 64 
.code

; Helper macro to give it i, j and it transforms it into single coordinate.

CONVERT MACRO i, j, ans, localColumnLength 
    mov al, localColumnLength
    mov ah, i
    mul ah
    add al, j 
    mov ans, al  
endm

ADDROUNDKEY macro sArr, rkArr, localRowLength, localColumnLength
    
    local outerL, innerL, endMacro ; declare outerL and innerL lables as local
    
    ; CX will hold the offset of the sArr, DX will hold the offset of the rkArr
    mov si, offset sArr
    mov di, offset rkArr
    ;mov col, -1
    outerL:
        inc colAddRound
        mov bl, colAddRound
        cmp bl, localColumnLength
        jz endMacro
        
        
        mov rowAddRound, -1
        innerL:
            inc rowAddRound
            mov bh, rowAddRound
            cmp bh, localRowLength
            jz outerL
            
            CONVERT rowAddRound, colAddRound, indexAddRound, rowLenAddRound, colLenAddRound
            ; beginning xor operation
            mov bl, indexAddRound                                          
            mov bh, 0                                              
            mov al, [si][bx] ; taking value from sArr[row][column] mov [si][index], al
            xor al, [di][bx] ; taking value from rkArr[row][column]
            mov [si][bx], al; store the value into sArr[row][column]
            jmp innerL    
                
endMacro:
        ;reset important variables at the end
        mov indexAddRound, 0
        mov rowAddRound, -1
        mov colAddRound, -1
        endm 
    
    
SUBBYTES macro st ; takes the state array but the s_box has to be global variable    
    
    local loop1
    
    mov cx ,16
    Mov si, 0
    mov bp, offset st
    loop1:      
        ;by doing bitmasking the lower bit "column" will be in the dl, dh will hold "row"
        mov al, 0fh
        and al, [bp][si]
        mov dl, al  
        mov al, 0f0h
        and al, [bp][si]
        mov dh, al
        shr dh, 4
        
        CONVERT dh, dl, indexSubByte, 16 
        
        mov bl, indexSubByte
        mov bh, 0
        mov ah, s_box[bx]
        mov [bp][si], ah
        mov ax, 0
        inc si
        loop loop1
    ;reset important variables at the end
    mov indexSubByte, 0    
        
endm

   
SHIFtROWS MACRO shRarr
    local LoopBig, LoopSmall, EN
    mov cx, 04h
    mov si, offset shRarr
LoopBig:
    mov tempCharShR, 04h
    mov bx, tempCharShR
    sub bx, cx
    mov tempCharShR, bx
    shl bx, 2  ; shifting by 2 instead of 3 for bytes
    cmp tempCharShR, 0h
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

    dec tempCharShR
    cmp tempCharShR, 0
    jnz LoopSmall

    mov bx, tempCharShR
    cmp bx, 0h
    je EN
EN:
    dec cx
    jnz LoopBig 
    
    ;reset important variables at the end
    mov tempCharShR, 0
    
ENDM
  
  
   
main proc
    
    mov ax, @data
    mov ds, ax 
    xor ax, ax
   
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    SUBBYTES state
                                                            
    SHIFTROWS state
    
    call MixColumns 
                   
    ADDROUNDKEY state, roundKey, rowLenAddRound, colLenAddRound 
                              
    SUBBYTES state
    
    SHIFTROWS state         
    
    call MixColumns 
    
    ADDROUNDKEY state, roundKey, rowLenAddRound, colLenAddRound 
                                 
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    mov ah, 4ch
    int 21h
    ret
main endp
ret



MixColumns PROC;MACRO P1,P2,P3
    ;LOCAL OUTERMIX,INNERMIX,ITSNOT1,NUMBER3,ENDMACRO,NEXTCOLUMN,THEREISNOSHIFT1,THEREISNOSHIFT2
    PUSHA
    MOV AX,0
    MOV BX,0
    MOV DX,0
    MOV BP,0
    MOV CX,0
    MOV DI,0           
    mov si,OFFSET state
    mov di,OFFSET MULTIPLY
    mov bp,OFFSET MIXPOINTER
   OUTERMIX:
   INNERMIX: ;inner loop for each row and column of 4 times
        CMP [DI],3
        JZ NUMBER3
        CMP [DI],1
        JNZ ITSNOT1
        MOV AL,[SI]
        XOR TOTALMIX,AL
        MOV AX,0
        ADD SI,4
        ADD DI,1
        INC MIXINNERCOUNTER
        CMP MIXINNERCOUNTER,4
        JNZ INNERMIX
        JZ ENDMACRO
        
   ITSNOT1:
        MOV AL,[SI]
        TEST AL,080H
        MUL [DI]
        MOV BL,AL
        JZ THEREISNOSHIFT1
        XOR BL,01BH        
        THEREISNOSHIFT1:
        XOR TOTALMIX,BL
        MOV AX,0
        ADD SI,4
        ADD DI,1 
        INC MIXINNERCOUNTER
        CMP MIXINNERCOUNTER,4
        JNZ INNERMIX
        JZ ENDMACRO
        
        
   NUMBER3:
        MOV AL,[SI]
        TEST AL,080H
        MOV AL,2
        MUL [SI]
        MOV BL,AL
        JZ THEREISNOSHIFT2
        XOR BL,01BH               
        THEREISNOSHIFT2:             
        MOV AX,0                                                                      
        MOV AL,BL
        XOR AL,[SI]
        XOR TOTALMIX,AL
        MOV AX,0
        ADD SI,4
        ADD DI,1
        INC MIXINNERCOUNTER
        CMP MIXINNERCOUNTER,4
        JNZ INNERMIX
        JZ ENDMACRO
         
    
    
    
   ENDMACRO:
        INC MIXOUTERCOUNTER
        MOV MIXINNERCOUNTER,0
        MOV AL,TOTALMIX 
        INC COLUMNDONE
        MOV [BP],AL
        MOV TOTALMIX,0
        CMP COLUMNDONE,4
        JZ NEXTCOLUMN
        ADD BP,4
        MOV AX,0
        MOV SI,OFFSET state
        ADD SI,NUMCOLUMN
        CMP MIXOUTERCOUNTER,16;HERE
        JZ ENDALL           
        JNZ INNERMIX 
        
   NEXTCOLUMN:
        INC NUMCOLUMN
        MOV COLUMNDONE,0 
        MOV BP,OFFSET MIXPOINTER
        ADD BP,NUMCOLUMN
        MOV SI,OFFSET state
        ADD SI,NUMCOLUMN
        MOV DI,OFFSET MULTIPLY
        CMP MIXOUTERCOUNTER,16;HERE
        JZ ENDALL
        JNZ INNERMIX            
        
        
        
        ENDALL:
        MOV AX,0
        MOV CX,16
        MOV BP,OFFSET state
        MOV DI,OFFSET MIXPOINTER
        MOVETOORIGIN:
        MOV AL,[DI]
        MOV [BP],AL
        INC BP
        INC DI
        LOOP MOVETOORIGIN
        
        POPA
        
        ;reset important variables at the end
        mov TOTALMIX, 0
        mov MIXINNERCOUNTER ,0
        mov MIXOUTERCOUNTER, 0
        mov COLUMNDONE, 0
        mov NUMCOLUMN, 0
        
    RET    
ENDP 
   