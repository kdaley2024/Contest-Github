INCLUDE Irvine32.inc
;.386
;.model flat,stdcall
.stack 4096
ExitProcess PROTO, dwExitCode:DWORD
OPTION PROC: PRIVATE


PutChAt PROTO :BYTE, :DWORD, :DWORD
DrawPlayer PROTO
DrawHUD    PROTO
DrawShip PROTO
CheckKeys PROTO

Gotoxy        PROTO
WriteString   PROTO
WriteChar     PROTO
WriteDec      PROTO
SetTextColor  PROTO
RandomRange   PROTO


;WIN API which was learnt from the textbook
EXTERN  GetAsyncKeyState@4:PROC



;global variables

EXTERNDEF stickX:DWORD
EXTERNDEF limbMask:DWORD
EXTERNDEF titleMsg:BYTE
EXTERNDEF lvlLbl:BYTE
EXTERNDEF level:DWORD
EXTERNDEF shipY:SDWORD
EXTERNDEF scrW:ABS, scrH:ABS
EXTERNDEF bgSpeed2x:DWORD
