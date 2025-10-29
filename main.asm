INCLUDE LimbbyLimb.inc
.data
stickX      DWORD 6

limbMask        DWORD 0Fh

stickHead   BYTE "O",0
stickBody   BYTE "|",0
stickArms   BYTE "/-",0

.code
main PROC PUBLIC
INVOKE ExitProcess, 0
main ENDP
END main
