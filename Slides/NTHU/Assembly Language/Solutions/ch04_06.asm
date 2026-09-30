TITLE  Chapter 4 Exercise 6                (ch04_06.asm)

Comment !
Description: Write a program that uses a loop to calculate the first
seven values in the Fibonacci number sequence { 1,1,2,3,5,8,13 }.
Place each value in the EAX register and display it with a
call DumpRegs statement inside the loop.

Last update: 05/02/2002
!
INCLUDE Irvine32.inc

.code
main PROC
	mov   eax,1
	call  DumpRegs
	mov   ebx,0	; initial setup
	mov   edx,1
    mov   ecx,6	; count
L1:
	mov  eax,ebx	; eax = ebx + edx
	add  eax,edx
	call DumpRegs	; display eax
	mov  ebx,edx
	mov  edx,eax
    Loop L1

	exit
main ENDP
END main