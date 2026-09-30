TITLE Chapter 15 Exercise 5                  (ch15_05.asm)

Comment !
Description: Using the pixel-drawing capabilities of INT 10h,
create a procedure named DrawRectangle that takes input
parameters specifying the location of the upper-left
corner and the lower-right corner, and the color. Write a
short test program that uses the INVOKE directive to draw
several rectangles of different sizes and colors.

Difficulty level: 3/5
Last update: 05/23/2002

!
INCLUDE Irvine16.inc

Draw_Rectangle PROTO,
	top:WORD,
	left:WORD,
	bottom:WORD,
	right:WORD,
	color:BYTE

.data

.code
main PROC
	mov ax,@data	; set up DS segment
	mov ds,ax

	mov ah, 0	; set Video Mode
	mov al, 12h	; 640 * 480 color graphics mode
	int 10h	; call BIOS

	; Draw several rectangles of different sizes and colors.
	INVOKE Draw_Rectangle, 100, 200, 140, 240, 1
	INVOKE Draw_Rectangle, 100, 300, 140, 340, 2
	INVOKE Draw_Rectangle, 200, 180, 280, 360, 4

	call ReadChar	; wait for key
	exit
main ENDP

;------------------------------------------------------
Draw_Rectangle PROC,
	top:WORD,
	left:WORD,
	bottom:WORD,
	right:WORD,
	color:BYTE,
;
; Draws a rectangle with given coordinates and color
; Receives: coordinates and color parameters
; Returns: nothing
;------------------------------------------------------
	pusha

	mov ah, 0Ch	; draw pixel
	mov al, color
	mov bh, 0	; video page 0

	mov dx, top	; starting row
ROW_LOOP:

	mov cx, left	; starting col
	COL_LOOP:

	int 10h	; call Bios

	inc cx	; next col
	cmp cx, right	; is row <= right
	jbe COL_LOOP	; if true, loop

	inc dx	; next row
	cmp dx, bottom	; is row <= bottom
	jbe ROW_LOOP	; if true, loop

	popa
	ret
Draw_Rectangle ENDP
END main