TITLE Chapter 15 Exercise 2                        (ch15_02.asm)

Comment !
Description: Define a text window that is approximately 3/4 of
the size of the video display. Let the program carry out the
following actions, in sequence:

 Draw a string of random characters on the top line of the
  window. (You can call Random_range from the Irvine16 library.)
 Scroll the window down one line.
 Pause the program for approximately 500 milliseconds. (You
  can call the Delay function from the Irvine16 library.)
 Draw another line of random text.
 Continue scrolling and drawing until 50 lines have been displayed.


Difficulty level: 4/5
Last update: 05/20/2002
!
INCLUDE Irvine16.inc

WindowHeight = 19
WindowWidth = 60
WindowTop = 3
WindowLeft = 10
CharMin = 1
CharMax = 254
DelayVal = 500

.data
StrBuffer BYTE WindowWidth + 1 DUP(0)

.code
main PROC
	mov ax,@data	; set up DS segment
	mov ds,ax

	call ClrScr	; clear the screen
	call Randomize	; seed the random generator
	mov  cx,50	; display 50 lines

L1:	push cx	; save counter
	call GetRandomString	; generate random string
	mov  dh,WindowTop	; row to display line
	mov  dl,WindowLeft	; column for first char
	call GotoXY	; locate cursor
	mov  si,OFFSET StrBuffer	; pointer to random string
	mov  cx,WindowWidth	; width of string
	call WriteStr	; display string
	mov  eax,DelayVal	; number of miliseconds
	call Delay	; to delay
	call ScrollWindowDown
	pop  cx	; restore counter
	loop L1

	mov  dx,0	; top left corner
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
	pusha		; save 16-bit registers

	mov  ah,7		; scroll window down
	mov  al,1		; all lines
	mov  ch,WindowTop		; row
	mov  cl,WindowLeft		; column
	mov  dh,WindowTop + WindowHeight
	mov  dl,WindowLeft + WindowWidth
	mov  bh,7		; blank line attribute
	int  10h		; call BIOS

	popa		; restore 16-bit registers
	ret
ScrollWindowDown ENDP

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
	mov  cx,WindowWidth	; counter

L1:	mov  eax,CharMax - CharMin	; range
	call RandomRange	; get random number
	add  eax, CharMin
	mov  [si],al	; store in string
	inc  si	; next character
	loop L1

	popad
	ret
GetRandomString ENDP

;---------------------------------------------------
WriteStr PROC
;
; Write a string character by character using INT 10h
; Function 9.
; Receives: SI points to the string, CX = length
; Returns: nothing
;---------------------------------------------------
	pusha

	mov  bh,0	; video page 0
L1:	push cx
	mov  ah,9	; display char/attrib function
	mov  al,[si]	; character to display
	mov  cx,1	; repetition count
	mov  bl,7	; normal attribute
	int  10h	; call Video BIOS (display char)

	mov  ah,3	; get cursor position
	int  10h	; call BIOS
	inc  dl	; increment column
	mov  ah,2	; set cursor position
	int  10h

	inc  si	; next character
	pop  cx	; restore counter
	loop L1

	popa
	ret
WriteStr ENDP
END main