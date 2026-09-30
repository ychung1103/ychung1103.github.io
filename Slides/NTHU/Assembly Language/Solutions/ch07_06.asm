TITLE Chapter 7 Exercise 6              (ch07_06.asm)

Comment !
Description: The greatest common divisor of two integers is the largest
integer that will evenly divide both integers. The GCD algorithm involves
integer division in a loop, described by the following C++ code:

	int GCD(int x, int y)
	{
	  x = abs(x);            // absolute value
	  y = abs(y);

	  do {
	    int n = x % y;
	    x = y;
	    y = n;
	  } while y > 0;

	  return y;
	}

Implement this function in assembly language and write a test program that
calls the function several times, passing it different values. Display all
results on the screen.

Last update: 05/00/2002
!
INCLUDE Irvine32.inc

.data
array SDWORD -5,-20,18,24,11,7,438,226,13,-26
str1 BYTE "Greatest common divisor is: ",0

.code
main PROC

	mov ecx,LENGTHOF array / 2
	mov esi,OFFSET array

L1:	mov eax,[esi]
	mov ebx,[esi+4]
	call CalcGcd
	mov  edx,OFFSET str1
	call WriteString
	call WriteDec
	call Crlf
	add  esi,TYPE array * 2
	loop L1

	exit
main ENDP

;---------------------------------------------
CalcGcd PROC
;
; Calculate the greatest common divisor, using
; a nonrecursive looping algorithm.
; Receives: eax (integer 1), ebx (integer 2)
; Returns: EAX = Greatest common divisor
;---------------------------------------------
	push ebx
	push edx

; Note that the following does not work, because the assembler
; generates an unsigned jump instruction when comparing EAX to zero:
;  .IF eax < 0
; Instead, we can explicitly set the sign flag:
	or eax,eax
	.IF SIGN?
	  neg eax
	.ENDIF
	or ebx,ebx
	.IF SIGN?
	  neg ebx
	.ENDIF

L1:	mov  edx,0
	div ebx		; divide int1 by int2
	cmp  edx,0		; remainder = 0?
	je   L2		; yes: quit
	mov  eax,ebx		; no: prepare for
	mov  ebx,edx		; next iteration
	jmp  L1

L2:	mov eax,ebx		; EAX = GCD

	pop edx
	pop ebx
	ret
CalcGcd ENDP

END main