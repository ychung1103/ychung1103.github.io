@echo off
REM asm16.bat
REM Revised 2/1/02

REM Assemble the current source file (do not link). This batch file is
REM useful when making modifications to Irvine16.asm. After running this
REM file, run the makeLib.bat file to update the Irvine16.lib library.
REM 
REM Command-line options (unless otherwise noted, they are case-sensitive):
REM 
REM /nologo	Suppress the Microsoft logo
REM -c		Assemble only (do not link)
REM -Zi		Include source code line information for debugging
REM -Fl		Generate a listing file (see page 88)

REM ************* The following lines can be customized:
PATH C:\Masm615
SET INCLUDE=C:\Masm615\INCLUDE
REM **************************** End of customized lines

REM Invoke ML.EXE (the assembler):

ML /nologo -c -Fl -Zi Irvine16.asm
