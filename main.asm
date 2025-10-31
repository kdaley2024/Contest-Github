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

limbMask        DWORD 0Fh

stickHead   BYTE "O",0
stickBody   BYTE "|",0
stickArms   BYTE "/-",0

shipX       SDWORD 70
shipY       SDWORD 1
shipType    DWORD 0
shipStep    DWORD 1

bgSpeed2x   DWORD 2

.code
main PROC PUBLIC
    call Clrscr
    call Randomize

    call GetTickCount@0
    add  eax, 15000
    mov  lastBumpMs, eax

    call SpawnShip

    call DrawShip
    call DrawHUD
    call DrawPlayer

exitGame:
    call Clrscr
    INVOKE ExitProcess, 0
main ENDP
END main
