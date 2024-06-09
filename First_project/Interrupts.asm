.model small
.stack 100h

.data
    char db ' '          ; This variable will store the input character
    msg db 'george hany zarif$'
    rec db 8,?,6 dup(?)   ; Record to store input
    arr db 10 dup(?)       ; Array to store characters
.code
    mov ax, @data
    mov ds, ax
    mov ax, 0
    
    ; Display the msg (if needed)
    ; mov dx, offset msg
    ; mov ah, 09h
    ; int 21h          
    
    ; Read the input (if needed)
    ; mov dx, offset rec   
    ; mov ah, 0Ah
    ; int 21h     
    
    mov di, 0             ; Initialize index to 0
    
l1: 
        mov ah, 01h       ; Function to read a character from input
        int 21h
        mov char, al      ; Store the input character in char
        cmp char, '$'     ; Compare the character with '$'
        jz term           ; If character is '$', jump to term
        mov arr[di], al   ; Store the character in array arr
        inc di            ; Increment index
        jmp l1            ; Repeat the loop
   
term:
    ; Terminate the program
    mov ah, 4Ch
    int 21h
    end