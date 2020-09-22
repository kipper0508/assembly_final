INCLUDE Irvine32.inc

code PROTO,e:WORD,N:WORD
decode PROTO,d:WORD,N:WORD
findN PROTO,aa:WORD,bb:WORD
findkey PROTO,e:WORD,N:WORD
takemod PROTO,q:WORD

main  EQU start@0 ;
.data
	title1   BYTE   "Choose mode(1 for code||2 for decode)",0
	title2   BYTE   "please input a character:",0
	title3   BYTE   "please input code:",0
	title4a   BYTE   "please input p(<100 Prime):",0
	title4b   BYTE   "please input q(<100 Prime):",0
	title4c   BYTE   "N is:",0
	title4d   BYTE   "please input N:",0
	title5   BYTE   "please input key(",0
	title5a   BYTE   "):",0
	title5b   BYTE   "decode key is:",0
	title5c   BYTE   "please input decode key:",0
	key WORD ?
	dekey WORD ?
	Num WORD ?
	R WORD ?
	a WORD ?
	b WORD ?
	char WORD ?
.code
main PROC
	
	choose:
	mov eax,0
	mov edx,0
    mov edx , OFFSET title1
    call WriteString
	call ReadInt
	cmp eax,1
	je L3
	cmp eax,2
	je L4
	jmp L5
	
	L3:
	mov eax,Yellow + (Black SHL 4)       ;####
    call SetTextColor
	mov edx , OFFSET title4a
    call WriteString
	call ReadInt
	mov [a],ax
	mov edx , OFFSET title4b
    call WriteString
	call ReadInt
	mov [b],ax
	invoke findN,[a],[b]
	mov eax,0
	mov eax,Yellow + (Black SHL 4)       ;####
    call SetTextColor
	mov edx , OFFSET title5
    call WriteString
	mov ax,[R]
	call WriteDec
	mov edx , OFFSET title5a
    call WriteString
	mov eax,0
	call ReadInt
	mov [key],ax
	invoke findkey,[key],[R]
	mov eax,Yellow + (Black SHL 4)       ;####
    call SetTextColor
	mov edx , OFFSET title2
    call WriteString
	mov eax,0
	mov edx,0
	call ReadChar
	mov ah,0
	mov [char],ax
	call WriteChar
	call Crlf 
	mov eax,White + (Black SHL 4)       ;設回原本設定
    call SetTextColor
	mov eax,0
	mov ax,[char]
	invoke code,[key],[Num]
	call WriteDec
	call Crlf
	jmp L5
	
	L4:
	mov edx , OFFSET title4d
    call WriteString
	call ReadInt
	mov [Num],ax
	mov eax,0
	mov edx , OFFSET title5c
    call WriteString
	call ReadInt
	mov [key],ax
	mov edx , OFFSET title3
    call WriteString
	mov eax,0
	mov edx,0
	call ReadInt
	invoke decode,[key],[Num]
	call WriteChar
	call Crlf
	
	L5:
		jmp choose
main ENDP

takemod PROC,
	q:WORD
	
	push bx
	mov bx,q
	div bx
	mov ax,dx
	
	pop bx
Exit_proc:
	ret
takemod ENDP

findN PROC,
	aa:WORD,
	bb:WORD
	
	mov eax,0
	mov ebx,0
	mov ax,aa
	mov bx,bb
	sub ax,1
	sub bx,1
	mul bx
	mov [R],ax
	
	mov eax,0
	mov ax,aa
	mov bx,bb
	mul bx
	mov [Num],ax
	mov eax,White + (Black SHL 4)       ;設回原本設定
    call SetTextColor
	mov ax,[Num]
	mov edx , OFFSET title4c
    call WriteString
	call WriteDec
	call Crlf
Exit_proc:
	ret
findN ENDP

findkey PROC,
	e:WORD,
	N:WORD

	mov ecx,0
	mov ebx,0
	mov edx,0

	L6:
		add ecx,1
		mov eax,0
		mov ax,cx
		mov bx,N
		mul ebx
		add eax,1
		mov bx,e
		div ebx
		cmp edx,0
		ja L6
	mov [dekey],ax
	mov eax,White + (Black SHL 4)       ;設回原本設定
    call SetTextColor
	mov edx , OFFSET title5b
    call WriteString
	mov ax,[dekey]
	call WriteDec
	call Crlf
Exit_proc:
	ret
findkey ENDP

code PROC,
	e:WORD,
	N:WORD
	
	mov ecx,0
	mov bx,ax
	mov cx,e
	sub cx,1
L1:
	mul bx
L2:	
	invoke takemod,N
	cmp ax,N
	ja L2

loop L1
	
Exit_proc:
	ret
code ENDP

decode PROC,
	d:WORD,
	N:WORD
	
	mov ecx,0
	mov bx,ax
	mov cx,d
	sub cx,1
L1:
	mul bx
L2:	
	invoke takemod,N
	cmp ax,N
	ja L2
	
loop L1

	
Exit_proc:
	ret
decode ENDP
END main
