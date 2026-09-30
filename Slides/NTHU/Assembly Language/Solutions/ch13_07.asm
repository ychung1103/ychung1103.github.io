TITLE Chapter 13 Exercise 7                  (ch13_07.asm)

Comment !
Description: Enhance the file encryption program from Section
6.3.4.3 as follows:

 Prompt the user for the name of a plain text file and a cipher
  text file.
 Open the plain text file for input, and open the cipher text
  file for output.
 Let the user enter a single integer encryption code (0-255).
 Read the input file into a buffer, and exclusive-OR each byte
  with the encryption code.
 Write the buffer to the cipher text file.

The only procedure you may call from the book's link library is
ReadInt. All other input/output must be performed using INT 21h.

Suggested way to test this program:
-------------------------------------------------------------------
Run this program once, reading "infile.txt" and producing
a cipher text file named "out.txt". Run the program a second time,
reading "out.txt" and producing "new.txt". If you use the same
encryption key both times you run the program, you will find
that "new.txt" is identical to "infile.txt".
-------------------------------------------------------------------

Difficulty level: 5/5
Last update: 05/15/2002
!
INCLUDE Irvine16.inc

ReadLine PROTO,
	bufPtr:PTR BYTE

ShowMessage PROTO,
	pString:PTR BYTE

BUFFER_SIZE = 10000

.data
inputFile  BYTE 60 DUP(0)
outputFile BYTE 60 DUP(0)
inHandle  WORD ?
outHandle WORD ?
encryptByte  BYTE ?
buffer    BYTE BUFFER_SIZE DUP(?)
bytesRead WORD ?
str1 BYTE "Enter name of input file: $"
str2 BYTE "Enter name of ouput file: $"
str3 BYTE "Enter encryption byte value (0-255): $"
str5 BYTE "Error: Cannot open input file.",0dh,0ah,"$"
str6 BYTE "Error: Cannot create output file.",0dh,0ah,"$"

.code
main PROC
	mov ax,@data
	mov ds,ax

; Try to open the input file
	call Open_Input_File
	.IF Carry?
	  INVOKE ShowMessage,ADDR str5
	  jmp Exit_prog
	.ENDIF

; Try to create the output file
	call Create_Output_File
	.IF Carry?
	  INVOKE ShowMessage, ADDR str6
	  jmp Exit_prog
	.ENDIF

; Ask user for encryption byte value
	INVOKE ShowMessage,ADDR str3
	call ReadInt	; Read the byte
	mov  encryptByte,al
	call EndLine

; Read, encrypt, and write the data
	call Read_and_Encrypt

; Close both files
Close_Files:
	mov  ah,3Eh    	; function: close file
	mov  bx,inHandle	; input file handle
	int  21h       	; call MS-DOS
	mov  ah,3Eh    	; function: close file
	mov  bx,outHandle	; cipher file handle
	int  21h       	; call MS-DOS

Exit_prog:
	exit
main ENDP

;--------------------------------------------------
Open_Input_File PROC
;
; Ask user for name of the input file and attempt
; to open the file.
; Receives: nothing
; Returns: CF=1 if the file could not be opened
;--------------------------------------------------
	pusha

; Ask user for name of input file
	INVOKE ShowMessage, ADDR str1
	INVOKE ReadLine,ADDR inputFile

; Attempt to open the input file
	mov ax,716Ch   	; extended create or open
	mov bx,0      	; mode = read-only
	mov cx,0	; normal attribute
	mov dx,1	; action: open
	mov si,OFFSET inputFile	; filename
	int 21h       	; call MS-DOS
	mov inHandle,ax	; save handle

	popa
	ret
Open_Input_File ENDP

;--------------------------------------------------
Create_Output_File PROC
;
; Ask user for name of the output file and attempt
; to create the file.
; Receives: nothing
; Returns: CF=1 if the file could not be created
;--------------------------------------------------
	pusha

; Ask user for name of output file
	INVOKE ShowMessage, ADDR str2
	INVOKE ReadLine,ADDR outputFile

; Attempt to create the output file
	mov  ax,716Ch   	; extended create or open
	mov  bx,1      	; mode = write-only
	mov  cx,0	; normal attribute
	mov  dx,12h	; action: create/truncate
	mov  si,OFFSET outputFile
	int  21h       	; call MS-DOS
	mov  outHandle,ax	; save handle

	popa
	ret
Create_Output_File ENDP

;-----------------------------------------------------
Read_and_Encrypt PROC
;
; Read the input file into a buffer, encrypt the data,
; and write the buffer to the output file.
; Receives: nothing
; Returns: CF=1 if the buffer could not be read
;-----------------------------------------------------
	pusha

	mov  ah,3Fh	; read file or device
	mov  bx,inHandle	; file handle
	mov  cx,BUFFER_SIZE	; max bytes to read
	mov  dx,OFFSET buffer	; buffer pointer
	int  21h
	jc   Exit_proc	; quit if error
	mov  bytesRead,ax

; Encrypt the buffer
	mov  si,OFFSET buffer
	mov  cx,bytesRead

L1:	mov  al,encryptByte	; get encrypt code
	xor  [si],al	; encrypt the byte
	inc  si
	loop L1	; repeat the loop

; Write the buffer to the output file
	mov ah,40h	; write file or device
	mov bx,outHandle	; output file handle
	mov cx,bytesRead	; number of bytes
	mov dx,OFFSET buffer	; buffer pointer
	int 21h

Exit_proc:
	popa
	ret
Read_and_Encrypt ENDP

;---------------------------------------------
EndLine PROC uses ax dx
;
; Display an end of line sequence
; Receives: nothing
; Returns:  nothing
;---------------------------------------------
.data
eolnStr BYTE 0dh,0ah,'$'
.code
	mov ah,9
	mov dx,OFFSET eolnStr
	int 21h

	ret
EndLine ENDP

;--------------------------------------------------------
ReadLine PROC uses ax si,
	bufPtr:PTR BYTE
;
; Reads a line of text from standard input until the
;   0Dh character is found. Inserts a null terminator
;   byte at the end of the string.
; Receives: pointer to input buffer
; Returns: nothing
;--------------------------------------------------------
	mov  si,bufPtr		; point to input buffer

L1:	mov  ah,1		; function: keyboard input
	int  21h		; AL = character
	cmp  al,0Dh		; end of line?
	je   Exit_proc		; yes: exit
	mov  [si],al		; no: store the character
	inc  si		; increment buffer pointer
	jmp  L1		; loop again

Exit_proc:
	mov  byte ptr [si],0		; insert null byte
	call EndLine
	ret
ReadLine ENDP

;-------------------------------------------
ShowMessage PROC uses ax dx,
	pString:PTR BYTE
;
; Display a string on the console, using
; INT 21h Function 9.
;-------------------------------------------
	mov  ah,9
	mov  dx,pString
	int  21h
	ret
ShowMessage ENDP


END main