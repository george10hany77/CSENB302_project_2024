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

;test state  ; INPUT_MSG
state db 32h,88h,31h,0e0h,43h,5ah,31h,37h,0f6h,30h,98h,07h,0a8h,8dh,0a2h,34h
 
;;;;;;;;;;;;;;;;;;;; 
             ; INPUT_KEY
roundKey db 2bh, 28h, 0abh, 09h, 7eh, 0aeh, 0f7h, 0cfh, 15h, 0d2h, 15h, 4fh, 16h, 0a6h, 88h, 3ch
arrLen dw 16 
indexAddRound db 0
rowAddRound db -1
colAddRound db -1  
rowLenAddRound db 4
colLenAddRound db 4

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

;;;;;;;;;;;;;;;;;;;;;

HEXA DB "0123456789ABCDEF" ;used for print hexa in case of a number bigger than 10 since the compiler reads
                           ;each number individually
                                       
COUNT DW 0   ;USED IN THE PRINTHEXA PROC FOR THE LOOP 
    
    
ROWCOUNT DB 0  ;USED IN THE PRINTHEXA TO INDCATE WHEN THE ROW ENDS AND STARTS A NEW ROW
      
;;;;;;;;;;;;;;;;;;;;; 


TOTAL db 0 ;A VARIABLE FOR READ NUMBER
MULTIPLIER DB 100 ; used for readNumber    


;;;;;;;;;;;;;;;;;;;;;

test0 db 4 dup(0)
test1 db 4 dup(0)
test2 db 4 dup(0) 

roundNum db 0
  
;keyArray db 2bh,28h,0abh,09h,4 dup(7h) ,7eh,0aeh,0f7h,0cfh,4 dup(8h),15h,0d2h,15h,4fh,4 dup(9h),16h,0a6h,088h,3ch, 4 dup(10h)
keyArray db 32 dup(0)

roundConstant db 01h,02h,04h,08h,10h,20h,40h,80h,1bh,36h, 30 dup (0)  

;;;;;;;;;;;;;;;;;;;;;      
                 
.stack 64 
.code

; Helper macro to give it i, j and it transforms it into single coordinate.

CONVERT MACRO i, j, ans, localColumnLength 
    push ax
    mov al, localColumnLength
    mov ah, i
    mul ah
    add al, j 
    mov ans, al
    pop ax  
endm 

ADDROUNDKEY macro sArr, rkArr, localRowLength, localColumnLength
    
    local outerL, innerL, endMacro ; declare outerL and innerL lables as local
    pusha
    ; CX will hold the offset of the sArr, DX will hold the offset of the rkArr
    mov si, offset sArr
    mov di, offset rkArr
    ;mov colAddRound, -1
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
        popa
        endm 
    
    
SUBBYTES macro st, len ; takes the state array but the s_box has to be global variable, 'len' is the lenth of 'st' which is the incomming array    
    local loop1
    pusha
    mov cx ,len
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
        push cx
        
        CONVERT dh, dl, cl, 16  ; 16 is the width of the sBox
        
        mov bl, cl
        mov bh, 0
        mov ah, s_box[bx]
        mov [bp][si], ah
        mov ax, 0
        inc si
        pop cx
        loop loop1  
popa        
endm

   
SHIFtROWS MACRO shRarr
    local LoopBig, LoopSmall, EN 
    pusha
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
    popa
    
ENDM

ROTWORD macro key 
    pusha
    mov si, offset key    
    
    ; al is the temp variable
    
    mov al, [si]
    mov ah, [si+1]     
    mov [si], ah
    mov [si+1], al
       
    mov al, [si+1]
    mov ah, [si+2]     
    mov [si+1], ah
    mov [si+2], al
     
    mov al, [si+2]
    mov ah, [si+3]     
    mov [si+2], ah
    mov [si+3], al
    popa    

endm

;takes a snippet from the provided array and the desired column index and stored in storeArr
VERTICALSNIPPET macro arr, arrLen, colIndexVS, storeArr  ;arr is the key schedule. It will store this snippit in the storeArr
    pusha ; to save all current data inside the registers
    local l1, term 
    mov si, 0 
    mov di, offset arr
    mov bp, offset storeArr
    l1:
        cmp si, 4
        jz term    
        
        mov dx, si 
        mov ch, arrLen
        CONVERT dl, colIndexVS, cl, ch ; arrLen is the width of the whole key schedule
        mov bl, cl
        mov bh, 0 
        mov al, [bx][di]
        
        mov [bp][si], al
        
        inc si
        jmp l1
    term: 
        popa
endm
 

ADDTOKEYSCHEDULE macro addedArr, colIndex ; takes the array with new values of length 4 and the desired column where we want to store the new data in the key schedule
    pusha ; to save all current data inside the registers
    local l1, term 
    mov si, 0 
    mov di, offset addedArr
    
    l1:
        cmp si, 4
        jz term    
        
        mov dx, si
        ;CONVERT dl, colIndex, cl, 44 ; dl contains the looping index of the added array and cl contains the actual index of the keySchedule
        CONVERT dl, colIndex, cl, 8 ; dl contains the looping index of the added array and cl contains the actual index of the keySchedule
        mov ch, 0
        mov bx, cx ; now bx has the actual address
        mov bp, dx ; now bp has the looping index
        mov al, [bp][di]
        mov keyArray[bx], al
        
        
        inc si
        jmp l1
    term: 
        popa
