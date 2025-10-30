INCLUDE LimbbyLimb.inc
.data

titleMsg    BYTE "Limb by Limb",0
lvlLbl      BYTE " Level: ",0
level           DWORD 1

stickX      DWORD 6

limbMask        DWORD 0Fh

stickHead   BYTE "O",0
stickBody   BYTE "|",0
stickArms   BYTE "/-",0

shipType    DWORD 0

.code
main PROC PUBLIC
INVOKE ExitProcess, 0
main ENDP
END main
