TITLE Chapter 9 Exercise 7              (ch09_07.asm)

Comment !
Description: The Sieve of Eratosthenes, invented by the Greek mathematician
having the same name, provides a way to find all the prime numbers within
a given range. The algorithm involves creating an array of bytes in which
positions are "marked" by inserting 1's in the following manner: Beginning
with position 2 (which is a prime number), insert a 1 in each array position
that is a multiple of 2. Then do the same thing for multiples of 3, the next
prime number. Find the next prime number after 3, which is 5, and mark all
positions that are multiples of 5. Proceed in this manner until all multiples
of primes have been found. The remaining positions of the array that are
unmarked indicate which numbers are prime. For this program, create a
65,000-element array and display all primes between 2 and 65,000.

Difficulty level: 4/5
Last update: 05/05/2002
!

INCLUDE Irvine32.inc

PrintPrimes PROTO,
	count:DWORD	; number of values to display

FIRST_PRIME = 2
LAST_PRIME = 65000

.data
commaStr BYTE ", ",0
sieve WORD LAST_PRIME DUP(0)

.code
main PROC

	mov esi,FIRST_PRIME

	.WHILE esi < LAST_PRIME
	  .IF sieve[esi*TYPE sieve] == 0		; is current entry prime?
	    call MarkMultiples		; yes: mark all of its multiples
	  .ENDIF
	  inc esi		; move to next table entry
	.ENDW

	INVOKE PrintPrimes, 8000		; display range 1..8000

	exit
main ENDP

;--------------------------------------------------
MarkMultiples PROC
;
; Mark all multiples of the value passed in ESI.
; Notice we use ESI as the prime value, and
; take advantage of the "scaling" feature of indirect
; operands to locate the address of the indexed item:
; [esi*TYPE sieve]
;--------------------------------------------------
	push eax
	push esi
	mov  eax,esi		; prime value
	add  esi,eax		; start with first multiple

L1:	cmp esi,LAST_PRIME		; end of array?
	ja  L2		; yes
	mov sieve[esi*TYPE sieve],1	; no: insert a marker
	add esi,eax
	jmp L1		; repeat the loop

L2:	pop esi
	pop eax
	ret
MarkMultiples ENDP


;--------------------------------------------------
PrintPrimes PROC,
	count:DWORD	; number of values to display
;
; Display the list of prime numbers
;--------------------------------------------------
	mov esi,1
	mov eax,0
	mov ecx,count

L1:	mov ax,sieve[esi*TYPE sieve]
	.IF ax == 0
	  mov  eax,esi
	  call WriteDec
	  mov edx,OFFSET commaStr
	  call WriteString
	.ENDIF
	inc esi
	loop L1

	ret
PrintPrimes ENDP

END main