endm 
 

XOR2ARRS macro arr1, arr2, len ; The result will be stored at arr1. The 2 arrays has to have same length
    pusha
    local l1, term
    mov bp, 0
    mov di, offset arr1
    mov si, offset arr2
    l1:
        cmp bp, len
        jz term
        
        mov al, [bp][si]
        xor [bp][di], al
        
        inc bp
        jmp l1
    term:
        popa
endm


COPYKEYSCHEDULETOROUNDKEY macro startIndex
    pusha
    local l1, term, resetIndices, curr
    mov bp, 0
    mov cl, startIndex
    mov ch, 0
    l1:
        cmp bp, 16
        jz term
        mov dh, startIndex
        add dh, 4
        
        cmp cl, dh  
        jz resetIndices
        curr:
        
        ;CONVERT ch, cl, bl, 44  ; cl has column current count + start index, ch has row current count
        CONVERT ch, cl, bl, 8  ; cl has column current count + start index, ch has row current count
       
        inc cl
        mov bh, 0
        
        mov dl, keyArray[bx] 
        mov roundKey[bp], dl
        
        inc bp
        jmp l1
    resetIndices:
        mov cl, startIndex
        inc ch
        jmp curr    
    term:
        popa
endm 


  
RESETKEY macro
    pusha
    local l1, term, resetIndices, curr
    mov bp, 0
    mov cl, 0
    mov ch, 0
    l1:
        cmp bp, 16
        jz term
        
        cmp cl, 4  
        jz resetIndices
        curr:
        
        ;CONVERT ch, cl, bl, 44  ; cl has column current count + start index, ch has row current count
        CONVERT ch, cl, bl, 8  ; cl has column current count + start index, ch has row current count
       
        inc cl
        mov bh, 0
        
        mov dl, roundKey[bp]
        mov keyArray[bx] , dl
        
        inc bp
        jmp l1
    resetIndices:
        mov cl, 0
        inc ch
        jmp curr    
    term:
        popa
endm  
   
main proc
    
    mov ax, @data
    mov ds, ax 
    xor ax, ax
    
    MOV SI,OFFSET state    
    call readCharacter
    call printHexa
    
    mov si, offset roundKey
    call readCharacter
    call printHexa
     
     
    RESETKEY   ; to load the keyArray
    
    ;;;;;;;;;;;;;  FIRST TIME  ;;;;;;;;;;;;;;;
    
    ADDROUNDKEY state, roundKey, rowLenAddRound, colLenAddRound 

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    SUBBYTES state, 16  ; '16' is the length of the state 
                                                            
    SHIFTROWS state
                                                                                         ;1
    call MixColumns 
    
    call updateRoundKey
    inc roundNum
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    ADDROUNDKEY state, roundKey, rowLenAddRound, colLenAddRound
                                  
    SUBBYTES state, 16  ; '16' is the length of the state                                ;2
    
    SHIFTROWS state         
    
    call MixColumns 
    
    call updateRoundKey
    inc roundNum
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    ADDROUNDKEY state, roundKey, rowLenAddRound, colLenAddRound

    SUBBYTES state, 16  ; '16' is the length of the state
    
    SHIFTROWS state         
                                                                                         ;3
    call MixColumns 
    
    call updateRoundKey
    inc roundNum
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   
    ADDROUNDKEY state, roundKey, rowLenAddRound, colLenAddRound
    
    SUBBYTES state, 16  ; '16' is the length of the state
    
    SHIFTROWS state         
    
    call MixColumns 
                                                                                          ;4
    call updateRoundKey
    inc roundNum
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   
   
    ADDROUNDKEY state, roundKey, rowLenAddRound, colLenAddRound
    
    SUBBYTES state, 16  ; '16' is the length of the state
    
    SHIFTROWS state         
                                                                                            ;5
    call MixColumns 
    
    call updateRoundKey
    inc roundNum
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   
    ADDROUNDKEY state, roundKey, rowLenAddRound, colLenAddRound
    
    SUBBYTES state, 16  ; '16' is the length of the state
    
    SHIFTROWS state                                                                           ;6
    
    call MixColumns 
    
    call updateRoundKey
    inc roundNum
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   
   
    ADDROUNDKEY state, roundKey, rowLenAddRound, colLenAddRound
    
    SUBBYTES state, 16  ; '16' is the length of the state
    
    SHIFTROWS state         
    
    call MixColumns                                                                             ;7
    
    call updateRoundKey
    inc roundNum
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   
   
    ADDROUNDKEY state, roundKey, rowLenAddRound, colLenAddRound
    
    SUBBYTES state, 16  ; '16' is the length of the state
    
    SHIFTROWS state         
                                                                                                  ;8
    call MixColumns 
    
    call updateRoundKey
    inc roundNum
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   
   
    ADDROUNDKEY state, roundKey, rowLenAddRound, colLenAddRound
    
    SUBBYTES state, 16  ; '16' is the length of the state
    
    SHIFTROWS state         
    
    call MixColumns 
                                                                                                    ;9
    call updateRoundKey
    inc roundNum
       
    ADDROUNDKEY state, roundKey, rowLenAddRound, colLenAddRound   
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    SUBBYTES state, 16  ; '16' is the length of the state
    
    SHIFTROWS state         
    
    ;call MixColumns 
    
    call updateRoundKey
    inc roundNum                                                                                      ;10
       
    ADDROUNDKEY state, roundKey, rowLenAddRound, colLenAddRound
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    call printHexa
                                 
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






