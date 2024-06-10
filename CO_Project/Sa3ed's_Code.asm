                    ; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

.data
    INPUT db 16 DUP (?) ;THIS WILL BE THE INPUT MESSAGE
    TOTAL db 0 ;A VARIABLE FOR READ NUMBER
    
    
    
    TOTALMIX DB 0 ;A VARIABLE FOR MIXCOLUMN MACRO THAT STORES THE RESULT OF MULTIPLYING EACH ROW AND COLUMN
                  ;IT RESETS EVERYLOOP CYCLE
                  
                  
    MIXOUTERCOUNTER DB 0 ;A VARIABLE FOR MIXCOLUMN MACRO IS INCREMENTED WHEN ONE ROW IN COLUMN FINISHES
    
    ;THIS WAS A TEST ARRAY AS THE ARRAY MULTIPLIED BY
    MULTIPLY DB 02,03,01,01,01,02,03,01,01,01,02,03,03,01,01,02  
             ; 02, 03, 01, 01,
             ; 01, 02, 03, 01,
             ; 01, 01, 02, 03,
             ; 03, 01, 01, 02
    
    ;THIS WAS    TEST ARRAY AS THE INPUT         
    ARRAY2 DB 0D4H,0E0H,0B8H,01EH,0BFH,0B4H,041H,027H,05DH,052H,011H,098H,030H,0AEH,0F1H,0E5H
              ;0D4H 0E0H 0B8H 01EH
              ;0BFH 0B4H 041H 027H
              ;05DH 052H 011H 098H
              ;030H 0AEH 0F1H 0E5H
               
    MIXINNERCOUNTER DB 0 ;to track the row column multiplication that when it reaches 4 it resets and starts
                         ;the next row
                         
    MIXPOINTER DB 16 DUP(?) ; the temporary array to store the output of the mix column function
    COLUMNDONE DB 0         ; checks when the column is done to move to the next column in adding the elements
                            ; to the array
                            
    NUMCOLUMN DW 0          ;the number of the current column
    
    
    
    
    
    
              
    
    ;this was also a test array
    ARRAYTEST2 DB 49h,45h,7fh,77h,0dbh,39h,02h,0deh,87h,53h,0d2h,96h,3bh,89h,0f1h,1ah
    
      
    MULTIPLIER DB 100 ; used for readNumber 
    HEXA DB "0123456789ABCDEF" ;used for print hexa in case of a number bigger than 10 since the compiler reads
                               ;each number individually
        
        
                               
    COUNT DW 0   ;USED IN THE PRINTHEXA PROC FOR THE LOOP 
    
    
    ROWCOUNT DB 0  ;USED IN THE PRINTHEXA TO INDCATE WHEN THE ROW ENDS AND STARTS A NEW ROW
    
    ;ARRAYTEST DB   12,14,15,16,
    ;          DB   17,18,19,20,
    ;          DB   21,22,23,24
    ;OFFSET_ADR1 DW OFFSET ARRAY1
    ;OFFSET_ADR2 DW OFFSET ARRAY2
    ;OFFSET_ADR3 DW OFFSET MIXPOINTER
    
     

.stack 64

.code
    main proc 
        mov ax,@data
        mov DS,ax
        MOV SI,OFFSET ARRAYTEST2
        
        CALL readCharacter
        call PRINTHEXA
        
        ;CALL MixColumns     
        
        ;call readNumber
        
;MixColumns OFFSET ARRAY1, OFFSET ARRAY2, OFFSET MIXPOINTER
        ;CALL PRINTHEXA
        ;call read
        ;CALL PRINTHEXA
        
        
        
        
    ret
    main endp

    

ret

;this method does something special it reads 3 numbers by 3 numbers
;that the first number falls in hundreds and the second falls in tens and then the last falls in ones
readNumber PROC
    pusha
    MOV CX,16
    MOV SI,OFFSET INPUT
    ;OUTER LOOP
    OUTER:
    MOV BL,3
    ;INNER LOOP
    INNER:
    MOV AH,01H
    int 21h
    sub al,'0'
    MUL MULTIPLIER
    ADD TOTAL,al
    MOV AL,MULTIPLIER
    MOV BH,10
    DIV BH
    MOV MULTIPLIER , AL
    DEC BL
    CMP BL,0
    JNZ INNER
    MOV AL,TOTAL
    MOV [SI],AL
    MOV TOTAL,0
    MOV AL,100
    MOV MULTIPLIER,AL
    INC SI 
    LOOP OUTER
    popa
    ret
readNumber ENDP


readCharacter PROC
    pusha
    MOV CX,16
    MOV SI,OFFSET INPUT
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
    



PRINTHEXA PROC 
     pusha
     MOV SI,OFFSET INPUT
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
     ;start: 
     term:
     ;rol dx, 12
     ;mov bl,dl
     ;and bl,0FH
     ;push dx
     ;mov dl,[hexa + bx]
     ;mov ah,02h
     ;int 21H
     ;pop dx 
     ;loop start
    popa
    RET 
    PRINTHEXA ENDP



MixColumns PROC;MACRO P1,P2,P3
    ;LOCAL OUTERMIX,INNERMIX,ITSNOT1,NUMBER3,ENDMACRO,NEXTCOLUMN,THEREISNOSHIFT1,THEREISNOSHIFT2
    PUSHA
    MOV AX,0
    MOV BX,0
    MOV DX,0
    MOV BP,0
    MOV CX,0
    MOV DI,0           
    mov si,OFFSET INPUT
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
        MOV SI,OFFSET INPUT
        ADD SI,NUMCOLUMN
        CMP MIXOUTERCOUNTER,16;HERE
        JZ ENDALL           
        JNZ INNERMIX 
        
   NEXTCOLUMN:
        INC NUMCOLUMN
        MOV COLUMNDONE,0 
        MOV BP,OFFSET MIXPOINTER
        ADD BP,NUMCOLUMN
        MOV SI,OFFSET INPUT
        ADD SI,NUMCOLUMN
        MOV DI,OFFSET MULTIPLY
        CMP MIXOUTERCOUNTER,16;HERE
        JZ ENDALL
        JNZ INNERMIX            
        
        
        
        ENDALL:
        MOV AX,0
        MOV CX,16
        MOV BP,OFFSET INPUT
        MOV DI,OFFSET MIXPOINTER
        MOVETOORIGIN:
        MOV AL,[DI]
        MOV [BP],AL
        INC BP
        INC DI
        LOOP MOVETOORIGIN
        
        POPA
        
    RET    
ENDP