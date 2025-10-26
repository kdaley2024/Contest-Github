INCLUDE rocketGame.inc

; 15s difficulty bump using GetTickCount
UpdateDifficulty PROC USES eax
    call GetTickCount@0
    mov  edx, lastBumpMs
    cmp  eax, edx
    jb   @skip
    mov  eax, bgSpeed2x
    inc  eax
    mov  bgSpeed2x, eax

    mov  eax, level
    inc  eax
    mov  level, eax

    call GetTickCount@0
    add  eax, 15000
    mov  lastBumpMs, eax
@skip: 
    ret
UpdateDifficulty ENDP

END
