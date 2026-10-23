.model small
.stack 64
.data
.code
MAIN PROC FAR
	MOV CX,100
	MOV AX,0
	
	;	这里算完后AX放数结果5050
	SUMLOOP:
		ADD AX,CX
	LOOP SUMLOOP
	
	
	MOV CX,0
	;	这里做除法时，8086貌似默认了被除数是32位，为dx:ax;除数为16位（div 指令来指定除数寄存器）除完后dx放余数，ax放商
	;	采用栈方法来存放结果字符串
	
	DIVLOOP:
	MOV BX,10	;	放除数10
	MOV DX,0	;	被除数高16位清零
	DIV BX		
	ADD DL,'0'	;	ASCII偏移：从char_num =  '0' + int_num (int_num = 0,1,2...9)
	PUSH DX
    INC CX
	CMP AX,0
	JNE DIVLOOP
	JMP PRINT

	;	反向打印: 循环弹栈（栈FILO使得按弹出顺序即可打印字符串，无需再倒序）
	PRINT:
	POP DX
	MOV AH,02H
	INT 21H
	LOOP PRINT
	
	MOV AX, 4C00H
    INT 21H

MAIN ENDP
END MAIN


	
	
	
	