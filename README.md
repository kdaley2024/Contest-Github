# Limb by Limb
Computer Architecture and Assembly Language contest code by Chervelle Pierre and Karla Daley.

# Overview

Arcade mini-game written in MASM using techniques shown in Kip Irvine, Assembly Language for x86 Processors (7th ed.). It runs as a Windows console app (text “graphics”) and uses Gotoxy, WriteString/WriteChar, Randomize/RandomRange, and Win32 timing (GetTickCount, Sleep).

You control a stickman while a spaceship continuously falls from the top of the screen. If the ship collides with the stickman, the player loses a limb (arms → legs → body → head). The stickman flashes red briefly and gains short invulnerability frames. Every 15 seconds the Level increases and the fall speed bumps up; the ship respawns at a random X when it leaves the screen.

## Core Mechanics

### What You See

Title bar: Limb by Limb

HUD (top-left): Level: <n>

Stickman: drawn with O | /- / \ and flashes red briefly when damaged

Spaceship: a solid block of ^ characters that falls straight down and respawns at a random X

### Collisions and Damage

The falling spaceship has three possible sizes (small/medium/big) with wider/heavier hitboxes.

On hit:

One limb is removed in order: arms → legs → body → head.

The stickman flashes red for a few frames and has brief i-frames (invincibility).

When all limbs are gone, the game ends.

### Spaceship (Target)

Spawns at a random X near the top row.

Falls downward; when it goes off the bottom it respawns at the top with a new random X and size.

### HUD

Top-left shows the title and Level

### Difficulty

Level increases automatically every 15 seconds.

Each level bump increases the fall speed (internally, bgSpeed2x is incremented).

## APIs used from the Textbook

Cursor & text: Gotoxy, WriteString, WriteChar, SetTextColor, Clrscr (Irvine32)

Random: Randomize, RandomRange (Irvine32)

Timing: GetTickCount, Sleep (Win32)

## APIs used from Microsoft Learn

Keyboard (non-blocking): GetAsyncKeyState (Win32)

# Game Operations

PutChAt – helper to draw one character at (x,y)

SpawnShip – choose size/X and reset ship at the top

UpdateSteps – compute per-frame fall step from speed

MoveShipDown – advance ship and respawn when off-screen

DrawShip – render the cyan ship rectangle

DrawPlayer – render the stickman (handles red flash)

DamagePlayer – remove a limb, set i-frames/flash, end if none left

CheckPlayerShipCollision – AABB overlap test, triggers damage

CheckKeys – handle arrow keys and Esc

UpdateDifficulty – bump Level and speed every 15s

DrawHUD – title + current Level

