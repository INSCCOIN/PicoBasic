# PicoElite

## Overview

PicoElite is a recreation of the classic 1984 Elite space trading and combat game for the PicoCalc platform. This game features a 3D wireframe engine, procedurally generated galaxies, trading, combat, and exploration in a vast universe.

**Version:** 0.2 (Development Build)
**Last Updated:** September 29, 2025
**File Size:** 75KB
**System Requirements:** 39KB of system RAM

## Mathematical Underpinnings

### 3D Rendering System

PicoElite uses basic 3D wireframe rendering techniques:

1. **Coordinate Systems:**

   - 3D space is represented using Cartesian coordinates (X, Y, Z)
   - Ship position acts as the origin for all calculations
   - Z-axis points into the screen, X is horizontal, Y is vertical
2. **Rotational Mathematics:**

   - Uses basic trigonometric functions (sin, cos) for rotation matrices
   - Euler angles (angX, angY, angZ) control ship orientation
   - Rotation calculations apply to vertices to transform objects in 3D space
3. **Perspective Projection:**

   - Simple perspective division: X' = X/Z, Y' = Y/Z
   - Scaling applied to fit screen dimensions (SWIDTH/SHEIGHT)
   - Z-ordering for basic depth perception
4. **Movement Vectors:**

   - Direction vector calculated from current orientation angles
   - Position updated by vector * speed for each frame
   - Collision detection uses simple Euclidean distance measurements

### Procedural Generation

The game's universe uses procedural generation to create 8 galaxies with 256 star systems each:

1. **Seeded Random Generation:**

   - Base seed determines galaxy characteristics
   - Deterministic random functions ensure consistent generation
   - Linear congruential generators for pseudo-randomness
2. **System Name Generation:**

   - Combines random prefixes and suffixes from predefined lists
   - Uses seed manipulation to ensure consistency
3. **Economy & Government:**

   - Systems have tech levels, economy, and government types
   - These affect available trade goods and prices

## Controls

### Ship Navigation

- **Arrow Keys:** Control ship orientation
  - ←/→: Yaw (turn left/right)
  - ↑/↓: Pitch (nose down/up)
- **R:** Roll the ship
- **W/S:** Increase/decrease thrust
- **Space:** Launch when docked at a station

### Game Functions

- **H:** View Galactic Map
- **J:** Initiate hyperspace jump to selected system
- **D:** Activate docking computer (when equipped and near station)
- **S:** Activate fuel scoop (when equipped and near star)
- **T:** Target nearest object

### Trading & Equipment

- While docked:
  - **F:** Purchase fuel scoop (allows collecting fuel from stars)
  - **C:** Purchase cargo scoop
  - **D:** Purchase docking computer
  - **R:** Refuel ship

## Known Issues & Limitations

### Technical Limitations

- **Memory Constraints:** With the game requiring 39KB of RAM, some systems may experience slowdown or memory errors.
- **Performance:** Complex scenes with many objects may cause frame rate drops.
- **Precision Issues:** Floating point calculations may cause positioning glitches at extreme distances.

### Known Bugs

1. **Rendering Glitches:**

   - Objects may occasionally render incorrectly at certain angles
   - Line clipping algorithm sometimes fails at screen edges
2. **Navigation Issues:**

   - Occasional physics miscalculation during high-speed maneuvers
   - Rotation controls may become unresponsive during hyperspace transitions
3. **Game Logic:**

   - Trade system has inconsistent pricing in some systems
   - Fuel consumption calculations may be inaccurate for long jumps
   - Hyperspace calculations can sometimes target incorrect systems
4. **Station Docking:**

   - Docking alignment detection needs refinement
   - Docking computer occasionally fails to complete approach
5. **Interface Problems:**

   - Text occasionally overflows screen boundaries
   - Menu selection may require multiple keypresses

## Development Notes

This is a rough draft implementation with several known issues. The core systems are functional but require optimization and refinement. The rendering engine successfully implements a fixed camera with the ship positioned centrally while the universe moves around it.

Combat systems are minimally implemented and trading balance requires adjustment. The focus of this version has been on establishing the 3D engine, navigation, and procedural generation systems.

## System Architecture

- **Main Loop:** Handles input, updates game state, renders environment
- **3D Engine:** Manages transformations and projections
- **Galaxy Generation:** Creates procedural star systems
- **Navigation:** Controls ship movement and hyperspace
- **Trade System:** Manages economy and transactions
- **HUD:** Provides status information and targeting

## Future Improvements

- Enhanced combat mechanics
- Ship upgrades and equipment variations
- Improved enemy AI
- Mission system
- Expanded trade options
- Performance optimizations
- Improved docking mechanics
- Sound effects and "music"
