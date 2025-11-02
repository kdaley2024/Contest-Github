INCLUDE LimbbyLimb.inc

;this procedure increases the difficulty of the game making the spaceships appear and fall on the screen faster
.code
UpdateDifficulty PROC USES eax
    ;WIN API that was learnt from the textbook
    call GetTickCount@0
    mov  edx, lastBumpMs
    cmp  eax, edx
    jb   @skip

    ; +0.5 speed step
    mov  eax, bgSpeed2x
    inc  eax
    mov  bgSpeed2x, eax

    ;the level increases which means that the number with the title level will increase in the HUD
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
