; Demonstrates different procedure call protocols.
INCLUDE rocketGame.inc

.code
main PROC PUBLIC

    call Clrscr
    call Randomize

    call GetTickCount@0
    add  eax, 15000
    mov  lastBumpMs, eax

    call SpawnShip

    gameLoop:

    cmp  bgSpeed2x, 0FFFFFFFFh
    je   exitGame

    call Clrscr
   
    call CheckKeys
    call ApplyGravity
    call UpdateSteps
    call MoveShipDown
    call CheckPlayerShipCollision

    cmp  playerFlash, 0
    jle  @noflash
    dec  playerFlash
@noflash:
    cmp  playerIFrames, 0
    jle  @noifr
    dec  playerIFrames
@noifr:
    call DrawShip
    call DrawHUD
    call DrawPlayer
    ;call UpdateDifficulty
    ;push frameDelay
    jmp  gameLoop
    ;call    DumpRegs

    ;exit
    invoke ExitProcess, 0

main ENDP

END main