xor3Snippets proc
    XOR2ARRS test0, test1, 4
    XOR2ARRS test0, test2, 4
    ret 
endp
 
 
updateRoundKey proc 
    
    pusha
                                               
    VERTICALSNIPPET keyArray,      8, 0, test0  ; takes a snippet from the provided array and the desired column index and stored in storeArr
                                       
    VERTICALSNIPPET keyArray,      8, 3, test1  ; takes a snippet from the provided array and the desired column index and stored in storeArr
     
    VERTICALSNIPPET roundConstant, 10, roundNum, test2  ; will increase by 1, takes a snippet from the provided array and the desired column index and stored in storeArr
    
    ROTWORD test1
    SUBBYTES test1, 4  ; takes array and its length "vertical length" which is = to its "length"
     
    call xor3Snippets
                            ;round# * 4
    ADDTOKEYSCHEDULE test0, 4 ; add to key schedule the data in tempArrSubKey at column at index 4
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    
    
    VERTICALSNIPPET keyArray, 8, 1, test0       ; takes a snippet from the provided array and the desired column index and stored in storeArr
    
    VERTICALSNIPPET keyArray, 8, 4, test1       ; takes a snippet from the provided array and the desired column index and stored in storeArr
     
    XOR2ARRS test0, test1, 4

    ADDTOKEYSCHEDULE test0, 5 ; add to key schedule the data in tempArrSubKey at column at index ?
    
                    ;;;;;;;;;;;
    VERTICALSNIPPET keyArray, 8, 2, test0       ; takes a snippet from the provided array and the desired column index and stored in storeArr
    
    VERTICALSNIPPET keyArray, 8, 5, test1       ; takes a snippet from the provided array and the desired column index and stored in storeArr
     
    XOR2ARRS test0, test1, 4

    ADDTOKEYSCHEDULE test0, 6 ; add to key schedule the data in tempArrSubKey at column at index ?
    
                    ;;;;;;;;;;;
   
    VERTICALSNIPPET keyArray, 8, 3, test0       ; takes a snippet from the provided array and the desired column index and stored in storeArr
    
    VERTICALSNIPPET keyArray, 8, 6, test1       ; takes a snippet from the provided array and the desired column index and stored in storeArr
     
    XOR2ARRS test0, test1, 4

    ADDTOKEYSCHEDULE test0, 7 ; add to key schedule the data in tempArrSubKey at column at index ?
    
                    ;;;;;;;;;;;
  
    COPYKEYSCHEDULETOROUNDKEY 4 ; Will copy the data stored in the key schedule starting from index 4
     
    RESETKEY 
    
    popa
    
    ret 
endp
   



printHexa PROC
    pusha
    MOV SI,OFFSET state
    MOV DI,16
    START:
    MOV AX,0
    MOV CX,0
    MOV DX,0
    MOV BX,0 
    mov dl,[si]
    rol dx,12
    mov cl,dl
    mov dl,0
    rol dx,4
    mov al,dl
    mov ch,0
    mov bl,cl
    mov dl,[HEXA + bx]
    push ax
    mov ah,02h
    int 21h
    pop ax          
    mov bl,al
    mov dl,[HEXA + bx]
    mov ah,02h
    int 21h
    INC COUNT
    inc ROWCOUNT 
    inc si
    MOV Dx," "
    MOV AH,02H
    INT 21H
    CMP ROWCOUNT,4
    JZ ADDITION
    CMP COUNT,DI
    
    
    
    JNZ START
    
    
    
    JZ term
    ADDITION:MOV Dx,10
    MOV ROWCOUNT,0
    MOV AH,02H
    INT 21h
    MOV DX,13
    MOV AH,02H
    INT 21H
    cmp count,di
    Jnz START 
    term:
        mov COUNT, 0 
        mov ROWCOUNT, 0 
        popa 
        RET 
   printHexa ENDP


readCharacter PROC
    pusha
    MOV CX,16
    MOV SI,OFFSET state
    STARTOfRead:
    MOV AH,01H
    INT 21H
    MOV [SI],AL
    inc si 
    dec cx
    CMP AL,0D
    JZ ENDreadCharacter
    CMP cx,0
    jnz STARTOfRead 
     
     
    EndreadCharacter :
    popa
    RET
readCharacter ENDP
 
      