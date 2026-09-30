TITLE Chapter 3 Exercise 2                   (ch03_02.asm)

Comment !
Description: Write a program that contains a definition
of each data type listed in Section 3.4. Initialize each
variable to a value that is consistent with its data type.

Last update: 05/02/2002
!

INCLUDE Irvine32.inc
.data
var1 BYTE 10h
var2 SBYTE -14
var3 WORD 2000h
var4 SWORD +2345
var5 DWORD 12345678h
var6 SDWORD -2342423
var7 FWORD 0
var8 QWORD 1234567812345678h
var9 TBYTE 1000000000123456789Ah
var10 REAL4 -1.25
var11 REAL8 3.2E+100
var12 REAL10 -6.223424E-2343

.code
main PROC

	exit
main ENDP
END main