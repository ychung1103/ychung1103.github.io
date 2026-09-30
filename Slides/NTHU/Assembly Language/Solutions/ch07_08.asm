TITLE Chapter 7 Exercise 8              (ch07_08.asm)

Comment !
Description: Write a procedure named PackedToAsc that converts a
4-byte packed decimal number to a string of ASCII decimal digits.
Pass the packed number to the procedure in EAX, and pass a pointer
to a buffer that will hold the ASCII digits. Write a short test
program that demonstrates several conversions and displays the
converted numbers on the screen.

Last update: 05/08/2002
!

INCLUDE Irvine32.inc

.data
numbers DWORD 87654321h, 45346894h, 00193492h
buffer BYTE 9 DUP(0)	; 8 digits plus null character

.code
main PROC

	mov esi, OFFSET numbers
	mov ecx, LENGTHOF numbers	; counter
L1:
	mov eax, [esi]	; packed decimal number
	mov edx, OFFSET buffer	; pointer to buffer
	call PackedToAsc	; convert to ASCII digits
	call WriteString	; display string of digits
	call Crlf

	add esi, TYPE numbers	; next number
	loop L1

	exit

main ENDP

;----------------------------------------------------------------
PackedToAsc PROC
;
; procedure that converts a 4-byte packed decimal number 
; to a string of ASCII decimal digits
; Receives: EAX = packed decimal number
; Returns: String of ASCII digits in buffer pointed by EDX
;------------------------------------------------------------------

	pushad	; save general registers to stack

	mov ecx, 8	; 8 decimals digits (2 digits per byte)
L1:
	mov ebx, eax	; make a copy of number
	and ebx, 0F0000000h	; keep 4 highest bits (one decimal digit)
	rol ebx, 4	; move to the lower 4 positions
	or  bl, 30h	; convert digit to ASCII character
	mov [edx], bl	; save to buffer

	inc edx	; next byte in buffer
	shl eax, 4	; discard highest 4 bits (already copied)

	loop L1	; next digit

	popad	; restore registers from stack
	ret

PackedToAsc ENDP

END main