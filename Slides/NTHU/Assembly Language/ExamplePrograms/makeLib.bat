REM makeLib.bat

REM by Kip Irvine
REM Last update: 08/28/2002

REM Creates a link library from an OBJ file.
REM Requires the 32-bit LIB.EXE program in the Microsoft Visual Studio directory.
REM (Microsoft does not supply this program with MASM.)

@ECHO OFF
cls

REM *** You must edit the following path to match your own system *****
SET EXEPATH="d:\ProgramFiles2000\Microsoft Visual Studio\VC98\BIN\LIB" 

%EXEPATH% /SUBSYSTEM:CONSOLE %1.obj

ECHO Creating the %1.LIB link library

ECHO .

:terminate
SET EXEPATH=
pause