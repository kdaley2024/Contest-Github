INCLUDE LimbbyLimb.inc
.code
SpawnShip PROC
    ;generates a random ship type
    mov  eax, 3   ; sets upper limit for range
    call RandomRange ; gets a random number within range
    mov  shipType, eax
    mov  eax, shipType
    
    ret
SpawnShip ENDP

END