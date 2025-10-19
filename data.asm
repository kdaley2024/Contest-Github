INCLUDE rocketGame.inc

.data

titleMsg    BYTE    "Trip in our Fav Rocketship",0
scoreLbl    BYTE    "Score: ",0
hpLbl       BYTE    " Ship HP: ",0
diffLbl     BYTE    "  Speed: ",0

; ---------- player / aim ----------
stickX      DWORD   6
stickY      DWORD   18           
jumpStep    DWORD   2
jumpTimerMs DWORD   0            ; for double-jump detection
jumpWindow  DWORD   180          ; ms to allow a second UP for double jump
isDucking   DWORD   0
aimDeg      SDWORD  90           ; 0 to 180 degrees

; ---------- bullets ----------
bulX        DWORD   MAX_BUL DUP(0)
bulY        DWORD   MAX_BUL DUP(0)
bulVX       SDWORD  MAX_BUL DUP(0)
bulVY       SDWORD  MAX_BUL DUP(0)
bulLive     DWORD   MAX_BUL DUP(0)

; ---------- spaceship ----------
shipX       SDWORD  70
shipY       SDWORD  6
shipType    DWORD   0            ; 0 small(1HP), 1 med(2HP), 2 big(3HP)
shipHP      DWORD   1
hitFlash    DWORD   0            ; frames of flash after hit

; ---------- obstacles / background ----------
bgSpeed     DWORD   1            ; increases every 10s
lastBumpMs  DWORD   0            ; next difficulty bump time (ms)
obsX        SDWORD  30, 45, 60   ; three moving pillars
obsGapY     DWORD   15, 10, 12   ; gap center rows
obsGapH     DWORD   5,  4,  6     ; half-gap heights

; ---------- timing ----------
score       DWORD   0
frameDelay  DWORD   30           

; strings
spcStr      BYTE    " ",0
stickHead   BYTE    "O",0
stickBody   BYTE    "|",0
stickArms   BYTE    "/-",0
stickLegs   BYTE    "/ \",0
gunChar     BYTE    "*",0       
shipChar    BYTE    "^",0
hitChar     BYTE    "#",0
pillarChar  BYTE    "|",0
bulletChar  BYTE    ".",0

END