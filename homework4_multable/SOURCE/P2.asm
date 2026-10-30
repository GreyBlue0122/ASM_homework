.model small
.stack 100h
.data
titleword DB 'The 9mul9 table:',0DH,0AH,'$'
exp DB 20 DUP ('$')
.code
MAIN PROC
	MOV AX, @DATA
    MOV DS, AX
    
	LEA DX,titleword
	MOV AH,09H
	INT 21H
	
	MOV CX,9
OUTLOOP:
	;	打印单行信息
	MOV AX,1
INLOOP:
	INC CX
	CMP AX,CX
	JE ENDL
	DEC CX
	PUSH CX
	PUSH AX
	;	打印单元素信息
	CALL ELMP	
	POP AX
	POP CX
	INC AX
	JMP INLOOP
ENDL:	
	;	回车 + 换行
	DEC CX
	MOV DX,0DH
	MOV AH,02H
	INT 21H
	MOV DX,0AH
	MOV AH,02H
	INT 21H
	
LOOP OUTLOOP
	;	回车 + 换行
	MOV DX,0DH
	MOV AH,02H
	INT 21H
	MOV DX,0AH
	MOV AH,02H
	INT 21H

	MOV AX,4C00H
	INT 21H
MAIN ENDP

ELMP PROC

	LEA SI,exp
	MOV DI,SI
	
	MOV BP,SP 
	MOV BX,[BP+4]
	MOV CX,[BP+2]
	
	ADD BX,'0'
	MOV [DI],BL
	INC DI
	MOV BYTE PTR [DI],'*'
	INC DI
	ADD CX,'0'
	MOV [DI],CL
	INC DI
	MOV BYTE PTR [DI],'='
	INC DI
	
	SUB BX,'0'
	SUB CX,'0'
	MOV AX,BX
	MUL CX		;	执行乘法时，输入1固定在AX中，输入2为指令参数，输出在AX中
	;	注意AX中存的结果是<100的两位数，因此要转成二位字符串
	
	MOV CX,0
	
	DIVLOOP:
	MOV BX,10	;	放除数10
	MOV DX,0	;	被除数高16位清零
	DIV BX		
	ADD DL,'0'	;	ASCII偏移：从char_num =  '0' + int_num (int_num = 0,1,2...9)
	PUSH DX
    INC CX
	CMP AX,0
	JNE DIVLOOP
	
	PRINT_NUM_LOOP:
    POP DX              ; 从栈里弹出字符
    MOV [DI], DL        ; 写入缓冲区
    INC DI
    LOOP PRINT_NUM_LOOP
	
	
	MOV CX,2
SPACE:
	;	添加空格(2个)
	MOV BYTE PTR [DI],' '
	INC DI
LOOP SPACE

	MOV BYTE PTR [DI],'$'
	
	MOV AH,09H
	MOV DX,SI
	INT 21H
	RET
	
ELMP ENDP


END MAIN


	
	
	
	