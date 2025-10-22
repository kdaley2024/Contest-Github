INCLUDE rocketGame.inc

; 10s difficulty bump using GetTickCount
UpdateDifficulty PROC USES eax
    call GetTickCount@0
    mov  edx, lastBumpMs
    cmp  eax, edx
    jb   @skip
    mov  eax, bgSpeed
    inc  eax
    mov  bgSpeed, eax
    call GetTickCount@0
    add  eax, 10000
    mov  lastBumpMs, eax
@skip: ret
UpdateDifficulty ENDP

END
