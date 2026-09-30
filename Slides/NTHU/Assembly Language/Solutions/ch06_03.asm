TITLE Chapter 6 Exercise 3              (ch06_03.asm)

Comment !
Description: Using the following table as a guide,
write a program that asks the user to enter an integer
test score between 0 and 100. The program should
display the appropriate letter grade:

Score Range  Letter Grade
-------------------------
90 to 100        A
80 to  89        B
70 to  79        C
60 to  69        D
 0 to  59        F

Last update: 05/03/2002
!
INCLUDE Irvine32.inc

.data
str1 BYTE "Enter an integer score: ",0
str2 BYTE "The letter grade is:    ",0

.code
main PROC
	call Clrscr
	mov  edx,OFFSET str1	; input score from user
	call WriteString
	call ReadInt
	call Crlf

	.IF eax >= 90	; multiway selection structure to
	  mov al,'A'	; choose the correct grade letter
	.ELSEIF eax >= 80
	  mov al,'B'
	.ELSEIF eax >= 70
	  mov al,'C'
	.ELSEIF eax >= 60
	  mov al,'D'
	.ELSE
	  mov al,'F'
	.ENDIF

	mov edx,OFFSET str2
	call WriteString
	call WriteChar	; display grade letter in AL
	call Crlf

	exit
main ENDP
END main