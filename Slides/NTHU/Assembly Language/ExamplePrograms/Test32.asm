TITLE Test the Link Library        (Test32.asm)

; Use this program to test the 32-bit link library.

INCLUDE Irvine32.inc

.data
myArray DWORD 10,20,30,40

.code
main PROC

	mDumpMem OFFSET myArray,4,4

	mDump myArray	; same output

	mDump myArray, Y	; show name of variable

    exit
main ENDP
END main