; ============================================================
; Rocket Stickman — MASM + Irvine32 console game (text-mode)
; Textbook building blocks:
; - Irvine32.lib: Randomize, RandomRange, Clrscr, Gotoxy, ReadKey (scan codes),
;                 WriteString, WriteDec, Crlf
; - Win32 API: GetTickCount, Sleep, GetAsyncKeyState (key polling)
; Controls:
;   ↑  = jump (press twice quickly for double jump)
;   ↓  = duck (one-frame clear)
;   A  = rotate aim left    (0..180 degrees)
;   D  = rotate aim right   (0..180 degrees)
;   SPACE = shoot
;   ESC = quit
; ============================================================

INCLUDE Irvine32.inc

.data
; ---------- screen / drawing ----------
scrW        EQU     80
scrH        EQU     25

titleMsg    BYTE    "Rocket Stickman (MASM/Irvine32)",0
scoreLbl    BYTE    "Score: ",0
hpLbl       BYTE    " Ship HP: ",0
diffLbl     BYTE    "  Speed: ",0

; ---------- player / aim ----------
stickX      DWORD   6
stickY      DWORD   18           ; baseline row (0=top)
jumpStep    DWORD   2
jumpTimerMs DWORD   0            ; for double-jump detection
jumpWindow  DWORD   180          ; ms to allow a second UP for double jump
isDucking   DWORD   0
aimDeg      SDWORD  90           ; 0 to 180 degrees

; ---------- bullets ----------
MAX_BUL     EQU     8
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
tNow        DWORD   0
tPrev       DWORD   0
dt          DWORD   0
frameDelay  DWORD   30           ; ~33 FPS

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

.code

; --- helper: print 1 char at (x,y) ---
PutChAt PROC USES eax edx,
    ch:BYTE, x:DWORD, y:DWORD
    mov   dl, BYTE PTR [x]    ; column
    mov   dh, BYTE PTR [y]    ; row
    call  Gotoxy
    mov   al, [ch]
    call  WriteChar
    ret
PutChAt ENDP

; --- draw a short dotted aim line from (x0,y0) at aimDeg ---
DrawAim PROC USES eax ebx ecx edx esi edi,
    x0:DWORD, y0:DWORD, deg:SDWORD
    ; clamp 0..180, then index 15-degree steps
    mov eax, deg
    cmp eax, 0
    jge @ok1
    mov eax, 0
@ok1: cmp eax, 180
    jle @ok2
    mov eax, 180
@ok2: mov ebx, 15
    cdq
    idiv ebx                 ; EAX = idx 0..12

    ; map idx -> (dx,dy)
    mov esi, 1   ; dx default
    mov edi, 0   ; dy default
    cmp eax, 0  je @Lset
    cmp eax, 1  je @L1
    cmp eax, 2  je @L2
    cmp eax, 3  je @L3
    cmp eax, 4  je @L4
    cmp eax, 5  je @L5
    cmp eax, 6  je @L6
    cmp eax, 7  je @L7
    cmp eax, 8  je @L8
    cmp eax, 9  je @L9
    cmp eax, 10 je @L10
    cmp eax, 11 je @L11
    mov esi, -1
    mov edi, 0
    jmp @Lset
@L1:  mov esi, 1   ; 15
      mov edi, 0   ;  
      jmp @Lset
@L2:  mov esi, 1   ; 30
      mov edi, -1
      jmp @Lset
@L3:  mov esi, 1   ; 45
      mov edi, -1
      jmp @Lset
@L4:  mov esi, 1   ; 60
      mov edi, -1
      jmp @Lset
@L5:  mov esi, 0   ; 75
      mov edi, -1
      jmp @Lset
@L6:  mov esi, 0   ; 90
      mov edi, -1
      jmp @Lset
@L7:  mov esi, 0   ; 105
      mov edi, -1
      jmp @Lset
@L8:  mov esi, -1  ; 120
      mov edi, -1
      jmp @Lset
@L9:  mov esi, -1  ; 135
      mov edi, -1
      jmp @Lset
@L10: mov esi, -1  ; 150
      mov edi, 0
      jmp @Lset
@L11: mov esi, -1  ; 165
      mov edi, 0
@Lset:

    mov ecx, 10
    mov eax, [x0]
    mov ebx, [y0]
@dots:
    ; bounds check
    cmp eax, 0     jl  @next
    cmp eax, scrW  jge @next
    cmp ebx, 0     jl  @next
    cmp ebx, scrH  jge @next
    ; draw dot
    INVOKE PutChAt, bulletChar, eax, ebx
@next:
    add eax, esi
    add ebx, edi
    loop @dots
    ret
DrawAim ENDP

