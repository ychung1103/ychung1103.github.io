TITLE Chapter 5 Exercise 7              (ch05_07.asm)

Comment !
Description: Write a program that displays a single character
at 100 random screen locations. Optional: use a randomized delay
between characters, between 10 and 300 milliseconds.

Last update: 05/02/2002
!

INCLUDE Irvine32.inc

CHAR_VAL = 'A'
COUNT = 100

.data


.code
main PROC
	call Clrscr
	mov  ecx,COUNT	; character count

L1:	mov  eax,25	; random row (0..24)
	call RandomRange
	mov  dh,al
	mov  eax,80	; random column (0..79)
	call RandomRange
	mov  dl,al
	call Gotoxy	; locate cursor
	mov  al,CHAR_VAL	; display the character
	call WriteChar
	call RandomDelay	; optional: create a delay
	loop L1	; next character

	mov dx,0	; move cursor to 0,0
	call Gotoxy

	exit
main ENDP

;----------------------------------------------------------
RandomDelay PROC
;
; OPTIONAL:
; Pause the program for a randomly-chosen length of time.
; Receives: nothing
; Returns: nothing
;----------------------------------------------------------
	push eax

	mov  eax,291
	call RandomRange	; generate random integer (0..290)
	add  eax,10	; scale range to (10..300)
	call Delay	; pause the program (EAX = milliseconds)

	pop  eax
	ret
RandomDelay ENDP


END main