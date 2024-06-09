.data
    
    x db 5
    y db 20
    res dw 0
    
.code
    
    
    CALL main
    
    
    main proc
             
        CALL ADD_X_Y
        
        ret
        endp
    
    
    
    ADD_X_Y proc
        
        mov ax, 0
        add al, x
        add byte ptr res, al
        add ah, y
        add byte ptr res, ah
       
    end