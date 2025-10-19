INCLUDE rocketGame.inc

.code

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
