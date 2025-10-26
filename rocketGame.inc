INCLUDE Irvine32.inc
;.386
;.model flat,stdcall
.stack 4096
ExitProcess PROTO, dwExitCode:DWORD
OPTION PROC: PRIVATE

;constants
scrW        EQU 80
scrH        EQU 25
MAX_BUL     EQU 8

;Windows virtual-key codes (hex)
VK_LEFT   EQU 25h
VK_RIGHT  EQU 27h
VK_UP     EQU 26h
VK_DOWN   EQU 28h
VK_SPACE  EQU 20h
VK_A      EQU 41h
VK_D      EQU 44h
VK_ESCAPE EQU 1Bh

;Win API proto
 GetAsyncKeyState PROTO :DWORD
 GetTickCount    PROTO
 Sleep           PROTO :DWORD
PutChAt PROTO :BYTE, :DWORD, :DWORD
DrawShip  PROTO
SpawnShip PROTO
Fire  PROTO
DrawHud PROTO
CheckKeys PROTO
UpdateDifficulty PROTO
ApplyGravity PROTO
DrawPlayer PROTO


EXTERNDEF sum:DWORD
EXTERNDEF titleMsg:BYTE, scoreLbl:BYTE, hpLbl:BYTE, diffLbl:BYTE
EXTERNDEF stickX:DWORD, stickY:DWORD, jumpStep:DWORD, jumpTimerMs:DWORD
EXTERNDEF jumpWindow:DWORD, isDucking:DWORD, aimDeg:SDWORD
EXTERNDEF bulX:DWORD, bulY:DWORD, bulVX:SDWORD, bulVY:SDWORD, bulLive:DWORD
EXTERNDEF shipX:SDWORD, shipY:SDWORD, shipType:DWORD, shipHP:DWORD, hitFlash:DWORD
EXTERNDEF bgSpeed:DWORD, lastBumpMs:DWORD, obsX:SDWORD, obsGapY:DWORD, obsGapH:DWORD
EXTERNDEF score:DWORD, frameDelay:DWORD
EXTERNDEF stickHead:BYTE, stickBody:BYTE, stickArms:BYTE, stickLegs:BYTE
EXTERNDEF shipChar:BYTE, hitChar:BYTE, pillarChar:BYTE, bulletChar:BYTE
