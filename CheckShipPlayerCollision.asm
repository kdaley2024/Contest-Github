INCLUDE LimbbyLimb.inc
.code

; procedure that checks if any part of the play collides with a ship
CheckPlayerShipCollision PROC USES eax ebx ecx edx esi edi ebp

    cmp  playerIFrames, 0
    jg   @skip

    ; ship size (width -> W in EDX, height -> H in EBX)
    mov  edi, shipType
    mov  edx, 6
    mov  ebx, 2
    cmp  edi, 0
    je   @sz_ok
    cmp  edi, 1
    jne  @big
    mov  edx, 8
    mov  ebx, 2
    jmp  @sz_ok
@big:
    mov  edx, 10
    mov  ebx, 3
@sz_ok:

    ; ships rectangular bounded box coordinates
    mov  eax, shipX                   ; sx0
    mov  ecx, eax                     ; temp = sx0
    add  ecx, edx                     ; temp = sx0 + W
    dec  ecx                          ; sx1
 @skip:  
    ret
CheckPlayerShipCollision ENDP

END