TITLE Chapter 5 Exercise 3              (ch05_03.asm)

Comment !
Description: Write a program that clears the screen, locates
the cursor near the middle of the screen, prompts the user for
two integers, adds the integers, and displays their sum.

Last update: 05/02/2002
!
INCLUDE Irvine32.inc

.data
val1 SDWORD ?
val2 SDWORD ?
str1 BYTE "Enter first integer:  ",0
str2 BYTE "Enter second integer: ",0
str3 BYTE "The sum is:           ",0

.code
main PROC
	call ClrScr

; Input the first integer
	mov  dh,10
	mov  dl,20
	call Gotoxy
	mov  edx,OFFSET str1
	call WriteString
	call ReadInt
	mov  val1,eax

; Input the second integer
	mov  dh,12
	mov  dl,20
	call Gotoxy
	mov  edx,OFFSET str2
	call WriteString
	call ReadInt

	add  eax,val1

; Display the sum
	mov  dh,14
	mov  dl,20
	call Gotoxy
	mov  edx,OFFSET str3
	call WriteString
	call WriteInt
	call Crlf
	call Crlf

	exit
main ENDP
END main