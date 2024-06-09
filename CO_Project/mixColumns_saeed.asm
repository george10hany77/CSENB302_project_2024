MixColumns PROC
    PUSHA
    MOV AX,0
    MOV BX,0
    MOV DX,0
    MOV BP,0
    MOV CX,0
    MOV DI,0           
    mov si,offset ARRAY2
    mov di,offset ARRAY1
    mov bp,offset MIXPOINTER
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
        MOV SI,OFFSET ARRAY2
        ADD SI,NUMCOLUMN
        CMP MIXOUTERCOUNTER,16;HERE
        JZ ENDALL           
        JNZ INNERMIX 
        
        NEXTCOLUMN:
        INC NUMCOLUMN
        MOV COLUMNDONE,0 
        MOV BP,OFFSET MIXPOINTER
        ADD BP,NUMCOLUMN
        MOV SI,OFFSET ARRAY2
        ADD SI,NUMCOLUMN
        MOV DI,OFFSET ARRAY1
        CMP MIXOUTERCOUNTER,16;HERE
        JZ ENDALL
        JNZ INNERMIX            
        
        
        
        ENDALL:
        POPA
    
    RET   
    ENDP