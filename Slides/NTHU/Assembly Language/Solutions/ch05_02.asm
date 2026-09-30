TITLE Chapter 5 Exercise 2              (ch05_02.asm)

Comment !
Description:Write a program that uses a loop to input ten
signed 32-bit integers from the user, stores the integers
in an array, and redisplays the integers.

Last update: 05/02/2002
!
INCLUDE Irvine32.inc
COUNT = 10

.data
str1 BYTE "Input a 32-bit signed integer: ",0
str2 BYTE "Redisplaying the integers: ",0dh,0ah,0
array SDWORD COUNT DUP(?)

.code
main PROC

; Input integers from user

	mov ecx,COUNT
	mov edx,OFFSET str1
	mov esi,OFFSET array

L1:	call WriteString		; display prompt
	call ReadInt		; read int from user
	mov  [esi],eax		; store in array
	add  esi,TYPE array		; next array position
	loop L1

	call Crlf

; Redisplay the integers

	mov edx,OFFSET str2		; "Redisplaying..."
	call WriteString
	mov ecx,COUNT
	mov esi,OFFSET array

L2:	mov  eax,[esi]		; get integer from array
	call WriteInt		; display it
	call Crlf
	add  esi,TYPE array		; next array position
	loop L2

	exit
main ENDP
END main