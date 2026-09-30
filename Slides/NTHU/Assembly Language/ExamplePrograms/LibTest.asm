TITLE Test the Link Library        (LibTest.asm)

; Use this program to test the link library.

INCLUDE Irvine32.inc

.data

.code
main PROC

	call GetMaxXY
	call DumpRegs


    exit
main ENDP
END main