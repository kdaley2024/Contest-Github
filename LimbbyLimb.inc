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

Gotoxy        PROTO
WriteString   PROTO
WriteChar     PROTO
WriteDec      PROTO
DrawHUD       PROTO


;global variables

EXTERNDEF stickX:DWORD
EXTERNDEF limbMask:DWORD
EXTERNDEF titleMsg:BYTE
EXTERNDEF lvlLbl:BYTE
EXTERNDEF level:DWORD
