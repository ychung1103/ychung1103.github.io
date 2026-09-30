TITLE Chapter 6 Exercise 1              (ch06_01.asm)

Comment !
Description: Using the ArrayScan program in Section 6.3.4.2
as a model, implement the search using the LOOPZ instruction.

Last update: 05/03/2002
!
INCLUDE Irvine32.inc

.data
intArray SWORD 0,0,0,0,1,20,35,-12,66,4,0
noneMsg  BYTE "A non-zero value was not found",0

.code
main PROC
	mov ebx,OFFSET intArray - 2 		; point to the array
	mov ecx,LENGTHOF intArray 	; loop counter

L1:	add ebx,2 		; point to next
	cmp WORD PTR [ebx],0 		; compare value to zero
	loopz L1 		; continue the loop if ZF set
	jz notFound 		; none found

found: 		; display the value
	movsx eax,WORD PTR[ebx]
	call WriteInt
	jmp quit

notFound: 		; display "not found" message
	mov edx,OFFSET noneMsg
	call WriteString

quit:
	call crlf
	exit
main ENDP
END main