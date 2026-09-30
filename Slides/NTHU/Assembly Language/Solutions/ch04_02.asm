TITLE  Chapter 4 Exercise 2              (ch04_02.asm)

Comment !
Description: Write a short program demonstrating that the INC
and DEC instructions do not affect the Carry flag.

Last update: 05/02/2002
!

INCLUDE Irvine32.inc
.data

.code
main PROC

	; INC does not affect the carry flag:
	mov al,254
	add al,1	; AL=255, CF=0
	call DumpRegs
	inc al	; AL=0, CF=0 (unchanged)
	call DumpRegs

	; DEC does not affect the carry flag:
	mov al,1
	sub al,1	; AL=0, CF=0
	call DumpRegs
	dec al	; AL=255, CF=0 (unchanged)
	call DumpRegs

	exit
main ENDP
END main