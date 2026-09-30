TITLE Chapter 6 Exercise 4                  (ch06_04.asm)

Comment !
Description: Using the solution program from the preceding
exercise as a starting point, add the following features:

 Run in a loop so that multiple test scores can be entered.
 Accumulate a counter of the number of test scores.

Perform range checking on the user's input: display an
error message if the test score is less than 0 or greater
than 100.

Last update: 05/03/2002
!

INCLUDE Irvine32.inc


.data
str1 BYTE "Enter an integer score (0 to quit): ",0
str2 BYTE "The letter grade is:    ",0
str3 BYTE "Error: The score must be between 0 and 100.",0dh,0ah,0
str4 BYTE "Number of valid scores entered was: ",0
scoreCount DWORD 0

.code
main PROC
	call Clrscr

L1:	call ProcessOneScore
	jnz  L1

	mov  edx,OFFSET str4		; "Number of scores..."
	call WriteString
	mov  eax,scoreCount		; show score counter
	call WriteDec
	call Crlf

L2:	exit
main ENDP

;---------------------------------------------------
ProcessOneScore PROC
;
; Input a single test score, convert it to a
; letter grade, and display the grade.
; Receives: nothing
; Returns: ZF=1 if the user wants to quit
;---------------------------------------------------
	pushad

	mov  edx,OFFSET str1	; input score from user
	call WriteString
	call ReadInt
	call Crlf

; The following .IF directive performs an unsigned comparison.
; Fortunately, negative values are all greater than 100, so the
; logic works as desired:
	.IF eax > 100		; score out of range?
	  mov edx,OFFSET str3		; display error message
	  call WriteString
	  jmp quit		; quit this procedure
	.ENDIF

	cmp  eax,0		; was zero entered?
	je   quit		; user wants to quit

	.IF eax >= 90		; multiway selection structure to
	  mov al,'A'		; choose the correct grade letter
	.ELSEIF eax >= 80
	  mov al,'B'
	.ELSEIF eax >= 70
	  mov al,'C'
	.ELSEIF eax >= 60
	  mov al,'D'
	.ELSE
	  mov al,'F'
	.ENDIF

	inc  scoreCount		; add to score counter
	mov edx,OFFSET str2
	call WriteString
	call WriteChar		; display grade letter in AL
	call Crlf

quit:
	popad
	ret
ProcessOneScore ENDP

END main