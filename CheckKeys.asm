INCLUDE LimbbyLimb.inc

H_STEP   EQU 2
VK_LEFT  EQU 25h
VK_RIGHT EQU 27h
VK_ESCAPE EQU 1Bh

.code

CheckKeys PROC USES eax ebx

    ; ESC - quit the game
    push VK_ESCAPE
;Windows API that was learnt from the textbook
    call GetAsyncKeyState@4
    test ax, 8000h
    jz   @noEsc
    mov  bgSpeed2x, 0FFFFFFFFh
    ret
@noEsc:
    ; LEFT - move player left (X-)
    push VK_LEFT
;Windows API that was learnt from the textbook
    call GetAsyncKeyState@4
    test ax, 8000h
    jz   @noLeft
    mov  eax, stickX
    sub  eax, H_STEP
    cmp  eax, 0
    jge  @leftOk
    mov  eax, 0
@leftOk:
    mov  stickX, eax
@noLeft:
; RIGHT - move player right (X+)
    push VK_RIGHT
;Windows API that was learnt from the textbook
    call GetAsyncKeyState@4
    test ax, 8000h
    jz   @noRight
    mov  eax, stickX
    add  eax, H_STEP
    mov  ebx, scrW
    ; width ~3 columns
    sub  ebx, 3                        
    cmp  eax, ebx
    jle  @rightOk
    mov  eax, ebx
@rightOk:
    mov  stickX, eax
@noRight:

    ret
CheckKeys ENDP
END
