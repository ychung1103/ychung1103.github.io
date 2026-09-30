TITLE Chapter 5 Exercise 4              (ch05_04.asm)

Comment !
Description: Use the solution program from the preceding
exercise as a starting point. Let this new program
repeat the same steps three times, using a loop. Clear
the screen after each loop iteration.

Last update: 05/02/2002
!

INCLUDE Irvine32.inc

COUNT = 3

.data
val1 SDWORD ?
val2 SDWORD ?
str1 BYTE "Enter an integer: ",0
str2 BYTE "The sum is:       ",0

sum  SDWORD 0
row  BYTE 8
col  BYTE 20

.code
main PROC
	call ClrScr

	mov  ecx,count
	mov  sum,0

; Input multiple integers, using a loop
L1:	mov  dh,row
	mov  dl,col
	call Gotoxy
	mov  edx,OFFSET str1
	call WriteString
	call ReadInt
	add  sum,eax		; add integer to sum
	add  row,2
	loop L1

; Display the sum
	mov  dh,row
	mov  dl,col
	call Gotoxy
	mov  edx,OFFSET str2
	call WriteString
	mov  eax,sum
	call WriteInt
	call Crlf
	call Crlf

	exit
main ENDP
END main