INCLUDE LimbbyLimb.inc

scrW        EQU 80
scrH        EQU 25
BLACK       EQU 0
WHITE       EQU 15
LIGHTRED    EQU 12
LIGHTCYAN   EQU 11
H_STEP      EQU 2

.data

titleMsg    BYTE "Limb by Limb",0
lvlLbl      BYTE " Level: ",0
level           DWORD 1
lastBumpMs  DWORD 0

stickX      DWORD 6
stickY      DWORD 18

frameDelay      DWORD 30
limbMask        DWORD 0Fh

stickHead   BYTE "O",0
stickBody   BYTE "|",0
stickArms   BYTE "/-",0
stickLegs   BYTE "/ \",0

shipX       SDWORD 70
shipY       SDWORD 1
shipType    DWORD 0
shipStep    DWORD 1
shipAcc     DWORD 0

bgSpeed2x   DWORD 2
playerIFrames   DWORD 0
nextDamageIdx   DWORD 0
damageOrder     DWORD 4, 8, 2, 1
playerFlash     DWORD 0




.code
main PROC PUBLIC
;wipes the screen clean
    call Clrscr
;get random numbers ready
    call Randomize
;get the time now in ms
    call GetTickCount@0
;add 15 seconds
    add  eax, 15000
;remember when to make it harder
    mov  lastBumpMs, eax
;make the first ship
    call SpawnShip

gameLoop:
;if chosen to quit, leave the game
    cmp  bgSpeed2x, 0FFFFFFFFh
    je   exitGame
;clear the screen for a new frame
    call Clrscr
;read arrow keys/ESC
    call CheckKeys
;turn speed into a step size
    call UpdateSteps
;move the ship down
    call MoveShipDown
;checks if the ship hits the player
    call CheckPlayerShipCollision

;checks if the player still flashing red
    cmp  playerFlash, 0
    jle  @noflash
;count down the flash
    dec  playerFlash
@noflash:
;checks if the player is invincible
    cmp  playerIFrames, 0
    jle  @noifr
;counts down the invinvibility
    dec  playerIFrames
@noifr:

;draw the ship
    call DrawShip
;draw the title and the level headers
    call DrawHUD
;draw the stickman
    call DrawPlayer
;make the game harder over time
    call UpdateDifficulty
    
;how long to pause the frame
    push frameDelay
;pause so it doesn't run too fast
    call Sleep@4

;do the next frame
    jmp  gameLoop

exitGame:
;clear the screen
    call Clrscr
;close the program
    INVOKE ExitProcess, 0
main ENDP
END main
