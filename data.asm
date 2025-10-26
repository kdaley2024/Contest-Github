INCLUDE rocketGame.inc

.data

titleMsg    BYTE    "Trip in our Fav Rocketship",0
lvlLbl      BYTE    " Level: ",0

; ---------- player ----------
stickX      DWORD   6
stickY      DWORD   18           


; ---------- spaceship ----------
shipX       SDWORD  70
shipY       SDWORD  6
shipType    DWORD   0            ; 0 small(1HP), 1 med(2HP), 2 big(3HP)

; ---------- obstacles / background ----------
bgSpeed2x     DWORD   2           
lastBumpMs  DWORD   0            ; next difficulty bump time (ms)
shipAcc DWORD   0
shipStep    DWORD   1

; ---------- timing ----------
frameDelay  DWORD   30        
limbMask        DWORD   0Fh
nextDamageIdx   DWORD   0
playerIFrames   DWORD   0
playerFlash     DWORD   0
damageOrder     DWORD   4, 8, 2, 1
gravAcc         DWORD   0
vInput          DWORD   0
level           DWORD   1

; strings
stickHead   BYTE    "O",0
stickBody   BYTE    "|",0
stickArms   BYTE    "/-",0
stickLegs   BYTE    "/ \",0

;colors
BLACK       EQU 0
WHITE       EQU 15
LIGHTRED    EQU 12
LIGHTCYAN   EQU 11
H_STEP      EQU 2

END
