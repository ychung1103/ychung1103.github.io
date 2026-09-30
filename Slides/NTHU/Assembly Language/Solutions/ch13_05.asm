TITLE Chapter 13 Exercise 5                  (ch13_05.asm)

Comment !
Description: Write a procedure that displays the date when a
file was created, along with its filename. Write a test program
that demonstrates the procedure with several different filenames,
including extended filenames. If a file cannot be found, display
an appropriate error message. Optional: Use the DecodeDate
procedure from the preceding exercise as a starting point for this
program.

Difficulty level:
Last update: 05/14/2002
!
INCLUDE Irvine16.inc
OPEN_ACCESS_READWRITE = 0002h
NORMAL    = 0
FILE_OPEN =1

DecodeDate PROTO, binval:WORD, pmonth:PTR WORD,
	pday:PTR WORD, pyear:PTR WORD

DisplayDate PROTO, month:WORD, day:WORD, year:WORD

ShowCreationDate PROTO, pFileName:PTR BYTE

.data
file1 BYTE "long_filename.txt",0
file2 BYTE "hello.asm",0
file3 BYTE "ch13_05.asm",0

.code
main PROC
	mov  ax,@data
	mov  ds,ax
	INVOKE ShowCreationDate, ADDR file1
	INVOKE ShowCreationDate, ADDR file2
	INVOKE ShowCreationDate, ADDR file3

	exit
main ENDP

;-----------------------------------------------------
ShowCreationDate PROC,
	pFileName:PTR BYTE
;
; Given a file specifier, display the date when the
; file was created. If the file cannot be found,
; display an error message.
;-----------------------------------------------------
.data
gmonth   WORD ?
gday     WORD ?
gyear    WORD ?
handle   WORD ?
str1     BYTE " was created on ",0
str2     BYTE "Cannot open file: ",0
.code
	mov  ax,716Ch		; Extended Open/Create
	mov  bx,OPEN_ACCESS_READWRITE	; mode and flags
	mov  cx,NORMAL      		; attribute
	mov  dx,FILE_OPEN		; action to take
	mov  si,pFilename		; filename
	int  21h
	jc   error		; quit if error
	mov  handle,ax        	; file handle

	; Input: BX=handle
	mov ax,5706h	; Get Creation date/time
	mov bx,handle
	int 21h	; DX = date
	jc  error
	mov ah,3Eh	; close file handle
	mov bx,handle
	int 21h

	INVOKE DecodeDate,
	  DX,
	  ADDR gmonth,
	  ADDR gday,
	  ADDR gyear

	; Display filename and creation date.
	mov  dx,pFileName
	call WriteString
	mov  dx,OFFSET str1
	call WriteString
	INVOKE DisplayDate, gmonth, gday, gyear

	jmp  quit

error:	; cannot open file
	mov  dx,OFFSET str2
	call WriteString
	mov  dx,pFileName
	call WriteString
	call Crlf
quit:
	ret
ShowCreationDate ENDP


;-----------------------------------------------------
DecodeDate PROC,
	binval:WORD,	; compessed date
	pmonth:PTR WORD,	; ptr to month
	pday:PTR WORD,	; ptr to day
	pyear:PTR WORD	; ptr to year
;
; Extracts the month, day, and year from a compressed
; date stamp field.
; Output: sets values of day, month, year
;-----------------------------------------------------
	mov   ax,binval
	and   ax,001Fh          	; clear bits 5-15
	mov   si,pday
	mov   [si],ax
	mov   ax,binval             ; get the month
	shr   ax,5              	; shift right 5 bits
	and   ax,000Fh          	; clear bits 4-15
	mov   si,pmonth
	mov   [si],ax
	mov   ax,binval             ; get the year
	shr   ax,9              	; shift right 9 bits
	add   ax,1980           	; year relative to 1980
	mov   si,pyear
	mov   [si],ax
	ret
DecodeDate endp

;------------------------------------------------
DisplayDate PROC,
	month:WORD, day:WORD, year:WORD
;
; Displays a date on the console, in the
; m-d-yyyy format.
; Receives: month, day, year
; Returns: nothing
;------------------------------------------------
 	mov  ax,month
 	call WriteDec
	mov  ah,2
	mov  dl,'-'
	int  21h
	mov  ax,day
	call WriteDec
	mov  ah,2
	mov  dl,'-'
	int  21h
	mov  ax,year
	call WriteDec
	call Crlf
	ret
DisplayDate endp

END main