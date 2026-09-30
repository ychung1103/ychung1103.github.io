TITLE ArrayFill program        (ArryFill.asm)

Comment !
 This program fills an array of 16-bit words
 with random integers. Sample program from
 Section 8.4.4.1.

 Last update: 06/20/2002
!

INCLUDE Irvine32.inc

.data
count = 100
array WORD count DUP(?)

.code
main proc

	push OFFSET array
	push COUNT
	call ArrayFill

	mov esi,OFFSET array
	mov ecx,count
	mov ebx,2
	call DumpMem

	exit
main endp

ArrayFill PROC
	push ebp
	mov ebp,esp
	pushad

	mov esi,[ebp+12]	; offset of array
	mov ecx,[ebp+8]	; array size
	cmp ecx,0	; ECX < 0?
	jle L2	; yes: skip over loop
L1:
	mov eax,10000h	; get random 0 - FFFFh
	call RandomRange	; from the link library
	mov [esi],eax
	add esi,TYPE WORD
	loop L1

L2: popad
	pop ebp
	ret 8	; clean up the stack
ArrayFill ENDP

END main