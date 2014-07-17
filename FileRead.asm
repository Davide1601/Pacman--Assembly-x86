TITLE FileRead, Chris Cullati, November				(main.asm)

;
; 
; Revision date:

INCLUDE Irvine32.inc
.data

filename db "highscores.txt", 0
BUFFER_SIZE = 5000
buffer db BUFFER_SIZE DUP (?)
bytesRead dd ?

.code
main PROC

mov edx, OFFSET filename
call OpenInputFile
mov edx, OFFSET buffer
mov ecx, BUFFER_SIZE
call ReadFromFile
mov edx, OFFSET buffer
call WriteString
call Crlf

	exit
main ENDP
END main