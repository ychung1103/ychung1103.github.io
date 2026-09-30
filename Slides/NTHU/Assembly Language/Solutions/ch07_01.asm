TITLE Chapter 7 Exercise 1                        (ch07_01.asm)

Comment !
Description: Modify the Extended_Add procedure in Section 7.5.1
to add two 256-bit (32-byte) integers.

Difficulty level: 3/5
Last update: 05/10/2002
!
INCLUDE Irvine32.inc

.data
; two 256 bit operands, stored in Little Endian order:

; op1: D98709374FDECAA06453DC973294BFE2B457AFD8BC939321A2B2A40674981234h
; op2: 2974BC9397320002E6749332BFE253DCFBC974FDDC97B2A4A010870000234502h

op1 QWORD 0A2B2A40674981234h,0B457AFD8BC939321h,06453DC973294BFE2h,0D98709374FDECAA0h
op2 QWORD 0A010870000234502h,0FBC974FDDC97B2A4h,0E6749332BFE253DCh,02974BC9397320002h

sum DWORD 9 dup(0)
; = 0000000102FBC5CAE710CAA34AC86FC9F27713BFB02124D6992B45C642C32B0674BB5736h

msg BYTE "Sum is: ",0

.code
main PROC

	mov  esi, OFFSET op1	; first operand
	mov  edi, OFFSET op2	; second operand
	mov  ebx, OFFSET sum	; sum
	mov  ecx, 8	; number of doublewords
	call Extended_Add

	mov edx, OFFSET msg	; message to display
	call WriteString

	mov esi, OFFSET sum	; starting address of sum
	add esi, 8 * TYPE sum	; get to the start of last dword in sum
	mov ecx, LENGTH sum	; number of doublewords

L1:	mov eax, [esi]	; get 32 bits of sum
	call WriteHex	; display on the screen
	sub esi, TYPE sum	; previous dword (little endian order)
	loop L1

	call Crlf
	exit

main ENDP

;--------------------------------------------------------
Extended_Add PROC
;
; Calculates the sum of two extended integers that are
; stored as an array of doublewords.
; Receives: ESI and EDI point to the two integers,
; EBX points to a variable that will hold the sum, and
; ECX indicates the number of doublewords to be added.
;--------------------------------------------------------
	pushad
	clc	; clear the Carry flag

L1:	mov eax,[esi]	; get the first integer
	adc eax,[edi]	; add the second integer
	pushfd	; save the Carry flag
	mov [ebx],eax	; store partial sum
	add esi,4	; advance all 3 pointers
	add edi,4
	add ebx,4
	popfd	; restore the Carry flag
	loop L1	; repeat the loop

	adc word ptr [ebx],0	; add any leftover carry
	popad
	ret
Extended_Add ENDP

END main