TITLE Chapter 14 Exercise 3                     (ch14_03.asm)

Comment !
Description: Write a procedure named Get_DiskFreespace
that returns the amount of free space on a selected disk
drive. Input: DS:DX points to a string containing the drive
specifier. Output: EDX:EAX = disk free space, in bytes.
Write a program that tests the procedure and displays the
64-bit result in hexadecimal.

Difficulty level: 3/5
Last update: 06/11/2002
!
INCLUDE Irvine16.inc

.data
buffer ExtGetDskFreSpcStruc <>
driveName BYTE "C:\",0
str1 BYTE "Free space of drive ",0
str2 BYTE " is: ",0

.code
main PROC
	mov ax,@data	; set up DS, ES segment
	mov ds,ax
	mov es,ax

	mov dx, OFFSET driveName
	call Get_DiskFreespace

	push eax	; save result
	push edx

	mov dx, OFFSET str1
	call WriteString
	mov dx, OFFSET driveName
	call WriteString
	mov dx, OFFSET str2
	call WriteString

	pop edx
	mov eax, edx	; EAX = high 32 bits of disk free space
	call WriteHex
	pop eax	; EAX = low 32 bits of disk free space
	call WriteHex

	call Crlf
	exit
main ENDP

;-------------------------------------------
Get_DiskFreespace PROC USES cx di
;
; procedure named Get_DiskFreespace that returns
; the amount of free space on a selected disk drive.
; Receives: DS:DX = drive specifier
; Returns:  EDX:EAX = disk free space in bytes.
;           CF = 1, if error ocurred
;-------------------------------------------

	mov buffer.Level,0		; must be zero
	mov di, OFFSET buffer		; ES:DI points to buffer
	mov cx, SIZEOF buffer		; buffer size
	mov ax, 7303h		; Get disk info
	int 21h
	jc error			; Failed if CF = 1

	; Total space = (SectorsPerCluster * 512 * AvailableClusters)
	mov eax, buffer.SectorsPerCluster
	shl eax, 9	; multiply by 512
	mul buffer.AvailableClusters	; EDX:EAX = disk free space

	jmp  quit
error:
	stc	; CF = 1, if error ocurred
quit:
	ret
Get_DiskFreespace ENDP
END main