TITLE Chapter 15 Exercise 8                  (ch15_08.asm)

Comment !
Description: Modify the Memory Mapped Graphics program in
Section 15.5.2 so that it draws a series of 10 vertical
lines, each in a different color.

Implementation note: Although it was not in the specifications,
we chose to set the screen background color to gray.

Difficulty level: 4/5
Last update: 05/23/2002
!
INCLUDE Irvine16.inc

DrawVerticalLine PROTO,
	Xcoord:WORD,
	Ycoord:WORD,
	lineLength:WORD,
	color:BYTE

.data
saveMode BYTE ?	; saved video mode
colorArg BYTE ?
xVal WORD ?

.code
main PROC
	mov ax,@data
	mov ds,ax

	call SetVideoMode
	call SetScreenBackground
	mov cx, 10	; draw 10 lines
L1:
	mov ax, cx
	shl ax, 3
	add ax, 100	; x coordinate
	mov xVal, ax
	mov ax, cx
	add ax, 5	; colors ( 6 - 15)
	mov colorArg, al	; color
	INVOKE DrawVerticalLine, xVal, 30, 120, colorArg
	loop L1
	call RestoreVideoMode
	exit
main ENDP

;----------------------------------------------------------
SetScreenBackground PROC
;
; This procedure sets the screen's background color.
; Video palette index 0 is the background color.
; Receives: nothing
; Returns: nothing
;----------------------------------------------------------
	mov dx,3c8h	; video palette port (3C8h)
	mov al,0	; set palette index
	out dx,al

; Set screen background color to gray.
	mov dx,3c9h	; colors go to port 3C9h
	mov al,35	; red
	out dx,al
	mov al,35	; green
	out dx,al
	mov al,35	; blue
	out dx,al

	ret
SetScreenBackground ENDP

;----------------------------------------------------------
SetVideoMode PROC
;
; This procedure saves the current video mode, switches to
; a new mode, and points ES to the video segment.
; Receives: nothing
; Returns: ES = video segment
;----------------------------------------------------------
	mov ah,0Fh	; get current video mode
	int 10h
	mov saveMode,al	; save it

	mov ah,0	; set new video mode
	mov al,13h	; to mode 13h
	int 10h

	push 0A000h	; video segment address
	pop es	; ES = A000h (video segment).

	ret
SetVideoMode ENDP

;----------------------------------------------------------
RestoreVideoMode PROC
;
; This procedure waits for a key to be pressed and
; restores the video mode to its original value.
; Receives: nothing
; Returns: nothing
;----------------------------------------------------------
	mov ah,10h	; wait for keystroke
	int 16h
	mov ah,0	; reset video mode
	mov al,saveMode	; to saved mode
	int 10h
	ret
RestoreVideoMode ENDP

;----------------------------------------------------------
DrawVerticalLine PROC,
	Xcoord:WORD,
	Ycoord:WORD,
	lineLength:WORD,
	color:BYTE
;
; This procedure sets individual palette colors and
; draws several pixels.
; Receives: X,Y coordinates, length and color parameters
; Returns: nothing
;----------------------------------------------------------
	pusha

	; Change color at index 1
	mov dx,3c8h	; video palette port (3C8h)
	mov al, color	; set palette index
	out dx, al

	mov bl, color	; get color
	mov dx,3c9h	; colors go to port 3C9h
	mov al, 0	; not red by default
	shl bl, 6	; shift red bit to CF
	jnc R1	; if not red, skip
	mov al, 63	; red
R1:	out dx,al
	mov al, 0	; not green by default
	shl bl, 1	; get red bit
	jnc G1	; if not green skip
	mov al, 63	; green
G1:	out dx,al
	mov al, 0	; not blue by default
	shl bl, 1	; get blue bit
	jnc B1	; if not blue skip
	mov al, 63	; blue
B1:	out dx,al

	; Calculate the video buffer offset of the first pixel.
	; Specific to mode 13h, which is 320 X 200.
	mov ax, 320	; 320 for video mode 13h
	mul yCoord	; y-coordinate
	add ax, xCoord	; x-coordinate

	; Place the color index into the video buffer.
	mov cx, lineLength	; pixel counter
	mov di,ax	; AX contains buffer offset
	mov al, color

	; Draw the vertical line
DP1:
	mov BYTE PTR es:[di], al	; store color index
	add di,320	; move one pixel down
	Loop DP1

	popa
	ret
DrawVerticalLine ENDP
END main