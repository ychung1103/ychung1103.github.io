TITLE Chapter 14 Exercise 0                     (ch14_00.asm)

Comment !
Description:


Difficulty level:
Last update: 05/16/2002
!
INCLUDE Irvine16.inc

.data


.code
main PROC
	mov ax,@data	; set up DS segment
	mov ds,ax



	exit
main ENDP
END main