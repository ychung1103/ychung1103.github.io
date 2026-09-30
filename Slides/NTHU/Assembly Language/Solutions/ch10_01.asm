TITLE Chapter 10 Exercise 1              (ch10_01.asm)

Comment !
Description: Create a macro that waits for a keystroke and returns
the key that was pressed. The macro should include parameters for the
ASCII code and keyboard scan code. (Requires reading Section 15.2.2.
The program must also run in Real-address mode.)

Difficulty level: 1/5
Last update: 05/05/2002
!
INCLUDE Irvine16.inc

mReadkey MACRO ascii, scan
	mov ah,10h		; BIOS keyboard input function
	int 16h
	mov scan,ah
	mov ascii,al
ENDM

.data
ascii BYTE ?
scan  BYTE ?
str1  BYTE "ASCII code: ",0
str2  BYTE "Scan code:  ",0

.code
main PROC
	mov ax,@data
	mov ds,ax

; Wait for a key; when the macro returns, the two arguments
; contain the ASCII code and scan code of the key.
	mReadkey ascii, scan

; Display the values.
	mov edx,OFFSET str1
	call WriteString
	movzx eax,ascii
	call WriteHex
	call Crlf

	mov edx,OFFSET str2
	call WriteString
	movzx eax,scan
	call WriteHex
	call Crlf

	exit
main ENDP
END main