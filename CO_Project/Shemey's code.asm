.model small
,stack 100h
.data


Arr
TempC     

.code

Mov cx,04h
LoopBig: TempC = 04h-cx

LoopSmall: jz END
Mov ax,Arr[0+TempC x 04h]
Mov Arr[0+TempC x 04h] , Arr[1+TempC x 04h]
Mov Arr[1+TempC x 04h] , Arr[2+TempC x 04h]
Mov Arr[2+TempC x 04h] , Arr[3+TempC x 04h]

Mov Arr[3+TempC x 04h],ax

Mov bx,TempC
Cmp bx,0h
je END
End: Dec cx
jnz LoopBig  
end