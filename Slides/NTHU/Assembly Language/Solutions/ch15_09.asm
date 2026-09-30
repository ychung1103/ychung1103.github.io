TITLE Chapter 15 Exercise 9                  (ch15_09.asm)

Comment !
Description: Write a procedure that draws a single-line frame
anywhere on the screen. Use the following extended ASCII codes:
C0h, BFh, B3h, C4h, D9h, and DAh, from the table on the inside back
cover of this book. The procedure's only input parameter should
be a pointer to a FRAME structure:

	FRAME STRUCT
	  Left BYTE ? 	; left side
	  Top BYTE ? 	; top line
	  Right BYTE ? 	; right side
	  Bottom BYTE ? 	; bottom line
	  FrameColor BYTE ? 	; box color
	FRAME ENDS

Write a program that tests your procedure, passing it pointers
to various FRAME objects.

Difficulty level: 4/5
Last update: 05/23/2002
!
INCLUDE Irvine16.inc

FRAME STRUCT
	Left BYTE ? 	; left side
	Top BYTE ? 	; top line
	Right BYTE ? 	; right side
	Bottom BYTE ? 	; bottom line
	FrameColor BYTE ? 	; box color
FRAME ENDS

DrawFrame PROTO,
	framePtr:PTR WORD

whiteOnBlack   = 0Fh
blueOnWhite    = 71h
yellowOnBlue   = 1Eh
magentaOnBlack = 0Dh
yellowOnBrown  = 6Eh

; Define constants for the box drawing characters
ulcorner = 0DAh
urcorner = 0BFh
llcorner = 0C0h
lrcorner = 0D9h
hbar     = 0C4h
vbar     = 0B3h

.data
frameArray FRAME <5,5,30,20,blue>
	FRAME <1,5,10,20,whiteOnBlack>
	FRAME <20,12,60,18,blueOnWhite>
	FRAME <5,1,10,3,yellowOnBlue>
	FRAME <0,7,79,24,magentaOnBlack>
	FRAME <25,9,75,18,yellowOnBrown>
NumberOfFrames = ($ - frameArray) / SIZEOF FRAME

boxWidth  WORD ?
boxHeight WORD ?
attribute BYTE ?	; color of box frame
row       BYTE ?
col       BYTE ?

.code
main PROC
	mov ax,@data	; set up DS segment
	mov ds,ax
	call Clrscr

	mov si, OFFSET frameArray
	mov cx, NumberOfFrames
L1:
	INVOKE DrawFrame, si
	add si, SIZEOF FRAME	; next frame
	loop L1

	; Wait for a keystroke
	mov ah,10h	; wait for key
	int 16h

	exit
main ENDP

;--------------------------------------------
DrawFrame PROC,
	framePtr:PTR WORD
; procedure that draws a single-line frame
; anywhere on the screen
; Receives: pointer to frame structure
; Returns: nothing
;--------------------------------------------
	pusha

	mov si, framePtr	; pointer to frame structure

	mov ch,0	; calculate boxHeight
	mov cl,(FRAME PTR [si]).bottom
	sub cl,(FRAME PTR [si]).top
	dec cl
	mov boxHeight, cx

	mov ch, 0	; calculate boxWidth
	mov cl, (FRAME PTR [si]).right
	sub cl, (FRAME PTR [si]).left
	dec cl
	mov boxWidth,cx

	mov al, (FRAME PTR [si]).frameColor	; initialize the attribute
	mov attribute, al

	mov al, (FRAME PTR [si]).top	; set starting row,col values
	mov row, al
	mov al, (FRAME PTR [si]).left
	mov col,al

	call draw_top	; draw top of box
	inc row 	; second row of box, left side

	mov cx, boxHeight
	call draw_side	; draw left side of box

	mov al, (FRAME PTR [si]).right	; right column
	mov col, al
	mov cx, boxHeight
	call draw_side	; draw right side of box

	mov cx,boxWidth
	mov al,(FRAME PTR [si]).bottom	; lower-left row
	mov row,al
	mov al,(FRAME PTR [si]).left	; lower-left column
	mov col,al
	call draw_bottom	; draw bottom of box

	popa
	ret
DrawFrame ENDP

;--------------------------------------------
draw_side PROC
;
; Draw the side of a box, starting at position
; row,col, using CX as a counter.
; Receives: CX = counter.
; Returns: nothing
;--------------------------------------------
	mov al,row	; save the row
	push ax

DS1:
	mov al,vbar
	call Outchar
	inc row
	loop DS1

	pop ax	; restore the row
	mov row,al
	ret
draw_side ENDP

;--------------------------------------------
draw_top PROC
;
; Draw the top of the box by displaying the upper-left
; corner character, a straight line, and the upper-right
; corner character.
; Receives: nothing
; Returns: nothing
;--------------------------------------------
	mov al,col	; save the column
	push ax

	mov al,ulcorner	; lower-left corner char
	call Outchar	; display the character
	inc col

	; Draw a horizontal line.

	mov cx,boxWidth
L2:
	mov al, hbar	; horizontal bar char
	call Outchar
	inc col
	loop L2

	mov al,urcorner	; upper-right corner char
	call Outchar
	inc col

	pop ax	; restore the column
	mov col,al
	ret
draw_top ENDP

;--------------------------------------------
draw_bottom PROC
;
; Draw the bottom of the box, starting at
; row,col, with a width specified in CX.
; Receives: nothing
; Returns: nothing
;--------------------------------------------
	mov al,col	; save the column
	push ax

	mov al,llcorner	; lower-left corner char
	call Outchar
	inc col

	; Draw a horizontal line.

	mov cx,boxWidth
DB1:
	mov al,hbar
	call Outchar
	inc col
	loop DB1

	mov al,lrcorner
	call Outchar

	pop ax	; restore the column
	mov col,al
	ret
draw_bottom ENDP

;--------------------------------------------
Outchar PROC
;
; Output character at current row,col position
; Receives: AL = character to display
; Returns: nothing
;--------------------------------------------
	push bx
	push cx
	push dx

	mov dh,row
	mov dl,col
	call GotoXY	; locate cursor

	mov ah, 9	; select function 9
	mov bh, 0	; video page 0
	mov bl,attribute
	mov cx, 1	; write one time
	int 10h	; call BIOS

	pop dx
	pop cx
	pop bx
	ret
Outchar ENDP
END main