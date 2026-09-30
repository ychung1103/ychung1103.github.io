TITLE  Chapter 4 Exercise 5                (ch04_05.asm)

Comment !
Description: Write instructions that use direct-offset
addressing to move the four values in Uarray to the
EAX, EBX, ECX, and EDX registers. When you follow this
with a call DumpRegs statement, the following register
values should display:

	EAX=00001000 EBX=00002000 ECX=00003000 EDX=00004000

Next, write instructions that use direct-offset addressing
to move the four values in Sarray to the EAX, EBX, ECX, and EDX
registers. When you follow this with a call DumpRegs statement,
the following register values should display:

	EAX=FFFFFFFF EBX=FFFFFFFE ECX=FFFFFFFD EDX=FFFFFFFC

Last update: 05/02/2002
!

INCLUDE Irvine32.inc

.data
Uarray WORD 1000h,2000h,3000h,4000h
Sarray SWORD -1,-2,-3,-4

.code
main PROC

; Move with zero extension:
	movzx eax,Uarray
	movzx ebx,Uarray+2
	movzx ecx,Uarray+4
	movzx edx,Uarray+6
	call DumpRegs

; Move with sign extension:
	movsx eax,Sarray
	movsx ebx,Sarray+2
	movsx ecx,Sarray+4
	movsx edx,Sarray+6
	call DumpRegs

	exit
main ENDP
END main