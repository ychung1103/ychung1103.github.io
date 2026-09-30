TITLE Chapter 15 Exercise 6                  (ch15_06.asm)

Comment !
Description: Using the pixel-drawing capabilities of INT 10h,
plot the line determined by the equation Y = 2(X^2).

Note to instructors: this project should only be given to
advanced students who do not mind experimenting with the
X and Y dimensions to produce a graph that will fit on the
screen. It definitely requires some creativity!

Difficulty level: 5/5
Last update: 05/23/2002
!
INCLUDE Irvine16.inc

Mode = 12h	; 640 X 480, 16 colors
ModeWidth  = 640
ModeHeight = 480
X_axisY = ( ModeHeight / 2 ) - 1
X_axisX = 0
X_axisLen = ModeWidth - 1

Y_axisX = (ModeWidth / 2) - 1
Y_axisY = 0
Y_axisLen = ModeHeight - 1

.data
saveMode BYTE ?

.code
main PROC
	mov ax,@data
	mov ds,ax

; Save the current video mode
	mov ah,0Fh	; get video mode
	int 10h
	mov saveMode,al

; Switch to a graphics mode
	mov ah, 0	; set video mode
	mov al, Mode
	int 10h

; Draw the X-axis
	mov cx, X_axisX	; X-coord of start of line
	mov dx, X_axisY	; Y-coord of start of line
	mov ax, X_axisLen 	; length of line
	mov bl, white	; line color (see IRVINE16.inc)
	call DrawHorizLine	; draw the line now

; Draw the Y-axis
	mov cx, Y_axisX	; X-coord of start of line
	mov dx, Y_axisY	; Y-coord of start of line
	mov ax, Y_axisLen	; length of line
	mov bl, white	; line color
	call DrawVerticalLine	; draw the line now

	mov al, 12	; blue color
	call DrawEquation

; Wait for a keystroke
	mov ah,10h	; wait for key
	int 16h

; Restore the starting video mode
	mov ah,0	; set video mode
	mov al, saveMode	; saved video mode
	int 10h

	exit
main endp

;------------------------------------------------------
DrawHorizLine PROC
;
; Draws a horizontal line starting at position X,Y with
; a given length and color.
; Receives: CX = X-coordinate, DX = Y-coordinate,
;           AX = length, and BL = color
; Returns: nothing
;------------------------------------------------------
.data
currX WORD ?

.code
	pusha
	mov currX,cx	; save X-coordinate
	mov cx,ax	; loop counter

DHL1:
	push cx	; save loop counter
	mov al,bl	; color
	mov ah,0Ch	; draw pixel
	mov bh,0	; video page
	mov cx,currX	; retrieve X-coordinate
	int 10h
	inc currX	; move 1 pixel to the right
	pop cx	; restore loop counter
	Loop DHL1

	popa
	ret
DrawHorizLine ENDP

;------------------------------------------------------
DrawVerticalLine PROC
;
; Draws a vertical line starting at position X,Y with
; a given length and color.
; Receives: CX = X-coordinate, DX = Y-coordinate,
;           AX = length, BL = color
; Returns: nothing
;------------------------------------------------------
.data
currY WORD ?

.code
	pusha
	mov  currY,dx	; save Y-coordinate
	mov  currX,cx	; save X-coordinate
	mov  cx,ax	; loop counter

DVL1:
	push cx	; save loop counter
	mov al,bl	; color
	mov ah,0Ch	; function: draw pixel
	mov bh,0	; set video page
	mov cx,currX	; set X-coordinate
	mov dx,currY	; set Y-coordinate
	int 10h	; draw the pixel
	inc currY	; move down 1 pixel
	pop cx	; restore loop counter
	Loop DVL1

	popa
	ret
DrawVerticalLine ENDP

;------------------------------------------------------
DrawEquation PROC
;
; Plot the line determined by the equation Y = 2(X^2).
XWidth = 11	; Maximun X coordinate to draw
RESOLUTION = 5	; Points per unit (2^RESOLUTION)
;
; Receives: AL = color
; Returns: nothing
;------------------------------------------------------
	pushad
	mov ah, 0Ch	; function: draw pixel
	mov bh, 0	; set video page
	mov ecx, XWidth * 2	; loop counter
	shl ecx, RESOLUTION	; multiply by resolution
EQ1:
	push ecx	; save loop counter
	push eax	; save function and color

	mov eax, XWidth
	shl eax, RESOLUTION
	sub ecx, eax
	mov eax, ecx	; AX = X coordinate
	imul ecx	; X ^ 2
	shl eax, 1	; 2(X^2)
	mov edx, eax	; Y = 2(X^2)
	sar ecx, RESOLUTION - 3	; divide by resolution (to scale)
	add ecx, ModeWidth / 2	; add offset to center of coordinates
	sar edx, RESOLUTION + 5	; divide by resolution (to scale)
	mov eax, ModeHeight / 2	; offset to center of Y coordinates
	sub eax, edx	; AX = row number in cartesian coordinates
	mov edx, eax	; DX = y coordinate

	pop eax
	int 10h	; draw the pixel
	pop ecx	; restore loop counter
	Loopd EQ1	; next point

	popad
	ret
DrawEquation ENDP
END main