INCLUDE LimbbyLimb.inc

.code
;this procedure includes the logic for how the player will flash when hit by a spaceship, and lose a limb per hit
DamagePlayer PROC USES eax ebx ecx edx
    mov  eax, nextDamageIdx
    cmp  eax, 4
    jge  @done

    mov  ecx, eax
    shl  ecx, 2
    mov  ebx, damageOrder[ecx]
    not  ebx
    and  limbMask, ebx

    inc  eax
    mov  nextDamageIdx, eax

    mov  eax, 20
    mov  playerIFrames, eax

    mov  eax, 4
    mov  playerFlash, eax

@done:
    ret
DamagePlayer ENDP
END
