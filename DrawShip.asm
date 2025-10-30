INCLUDE LimbbyLimb.inc

BLACK    EQU 0
WHITE    EQU 15
LIGHTRED EQU 12
LIGHTCYAN EQU 11

.code
;this is the procedure for drawing the spaceships in different sizes.
DrawShip PROC USES eax ebx ecx edx edi

    mov  edi, shipType
    mov  edx, 6
    mov  ebx, 2
    cmp  edi, 0
    cmp  edi, 1
    jne  @big
    mov  edx, 8
    mov  ebx, 2
@big:
    mov  edx, 10
    mov  ebx, 3

;makes the spaceships have a color of lightcyan
    mov  eax, (BLACK SHL 4) + LIGHTCYAN
    call SetTextColor


    ret
DrawShip ENDP
END
