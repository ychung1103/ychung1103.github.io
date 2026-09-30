TITLE Chapter 15 Exercise 1                  (ch15_01.asm)

Comment !
Description: Using INT 10h, display all 256 characters from the
IBM Extended ASCII character set (inside back cover of the book).
Display 40 columns per line, with a space following each character.

Difficulty level: 2/5
Last update: 05/20/2002
!
INCLUDE Irvine16.inc

.data

.code
main PROC
	mov ax,@data	; set up DS segment
	mov ds,ax

	call Clrscr

	mov bh,0	; video page 0
	mov dh,0	; row 0
	mov dl,0	; column 0
	mov cx,0	; char counter

L1: push cx	; save counter
	mov ah, 2	; set cursor position
	int 10h	; call BIOS

	mov ah,0Ah	; write character
	mov al,cl	; AL = char to display
	mov cx,1	; display only once
	int 10h	; call BIOS

	.IF dl >= 39	; then line is complete
	  mov dl,0	; reset column
	  inc dh	; go to next row
	.ELSE	; line is not complete
	  inc dl	; go to next column
	  mov ah, 2	; set cursor position
	  int 10h	; call BIOS
	  mov ah,0Ah	; write character
	  mov al,' '	; AL = char to display
	  mov cx,1	; display only once
	  int 10h	; call BIOS
	  inc dl	; go to next column
	.ENDIF

	pop cx	; restore counter
	inc cx	; next char
	cmp cx,256	; is counter >= 256
	jae quit	; if true, quit
	jmp L1	; else, loop

quit:
	call Crlf
	exit
main ENDP
END main