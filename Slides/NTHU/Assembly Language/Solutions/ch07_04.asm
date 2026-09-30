TITLE Chapter 7 Exercise 4              (ch07_04.asm)

Comment !
Description: Write a procedure that shifts an array of five
32-bit integers using the SHRD instruction (Section 7.2.8).
Write a program that tests your procedure and displays the array.

We will shift a series of consecutive doublewords 4 bits to the right.
We assume that the number is in little Endian order.

Last update: 05/03/2002
!

INCLUDE Irvine32.inc

COUNT = 4	; shift count

.data
array DWORD 648B2165h,8C943A29h,6DFA4B86h,91F76C04h,8BAF9857h

.code
main PROC

	mov  bl,COUNT
	call ShiftDoublewords

; Display the results
	mov esi,OFFSET array
	mov ecx,LENGTHOF array
	mov ebx,TYPE array
	call DumpMem

	exit
main ENDP

;---------------------------------------------------------------
ShiftDoublewords PROC
;
; Shifts an array of doublewords to the right.
; The array is a global variable.
; Receives: BL = number of bits to shift
; Returns: nothing
; Note to instructors: this procedure would be a good candidate
; for a macro, because you can pass the array name, array size,
; and the direction (R or L) as macro parameters.
;---------------------------------------------------------------
	mov  esi,OFFSET array
	mov  ecx,(LENGTHOF array) - 1

L1:	push ecx		; save loop counter
	mov  eax,[esi + TYPE DWORD]
	mov  cl,bl		; shift count
	shrd [esi],eax,cl		; shift EAX into high bits of [esi]
	add  esi,TYPE DWORD		; point to next doubleword pair
	pop  ecx		; restore loop counter
	loop L1

; Right-shift the last doubleword
	shr DWORD PTR [esi],COUNT

	ret
ShiftDoublewords ENDP

END main