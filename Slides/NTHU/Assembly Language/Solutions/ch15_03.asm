TITLE Chapter 15 Exercise 3                        (ch15_03.asm)

Comment !
Description: Using the Scrolling Text Window exercise as a starting
point, make the following changes:

 The random string should only have characters in columns 0, 3,
   6, 9, ..., 78. The other columns should be blank. This will
   create the effect of columns as it scrolls downward.
 Each column should be in a different color.

Difficulty level: 4/5
Last update: 05/20/2002
!
INCLUDE Irvine16.inc

WindowHeight = 25
WindowWidth = 80
WindowTop = 0
WindowLeft = 0
CharMin = 1
CharMax = 254
CharsToSkip = 3

.data
strBuffer BYTE WindowWidth DUP(0)
colors BYTE WindowWidth DUP(0)

.code
main PROC
	mov ax,@data	; set up DS segment
	mov ds,ax

	call ClrScr	; clear the screen
	call Randomize	; seed the random generator
	call ChooseColumnColors

	mov cx, 50	; display 50 lines
L1:	call GetRandomString	; generate random string
	mov dh, WindowTop	; row to display line
	mov dl, WindowLeft	; column for first char
	call GotoXY	; locate cursor
	call WriteStr	; display string
	mov eax, 200	; number of miliseconds
	call Delay	; to delay
	call ScrollWindowDown
	loop L1
	
	mov dx, 0	; top left corner
	call GotoXY	; locate cursor
	
	exit
main ENDP

;---------------------------------------------------
ScrollWindowDown PROC
;
; Scrolls the text window down
; Receives: nothing
; Returns: nothing
;---------------------------------------------------
	pusha	; save 16 bit registers

	mov ah, 7	; scroll window down
	mov al, 1	; all lines
	mov ch, WindowTop	; row
	mov cl, WindowLeft	; column
	mov dh, WindowTop + WindowHeight
	mov dl, WindowLeft + WindowWidth
	mov bh, 7	; blank line attribute
	int 10h	; call BIOS

	popa	; restore 16 bit registers
	ret
ScrollWindowDown ENDP

;---------------------------------------------------
ChooseColumnColors proc
;
; Select a random color for each column
; Receives: nothing
; Returns: colors chosen in array: colors
;---------------------------------------------------
	pushad
	mov cx, WindowWidth
	mov si, OFFSET colors

L1:	mov eax, 15	; range (0 - 14)
	call RandomRange
	inc eax	; range ( 1 - 15 )
	mov [si], al
	inc si
	Loop L1
	
	popad
	ret
ChooseColumnColors endp

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
	
	mov si, OFFSET StrBuffer
	mov cx, WindowWidth / CharsToSkip	; counter
CHAR_LOOP:
	mov eax, CharMax - CharMin	; range
	call RandomRange	; get random number
	add eax, CharMin
	mov [si], al	; store in string 
	add si, CharsToSkip	; next character
	loop CHAR_LOOP
	
	popad
	ret
GetRandomString ENDP

;---------------------------------------------------
WriteStr PROC
;
; Write a string character by character 
; using INT 10h function 9
; Receives: String to write in variable: strBuffer
; 	Array of color attributes in variable: colors
; Returns: nothing
;---------------------------------------------------

	pusha

	mov si, OFFSET strBuffer	; pointer to random string
	mov di, OFFSET colors
	mov cx, WindowWidth	; width of string
	mov bh, 0	; video page 0
	
L1: push cx
	mov ah,9	; display char/attrib function
	mov al, [si]	; character to display
	mov cx, 1	; repetition count
	mov  bl,[di]	; get color value
	int 10h	; call Video BIOS (display char)

	mov ah, 3	; get cursor position
	int 10h	; call BIOS
	inc dl	; increment column
	mov ah, 2	; set cursor position
	int 10h

	inc si	; next character
	inc di
	pop  cx	; restore counter
	loop L1

	popa
	ret
WriteStr ENDP
END main