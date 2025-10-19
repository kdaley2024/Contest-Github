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


