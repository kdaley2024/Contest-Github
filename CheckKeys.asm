INCLUDE LimbbyLimb.inc

H_STEP   EQU 2
VK_LEFT  EQU 25h
VK_RIGHT EQU 27h
VK_ESCAPE EQU 1Bh

.code

CheckKeys PROC USES eax ebx

    ; ESC - quit the game
    push VK_ESCAPE
    call GetAsyncKeyState@4
    test ax, 8000h
    jz   @noEsc
    mov  bgSpeed2x, 0FFFFFFFFh
    ret
@noEsc:

    ret
CheckKeys ENDP
END