; --- random spaceship spawn ---
SpawnShip PROC
    mov  eax, 3
    call RandomRange
    mov  shipType, eax
    mov  shipHP, 1
    cmp  eax, 0    je  @yset
    cmp  eax, 1    jne @big
    mov  shipHP, 2
    jmp  @yset
@big:
    mov  shipHP, 3
@yset:
    mov  eax, scrH
    sub  eax, 10
    call RandomRange
    add  eax, 3
    mov  shipY, eax
    mov  shipX, 70
    mov  hitFlash, 0
    ret
SpawnShip ENDP

; --- shoot if a slot free ---
Fire PROC
    mov  ecx, MAX_BUL
    mov  esi, 0
@find:
    cmp  bulLive[esi*4], 0
    je   @use
    inc  esi
    loop @find
    ret
@use:
    mov  eax, stickX
    add  eax, 2
    mov  bulX[esi*4], eax
    mov  eax, stickY
    sub  eax, 1
    mov  bulY[esi*4], eax
    mov  bulLive[esi*4], 1

    ; velocity from aimDeg
    mov eax, aimDeg
    cmp eax, 0   jge @ok1
    mov eax, 0
@ok1: cmp eax, 180 jle @ok2
    mov eax, 180
@ok2: mov ebx, 15
    cdq
    idiv ebx                     ; idx 0..12

    mov ebx, 1   ; vx
    mov edi, 0   ; vy
    cmp eax, 0  je @Bset
    cmp eax, 1  je @B1
    cmp eax, 2  je @B2
    cmp eax, 3  je @B3
    cmp eax, 4  je @B4
    cmp eax, 5  je @B5
    cmp eax, 6  je @B6
    cmp eax, 7  je @B7
    cmp eax, 8  je @B8
    cmp eax, 9  je @B9
    cmp eax, 10 je @B10
    cmp eax, 11 je @B11
    mov ebx, -1
    mov edi, 0
    jmp @Bset
@B1:  mov ebx, 1   ; 15
      mov edi, 0   ; (coarse)
      jmp @Bset
@B2:  mov ebx, 1   ; 30
      mov edi, -1
      jmp @Bset
@B3:  mov ebx, 1   ; 45
      mov edi, -1
      jmp @Bset
@B4:  mov ebx, 1   ; 60
      mov edi, -1
      jmp @Bset
@B5:  mov ebx, 0   ; 75
      mov edi, -1
      jmp @Bset
@B6:  mov ebx, 0   ; 90
      mov edi, -1
      jmp @Bset
@B7:  mov ebx, 0   ; 105
      mov edi, -1
      jmp @Bset
@B8:  mov ebx, -1  ; 120
      mov edi, -1
      jmp @Bset
@B9:  mov ebx, -1  ; 135
      mov edi, -1
      jmp @Bset
@B10: mov ebx, -1  ; 150
      mov edi, 0
      jmp @Bset
@B11: mov ebx, -1  ; 165
      mov edi, 0
@Bset:
    mov  bulVX[esi*4], ebx
    mov  bulVY[esi*4], edi
    ret
Fire ENDP

; --- bullets update and collision using x/y range comparisons ---
UpdateBullets PROC USES eax ebx ecx edx esi edi
    mov  ecx, MAX_BUL
    mov  esi, 0
@loopB:
    cmp  bulLive[esi*4], 0
    je   @nextB

    mov  eax, bulX[esi*4]
    add  eax, bulVX[esi*4]
    mov  bulX[esi*4], eax
    mov  eax, bulY[esi*4]
    add  eax, bulVY[esi*4]
    mov  bulY[esi*4], eax

    ; kill if off-screen
    cmp  bulX[esi*4], 0     jl  @kill
    cmp  bulX[esi*4], scrW  jge @kill
    cmp  bulY[esi*4], 0     jl  @kill
    cmp  bulY[esi*4], scrH  jge @kill

    ; draw bullet
    mov  eax, bulX[esi*4]
    mov  ebx, bulY[esi*4]
    INVOKE PutChAt, bulletChar, eax, ebx

    ; ship size by type
    mov  edi, shipType
    mov  edx, 3     ; w
    mov  ebx, 1     ; h
    cmp  edi, 0   je  @sz_ok
    cmp  edi, 1   jne @big
    mov  edx, 4
    mov  ebx, 2
    jmp  @sz_ok
@big:
    mov  edx, 6
    mov  ebx, 3
