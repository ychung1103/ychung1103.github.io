TITLE Chapter 13 Exercise 1                       (ch13_01.asm)

Comment !
Description: Open a file for input, read the file, and display its
contents on the screen in Hexadecimal. Make the input buffer smaller
than the file and use a loop to repeat the call to Function 3Fh as
many times as necessary until the entire file has been processed.

Implementation note: We will borrow code from the ReadFile program
in Section 13.3.4, and use DumpMem from the link library to
display the buffer.

Difficulty level: 2/5
Last update: 05/14/2002
!
INCLUDE Irvine16.inc

.data
BufSize = 256
infile    BYTE "infile.txt",0
inHandle  WORD ?
buffer    BYTE BufSize DUP(?)
bytesRead WORD ?

.code
main PROC
    mov  ax,@data
    mov  ds,ax

; Open the input file
	mov ax,716Ch   	; extended create or open
	mov bx,0      	; mode = read-only
	mov cx,0	; normal attribute
	mov dx,1	; action: open
	mov si,OFFSET infile
	int 21h       	; call MS-DOS
	jc  quit	; quit if error
	mov inHandle,ax

Read_File_Into_Buffer:
	mov ah,3Fh	; read file or device
	mov bx,inHandle	; file handle
	mov cx,BufSize	; max bytes to read
	mov dx,OFFSET buffer	; buffer pointer
	int 21h
	jc  Close_File	; quit if error
	cmp ax,0	; end of file?
	je  Close_File	; yes: close the file
	mov bytesRead,ax

; Display the buffer in hexadecimal
	mov esi,OFFSET buffer	; address of buffer
	movzx ecx,bytesRead	; number of units to display
	mov  ebx,1	; unit size (byte)
	call DumpMem

	jmp Read_File_Into_Buffer	; read more data

Close_File:
	mov  ah,3Eh    	; function: close file
	mov  bx,inHandle	; input file handle
	int  21h       	; call MS-DOS

quit:
	call Crlf
    exit

main ENDP
END main