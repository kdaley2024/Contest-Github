INCLUDE LimbbyLimb.inc
.code

# procedure that checks if any part of the play collides with a ship
CheckPlayerShipCollision PROC USES eax ebx ecx edx esi edi ebp

    cmp  playerIFrames, 0
    jg   @skip

    ;ship size (width -> W in EDX, height -> H in EBX)
    mov  edi, shipType
    mov  edx, 6
    mov  ebx, 2
 @skip:  
    ret
CheckPlayerShipCollision ENDP

END