TITLE Chapter 14 Exercise 5                     (ch14_05.asm)

Comment !
Description: Disk Free Space, in Clusters

Modify the Disk Free Space program from Section 14.5.1.1
so that it displays the following information:
	Drive specification: "C:\"
	Bytes per sector: 512
	Sectors per cluster: 8
	Total Number of clusters: 999999
	Number of available clusters: 99999

Difficulty level: 2/5
Last update: 06/11/2002
!
INCLUDE Irvine16.inc

.data
buffer ExtGetDskFreSpcStruc <>
driveName BYTE "C:\",0
str1 BYTE "Drive specification: ",0
str2 BYTE "Bytes per sector: ",0
str3 BYTE "Sectors per cluster: ",0
str4 BYTE "Total Number of clusters: ",0
str5 BYTE "Number of available clusters: ",0
str6 BYTE "Function call failed.",0dh,0ah,0

.code
main PROC
	mov ax,@data	; set up DS, ES segment
	mov ds,ax
	mov es,ax

	mov buffer.Level,0	; must be zero
	mov di, OFFSET buffer	; ES:DI points to buffer
	mov cx, SIZEOF buffer	; buffer size
	mov dx, OFFSET DriveName	; ptr to drive name
	mov ax, 7303h	; Get disk free space
	int 21h
	jc error	; Failed if CF = 1

	mov dx, OFFSET str1	; drive specification
	call WriteString
	mov dx, OFFSET driveName
	call WriteString
	call Crlf

	mov  dx,OFFSET str2	; bytes per sector
	call WriteString
	mov eax, buffer.bytesPerSector
	call WriteDec
	call Crlf

	mov dx,OFFSET str3	; sectors per cluster
	call WriteString
	mov eax, buffer.sectorsPerCluster
	call WriteDec
	call Crlf

	mov  dx,OFFSET str4	; total number of clusters
	call WriteString
	mov eax, buffer.totalClusters
	call WriteDec
	call Crlf

	mov dx,OFFSET str5	; Number of available clusters
	call WriteString
	mov eax, buffer.availableClusters
	call WriteDec
	call Crlf

	jmp quit
error:
	mov dx,OFFSET str6
	call WriteString
quit:
	exit
main ENDP
END main