@sz_ok:
    mov  eax, bulX[esi*4]
    mov  edi, shipX
    cmp  eax, edi   jl  @nextB
    mov  ecx, edx
    add  ecx, edi
    dec  ecx
    cmp  eax, ecx   jg  @nextB
    mov  eax, bulY[esi*4]
    mov  edi, shipY
    cmp  eax, edi   jl  @nextB
    mov  ecx, ebx
    add  ecx, edi
    dec  ecx
    cmp  eax, ecx   jg  @nextB

    ; HIT
    mov  bulLive[esi*4], 0
    mov  eax, shipHP
    dec  eax
    mov  shipHP, eax
    mov  hitFlash, 4
    cmp  eax, 0
    jne  @nextB
    ; destroyed -> score++ and respawn
    mov  eax, score
    inc  eax
    mov  score, eax
    call SpawnShip
    jmp  @nextB

@kill:
    mov  bulLive[esi*4], 0
@nextB:
    inc  esi
    loop @loopB
    ret
UpdateBullets ENDP

; --- draw spaceship (flash on hit) ---
DrawShip PROC USES eax ebx ecx edx edi
    mov  edi, shipType
    mov  edx, 3     ; w
    mov  ebx, 1     ; h
    cmp  edi, 0   je  @sz_ok
    cmp  edi, 1   jne @big
    mov  edx, 4
    mov  ebx, 2
    jmp  @sz_ok
@big:
    mov  edx, 6
    mov  ebx, 3
@sz_ok:
    mov  ecx, ebx                ; rows
    mov  eax, shipY
@rows:
    push ecx
    mov  ecx, edx                ; cols
    mov  edi, shipX
@cols:
    ; choose glyph
    cmp  hitFlash, 0
    jg   @flash
    INVOKE PutChAt, shipChar, edi, eax
    jmp  @colNext
@flash:
    INVOKE PutChAt, hitChar,  edi, eax
@colNext:
    inc  edi
    loop @cols
    inc  eax
    pop  ecx
    loop @rows
    ret
DrawShip ENDP

; --- pillars with vertical gap; scroll left by bgSpeed ---
DrawObstacles PROC USES eax ebx ecx edx esi edi
    mov  esi, 0
@each:
    cmp  esi, 3
    jge  @done
    ; advance
    mov  eax, obsX[esi*4]
    sub  eax, bgSpeed
    mov  obsX[esi*4], eax
    ; wrap & randomize gap center
    cmp  eax, -1
    jg   @draw
    mov  obsX[esi*4], scrW-1
    mov  eax, scrH
    sub  eax, 6
    call RandomRange
    add  eax, 3
    mov  obsGapY[esi*4], eax
@draw:
    ; vertical pillar at X with gap
    mov  edi, obsX[esi*4]
    cmp  edi, 0     jl  @next
    cmp  edi, scrW  jge @next
    mov  eax, 0
@row:
    cmp  eax, scrH  jge @next
    mov  ebx, obsGapY[esi*4]
    mov  ecx, obsGapH[esi*4]
    mov  edx, ebx
    sub  edx, ecx
    add  ebx, ecx
    cmp  eax, edx   jl  @drawCell
    cmp  eax, ebx   jle @skipCell
@drawCell:
    INVOKE PutChAt, pillarChar, edi, eax
@skipCell:
    inc  eax
    jmp  @row
@next:
    inc  esi
    jmp  @each
@done:
    ret
DrawObstacles ENDP

; --- draw player & aim using Gotoxy ---
DrawPlayer PROC USES eax ebx
    ; duck shortens sprite by 1
    mov  eax, stickY
    mov  ebx, isDucking
    cmp  ebx, 0
    je   @normal
    inc  eax
@normal:
    ; head
    INVOKE PutChAt, stickHead, stickX, eax
    ; body
    inc  eax
    INVOKE PutChAt, stickBody, stickX, eax
    ; arms "/-" start at x-1
    inc  eax
    mov  ebx, stickX
    dec  ebx
    mov  dl, BYTE PTR ebx
    mov  dh, BYTE PTR eax
    call Gotoxy
    mov  edx, OFFSET stickArms
    call WriteString
    ; legs
    inc  eax
    INVOKE PutChAt, stickLegs, stickX, eax
    ; aim guide from approx gun origin (x+2, baseline or ducked baseline)
    mov  eax, stickY
    mov  ebx, isDucking
    cmp  ebx, 0
    je   @aimy
    inc  eax
@aimy:
    mov  ebx, stickX
    add  ebx, 2
    INVOKE DrawAim, ebx, eax, aimDeg
    ret
DrawPlayer ENDP

; --- HUD using Gotoxy/WriteString/WriteDec ---
DrawHUD PROC USES eax edx
    mov  dl, 0    ; x=0, y=0
    mov  dh, 0
    call Gotoxy
    mov  edx, OFFSET titleMsg
    call WriteString

    mov  dl, 0
    mov  dh, 1
    call Gotoxy
    mov  edx, OFFSET scoreLbl
    call WriteString
    mov  eax, score
    call WriteDec

    mov  dl, 18
    mov  dh, 1
    call Gotoxy
    mov  edx, OFFSET hpLbl
    call WriteString
    mov  eax, shipHP
    call WriteDec

    mov  dl, 34
    mov  dh, 1
    call Gotoxy
    mov  edx, OFFSET diffLbl
    call WriteString
    mov  eax, bgSpeed
    call WriteDec
    ret
