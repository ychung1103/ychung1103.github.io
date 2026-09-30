TITLE Binary Multiplication         (BMult.asm)

; Demonstration of binary multiplication using SHL.
; Multiply intval by 36, using SHL instructions.
; Last update: 08/01/02

INCLUDE Irvine32.inc

.data
intval  DWORD  123

.code
main PROC

	mov eax,intval
	mov ebx,eax
	shl eax,5
	shl ebx,2
	add eax,ebx
	call DumpRegs

	exit
main ENDP
END main