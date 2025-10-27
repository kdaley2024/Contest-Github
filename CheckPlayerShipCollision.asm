INCLUDE rocketGame.inc

.code

CheckPlayerShipCollision PROC USES eax ebx ecx edx esi edi ebp

    cmp  playerIFrames, 0
    jg   @skip

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

    mov  eax, shipX                 
    mov  ecx, eax                    
    add  ecx, edx                     
    dec  ecx                          

    mov  esi, shipY                  
    mov  edx, esi                     
    add  edx, ebx                   
    dec  edx                          

    mov  ebx, stickX                 
    mov  edi, ebx                    
    sub  ebx, 1                    
    add  edi, 1                    

    cmp  eax, edi                    
    jg   @skip
    cmp  ecx, ebx                     
    jl   @skip

    mov  ebp, stickY                
    mov  eax, ebp                     
    add  eax, 3                       

    cmp  esi, eax                     
    jg   @skip
    cmp  edx, ebp                    
    jl   @skip

    call DamagePlayer

@skip:
    ret
CheckPlayerShipCollision ENDP

END
