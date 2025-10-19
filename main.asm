; Demonstrates different procedure call protocols.
INCLUDE rocketGame.inc

.code
main PROC PUBLIC

    ;call    Example1
    ;call    Example2

    gameLoop:
    call Clrscr
    ;call CheckKeys
    ;call ApplyGravity
    ;call DrawObstacles
    ;call DrawShip
    ;call UpdateBullets
    ;call DrawHUD
    call DrawPlayer
    ;call UpdateDifficulty
    ;push frameDelay
    ;call Sleep@4
    jmp  gameLoop
    ;call    DumpRegs

    ;exit
    invoke ExitProcess, 0

main ENDP

END main
