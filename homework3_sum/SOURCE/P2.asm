.model small
.stack 64
.data
num DB 5 DUP('$')
.code
MAIN PROC FAR
	
	MOV AX,@data
	MOV DS,AX
	LEA SI, num        
    MOV DI, SI        
      
	MOV CX,0
	MOV AX,0
	
	READ_LOOP:
    MOV AH, 01H		; 从键盘读入一个字符，回显在屏幕上，存入 AL
    INT 21H      
    CMP AL, 0DH         ; 判断是否回车键
    JE PRINT
    MOV [DI],AL
    INC DI
    JMP READ_LOOP
 
	;	打印
	PRINT:
	MOV BYTE PTR [DI], '$'
	MOV AH,09H
	MOV DX,SI
	INT 21H
	
	MOV AX, 4C00H
    INT 21H

MAIN ENDP
END MAIN