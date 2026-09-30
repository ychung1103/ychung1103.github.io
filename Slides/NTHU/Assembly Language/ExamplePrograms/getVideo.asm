TITLE Get Video Information              (getVideo.asm)

; Copyright Kip Irvine 2002. All rights reserved.
;
; This program retrieves information about the current video
; display mode as well as a pointer to a table describing the
; characteristics and capabilities of the video display adapter
; and monitor. Information about INT 10h function 1Bh was found
; in Ray Duncan's book, Advanced MS-DOS 2nd Edition, pages 531-532.
; Last update: 4/14/02

.model small
.stack 100h

CursorPosStruc STRUCT
	Ycoord DB ?
	Xcoord DB ?
CursorPosStruc ENDS

VideoInfoStruc STRUC
	supportedInfoPtr     DD ?
	videoMode            DB ?
	numCharColumns       DW ?
	videoBufferLen       DW ?
	videoBufferStartPtr  DW ?
	cursors CursorPosStruc 8 DUP(<>)	; video pages 0-7
	cursorStartLine      DB ?
	cursorEndLine        DB ?
	activeDisplayPage    DB ?
	adapterBasePortAddr  DW ?
	currentRegister3B8or3D8 DB ?
	currentRegister3B9or3D9 DB ?
	numCharRows          DB ?
	characterScanHeight  DW ?
	activeDisplayCode    DB ?
	inactiveDisplayCode  DB ?
	numberOfColors       DW ?
	numberOfVideoPages   DB ?
	numberOfScanLines    DW ?
	primaryCharBlock     DB ?
	secondaryCharBlock   DB ?
	miscStateInfo        DB ?
	                     DB 3 dup(?)
	videoMemAvail        DB ?
	savePointerStateInfo DB ?
	                     DB 13 dup(?)
VideoInfoStruc ENDS

.data
videoInfo VideoInfoStruc <>
str1 DB "Video function 1Bh is not supported",0dh,0ah,0

.code
extrn WriteString:proc, WriteInt:proc, ClrScr:proc, Crlf:proc
main PROC
	mov  ax,@data
	mov  ds,ax
	call ClrScr

	mov ah,1Bh
	mov bx,0	; always zero
	push ds
	pop  es
	mov  di,OFFSET videoInfo
	int 10h
	cmp al,1Bh
	jne notSupported

	mov ah,0
	mov al,videoInfo.numCharRows
	mov bx,10
	call WriteInt
	call Crlf

	mov ax,videoInfo.numCharColumns
	mov bx,10
	call WriteInt
	call Crlf
	jmp  finished

notSupported:
	mov dx,OFFSET str1
	call WriteString

finished:
	.exit
main ENDP
END main
