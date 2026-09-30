TITLE Procedure Wrapper Macros        (Wraps.ASM)

; This program demonstrates macros as wrappers
; for library procedures. Contents: mGotoxy, mWrite,
; mWriteLn, mWriteStr, mReadStr, and mDumpMem.
; Last update: 3/16/02

INCLUDE Irvine32.inc
INCLUDE Macros.inc	; macro definitions

.data
array DWORD 1,2,3,4,5,6,7,8
firstName BYTE 31 DUP(?)
lastName  BYTE 31 DUP(?)

.code
main PROC
	mGotoxy 20,0
	mWriteLn "Sample Macro Program"

	mGotoxy 0,5
	mWrite "Please enter your first name: "
	mReadStr firstName
	call Crlf

	mWrite "Please enter your last name: "
	mReadStr lastName
	call Crlf

; Display the person's complete name:
	mWrite "Your name is "
	mWriteStr firstName
	mWrite " "
	mWriteStr lastName

	call Crlf
	mDumpMem OFFSET array,LENGTHOF array, TYPE array

	exit
main ENDP
END main