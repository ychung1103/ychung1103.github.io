TITLE Chapter 5 Exercise 8              (ch05_08.asm)

Comment !
Description: Write a program that displays a single character
in all possible combinations of foreground and background colors
(16 x16 = 256). The colors are numbered from 0 to 15, so you can
use a nested loop to generate all possible combinations.

Implementation note: Changing the background color is awkward
because we cannot use the boolean operations from Chapters 6
and 7. Instead, we have to use addition and subtraction.

Last update: 05/02/2002
!

INCLUDE Irvine32.inc

CHAR_VALUE = 'X'
.data

.code
main PROC
	call Clrscr
	mov  eax,0

	mov  ecx,16
L1:	push ecx	; vary the background colors

	mov  ecx,16
L2:	call SetTextColor	; vary the foreground colors
	push eax
	mov  al,CHAR_VALUE
	call WriteChar
	pop  eax

	inc  al	; next foreground color
	loop L2

	sub  al,16	; reset foreground color to zero
	add  al,16	; select next background color
	call Crlf

	pop  ecx
	loop L1

	mov  eax,7
	call SetTextColor

	exit
main ENDP
END main