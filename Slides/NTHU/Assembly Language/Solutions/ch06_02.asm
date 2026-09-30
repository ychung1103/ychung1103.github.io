TITLE Chapter 6 Exercise 2              (ch06_02.asm)

Comment !
Description:Implement the following C++ code in assembly
language, using the block-structured .IF and .WHILE
directives. Assume that all variables are 32-bit signed
integers:

	while( op1 < op2 )
	{
	  op1++;
	  if( op2 == op3 )
	    X = 2;
	  else
	    X = 3;
	}

Last update: 05/03/2002
!
INCLUDE Irvine32.inc

.data
op1 SDWORD 10h
op2 SDWORD 20h
op3 SDWORD 30h
X   SDWORD ?

.code
main PROC

	mov eax,op1
	mov ebx,op2
	mov ecx,op3

	.WHILE eax < ebx
	  inc eax
	  .IF ebx == ecx
	    mov X,2
	  .ELSE
	    mov X,3
	  .ENDIF
	.ENDW

	mov op1,eax
	call DumpRegs

	exit
main ENDP
END main