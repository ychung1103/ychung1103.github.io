TITLE Chapter 15 Exercise 4                    (ch15_04.asm)

Comment !
Description: Using the Scrolling Color Columns exercise as a
starting point, make the following change: Before the loop
starts, randomly choose each column to scroll either up or
down. It should continue in the same direction for the
duration of the program. Hint: Define each column as a
separately scrolling window.

Difficulty level: 5/5
Last update: 05/20/2002
!
INCLUDE Irvine16.inc

WindowHeight = 20
WindowWidth = 60
WindowTop = 2
WindowLeft = 10
CharMin = 1
CharMax = 254
CharsToSkip = 3
UP = 6
DOWN = 7
LinesToScroll = 80

.data
strBuffer BYTE WindowWidth / CharsToSkip DUP(0)
colors BYTE WindowWidth / CharsToSkip DUP(0)
direction BYTE WindowWidth / CharsToSkip DUP(0)

.code
main PROC
	mov  ax,@data	; set up DS segment
	mov  ds,ax

	call ClrScr	; clear the screen
	call Randomize	; seed the random generator
	call ChooseColumnColors
	call ChooseUpDown	; choose direction to scroll

	mov  cx,LinesToScroll	; display 50 lines
L1:
	call GetRandomString	; generate random string
	mov  dh, WindowTop	; row to display line
	mov  dl,WindowLeft	; column for first char
	call GotoXY	; locate cursor
	call WriteStr	; display string
	mov  eax,200	; number of miliseconds
	call Delay	; to delay
	call ScrollWindows
	loop L1

	mov  dx, 0	; top left corner
	call GotoXY	; locate cursor

	exit
main ENDP

;---------------------------------------------------
ScrollWindows PROC
;
; Scrolls all the column windows
; Receives: nothing
; Returns: nothing
;---------------------------------------------------
	pusha	; save 16 bit registers

	mov dl,WindowLeft + 1
	mov si,OFFSET direction
	mov cx,WindowWidth / CharsToSkip
L1:
	push cx	; save counter
	mov  ah,[si]	; get direction
	mov  al,1	; one line
	mov  ch,WindowTop	; row
	mov  cl,dl
	dec  cl	; column width = DL - CL = 1
	mov  dh,WindowTop + WindowHeight

	mov  bh,7	; blank line attribute
	int  10h	; call BIOS

	add  dl,CharsToSkip	; next column
	inc  si	; next column
	pop  cx	; restore counter
	loop L1

	popa	; restore 16 bit registers
	ret
ScrollWindows ENDP

;---------------------------------------------------
ChooseColumnColors PROC
;
; Select a random color for each column
; Receives: nothing
; Returns: nothing
;---------------------------------------------------
	pushad

	mov cx, WindowWidth / CharsToSkip
	mov si, OFFSET colors

L1:	mov  eax,15	; range (0 - 14)
	call RandomRange
	inc  eax	; range (1 - 15)
	mov  [si],al
	inc  si
	Loop L1

	popad
	ret
ChooseColumnColors ENDP

;---------------------------------------------------
ChooseUpDown PROC
;
; Choose column scrolling direction. UP = 6, DOWN = 7
; Receives: nothing
; Returns: nothing
;---------------------------------------------------
	pushad
	mov cx,WindowWidth / CharsToSkip
	mov si,OFFSET direction

L1:	mov  eax,2	; range (0 - 1)
	call RandomRange
	add  eax,6	; range (6 - 7)
	mov  [si],al
	inc  si
	Loop L1

	popad
	ret
ChooseUpDown ENDP

;---------------------------------------------------
LocateCursorNextColumn PROC
;
; Locate cursor according to direction. UP = 6, DOWN = 7
; Receives: nothing
; Returns: nothing
;---------------------------------------------------
	pusha
	mov ah, 3	; get cursor position
	int 10h	; call BIOS
	add dl, CharsToSkip	; increment column
	mov ah, 2	; set cursor position
	int 10h
	popa
	ret
LocateCursorNextColumn ENDP

;---------------------------------------------------
LocateCursorDirection PROC
;
; Locate cursor according to direction. UP = 6, DOWN = 7
; Receives: DI = offset to add to direction array
; Returns: nothing
;---------------------------------------------------
	pusha

	mov ah,3	; get cursor position
	int 10h	; call BIOS

	.IF direction[di] == UP
	  mov dh, WindowTop + WindowHeight - 1
	.ELSE	; direction is DOWN
	  mov dh, WindowTop
	.ENDIF

	mov ah, 2	; set cursor position
	int 10h

	popa
	ret
LocateCursorDirection ENDP

;---------------------------------------------------
GetRandomString PROC
;
; Draw a string of random characters
; on the top line of the window in the range
; between CharMin and CharMax.
; Receives: nothing
; Returns: random string in variable: StrBuffer
;---------------------------------------------------
	pushad

	mov  si,OFFSET StrBuffer
	mov  cx,WindowWidth / CharsToSkip	; counter

L1:	mov  eax,CharMax - CharMin		; range
	call RandomRange		; get random number
	add  eax,CharMin
	mov  [si],al		; store in string
	inc  si		; next character
	loop L1

	popad
	ret
GetRandomString ENDP

;---------------------------------------------------
WriteStr PROC
;
; Write a string character by character
; using INT 10h function 9
; Receives: nothing
; Returns: nothing
;---------------------------------------------------

	pusha

	mov  si,OFFSET strBuffer	; pointer to random string
	mov  di,0
	mov  cx,WindowWidth / CharsToSkip ; width of string
	mov  bh,0	; video page 0
L1:
	push cx

	call LocateCursorDirection

	mov  ah,9	; display char/attrib function
	mov  al,[si]	; character to display
	mov  cx,1	; repetition count
	mov  bl,colors[di]	; get color value
	int  10h	; call Video BIOS (display char)

	call LocateCursorNextColumn

	inc  si	; next character
	inc  di
	pop  cx	; restore counter
	loop L1

	popa
	ret
WriteStr ENDP
END main