INCLUDE LimbbyLimb.inc

;color constants that may be used for the implementation of the stickman
BLACK   EQU 0
WHITE   EQU 15
LIGHTRED EQU 12
LIGHTCYAN EQU 11

.code

;this procedure will draw the stickman in parts
DrawPlayer PROC USES eax ebx edx
    @draw:
        ; Draw the head looking like O
        mov  ebx, limbMask
        test ebx, 1
        jz   @noHead
        INVOKE PutChAt, 'O', stickX, eax
    @noHead:
        ; Draw the body looking like |
        inc  eax
        mov  ebx, limbMask
        test ebx, 2
        jz   @noBody
        INVOKE PutChAt, '|', stickX, eax
    @noBody:


    ret
DrawPlayer ENDP
END
