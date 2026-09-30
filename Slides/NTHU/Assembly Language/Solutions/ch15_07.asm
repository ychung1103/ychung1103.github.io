TITLE Chapter 15 Exercise 7                  (ch15_07.asm)

Comment !
Description: Modify the Memory Mapped Graphics program in
Section 15.5.2 so that it draws a single vertical line.

Difficulty level: 4/5
Last update: 05/23/2002
!
INCLUDE Irvine16.inc

DrawVerticalLine PROTO,
	Xcoord:WORD,
	Ycoord:WORD,
	lineLength:WORD

.data
saveMode BYTE ?	; saved video mode

.code
main PROC
	mov ax,@data
	mov ds,ax

	call SetVideoMode
	call SetScreenBackground
	INVOKE DrawVerticalLine, 200, 30, 80
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

; Set screen background color to dark blue.
	mov dx,3c9h	; colors go to port 3C9h
	mov al,0	; red
	out dx,al
	mov al,0	; green
	out dx,al
	mov al,35	; blue (intensity 35/63)
	out dx,al

	ret
SetScreenBackground ENDP

;----------------------------------------------------------
SetVideoMode PROC
;
; This procedure saves the current video mode, switches to
; a new mode, and points ES to the video segment.
; Receives: nothing
; Returns: ES = address of video segment
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
	lineLength:WORD
;
; This procedure sets individual palette colors and
; draws a vertical line
; Receives: coordinate and length parameters
; Returns: nothing
;----------------------------------------------------------
	pusha

	; Change color at index 1 to white (63,63,63)
	mov dx,3c8h	; video palette port (3C8h)
	mov al,1	; set palette index 1
	out dx,al

	mov dx,3c9h	; colors go to port 3C9h
	mov al,63	; red
	out dx,al
	mov al,63	; green
	out dx,al
	mov al,63	; blue
	out dx,al

	; Calculate the video buffer offset of the first pixel.
	; Specific to mode 13h, which is 320 X 200.
	mov ax, 320	; 320 for video mode 13h
	mul yCoord	; y-coordinate
	add ax, xCoord	; x-coordinate

	; Place the color index into the video buffer.
	mov cx, lineLength	; pixel counter
	mov di,ax	; AX contains buffer offset

	; Draw the vertical line
DP1:
	mov BYTE PTR es:[di], 1	; store color index
	add di,320	; move one pixel down
	Loop DP1

	popa
	ret
DrawVerticalLine ENDP
END main