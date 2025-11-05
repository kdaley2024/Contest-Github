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

    mov  esi, shipY                   ; sy0
    mov  edx, esi                     ; temp = sy0
    add  edx, ebx                     ; temp = sy0 + H
    dec  edx                          ; sy1   (EDX holds sy1)

    ; players bounding box for the horizontal directions
    mov  ebx, stickX                  ; px center
    mov  edi, ebx                     ; px1 base
    sub  ebx, 1                       ; px0 = x-1
    add  edi, 1                       ; px1 = x+1
    
    ;X overlap quick-reject
    cmp  eax, edi                    
    jg   @skip
    cmp  ecx, ebx                     ; sx1 < px0 ?
    jl   @skip

    ;player's bounding box in the vertical direction
    mov  ebp, stickY                  ; py0
    mov  eax, ebp                
    add  eax, 3                      

    ; Y overlap quick-reject
    cmp  esi, eax                     ; sy0 > py1 ?
    jg   @skip
    cmp  edx, ebp                    
    jl   @skip

    call DamagePlayer

 @skip:  
    ret
CheckPlayerShipCollision ENDP

END
