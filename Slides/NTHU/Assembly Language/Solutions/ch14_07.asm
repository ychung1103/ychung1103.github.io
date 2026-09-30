TITLE Chapter 14 Exercise 7                     (ch14_07.asm)

Comment !
Description: Using the Sector Display program as a starting
point, add code that lets the user press F2 to display
the current sector in hexadecimal, with 24 bytes on each
line. The offset of the first byte in
each line should be displayed at the beginning of the line.
The display will be 22 lines high with
a partial line at the end. The following is a sample of the
first two lines, to show the layout:

	0000 17311625 25425B75 279A4909 200D0655 D7303825 4B6F9234
	0018 273A4655 25324B55 273A4959 293D4655 A732298C FF2323DB
	(etc.)

Difficulty level: 5/5
Last update: 06/11/2002
!
INCLUDE Irvine16.inc

Setcursor PROTO, row:BYTE, col:BYTE
EOLN EQU <0dh,0ah>
ESC_KEY = 1Bh
DATA_ROW = 5
DATA_COL = 0
SECTOR_SIZE = 512
READ_MODE = 0		; for Function 7505h

DiskIO STRUCT
	startSector DWORD ?		; starting sector number
	numSectors  WORD 1		; number of sectors
	bufferOfs   WORD buffer		; buffer offset
	bufferSeg   WORD @DATA		; buffer segment
DiskIO ENDS

;------------------------------------------------------
mWrite MACRO text
;
; Write a string literal to standard output
; See chapter 10 for details.
;------------------------------------------------------
LOCAL string
.data		;; local data
string BYTE text,0		;; define the string
.code
	push dx
	mov  dx,OFFSET string
	call Writestring
	pop  dx
ENDM

.data
driveNumber BYTE ?
diskStruct DiskIO <>
;buffer BYTE SECTOR_SIZE DUP(0),0		    ; one sector

buffer BYTE 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,
  25,26,27,28,29,30,31,32,33,34,35,36,37,
  SECTOR_SIZE DUP(0),0		    ; one sector

curr_row   BYTE  ?
curr_col   BYTE  ?

; String resources
str1          BYTE "Sector ",0
strLine       BYTE  79 DUP(0C4h),EOLN,0
strHeading    BYTE "Sector Display Program (Sector32.exe)"
              BYTE EOLN,EOLN,0
strAskSector  BYTE "Enter starting sector number: ",0
strAskDrive   BYTE "Enter drive number (1=A, 2=B, "
	          BYTE "3=C, 4=D, 5=E, 6=F): ",0
strCannotRead BYTE EOLN,"*** Cannot read the sector. "
	          BYTE "Press any key...", EOLN, 0
strReadingSector \
	BYTE "Press Esc to quit, or any key to continue..."
	BYTE EOLN,EOLN,"Reading sector: ",0

.code
main PROC
	mov   ax,@data
	mov   ds,ax
	call  Clrscr

	mov   dx,OFFSET strHeading 			; display greeting
	call  Writestring			; ask user for...
	call  AskForSectorNumber

L1:	call  Clrscr
	call  ReadSector			; read a sector
	jc    L2                 			; quit if error
	call  DisplaySector
	call  ReadChar
	cmp   al,ESC_KEY         			; Esc pressed?
	je    Exit_prog                 		; yes: quit
	inc   diskStruct.startSector          			; next sector
	jmp   L1			; repeat the loop

L2:	mov   dx,OFFSET strCannotRead			; error message
	call  Writestring
	call  ReadChar

Exit_prog:
	;call  Clrscr
	exit
main ENDP

;-----------------------------------------------------
AskForSectorNumber PROC
;
; Prompts the user for the starting sector number
; and drive number. Initializes the startSector
; field of the DiskIO structure, as well as the
; driveNumber variable.
;-----------------------------------------------------
	pusha
	mov  dx,OFFSET strAskSector
	call WriteString
	call ReadInt
	mov  diskStruct.startSector,eax
	call Crlf
	mov  dx,OFFSET strAskDrive
	call WriteString
	call ReadInt
	mov  driveNumber,al
	call Crlf
	popa
	ret
AskForSectorNumber ENDP

;-----------------------------------------------------
ReadSector PROC
;
; Reads a sector into the input buffer.
; Receives: DL = Drive number
; Requires: DiskIO structure must be initialized.
; Returns:  If CF=0, the operation was successful;
;           otherwise, CF=1 and AX contains an
;           error code.
;-----------------------------------------------------
	pusha
	mov   ax,7305h		; ABSDiskReadWrite
	mov   cx,-1              		; always -1
	mov   dl,driveNumber		; drive number
	mov   bx,OFFSET diskStruct		; sector number
	mov   si,READ_MODE		; read mode
	int   21h               		; read disk sector
	popa
	ret
ReadSector ENDP

;-----------------------------------------------------
DisplaySector PROC
;
; Display the sector data in hexadecimal, with 24
; bytes per line. The starting offset of each line should
; appear along the left margin.
; Receives: nothing. Returns: nothing.
; Requires: buffer must contain sector data.
;-----------------------------------------------------
LINES_PER_SECTOR = 22
BYTES_PER_LINE = 24

	call  Clrscr
	mov   dx,OFFSET str1		; "Sector "
	call  WriteString
	mov   eax,diskStruct.startSector	; display sector number
	call  WriteDec
	call  Crlf
	mov   dx,OFFSET strLine    		; horizontal line
	call  WriteString

	mov   si,0    		; SI = offset into buffer
	mov   cx,LINES_PER_SECTOR		; loop counter

L1:	call  DisplayOneLine
	add   si,BYTES_PER_LINE
	loop  L1

	ret
DisplaySector ENDP

;----------------------------------------------------------
DisplayOneLine PROC uses ax cx si
LOCAL count:WORD
;
; Display a single line from a sector in hexadecimal
;----------------------------------------------------------

; Display the 16-bit offset
	mov   ax,si
	ror   ax,8		; get upper byte of offset
	call  DisplayHex
	ror   ax,8		; get lower byte of offset
	call  DisplayHex
	mWrite <20h,20h>		; two spaces

; Display the sector data, in groups of four bytes.

	mov   cx,BYTES_PER_LINE / 4		; groups of bytes per line
L1:	mov   count,0

	.REPEAT
	  mov  al,buffer[si]           	; get byte from buffer
	  call DisplayHex		; display in hexadecimal
	  inc  si
	  inc  count
	.UNTIL count == 4
	mWrite 20h		; one space

	loop  L1                		; repeat the loop
	mWrite EOLN		; end of line

	ret
DisplayOneLine ENDP

;------------------------------------------------------
DisplayHex PROC uses ax bx dx
LOCAL byteVal:BYTE
;
; Display contents of AL in hexadecimal. Techniques
; used here were explained in Chapters 6 and 7.
;------------------------------------------------------
.data
digits DB "0123456789ABCDEF"
.code
	mov bx,OFFSET digits
	mov byteVal,al

	shr al,4	; display upper digit
	xlat
	mov dl,al
	mov ah,2
	int 21h

	mov al,byteVal	; display lower digit
	and al,0Fh
	xlat
	mov dl,al
	mov ah,2
	int 21h

	ret
DisplayHex ENDP

END main