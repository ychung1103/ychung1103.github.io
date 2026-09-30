TITLE Chapter 10 Exercise 8                          (ch10_08.asm)

Comment !
Description: When testing the Drunkard Walk program, you may have
noticed that the professor doesn't seem to wander very far from the
starting point. This is no doubt caused by the fact that there is an
equal probability of the professor moving in each direction. Modify
the program so that there is a 60% probability that the professor
will continue to walk in the same direction as he/she did when taking
the previous step. Hint: You will have to assign a default starting
direction before the loop begins.

Difficulty level: 2/5
Last update: 05/05/2002
!
INCLUDE Irvine32.inc

WalkMax = 100
StartX = 25
StartY = 25

North = 0	; direction constants
South = 1
West = 2
East = 3

DrunkardWalk STRUCT
	path COORD WalkMax DUP(<0,0>)
	pathsUsed WORD 0
DrunkardWalk ENDS

DisplayPosition PROTO currX:WORD, currY:WORD

.data
aWalk DrunkardWalk <>

.code
main PROC
	call Randomize
	mov esi,offset aWalk
	call TakeDrunkenWalk
	exit
main ENDP

;-------------------------------------------------------
TakeDrunkenWalk PROC
LOCAL currX:WORD, currY:WORD, currDirection:DWORD
;
; Take a walk in random directions (north, south, east,
; west).
; Receives: ESI points to a DrunkardWalk structure
; Returns:  the structure is initialized with random values
;-------------------------------------------------------
	pushad

; Point EDI to the array of COORD objects.
	mov edi,esi
	add edi,OFFSET DrunkardWalk.path
	mov ecx,WalkMax		; loop counter
	mov currX,StartX		; current X-location
	mov currY,StartY		; current Y-location
	mov currDirection,North		; starting direction

Again:
	; Insert current location in array.
	mov ax,currX
	mov (COORD PTR [edi]).X,ax
	mov ax,currY
	mov (COORD PTR [edi]).Y,ax

	INVOKE DisplayPosition, currX, currY

	;60% probability that direction will remain the same
	mov  eax,10
	call RandomRange
	.IF eax < 6
	  mov eax,currDirection
	.ELSE	; choose new direction
	  mov eax,4
	  call RandomRange
	.ENDIF

	;Now that the direction has been chosen, adjust
	;the professor's location in the grid.
	.IF eax == North	; North
	  inc currY
	.ELSEIF eax == South	; South
	  dec currY
	.ELSEIF eax == West	; West
	  dec currX
	.ELSE	; East
	  inc currX
	.ENDIF

next:
	mov currDirection,eax	; save current direction
	add edi,TYPE COORD	; point to next COORD
	loop Again

finish:
	mov ax,WalkMax	; count the steps taken
	sub ax,cx
	mov (DrunkardWalk PTR [esi]).pathsUsed, ax
	popad
	ret
TakeDrunkenWalk ENDP

;-------------------------------------------------------
DisplayPosition PROC currX:WORD, currY:WORD
;
; Display the current X and Y positions.
; Optional: used for debugging.
;-------------------------------------------------------
.data
commaStr BYTE ",",0
.code
	pushad
	movzx eax,currX	; current X position
	call WriteDec
	mov edx,OFFSET commaStr	; "," string
	call WriteString
	movzx eax,currY	; current Y position
	call WriteDec
	call Crlf
	popad
	ret
DisplayPosition ENDP
END main