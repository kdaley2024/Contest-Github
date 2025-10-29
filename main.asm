INCLUDE LimbbyLimb.inc
.data
stickX      DWORD 6

limbMask        DWORD 0Fh

stickArms   BYTE "/-",0

.code
main PROC PUBLIC
INVOKE ExitProcess, 0
main ENDP
END main
