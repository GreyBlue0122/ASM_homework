;	为Turbo C 编译器的固定开头
	ifndef	??version
;	调试器的宏
?debug	macro
	endm
	endif
	?debug	S "..\source\p3.c"
;	将代码段，数据段组合成组，以便于寻址
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
	?debug	C E9ED5E575D0E2E2E5C736F757263655C70332E63
	?debug	C E900101D1107737464696F2E68
	?debug	C E900101D11087374646172672E68
_BSS	ends
_TEXT	segment	byte public 'CODE'




;	int main()
_main	proc	near
;	定义sum,i(i存在si,sum存在di)
	push	si
	push	di
;	sum = 0
	xor	di,di
;	进入循环体
;	i = 0
	xor	si,si
	jmp	short @5
@4:
;	sum += i
	add	di,si
@3:
;	i++
	inc	si
@5:
;	i <= 100? 
	cmp	si,100
	jle	@4
@2:
;	printf("%d",sum)
;	将%d对应变量内容压栈
	push	di
;	将待打印的内容的字符串首地址地址压入栈中
	mov	ax,offset DGROUP:s@
	push	ax
;	系统调用：_printf
	call	near ptr _printf
;	弹出printf的栈中的参数（两个）
	pop	cx
	pop	cx
@1:
;	弹出main函数中的参数：sum,i
	pop	di
	pop	si
	ret	
_main	endp
_TEXT	ends
	?debug	C E9
_DATA	segment word public 'DATA'
s@	label	byte
	db	37
	db	100
	db	0
_DATA	ends
_TEXT	segment	byte public 'CODE'
	extrn	_printf:near
_TEXT	ends
	public	_main
	end
