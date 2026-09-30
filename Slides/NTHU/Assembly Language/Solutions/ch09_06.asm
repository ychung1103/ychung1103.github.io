TITLE Chapter 9 Exercise 6              (ch09_06.asm)

Comment !
Description: Write a procedure named Get_frequencies that constructs
a character frequency table. Input to the procedure should be a
pointer to a string, and a pointer to an array of 256 doublewords.
Each array position is indexed by its corresponding ASCII code. When
the procedure returns, each entry in the array contains a count of how
many times that character occurred in the string.

Difficulty level: 3/5
Last update: 05/04/2002
!
INCLUDE Irvine32.inc

Get_frequencies PROTO,
	pString:PTR BYTE,	; points to string
	pTable:PTR DWORD	; points to frequencey table

.data
freqTable DWORD 256 DUP(0)
aString BYTE 1,2,"THE QUICK BROWN FOX JUMPED OVER THE LAZY DOGS BACK",0

.code
main PROC

	INVOKE Get_frequencies, ADDR aString, ADDR freqTable
	call DisplayTable

	exit
main ENDP

;-------------------------------------------------------------
Get_frequencies PROC,
	pString:PTR BYTE,	; points to string
	pTable:PTR DWORD	; points to frequencey table
;
; Constructs a character frequency table. Each array position
; is indexed by its corresponding ASCII code.
;
; Returns: Each entry in the table contains a count of how
; many times that character occurred in the string.
;-------------------------------------------------------------

	mov esi,pString
	mov edi,pTable
	cld		; clear Direction flag (forward)

L1:	mov eax,0		; clear upper bits of EAX
	lodsb		; AL = [ESI], inc ESI
	cmp al,0		; end of string?
	je  Exit_proc		; yes: exit
	shl eax,2		; multiply by 4
	inc DWORD PTR [edi + eax]	; inc table[AL]
	jmp L1		; repeat loop

Exit_proc:
	ret
Get_frequencies ENDP

;-------------------------------------------------------------
DisplayTable PROC
;
; Display frequency table entries 65 - 99 (35 entries)
; This procedure was not required, but it makes it easier
; to demonstrate that Get_frequencies works.
;-------------------------------------------------------------
.data
colonStr BYTE ": ",0
.code
	call Crlf
	mov ecx,35
	mov esi,OFFSET freqTable
	add esi,65 * TYPE freqTable
	mov ebx,65		; index counter

L1:	mov eax,ebx		; display the index
	call WriteDec
	mov edx,OFFSET colonStr		; display ": "
	call WriteString
	mov eax,[esi]		; show frequency count
	call WriteDec
	call Crlf
	add esi,TYPE freqTable		; point to next table entry
	inc ebx		; increment index
	loop L1

	call Crlf
	ret
DisplayTable ENDP

END main