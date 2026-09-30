TITLE Chapter 14 Exercise 1                     (ch14_01.asm)

Comment !
Description: Write a procedure that prompts the user for a
disk drive letter (A, B, C, or D), and then sets the default
drive to the user's choice.

Difficulty level: 1/5
Last update: 06/11/2002
!
INCLUDE Irvine16.inc

; Drive letters are: A=0, B=1, C=2, etc.

.data
str1 BYTE "Enter a drive letter (A, B, C, ...): ",0
driveLetter BYTE ?,0

.code
main PROC
	mov ax,@data	; set up DS segment
	mov ds,ax

	call setDefaultDrive

	exit
main ENDP

;--------------------------------------------
setDefaultDrive PROC USES ax cx dx
;
; procedure that prompts the user for a
; disk drive letter (A, B, C, or D),
; and then sets the default
; drive to the user's choice.
; Receives: nothing
; Returns: nothing
;--------------------------------------------

	mov dx, OFFSET str1
	call WriteString

	mov dx,OFFSET driveLetter
	mov cx,1
	call ReadString

	and driveLetter, 00001111b	; convert char to number
	dec driveLetter	; drive A starts with 0

	mov ah, 0Eh	; set default drive function
	mov dl, driveLetter	; number of drive selected
	int 21h	; call DOS

	ret
setDefaultDrive ENDP
END main