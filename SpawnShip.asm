INCLUDE LimbbyLimb.inc
.code
SpawnShip PROC
    ;generates a random ship type
    mov  eax, 3   ; sets upper limit for range
    call RandomRange ; gets a random number within range
    mov  shipType, eax


    mov  eax, shipType
    cmp  eax, 0
    je   @small
    cmp  eax, 1
    je   @med
    mov  eax, 3
    jmp  @sizeDone
@med:
    mov  eax, 2
    jmp  @sizeDone
@small:
    mov  eax, 1
@sizeDone:
   ; randomly select ship position on the screen
    mov  eax, scrW
    sub  eax, 12
    call RandomRange
    add  eax, 3
    mov  shipX, eax

    ; sets the initial Y position
    mov  eax, 1
    mov  shipY, eax

    mov  eax, 0
    ret
SpawnShip ENDP

END