TITLE Chapter 5 Exercise 1            (ch05_01.asm)

Comment !
Description: Write a program that displays a string in four
different colors, using the SetTextColor procedure from the
book's link library. (Any colors may be chosen)

Last update: 05/02/2002
!

INCLUDE Irvine32.inc

.data
str1 BYTE "This line is displayed in color",0

.code
main PROC

	mov  eax, black + (white * 16)	; black on white backgrouund
	mov  ecx,4		; loop counter

L1:	call SetTextColor
	mov  edx,OFFSET str1
	call WriteString
	call Crlf
	add  eax,2		; add 2 to foreground color
	loop L1

	exit
main ENDP
END main