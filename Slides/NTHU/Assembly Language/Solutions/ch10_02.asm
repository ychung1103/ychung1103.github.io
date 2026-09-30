TITLE Chapter 10 Exercise 2              (ch10_02.asm)

Comment !
Description: Create a macro that writes a null-terminated string
to the console with a given text color.

Difficulty level: 1/5
Last update: 05/05/2002
!
INCLUDE Irvine32.inc

mWritestringAttr MACRO aString,color
	push eax
	push edx
	mov  eax,color
	call SetTextColor
	mov  edx,OFFSET aString
	call WriteString
	pop  edx
	pop  eax
ENDM

.data
myString BYTE "This string is in color",0

.code
main PROC

	; Blue text on a white background:
	mWritestringAttr myString, (white * 16) + blue
	call Crlf

	; White text on a blue background:
	mWritestringAttr myString, (blue * 16) + white
	call Crlf

	mov eax,lightGray		; normal screen color
	call SetTextColor

	exit
main ENDP
END main