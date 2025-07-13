# Onoso The Great War 3.0

**A Text-Based War Survival Adventure for the PicoCalc**

---

## Overview

Onoso The Great War is a text-based, open world war survival game set in a galaxy torn apart by conflict. 
You command Commander Veyra, leader of a stranded strike unit behind enemy lines, as you navigate battlefields, ruined outposts, and the chaos of war. 
Gather resources, avoid patrols, complete side quests, and make choices that will determine the fate of millions!

---

## Features

- **Randomly generated 40x15 war map** (expanded for more exploration)
- **Multiple battlefield, outpost, depot, and wreckage types**
- **Resource management:** fuel, rations, hull, credits, medkits, upgrades
- **Shops at outposts with various items and upgrades**
- **Combat with enemy infantry, tanks, and drones**
- **Random encounters and story events**
- **8-directional movement** including diagonal commands
- **Personal log and event log system**
- **Special story events and extraction win condition**
- **Map and map key commands**
- **Save/Load game functionality**
- **Two-page notes system** for player record-keeping
- **Comprehensive side quest system** with 6 different quest types
- **Enhanced encounter system** with faction interactions

---

## Basic Commands

### Movement
- `N`, `S`, `E`, `W` — Move North, South, East, West
- `NE`, `NW`, `SE`, `SW` — Diagonal movement (Northeast, Northwest, Southeast, Southwest)

### Actions
- `LOOK` — Describe current sector
- `SCAN` — Scan the current sector
- `CAMP` — Camp, trade, or resupply if possible
- `STATUS` — Show unit status
- `MAP` — Show war map
- `MAPKEY` — Show map key/legend
- `REST` — Rest and recover hull (uses rations)
- `USE MEDKIT` — Use a medkit to heal
- `FIGHT` — Engage in combat (if available)

### Game Management
- `SAVE` — Save current game
- `NOTES1` — View/edit notes page 1 (10 notes)
- `NOTES2` — View/edit notes page 2 (10 notes)
- `QUESTS` — View active side quests and progress

### Information
- `CLEAR` — Clear the screen
- `REPEAT` — Repeat last command
- `HINT` — Show gameplay tips
- `LOG` — Show recent events and personal log
- `INV`, `INVENTORY` — Show inventory
- `HELP` — Show all commands
- `QUIT` — Exit the game

---

## How to Play

1. **Start** a new game or load a saved game from the main menu.
2. **Explore** the war-torn 40x15 map using movement commands (including diagonal movement).
3. **Camp** in battlefields, outposts, depots, or wreckage to gather resources or trade.
4. **Manage** your resources carefully—running out of fuel, rations, or hull means game over!
5. **Survive** random encounters, enemy patrols, and combat.
6. **Accept side quests** from NPCs you encounter to gain extra rewards and resources.
7. **Use the notes system** to keep track of important locations, quest information, and strategies.
8. **Save your progress** regularly using the SAVE command.
9. **Trigger story events** by reaching special locations marked on the map.
10. **Reach the extraction point** at (40,15) with the intelligence to win the game!

---

## Side Quest System

The game features a comprehensive side quest system with 6 different quest types:

- **Collection Quests** — Gather specific resources (medkits, rations, credits)
- **Delivery Quests** — Transport messages to specific coordinates
- **Exploration Quests** — Scout multiple sectors for intelligence
- **Combat Quests** — Defeat enemy units and report back
- **Resource Quests** — Accumulate credits for engineering supplies
- **Humanitarian Quests** — Help refugees and civilians

Quest progress is automatically tracked and can be viewed with the `QUESTS` command.

---

## Notes System

Two notes pages are available for player use:
- **NOTES1** — 10 slots for important information
- **NOTES2** — 10 additional slots for strategies and discoveries

Each notes page supports ADD, DEL, CLEAR, and EXIT commands for full note management.

---

## Save/Load System

- Games can be saved at any time using the `SAVE` command
- All progress, including quest status and notes, is preserved
- Load saved games from the main menu when starting the program

---

## Requirements
- Pico 1 / Pico 2 for optimal performance
- ClockworkPI's PicoCalc
- MMBasic Version 6.0002

---

## Credits

INSCCOIN 2025 ©  
Game by Ian C Simpson  
Story, ASCII art, and concept inspired by classic text adventures and the original Onoso Astrox.

Onoso The Great War was created for the PicoCalc and is a successor to Onoso Astrox.

---

Survive the war, Commander!
