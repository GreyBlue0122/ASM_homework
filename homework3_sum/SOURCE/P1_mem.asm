.model small
.stack 64
.data
result DB 5 DUP('$') 
.code
MAIN PROC FAR

	;	初始化内存地址
	MOV AX, @data
    MOV DS, AX
    
	MOV CX,100
	MOV AX,0
	
	;	这里算完后AX放数结果5050
	SUMLOOP:
		ADD AX,CX
	LOOP SUMLOOP
	
	
	MOV CX,0
	;	这里做除法时，8086貌似默认了被除数是32位，为dx:ax;除数为16位（div 指令来指定除数寄存器）除完后dx放余数，ax放商
	;	采用数据段内存来存放结果字符串
	
	MOV BX,10	;	放除数10
	LEA DI, result + 4  ;	初始放在末端
	DIVLOOP:
	MOV DX,0	;	被除数高16位清零
	DIV BX		
	ADD DL,'0'	;	ASCII偏移：从char_num =  '0' + int_num (int_num = 0,1,2...9)
	DEC DI              ; 指针往前挪
    MOV [DI], DL 
    INC CX
	CMP AX,0
	JNE DIVLOOP
	JMP PRINT

	;	反向打印:一次性打印即可
	PRINT:
	MOV AH,09H
	MOV DX, DI
	INT 21H
	
	MOV AX, 4C00H
    INT 21H

MAIN ENDP
END MAIN


	
	
	
	