INCLUDE LimbbyLimb.inc
.code

; Helper procedure that prints a single character at a specific x, y
; coordinate on the console using Irvine32 library.

PutChAt PROC USES eax edx, character:BYTE, x:DWORD, y:DWORD
    mov   dl, BYTE PTR x
    mov   dh, BYTE PTR y
    call  Gotoxy
    mov   al, character
    call  WriteChar
    ret
PutChAt ENDP

END
