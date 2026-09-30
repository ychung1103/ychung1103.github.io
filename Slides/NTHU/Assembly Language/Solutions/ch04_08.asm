TITLE  Chapter 4 Exercise 8                (ch04_08.asm)

Comment !
Description: Write a program using the LOOP instruction with
indirect addressing that copies a string from source to target,
reversing the character order in the process.

If your program works correctly, you will see the following sequence
of hexadecimal bytes on the screen when the program runs:

	67 6E 69 72 74 73 20 65 63 72 75 6F 73 20 65 68
	74 20 73 69 20 73 69 68 54

Last update: 05/02/2002
!

INCLUDE Irvine32.inc

.data
source  BYTE  "This is the source string",0
target  BYTE  SIZEOF source DUP(0),0

.code
main PROC
; Point ESI to the end of the source string:
	mov  esi,OFFSET target - 2

; Point EDI to the beginning of the target string:
	mov  edi,OFFSET target
	mov  ecx,SIZEOF source - 1	; loop counter
L1:
	mov  al,[esi]		; get a character from source
	mov  [edi],al		; store it in the target
	dec  esi		; move to next character
	inc  edi
	loop L1		; repeat for entire string

	mov  esi,OFFSET target		; offset of variable
	mov  ebx,1		; byte format
	mov  ecx,SIZEOF target-2		; counter
	call DumpMem

	exit
main ENDP
END main