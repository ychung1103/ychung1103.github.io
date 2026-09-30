TITLE Chapter 7 Exercise 5                           (ch07_05.asm)

Comment !
Description: Write a procedure named FastMultiply that multiplies any
unsigned 32-bit integer by EAX, using only shifting and addition. Pass
the integer to the procedure in the EBX register, and return the product
in the EAX register. Write a short test program that calls the procedure
and displays the product. (We will assume that the product is never
larger than 32 bits.)

Difficulty level:
Last update: 05/10/02
!
INCLUDE Irvine32.inc

.data
op1 DWORD 320
op2 DWORD 200	; op1 * op2 = 64000

.code
main PROC
	call Clrscr

	mov eax, op1
	mov ebx, op2
	call FastMultiply	; op1 * op2
	call WriteDec	; display product
	call Crlf

	exit
main ENDP

;-----------------------------------------------------------------
FastMultiply PROC
;
; Multiplies any unsigned 32-bit integer by EAX, using only
; shifting and addition.
; Receives: EBX = integer to multiply by EAX
; Returns: EAX = product of EBX times EAX
;----------------------------------------------------------------
	push ecx
	push edx
	mov edx, eax	; make a copy of operand1
	mov eax, 0	; clear eax
	mov ecx, 32	; bits in a DWORD

MultiplyLoop:
	dec ecx	; decrement bit counter

	shl edx, 1	; CF = highest bit
	jnc L1	; if CF = 0 don't multiply bit

	push edx	; save operand1

	mov edx, ebx	; make a copy of operand2
	shl edx, cl	; shift operand2 by counter
	add eax, edx	; add partial product to accumulator

	pop edx	; restore operand1

L1:	cmp ecx, 0	; is counter zero?
	jnz MultiplyLoop	; if not, multiply next bit

	pop edx
	pop ecx
	ret
FastMultiply ENDP

END main