DrawHUD ENDP

; --- key polling (non-blocking) ---
EXTERN GetAsyncKeyState@4:PROC
EXTERN GetTickCount@0:PROC
EXTERN Sleep@4:PROC

; Windows virtual-key codes (hex)
VK_LEFT   EQU 25h
VK_RIGHT  EQU 27h
VK_UP     EQU 26h
VK_DOWN   EQU 28h
VK_SPACE  EQU 20h
VK_A      EQU 41h
VK_D      EQU 44h
VK_ESCAPE EQU 1Bh

CheckKeys PROC USES eax ebx
    ; ESC -> quit sentinel
    push VK_ESCAPE
    call GetAsyncKeyState@4
    test ax, 8000h
    jz   @noEsc
    mov  bgSpeed, 0FFFFFFFFh
    ret
@noEsc:

    ; A -> aim left
    push VK_A
    call GetAsyncKeyState@4
    test ax, 8000h
    jz   @noA
    mov  eax, aimDeg
    sub  eax, 3
    cmp  eax, 0
    jge  @aok
    mov  eax, 0
@aok: mov  aimDeg, eax
@noA:

    ; D -> aim right
    push VK_D
    call GetAsyncKeyState@4
    test ax, 8000h
    jz   @noD
    mov  eax, aimDeg
    add  eax, 3
    cmp  eax, 180
    jle  @dok
    mov  eax, 180
@dok: mov  aimDeg, eax
@noD:

    ; UP -> jump (supports double within jumpWindow)
    push VK_UP
    call GetAsyncKeyState@4
    test ax, 8000h
    jz   @noUp
    call GetTickCount@0
    mov  ebx, eax              ; now
    mov  eax, jumpTimerMs
    cmp  eax, 0
    je   @firstUp
    sub  ebx, eax              ; delta
    cmp  ebx, jumpWindow
    jg   @firstUp
    ; double jump
    mov  eax, stickY
    sub  eax, jumpStep
    sub  eax, jumpStep
    cmp  eax, 2
    jge  @setY
    mov  eax, 2
@setY: mov  stickY, eax
    mov  jumpTimerMs, 0
    jmp  @noUp
@firstUp:
    mov  eax, stickY
    sub  eax, jumpStep
    cmp  eax, 2
    jge  @setY2
    mov  eax, 2
@setY2: mov stickY, eax
    call GetTickCount@0
    mov  jumpTimerMs, eax
@noUp:

    ; DOWN -> duck (one frame)
    mov  isDucking, 0
    push VK_DOWN
    call GetAsyncKeyState@4
    test ax, 8000h
    jz   @noDown
    mov  isDucking, 1
@noDown:

    ; SPACE -> fire
    push VK_SPACE
    call GetAsyncKeyState@4
    test ax, 8000h
    jz   @noSp
    call Fire
@noSp:
    ret
CheckKeys ENDP

; --- 10s difficulty bump using GetTickCount ---
UpdateDifficulty PROC USES eax
    call GetTickCount@0
    mov  edx, lastBumpMs
    cmp  eax, edx
    jb   @skip
    mov  eax, bgSpeed
    inc  eax
    mov  bgSpeed, eax
    call GetTickCount@0
    add  eax, 10000
    mov  lastBumpMs, eax
@skip: ret
UpdateDifficulty ENDP

; --- gravity toward baseline ---
ApplyGravity PROC USES eax
    mov  eax, stickY
    cmp  eax, 18
    jge  @done
    inc  eax
    mov  stickY, eax
@done: ret
ApplyGravity ENDP

; --- main loop ---
main PROC
    call Clrscr
    call Randomize

    ; schedule first difficulty bump 10s from now
    call GetTickCount@0
    add  eax, 10000
    mov  lastBumpMs, eax

    call SpawnShip

gameLoop:
    ; quit?
    cmp  bgSpeed, 0FFFFFFFFh
    je   exitGame

    call Clrscr

    call CheckKeys
    call ApplyGravity
    call DrawObstacles

    cmp  hitFlash, 0
    jle  @noflash
    dec  hitFlash
@noflash:
    call DrawShip
    call UpdateBullets
    call DrawHUD
    call DrawPlayer
    call UpdateDifficulty

    push frameDelay
    call Sleep@4

    jmp  gameLoop

exitGame:
    call Clrscr
    ret
main ENDP

END main
