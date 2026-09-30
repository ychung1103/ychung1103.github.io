TITLE Chapter 14 Exercise 2                     (ch14_02.asm)

Comment !
Description: Write a procedure named Get_DiskSize that returns
the amount of total data space on a selected disk drive. Input:
AL = drive number (0 = A, 1 = B, 2 = C, ...). Output: EDX:EAX =
drive space, in bytes.

Difficulty level: 3/5
Last update: 06/11/2002
!
INCLUDE Irvine16.inc

.data
buffer ExtGetDskFreSpcStruc <>
driveName BYTE 0,":\",0
str1 BYTE "Disk size, in bytes (hexadecimal): ",0

.code
main PROC
	mov ax,@data	; set up DS segment
	mov ds,ax
	mov es,ax

	mov al, 2	; drive C
	call Get_DiskSize

	push edx
	mov  dx,OFFSET str1
	call WriteString
	pop  edx

	push eax
	mov  eax,edx
	call WriteHex
	pop  eax
	call WriteHex
	call Crlf

	exit
main ENDP

;-------------------------------------------
Get_DiskSize PROC USES ecx esi edi
;
; procedure that returns the amount
; of total data space on a selected disk drive
; Receives: AL = drive number (0 = A, 1 = B, 2 = C, ...)
; Returns:  EDX:EAX = data space, in bytes.
;           CF = 1, if error ocurred
;-------------------------------------------

	add al, 41h	; convert number to char
	mov si, OFFSET driveName
	mov [si], al	; store drive name

	mov buffer.Level,0	; must be zero
	mov di, OFFSET buffer	; ES:DI points to buffer
	mov cx, SIZEOF buffer	; buffer size
	mov dx, OFFSET DriveName	; ptr to drive name
	mov ax, 7303h	; Get disk free space
	int 21h
	jc error	; Failed if CF = 1

	; Total space = (SectorsPerCluster * 512 * TotalClusters)
	mov eax, buffer.SectorsPerCluster
	shl eax, 9	; mult by 512
	mov ecx, buffer.TotalClusters
	mul ecx	; EDX:EAX = ECX * EAX
	jmp quit
error:
	stc	; CF = 1, if error ocurred
quit:
	ret
Get_DiskSize ENDP
END main