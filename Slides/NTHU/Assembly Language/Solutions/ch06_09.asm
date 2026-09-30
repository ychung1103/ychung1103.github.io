TITLE Chapter 6 Exercise 9              (ch06_09.asm)

Comment !
Description: Write a program that randomly chooses between three
different colors for displaying text on the screen. Use a loop to
display twenty lines of text, each with a randomly chosen color.
The probabilities for each color are to be as follows: white = 30%,
blue = 10%, green = 60%. Hint: generate a random integer between
0 and 9. If the resulting integer is in the range 0-2, choose white.
If the integer equals 3, choose blue. If the integer is in the
range 4-9, choose green.

Difficulty level: 2/5
Last update: 05/10/02
!
INCLUDE Irvine32.inc

.data
msg BYTE "Line of text with randomly chosen color",0

.code
main PROC

	call ClrScr
	call Randomize	; seed the random number generator

	mov edx, OFFSET msg	; line of text
	mov ecx, 20	; counter (lines of text)

L1:	call ChooseColor
	call SetTextColor
	call WriteString	; display line of text
	call Crlf
	loop L1

	exit

main ENDP

;------------------------------------------------
ChooseColor PROC
;
; Selects a color with the following probabilities:
; white = 30%, blue = 10%, green = 60%.
; Receives: nothing
; Returns: EAX = color chosen
;-----------------------------------------------

	mov eax, 10	; range of random numbers (0-9)
	call RandomRange	; EAX = Random number
	.IF eax >= 4	; if number is 4-9 (60%)
	  mov eax, green	; choose green
	.ELSEIF eax == 3	; if number is 3 (10%)
	  mov eax, blue	; choose blue
	.ELSE	; number is 0-2 (30%)
	  mov eax, white	; choose white
	.ENDIF

	ret

ChooseColor ENDP

END main