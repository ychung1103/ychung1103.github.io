TITLE  Chapter 4 Exercise 7                (ch04_07.asm)

Comment !
Description: Write a program that implements the following
arithmetic expression:

	EAX = -val2 + 7 - val3 + val1

In comments next to each instruction, write the hexadecimal value
of EAX. Insert a call DumpRegs statement at the end of the program.

Last update: 05/02/2002
!

INCLUDE Irvine32.inc

.data
val1 SDWORD 8
val2 SDWORD -15
val3 SDWORD 20

.code
main PROC

; eax = -val2 + 7 - val3 + val1

	mov eax,val2	; EAX=FFFFFFF1
	neg eax	; EAX=0000000F
	add eax,7	; EAX=00000016
	sub eax,val3	; EAX=00000001
	add eax,val1	; EAX=0000000A
	call DumpRegs

	exit
main ENDP
END main