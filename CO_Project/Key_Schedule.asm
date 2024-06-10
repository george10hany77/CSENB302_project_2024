org 100h
.data
 
;keyArray db 2bh,28h,0abh,09h,40 dup(7h) ,7eh,0aeh,0f7h,0cfh,40 dup(8h),15h,0d2h,15h,4fh,40 dup(9h),16h,0a6h,088h,3ch, 40 dup(10h)
keyArray db 2bh,28h,0abh,09h,4 dup(7h) ,7eh,0aeh,0f7h,0cfh,4 dup(8h),15h,0d2h,15h,4fh,4 dup(9h),16h,0a6h,088h,3ch, 4 dup(10h)

roundKey db 16 dup(0)
 
test0 db 4 dup(0)
test1 db 4 dup(0)
test2 db 4 dup(0) 

roundNum db 0

roundConstant db 01h,02h,04h,08h,10h,20h,40h,80h,1bh,36h, 30 dup (0)  

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
 
 
 
.stack 256
.code   
  
  

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

CONVERT MACRO i, j, ans, localColumnLength 
    push ax
    mov al, localColumnLength
    mov ah, i
    mul ah
    add al, j 
    mov ans, al
    pop ax  
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

           
           
SUBBYTES macro st, len ; takes the state array but the s_box has to be global variable, 'len' is the lenth of 'st' which is the incomming array    
    pusha
    local loop1
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

    

mov ax, @data
mov ds, ax
xor ax, ax

 
 

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
     
    ; the rcon parameter will be passed via the stack
    call updateRoundKey
    inc roundNum
    call updateRoundKey
    inc roundNum
    call updateRoundKey
  
     
    mov ah, 4ch
    int 21h
    ret
endp

xor3Snippets proc
    XOR2ARRS test0, test1, 4
    XOR2ARRS test0, test2, 4
    ret 
endp
 
 
updateRoundKey proc 
                                               
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
    
    ret 
endp
   
   
   

   
   
   
   
   
end

