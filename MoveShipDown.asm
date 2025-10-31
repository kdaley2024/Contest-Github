INCLUDE LimbbyLimb.inc

.code

; this procedure respawns the spaceship at top with new random X and size
MoveShipDown PROC USES eax ebx
    mov  eax, shipY
    add  eax, shipStep
    mov  shipY, eax

    cmp  eax, scrH
    jl   @done

    call SpawnShip
@done:
    ret
MoveShipDown ENDP

END
