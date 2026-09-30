TITLE Chapter 13 Exercise 4                     (ch13_04.asm)

Comment !
Description: Write a program that uses INT 21h to input lower
case letters from the keyboard and convert them to upper case.
Display only the upper case letters.

Implementation note: The .IF directive is required only if
the user will be entering non-alphabetic characters
(such as digits).

Difficulty level: 1/5
Last update: 05/14/2002
!
INCLUDE Irvine16.inc

ENTER_KEY = 0Dh

.code
main PROC
	mov ax,@data	; may be omitted, because
	mov ds,ax	; program has no variables

L1:	mov  ah,7	; input a character (no echo)
	int  21h	; into AL
	cmp  al,ENTER_KEY	; Enter key pressed?
	je   Exit_prog
	.IF  (AL >= 'a') && (AL <= 'z')	; if a lowercase letter,
	  and al,11011111b		; convert it to upper case
	.ENDIF
	mov  dl,al
	mov  ah,2	; display character in DL
	int  21h
	jmp  L1	; repeat the loop

Exit_prog:
	call Crlf
	exit
main ENDP
END main