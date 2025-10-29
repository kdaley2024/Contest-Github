INCLUDE LimbbyLimb.inc
.code

DrawHUD PROC USES eax edx
    mov  dl, 0
    mov  dh, 0
    call Gotoxy
    mov  edx, OFFSET titleMsg
    call WriteString

    mov  dl, 0
    mov  dh, 1
    call Gotoxy
    mov  edx, OFFSET lvlLbl
    call WriteString
    mov  eax, level
    call WriteDec
    ret
DrawHUD ENDP

END