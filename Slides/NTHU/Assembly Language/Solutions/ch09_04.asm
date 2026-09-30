TITLE Chapter 9 Exercise 4              (ch09_04.asm)

Comment !
Description: Write a procedure named Str_find that searches for the
first matching occurrence of a source string inside a target string
and returns the matching position. The input parameters should be a
pointer to the source string and a pointer to the target string. If
a match is found, the procedure sets the Zero flag and EAX points to
the matching position in the target string. Otherwise, the Zero
flag is clear.

Difficulty level: 5/5
Last update: 05/04/2002
!
INCLUDE Irvine32.inc

Str_find PROTO,
	pSource:PTR BYTE,
	pTarget:PTR BYTE

.data
target BYTE "01AB45ABC9012",0
source BYTE "ABC",0
str1   BYTE "Source string found in position ",0
str2   BYTE "Source string not found",0

.code
main PROC

; The following code searches for "ABC" and returns with EAX
; pointing to the "A" in the target string:
	INVOKE Str_find, ADDR source, ADDR target
	jnz notFound

; The string was found, so we calculate the index
; position of the matching string inside the target string.
	sub eax,OFFSET target
	mov edx,OFFSET str1		; "Source string found..."
	call WriteString
	call WriteDec		; display index
	jmp  Exit_prog

notFound:
	mov edx,OFFSET str2
	call WriteString

Exit_prog:
	call Crlf
	exit
main ENDP

;----------------------------------------------------------
Str_find PROC,
	pSource:PTR BYTE,
	pTarget:PTR BYTE
;
; Searches for the first matching occurrence of a source string
; inside a target string and returns the matching position.
; Returns: If a match is found, the procedure sets the Zero
; flag and EAX points to the matching position in the target
; string. Otherwise, the Zero flag is clear.
;-----------------------------------------------------------
	push ebx
	push ecx
	push edx
	push esi
	push edi

	INVOKE Str_length, pSource
	mov edx,eax		; EDX = length of source string
	INVOKE Str_length, pTarget
	mov ebx,eax		; EBX = length of target string

	cld		; direction = up
	mov esi,pSource		; point to source
	mov edi,pTarget		; point to target

; Scan the destination for the first character in the source string.

L1: cmp ebx,edx		; destination shorter than source?
    jb  Exit_proc		; yes: exit with ZF = 0
    mov ecx,ebx		; get destination length
    mov al,[esi]		; get first byte of source
    repne scasb		; was the character found?
    jz  L2		; yes: continue matching
    jmp Exit_proc		; no: quit with ZF = 0

; Try to match the rest of the source string.

L2: mov ebx,ecx		; save new destination length
    mov ecx,edx		; get the source length
    dec ecx		; and subtract 1 from it
    jz  L3		; exit if source is now empty
    cmp ebx,ecx		; destination shorter than source?
    jb  Exit_proc		; yes: exit with ZF = 0
    call compare		; source = destination?
    jz  L3		; yes: get ready to exit
    inc edi		; no: move to next character
    jmp L1		; continue to scan destination

; A matching string was found. Set EAX to matching position in target.

L3: pushf
	dec edi		; back up the destination pointer
	mov eax,edi		; set EAX to destination location
	popf
    jmp Exit_proc		; exit with ZF = 1

Exit_proc:
	pop edi		; restore saved registers
	pop esi
    pop edx
    pop ecx
    pop ebx
    ret
Str_find ENDP

;---------------------------------------------------------
compare PROC
;
; Compares two strings pointed to by ESI and EDI.
; Returns: ZF=1 if the two strings are equal; otherwise,
;   ZF=0
;---------------------------------------------------------
    push esi
    push edi
    inc  esi	; second character of source
    repe cmpsb	; compare remaining characters
    pop  edi
    pop  esi
    ret
compare ENDP


END main