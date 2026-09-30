TITLE Chapter 7 Exercise 7			  (ch07_07.asm)

Comment !
Description: Write a procedure that sets the Zero flag if the 32-bit
integer passed in the EAX register is prime. (A prime number is evenly
divisible by only itself and 1.) Optimize the program's loop to run as
efficiently as possible. Your program should prompt the user for a number
and then display a message indicating whether or not the number is prime.
The program should then ask for another number from the user. Continue
the loop in this fashion until the user enters a prearranged value
such as -1.

Last update: 05/03/2002
!
INCLUDE Irvine32.inc

.data
prompt  BYTE "Enter an integer between 2 and 2,147,483,647, ",0dh,0ah
	    BYTE "	  or enter 0 to quit: ",0
msgPrime BYTE " is prime.",0dh,0ah,0
msgNotPrime BYTE " is not prime.",0dh,0ah,0

.code
main PROC
	call ClrScr

L1: call Crlf
	mov  edx,OFFSET prompt
	call WriteString
	call ReadInt		; read value into EAX
	call Crlf
	cmp  eax,0		; does user want to quit?
	jle  Exit_main		; yes

	call IsPrime		; is EAX prime?
	.IF ZERO?		; yes:
	  mov  edx,OFFSET msgPrime	; display "is prime"
	.ELSE		; no:
	  mov  edx,OFFSET msgNotPrime	; display "is not prime"
	.ENDIF

	call WriteDec		; display the number
	call Writestring		; display the message
	jmp  L1

Exit_main:
	exit
main ENDP

;---------------------------------------------------------
IsPrime PROC
;
; Checks the integer in EAX to see if it is prime. If so,
; returns with ZF = 1; otherwise, clears the Zero flag.
;---------------------------------------------------------
	pusha
	cmp eax,2		; 1 and 2 are special cases
	jbe L3		; both are prime

	mov ecx,eax	   	; get number for loop count
	shr ecx,1		; divide by 2
	mov ebx,2		; first divisor

L1:	call IsDivisible   		; EAX divisble by EBX?
	jz L4		; yes: quit
	inc ebx		; next divisor
	loop L1

L3:	test eax,0		; prime, so set the Zero flag
	jmp L5

L4:	or eax,0		; not prime, so clear the Zero flag
	jmp L5

L5:	popa
	ret
IsPrime ENDP

;------------------------------------------------------
IsDivisible PROC
;
; Sets the Zero flag if EAX is evenly divisible by EBX.
;------------------------------------------------------
	push  eax
	push  edx
	mov   edx,0
	div   ebx	; divide EAX by EBX
	cmp   edx,0	; remainder = 0?
	pop   edx
	pop   eax
	ret
IsDivisible ENDP

END main