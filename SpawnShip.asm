INCLUDE rocketGame.inc

.code
SpawnShip PROC
    mov  eax, 3
    call RandomRange
    mov  shipType, eax

    mov  eax, scrW
    sub  eax, 12
    call RandomRange
    add  eax, 3
    mov  shipX, eax

    mov  shipY, 1
    ret
SpawnShip ENDP

END
