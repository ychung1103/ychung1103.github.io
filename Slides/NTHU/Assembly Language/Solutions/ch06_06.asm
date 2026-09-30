TITLE Chapter 6 Exercise 6              (ch06_06.asm)

Comment !
Description: Using the solution program from the
preceding exercise as a starting point, write a
complete program that does the following:

1. Input gradeAverage and credits from the user. If the
   user enters zero for either value, halt the program.

2. Perform range checking on both credits and GradeAverage.
   The latter must be between 1 and 400. If either value
   is out of range, display an appropriate error message.
   (Note: the book says 0 to 400, but 1 to 400 is more logical.)

3. Determine whether or not the person can register (using
   the existing example) and display an appropriate message.

4. Repeat steps 1 through 3 until the user decides to quit.

Last update: 05/03/2002
!
INCLUDE Irvine32.inc

TRUE  = 1
FALSE = 0

.data
gradeAverage  SDWORD ?
credits       DWORD ?
OkToRegister  BYTE ?
str1 BYTE "Error: Credits must be between 1 and 30",0dh,0ah,0
str2 BYTE "Input the grade average (0 to quit): ",0
str3 BYTE "Input credits (0 to quit): ",0
str4 BYTE "Error: Grade average must be between 1 and 400",0dh,0ah,0
str5 BYTE "The student can register",0dh,0ah,0
str6 BYTE "The student cannot register",0dh,0ah,0

.code
main PROC

L1:	call InputAverageAndCredits
	jz   ExitMain		; exit if ZF = 1
	call CheckInputRanges
	jc   L3		; errors: try again
	call CheckRegistration

; Indicate whether or not the student can register
	.IF OkToRegister == TRUE
	  mov edx,OFFSET str5
	.ELSE
	  mov edx,OFFSET str6
	.ENDIF
	call WriteString

L3:	call Crlf
	jmp  L1	; input more values

ExitMain:
	exit
main ENDP

;-----------------------------------------------
InputAverageAndCredits PROC
;
; Inputs grade average and credits from the user.
; Receives: nothing
; Returns:  If ZF=0, the procedure sets the
;   values of two variables: gradeAverage and credits.
; If ZF=1, the user wants to quit and no values are
; set.
;-----------------------------------------------
	pushad

; input the grade average
	mov  edx,OFFSET str2
	call WriteString
	call ReadInt
	cmp  eax,0		; user wants to quit?
	je   Exit_proc		; if so, exit now
	mov  gradeAverage,eax		; else set grade average
	call Crlf

; input the number of credits
	mov  edx,OFFSET str3
	call WriteString
	call ReadInt
	cmp  eax,0		; user wants to quit?
	je   Exit_proc		; if so, exit now
	mov  credits,eax		; else set credits
	call Crlf

Exit_proc:
	popad
	ret
InputAverageAndCredits ENDP

;-----------------------------------------------
CheckInputRanges PROC
;
; Displays an error message and sets the Carry
; flag if credits are not in the range 1-30.
; Displays an error message and sets the Carry
; flag if gradeAverage is not in the range 1-400.
; Appropriate error messages are displayed.
;-----------------------------------------------
.data
errCount DWORD ?
.code
	push edx
	mov errCount,0

	.IF credits < 1 || credits > 30
	  mov edx,OFFSET str1
	  call WriteString
	  inc  errCount
	.ENDIF

	.IF gradeAverage < 1 || gradeAverage > 400
	  mov edx,OFFSET str4
	  call WriteString
	  inc  errCount
	.ENDIF

; Use the Carry flag to return False
	.IF errCount > 0
	  stc
	.ELSE
	  clc
	.ENDIF

	pop edx
	ret
CheckInputRanges ENDP

;-----------------------------------------------
CheckRegistration PROC
;
; Evaluates the gradeAverage and number of
; credits, and sets the value of OkToRegister.
; Requirement: cannot use .IF directive.
; Receives: nothing
; Returns: sets boolean value of OkToRegister
;-----------------------------------------------
	push edx
	mov OkToRegister,FALSE

; Evaluate gradeAverage and credits, using the logic
; found in Section 6.7.2.2
L1:	cmp gradeAverage,350	; if gradeAverage > 350
	jng L2
	mov OkToRegister,TRUE	; OkToRegister = TRUE
	jmp L4

L2:	cmp gradeAverage,250	; elseif gradeAverage > 250
	jng L3
	cmp credits,16	;   && credits <= 16
	jnbe L3
	mov OkToRegister,TRUE	; OKToRegister = TRUE
	jmp L4

L3:	cmp credits,12	; elseif credits <= 12
	ja  L4
	mov OkToRegister,TRUE	; OKToRegister = TRUE

L4:	pop edx
	ret
CheckRegistration ENDP

END main