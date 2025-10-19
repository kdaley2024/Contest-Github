INCLUDE rocketGame.inc

.code

DrawAim PROC USES eax ebx ecx edx esi edi,
    x0:DWORD, y0:DWORD, deg:SDWORD
    ; 0..180, then index 15-degree steps
    mov eax, deg
    cmp eax, 0
    jge @ok1
    mov eax, 0
@ok1: cmp eax, 180
    jle @ok2
    mov eax, 180
@ok2: mov ebx, 15
    cdq
    idiv ebx
mov esi, 1   ; dx default
    mov edi, 0   ; dy default
    cmp eax, 0
    je  DrawAim_Lset
    cmp eax, 1
    je  DrawAim_L1
    cmp eax, 2
    je  DrawAim_L2
    cmp eax, 3
    je  DrawAim_L3
    cmp eax, 4
    je  DrawAim_L4
cmp eax, 5
    je  DrawAim_L5
    cmp eax, 6
    je  DrawAim_L6
    cmp eax, 7
    je  DrawAim_L7
    cmp eax, 8
    je  DrawAim_L8
    cmp eax, 9
    je  DrawAim_L9
    cmp eax, 10
    je  DrawAim_L10
    cmp eax, 11
    je  DrawAim_L11
    mov esi, -1
    mov edi, 0
    jmp DrawAim_Lset
DrawAim_L1:  mov esi, 1   ; 15
             mov edi, 0
             jmp DrawAim_Lset
DrawAim_L2:  mov esi, 1   ; 30
             mov edi, -1
             jmp DrawAim_Lset
DrawAim_L3:  mov esi, 1   ; 45
             mov edi, -1
             jmp DrawAim_Lset
DrawAim_L4:  mov esi, 1   ; 60
             mov edi, -1
             jmp DrawAim_Lset
DrawAim_L5:  mov esi, 0   ; 75
             mov edi, -1
             jmp DrawAim_Lset
DrawAim_L6:  mov esi, 0   ; 90
             mov edi, -1
             jmp DrawAim_Lset
DrawAim_L7:  mov esi, 0   ; 105
             mov edi, -1
             jmp DrawAim_Lset
DrawAim_L8:  mov esi, -1  ; 120
             mov edi, -1
             jmp DrawAim_Lset
DrawAim_L9:  mov esi, -1  ; 135
             mov edi, -1
             jmp DrawAim_Lset
DrawAim_L10: mov esi, -1  ; 150
             mov edi, 0
             jmp DrawAim_Lset
DrawAim_L11: mov esi, -1  ; 165
             mov edi, 0
DrawAim_Lset:

    mov ecx, 10
    mov eax, x0
    mov ebx, y0
@dots:
    ; bounds check
    cmp eax, 0    
    jl  @next
    cmp eax, scrW  
    jge @next
    cmp ebx, 0    
    jl  @next
    cmp ebx, scrH  
    jge @next
    ; draw dot
    INVOKE PutChAt, '.', eax, ebx
@next:
    add eax, esi
    add ebx, edi
    loop @dots
    ret
DrawAim ENDP

END
