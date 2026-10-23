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
	?debug	C E9539D4F5D112E2E5C736F757263655C61736369692E63
	?debug	C E900101D1107737464696F2E68
	?debug	C E900101D11087374646172672E68
_BSS	ends
_TEXT	segment	byte public 'CODE'





;	int main()
_main	proc	near
;	定义栈基址指针bp、栈顶指针sp、分配临时变量i，j的空间（si,di）
	push	bp
	mov	bp,sp
	sub	sp,2
	push	si
	push	di
;	char ch = 'a'
	mov	byte ptr [bp-1],97
;	si 等于 si xor si（也就是0），即外循环初始化i=0
	xor	si,si
;	进入外循环
	jmp	@5
	
;	外循环的循环体
@4:
;	内循环初始化j = 0
	xor	di,di
	jmp	short @9
;	内循环循环体
@8:
;	流分配
	inc	word ptr DGROUP:__streams+16
;	如果缓冲区满了，跳到 @11 调用 __fputc
	jge	@11
;	栈中取ch
	mov	al,byte ptr [bp-1]
;	缓冲区指针后移
	inc	word ptr DGROUP:__streams+26
;	获取当前写位置
	mov	bx,word ptr DGROUP:__streams+26
;	将 ch 写入缓冲区
	mov	byte ptr [bx-1],al
	mov	ah,0
	jmp	short @10
	
;	将缓冲区内容写到屏幕
@11:
;	将待打印的内容的字符串首地址地址压入栈中
	mov	ax,offset DGROUP:__streams+16
	push	ax
;	缓冲区内的字符压栈
	push	word ptr [bp-1]
;	系统调用：__fputc
	call	near ptr __fputc
;	弹出printf的栈中的参数（两个）
	pop	cx
	pop	cx
@10:
	inc	word ptr DGROUP:__streams+16
	jge	@13
;	写空格(32)
	mov	al,32
	inc	word ptr DGROUP:__streams+26
;	获取当前写位置
	mov	bx,word ptr DGROUP:__streams+26
;	空格写入缓冲区
	mov	byte ptr [bx-1],al
	mov	ah,0
	jmp	short @12
;	将缓冲区内容写到屏幕
@13:
;	将待打印的内容的字符串首地址地址压入栈中
	mov	ax,offset DGROUP:__streams+16
	push	ax
;	移动空格并压栈
	mov	al,32
	push	ax
;	系统调用：__fputc	
	call	near ptr __fputc
	pop	cx
	pop	cx

;	ch++
@12:
	inc	byte ptr [bp-1]
;	j++
@7:
	inc	di
;	内循环
@9:
;	判断j < 13？是则跳转到@8
	cmp	di,13
	jl	@8
;	写换行符(10)
@6:
	inc	word ptr DGROUP:__streams+16
	jge	@15
	mov	al,10
	inc	word ptr DGROUP:__streams+26
	mov	bx,word ptr DGROUP:__streams+26
	mov	byte ptr [bx-1],al
	mov	ah,0
	jmp	short @14
;	将缓冲区内容写到屏幕
@15:
	mov	ax,offset DGROUP:__streams+16
	push	ax
	mov	al,10
	push	ax
	call	near ptr __fputc
	pop	cx
	pop	cx
@14:
@3:
	inc	si
;	外循环
@5:
;	i<2？ 是则跳转到@4
	cmp	si,2
	jge	@16
	jmp	@4
@16:
;	return 0（放在ax中）
@2:
	xor	ax,ax
	jmp	short @1
@1:
;	函数上下文还原：di,si,bp
	pop	di
	pop	si
	mov	sp,bp	; 释放局部变量 ch 的空间
	pop	bp
	ret	
_main	endp
_TEXT	ends
	?debug	C E9
_DATA	segment word public 'DATA'
s@	label	byte
_DATA	ends
	extrn	__streams:word
_TEXT	segment	byte public 'CODE'
	extrn	__fputc:near
_TEXT	ends
	public	_main
	end
