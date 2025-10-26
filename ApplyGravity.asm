INCLUDE rocketGame.inc


.code
ApplyGravity PROC USES eax
    mov  eax, stickY
    cmp  eax, 18
    jge  @done
    inc  eax
    mov  stickY, eax
@done: ret
ApplyGravity ENDP
END