TITLE  Chapter 3 Exercise 1                   (ch03_01.asm)

Comment !
Description: Using the AddSub program from Section 3.2 as a
reference, write a program that subtracts three 16-bit
integers using only registers. Insert a call DumpRegs
statement to display the register values.

Last update: 05/02/2002
!

INCLUDE Irvine32.inc
.code
main PROC

	mov ax,4000h
	mov bx,1000h
	mov cx,1500h

	sub ax,bx
	sub ax,cx
	call DumpRegs

	exit
main ENDP
END main