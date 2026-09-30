TITLE Chapter 10 Exercise 6                          (ch10_06.asm)

Comment !
Description: Create a macro named mWriteInt that writes a signed integer
to standard output by calling the WriteInt library procedure. The argument
passed to the macro can be a byte, word, or doubleword. Use conditional
operators in the macro so it adapts to the size of the argument. Write a
program that demonstrates the macro, passing it arguments of different sizes.
As an extra feature, we display an error message during assembly if the
operand has an unexpected size.

Difficulty level: 2/5
Last update: 05/05/2002
!
INCLUDE Irvine32.inc

mWriteInt MACRO intVal
	push eax
	IF (TYPE intVal) EQ 1		;; 8-bit operand?
	  movsx eax,intVal
	  call WriteInt
	ELSEIF (TYPE intVal) EQ 2	;; 16-bit operand?
	  movsx eax,intVal
	  call WriteInt
	ELSEIF (TYPE intVal) EQ 4	;; 32-bit operand?
	  mov eax,intVal
	  call WriteInt
	ELSE
	  %OUT ************************************************************************
	  ; (The actual value of intVal is substituted into the following message)
	  %OUT Error: Argument intVal passed to mWriteInt must be 8, 16, or 32 bits.
	  %OUT ************************************************************************
	ENDIF
	pop eax
ENDM

.data
bVal SBYTE -26
wVal SWORD -12345
dVal SDWORD +2332424
qVal QWORD 1

.code
main PROC

	mWriteInt bVal
	call Crlf
	mWriteInt wVal
	call Crlf
	mWriteInt dVal
	call Crlf

	; Test the macro's error message
	mWriteInt qVal

	exit
main ENDP
END main