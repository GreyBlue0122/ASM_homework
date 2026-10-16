.model small
.stack 64
.data
.code
MAIN PROC FAR
	MOV CX,100
	MOV AX,0
	
	;	这里算完后AX放数结果5050，但打印的字符结果需要分放在别的寄存器中（4字节）
	SUMLOOP:
		ADD AX,CX
	LOOP SUMLOOP
	MOV CX,0
	
	;	这里做除法时，8086貌似默认了被除数是32位，为dx:ax;除数为16位（div 指令来指定除数寄存器）除完后dx放余数，ax放商
	;	这里采用的是寄存器放结果的方法，由于可用的寄存器实在有限且像ax,bx,dx寄存器本身就参与除法运算，不能作为存放结果的寄存器，因此需要手动指定5050的四位字符所放位置，因此不采用循环
	MOV BX,10	;	放除数10
	MOV DX,0	;	被除数高16位清零
	DIV BX		
	ADD DL,'0'	;	ASCII偏移：从char_num =  '0' + int_num (int_num = 0,1,2...9)
	MOV Di,DX	;	个位0:放在Di中
	
	MOV DX,0
	DIV BX
	ADD DL,'0'	
	MOV CX,DX	;	十位5:放在CX中
	
	MOV DX,0
	DIV BX
	ADD DL,'0'	
	MOV Si,DX	;	百位0：放在Si中
	
	MOV DX,0
	DIV BX
	ADD DL,'0'	
	MOV BP,DX	;	千位5：放在BP中
		
	;	反向打印: BP -> Si -> CX -> Di
	
	MOV AH,02H
	MOV	DX,BP
	INT 21H
	
	MOV AH,02H
	MOV	DX,Si
	INT 21H
	
	MOV AH,02H
	MOV	DX,CX
	INT 21H
	
	MOV AH,02H
	MOV	DX,Di
	INT 21H
	
	MOV AX, 4C00H
    INT 21H

MAIN ENDP
END MAIN


	
	
	
	