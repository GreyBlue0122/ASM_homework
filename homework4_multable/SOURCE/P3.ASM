;	为Turbo C 编译器的固定开头
	ifndef	??version
?debug	macro
	endm
	endif
	?debug	S "..\source\p3.c"
;	将代码段、数据段组合成组，以便于寻址
_TEXT	segment	byte public 'CODE'
DGROUP	group	_DATA,_BSS
	assume	cs:_TEXT,ds:DGROUP,ss:DGROUP
_TEXT	ends
_DATA	segment word public 'DATA'
d@	label	byte
d@w	label	word
_DATA	ends
_BSS	segment word public 'BSS'
b@	label	byte
b@w	label	word
	?debug	C E9145B5E5D0E2E2E5C736F757263655C70332E63
	?debug	C E900101D1107737464696F2E68	; 调试信息：stdio.h
	?debug	C E900101D11087374646172672E68	; 调试信息：stdarg.h
_BSS	ends
_TEXT	segment	byte public 'CODE'


;	int main()
_main	proc	near
	push	si	;	int i
	push	di	;	int j
;	i = 9
	mov	si,9
;	进入外循环主体
	jmp	short @5
@4:
;	j = 1
	mov	di,1
;	进入内循环主体
	jmp	short @9
@8:
;	计算 si * di，并调用 printf("%d  ", si*di)
	mov	ax,si
	mul	di
	push	ax	; 将乘积作为打印字符串的第三个参数压栈
	push	di	; 将j作为打印字符串的第二个参数压栈
	push	si	; 将i作为打印字符串的第一个参数压栈
	mov	ax,offset DGROUP:s@	; 获取格式字符串 "%d  " 的首地址
	push	ax	; 将格式字符串地址压栈
	call	near ptr _printf	; 调用printf
	add	sp,8	; 栈指针上移8字节，相当于把printf的三个参数以及格式字符串地址全部弹出，栈平衡
@7:
;	j++
	inc	di
@9:
;	j <= i?
	cmp	di,si
;	打印单元素信息
	jle	@8
@6:
;	内循环结束，打印行尾信息\n
	mov	ax,offset DGROUP:s@+11	; 获取格式字符串 "%d  " 的首地址
	push	ax	; 将格式字符串地址压栈
	call	near ptr _printf	; 调用printf
	pop	cx	;栈平衡，弹出格式字符串地址
@3:
;	i--
	dec	si
@5:
;	s!=0?
	or	si,si
;	进入内循环
	jne	@4
@2:
@1:
;	恢复 main 函数中保存的寄存器变量
	pop	di
	pop	si
	ret	
_main	endp
_TEXT	ends
	?debug	C E9
_DATA	segment word public 'DATA'
s@	label	byte	;	格式字符串
	db	37	; '%'
	db	100	; 'd'
	db	42	; '*'
	db	37	; '%'
	db	100	; 'd'
	db	61	; '='
	db	37	; '%'
	db	100	; 'd'
	db	32	; ' '
	db	32	; ' '
	db	0	; '\0'
	db	10	; '\n'，s@+11
	db	0	; '\0'
_DATA	ends
_TEXT	segment	byte public 'CODE'
	extrn	_printf:near
_TEXT	ends
	public	_main
	end
