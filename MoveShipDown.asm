INCLUDE rocketGame.inc

MoveShipDown PROC USES eax ebx
    mov  eax, shipY
    add  eax, shipStep
    mov  shipY, eax

    cmp  eax, scrH
    jl   @done

    ; respawn at top with new random X and size/HP
    call SpawnShip
@done:
    ret
MoveShipDown ENDP
