INCLUDE rocketGame.inc

.code

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

    mov  eax, limbMask
    cmp  eax, 0
    jne  @done

    mov  bgSpeed2x, 0FFFFFFFFh

@done:
    ret
DamagePlayer ENDP

END
