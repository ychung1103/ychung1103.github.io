TITLE Chapter 14 Exercise 4                (ch14_04.asm)

Comment !
Description: Write a procedure that creates a hidden
directory named \tempx. Use the DIR command to verify
its hidden status.

Difficulty level: 1/5
Last update: 06/11/2002
!
INCLUDE Irvine16.inc

.data
pathName BYTE ".\tempx",0

.code
main PROC
	mov ax,@data	; set up DS segment
	mov ds,ax

	call Create_Temp_Dir

	exit
main ENDP

;----------------------------------------------------
Create_Temp_Dir PROC USES ax dx
;
; procedure that creates a hidden directory named temp
; Receives: nothing
; Returns:  nothing
;----------------------------------------------------

	mov ah, 39h	; select create directory function
	mov dx, OFFSET pathName
	int 21h	; call DOS

	mov cx, 00000010b	; sets bits for hidden file
	mov ax, 4301h	; select set file attributes function
	int 21h	; call DOS

	ret
Create_Temp_Dir ENDP
END main