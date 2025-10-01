' INSCCOIN 2025
' PicoElite, An attempt at recreating the classic 1984 Elite game for the PicoCalc
' Version 0.3
' As of Sep, 30th, 2025 theres tons of bugs and shitty programing (I've slept for about 5 hours in the last week), Claud Sonnet 3.7 did most of the comments, Claud also fixed the render problem. About 90% of this is done by me, the rest is Claud. 

' Set array base to 0
OPTION BASE 0

' Screen dimensions for 40-column display
CONST SWIDTH = 320       ' 40 columns at 8 pixels per character
CONST SHEIGHT = 240
CONST CENTERX = SWIDTH / 2
CONST CENTERY = SHEIGHT / 2
CONST MAX_TEXT_WIDTH = 38  ' Maximum text width in characters

' Game constants
CONST MAX_SPEED = 5
CONST ACCEL = 0.1
CONST ROT_SPEED = 0.03

' Ship equipment and upgrades
CONST EQUIP_NONE = 0
CONST EQUIP_DOCKING_COMPUTER = 1
CONST EQUIP_FUEL_SCOOP = 2
CONST EQUIP_CARGO_SCOOP = 4
CONST EQUIP_MILITARY_LASER = 8
CONST EQUIP_MINING_LASER = 16
CONST EQUIP_ENERGY_BOMB = 32
CONST EQUIP_ECM = 64
CONST EQUIP_SHIELD = 128

' Game state variables
shipX = 0
shipY = 0  
shipZ = 0
shipSpeed = 0
angX = 0
angY = 0
angZ = 0
credits = 1000           ' Starting credits
equipment = EQUIP_NONE   ' No equipment at start
cargoSpace = 20          ' Cargo capacity
cargoHold = 0            ' Current cargo amount
dockingComputer = 0      ' 0 = manual docking, 1 = auto-docking active
isDocked = 0             ' Whether ship is currently docked
dockingInProgress = 0    ' Whether currently in docking process

' Background stars (just visual elements)
CONST NUM_BG_STARS = 20
DIM bgStarX(NUM_BG_STARS-1)
DIM bgStarY(NUM_BG_STARS-1)
DIM bgStarZ(NUM_BG_STARS-1)

' Frame buffer system (software-based rendering optimization)
' This provides structure for future double buffering implementation
currentBuffer = 0    ' Current drawing buffer state (0 or 1)
CONST BUFFER_SCREEN = 0
CONST BUFFER_BACK = 1

' Initialize background stars
FOR i = 0 TO NUM_BG_STARS-1
  bgStarX(i) = RND * 2000 - 1000
  bgStarY(i) = RND * 2000 - 1000
  bgStarZ(i) = RND * 1000 + 500
NEXT i

' Elite Universe Constants
CONST NUM_GALAXIES = 8
CONST PLANETS_PER_GALAXY = 256
CONST CURRENT_VIEW_SYSTEMS = 16  ' How many systems we show in the map at once

' Procedural generation word lists
DIM prefixList$(19)
DATA "ACA", "ACH", "AQUA", "ARA", "ASTER", "ANTI", "ARQU", "BRA", "BERA", "BI"
DATA "CALA", "CEMI", "CETI", "CORIN", "DISO", "DIVA", "EDRA", "ERLA", "ESLA", "EXTA"
FOR i = 0 TO 19
  READ prefixList$(i)
NEXT i

DIM suffixList$(29)
DATA "XLAN", "HIRE", "LABE", "RIAN", "TIE", "STIA", "STIN", "THE", "TRA", "VIAN"
DATA "VERT", "CE", "DI", "EN", "ESS", "LIS", "LA", "LE", "RE", "RI"
DATA "RA", "RUS", "SOL", "TI", "TE", "TIL", "XE", "ZA", "ZEN", "ZO"
FOR i = 0 TO 29
  READ suffixList$(i)
NEXT i

DIM governmentTypes$(7)
DATA "Anarchy", "Feudal", "Multi-gov", "Dictatorship", "Communist", "Confederacy", "Democracy", "Corporate State"
FOR i = 0 TO 7
  READ governmentTypes$(i)
NEXT i

DIM economyTypes$(7)
DATA "Rich Industrial", "Average Industrial", "Poor Industrial", "Mainly Industrial", "Mainly Agricultural", "Rich Agricultural", "Average Agricultural", "Poor Agricultural"
FOR i = 0 TO 7
  READ economyTypes$(i)
NEXT i

' Current location info
currentGalaxy = 0          ' Current galaxy (0-7)
currentSystem = 0          ' Current system within galaxy (0-255)
systemSeed = 12345         ' Base random seed for procedural generation
inHyperspace = 0           ' Flag for hyperspace jump
hyperspaceTimer = 0        ' Counter for hyperspace animation
hyperspaceTarget = -1      ' Target system for jump
targetGalaxy = 0           ' Target galaxy for jump
fuel = 7.0                 ' Current fuel level
CONST MAX_FUEL = 7.0       ' Maximum hyperspace fuel

' Function to generate a pseudo-random number from a seed
FUNCTION Rand(seed)
    ' Linear Congruential Generator parameters
    a = 16807
    m = 2147483647
    
    seed = (a * seed) MOD m
    Rand = seed / m
    
    ' Return the new seed as the function value
END FUNCTION

' Generate a system name from seed
FUNCTION GenerateSystemName$(seed)
    ' Use seed to pick parts
    prefixIdx = INT(Rand(seed) * 20)
    seed = (seed * 11) MOD 123456  ' Scramble seed
    
    suffixIdx = INT(Rand(seed) * 30)
    
    GenerateSystemName$ = prefixList$(prefixIdx) + suffixList$(suffixIdx)
END FUNCTION

' Generate system details from a base seed and system number
FUNCTION GenerateSystemDetails(baseSeed, galaxyNum, systemNum)
    ' Each galaxy has a unique offset
    galaxyOffset = galaxyNum * 65537
    ' Each system has a unique seed derived from the base seed
    systemSeed = baseSeed + galaxyOffset + systemNum * 127
    
    ' Store system data in global arrays indexed by display position
    sysID(systemNum) = systemNum
    
    ' Generate name
    sysName$(systemNum) = GenerateSystemName$(systemSeed)
    
    ' Generate position using the seed
    sysX(systemNum) = (Rand(systemSeed) * 2 - 1) * 0.75 * SWIDTH/2  ' X position 
    systemSeed = (systemSeed * 11) MOD 123456  ' Scramble seed
    
    sysY(systemNum) = (Rand(systemSeed) * 2 - 1) * 0.75 * SHEIGHT/2  ' Y position
    systemSeed = (systemSeed * 11) MOD 123456  ' Scramble seed
    
    sysZ(systemNum) = (Rand(systemSeed) * 2 - 1) * 0.75 * SWIDTH/2  ' Z position
    systemSeed = (systemSeed * 11) MOD 123456  ' Scramble seed
    
    ' Tech level (1-10)
    sysTech(systemNum) = INT(Rand(systemSeed) * 10) + 1
    systemSeed = (systemSeed * 11) MOD 123456
    
    ' Government type (0-7)
    sysGovt(systemNum) = INT(Rand(systemSeed) * 8)
    systemSeed = (systemSeed * 11) MOD 123456
    
    ' Economy type (0-7)
    sysEcon(systemNum) = INT(Rand(systemSeed) * 8)
    systemSeed = (systemSeed * 11) MOD 123456
    
    ' Planet color (1-5)
    sysPlanetColor(systemNum) = INT(Rand(systemSeed) * 5) + 1
    systemSeed = (systemSeed * 11) MOD 123456
    
    ' Generate description seed
    sysDescSeed(systemNum) = systemSeed
    
    ' Return the final seed for chaining
    GenerateSystemDetails = systemSeed
END FUNCTION

' Generate planet description based on seed
FUNCTION GeneratePlanetDescription$(seed)
    ' Uses the seed to generate pseudo-random description elements
    ' Temperature
    tempRand = Rand(seed)
    seed = (seed * 11) MOD 123456
    
    IF tempRand < 0.2 THEN
        temp$ = "a frigid"
    ELSEIF tempRand < 0.4 THEN
        temp$ = "a cold"
    ELSEIF tempRand < 0.6 THEN
        temp$ = "a temperate"
    ELSEIF tempRand < 0.8 THEN
        temp$ = "a warm"
    ELSE
        temp$ = "a scorching"
    ENDIF
    
    ' Size
    sizeRand = Rand(seed)
    seed = (seed * 11) MOD 123456
    
    IF sizeRand < 0.25 THEN
        size$ = "small"
    ELSEIF sizeRand < 0.75 THEN
        size$ = "medium-sized"
    ELSE
        size$ = "large"
    ENDIF
    
    popRand = Rand(seed)
    seed = (seed * 11) MOD 123456
    
    IF popRand < 0.2 THEN
        pop$ = "sparsely populated"
    ELSEIF popRand < 0.4 THEN
        pop$ = "under-populated"
    ELSEIF popRand < 0.6 THEN
        pop$ = "moderately populated"
    ELSEIF popRand < 0.8 THEN
        pop$ = "densely populated"
    ELSE
        pop$ = "over-populated"
    ENDIF
    
    famousRand = Rand(seed)
    seed = (seed * 11) MOD 123456
    
    famousAdj$ = "famous for "
    IF famousRand < 0.1 THEN
        famous$ = "its advanced technology"
    ELSEIF famousRand < 0.2 THEN
        famous$ = "its ancient ruins"
    ELSEIF famousRand < 0.3 THEN
        famous$ = "its carnivorous arts graduates"
    ELSEIF famousRand < 0.4 THEN
        famous$ = "its deadly wildlife"
    ELSEIF famousRand < 0.5 THEN
        famous$ = "its beautiful landscapes"
    ELSEIF famousRand < 0.6 THEN
        famous$ = "its bizarre cuisine"
    ELSEIF famousRand < 0.7 THEN
        famous$ = "its exotic gardens"
    ELSEIF famousRand < 0.8 THEN
        famous$ = "its talented musicians"
    ELSEIF famousRand < 0.9 THEN
        famous$ = "its narcotic wines"
    ELSE
        famous$ = "its unusual mating rituals"
    ENDIF
    
    GeneratePlanetDescription$ = temp$ + " " + size$ + " world, " + pop$ + " and " + famousAdj$ + famous$
END FUNCTION

' Currently visible systems (just ones in range)
DIM sysID(CURRENT_VIEW_SYSTEMS-1)      ' System index in galaxy (0-255)
DIM sysName$(CURRENT_VIEW_SYSTEMS-1)   ' Generated name
DIM sysX(CURRENT_VIEW_SYSTEMS-1)       ' X position in galactic map
DIM sysY(CURRENT_VIEW_SYSTEMS-1)       ' Y position in galactic map
DIM sysZ(CURRENT_VIEW_SYSTEMS-1)       ' Z position in galactic map
DIM sysTech(CURRENT_VIEW_SYSTEMS-1)    ' Tech level 1-10
DIM sysGovt(CURRENT_VIEW_SYSTEMS-1)    ' Government type 0-7
DIM sysEcon(CURRENT_VIEW_SYSTEMS-1)    ' Economy type 0-7
DIM sysPlanetColor(CURRENT_VIEW_SYSTEMS-1)  ' Planet color
DIM sysDescSeed(CURRENT_VIEW_SYSTEMS-1)     ' Seed for descriptions

' Galaxy names from original Elite
DIM galaxyNames$(7)
galaxyNames$(0) = "GALAXY 1 - LAVE"
galaxyNames$(1) = "GALAXY 2 - RIEDQUAT" 
galaxyNames$(2) = "GALAXY 3 - LEESTI"
galaxyNames$(3) = "GALAXY 4 - ZAONCE"
galaxyNames$(4) = "GALAXY 5 - DISO"
galaxyNames$(5) = "GALAXY 6 - USZAA"
galaxyNames$(6) = "GALAXY 7 - TIONISLA"
galaxyNames$(7) = "GALAXY 8 - REORTE"

' Generate a seed for the first galaxy
masterSeed = 46372

' Generate initial systems
GOSUB GenerateLocalSystems

' Current system objects
planetDist = 2000      ' Distance to planet from star
stationDist = 300      ' Distance from planet to station
stationOrbit = 0       ' Orbital position angle
stationDistance = 1000 ' Current distance to station
dockingTimer = 0       ' Timer for docking sequence
starDist = 5000        ' Distance to star

' Define whether we're near the star, planet, or station
CONST MODE_SPACE = 0
CONST MODE_NEAR_STAR = 1
CONST MODE_NEAR_PLANET = 2
CONST MODE_NEAR_STATION = 3
currentMode = MODE_SPACE

' Ship model
DIM vertices(7, 2)  ' 8 vertices with x,y,z coordinates
DIM faces(6, 2)     ' 7 triangular faces with 3 vertex indices each
DIM edges(11, 1)    ' 12 edges with start and end vertex indices
DIM points(7, 1)    ' 2D projected coordinates

' Ship vertices
DATA  0, 0,-50,  -30,-10, 30,   30,-10, 30,  -20, 0, 30
DATA 20, 0, 30,  -10, 10, 30,   10, 10, 30,   0, 5, 40

' Ship Triangles
DATA 0,1,3, 0,3,5, 0,2,4, 0,4,6, 1,2,7, 5,6,7, 3,4,7

' Ship Edges
DATA 0,1, 0,2, 0,3, 0,4, 0,5, 0,6, 1,3, 2,4, 3,5, 4,6, 5,7, 6,7

' Vertices
FOR i = 0 TO 7
   READ vertices(i,0), vertices(i,1), vertices(i,2)
NEXT i

' Faces
FOR i = 0 TO 6
   READ faces(i,0), faces(i,1), faces(i,2)
NEXT i

' Edges
FOR i = 0 TO 11
   READ edges(i,0), edges(i,1)
NEXT i

GOTO ProgramStart


GenerateLocalSystems:
    centerSysIndex = currentSystem
    
    seed = GenerateSystemDetails(masterSeed, currentGalaxy, centerSysIndex)
    
    FOR i = 1 TO CURRENT_VIEW_SYSTEMS-1
        nextSys = (centerSysIndex + i) MOD PLANETS_PER_GALAXY
        seed = GenerateSystemDetails(masterSeed, currentGalaxy, nextSys)
    NEXT i
RETURN


ProgramStart:
' Initialize frame buffer system for smooth rendering
GOSUB InitFrameBuffer

CLS
GOSUB DrawShip
GOSUB DrawHUD

GOSUB ShowControls

' Main Loop
DO
    ' Check for player input
    key$ = INKEY$
    
    ' Flag to track if screen needs update
    needsUpdate = 0
    
    ' Check if we're in hyperspace
    IF inHyperspace = 1 THEN
        needsUpdate = 1
        hyperspaceTimer = hyperspaceTimer + 1
        
        ' Determine hyperspace duration based on jump type
        maxHyperspaceTime = 20
        IF targetGalaxy <> currentGalaxy THEN
            ' Intergalactic jumps take longer
            maxHyperspaceTime = 30
        ENDIF
        
        ' After hyperspace animation completes
        IF hyperspaceTimer > maxHyperspaceTime THEN
            ' Show arrival message
            CLS
            FONT #7
            
            IF targetGalaxy <> currentGalaxy THEN
                TEXT CENTERX, 50, "INTERGALACTIC HYPERSPACE JUMP COMPLETE", "CT", 7
                TEXT CENTERX, 80, "Arrived in " + galaxyNames$(targetGalaxy), "CT", 7
                TEXT CENTERX, 100, "System: " + sysName$(0), "CT", 7
                TEXT CENTERX, 150, "Warning: Fuel depleted", "CT", 7
            ELSE
                TEXT CENTERX, 80, "HYPERSPACE COMPLETE", "CT", 7
                TEXT CENTERX, 110, "Arrived at " + sysName$(hyperspaceTarget), "CT", 7
                TEXT CENTERX, 130, "Fuel remaining: " + STR$(INT(fuel * 10) / 10) + " LY", "CT", 7
            ENDIF
            
            TEXT CENTERX, SHEIGHT-40, "Press any key to continue", "CT", 7
            
            ' Wait for keypress
            DO
                key$ = INKEY$
                IF key$ <> "" THEN EXIT DO
            LOOP
            
            ' Reset hyperspace state
            inHyperspace = 0
            hyperspaceTimer = 0
            
            ' Update galaxy and system
            IF targetGalaxy <> currentGalaxy THEN
                ' Changing galaxies
                currentGalaxy = targetGalaxy
                hyperspaceTarget = 0  ' Start at system 0 in new galaxy
            ENDIF
            
            ' Update current system to the target
            currentSystem = sysID(hyperspaceTarget)
            
            ' Regenerate local systems with new current position
            GOSUB GenerateLocalSystems
            
            ' Reset ship position
            shipX = 0
            shipY = 0
            shipZ = 0
            shipSpeed = 0
            
            ' Reset to space mode
            currentMode = MODE_SPACE
            
            ' Initialize local system objects
            stationOrbit = RND * 360
            
            ' Reset target
            hyperspaceTarget = -1
        ENDIF
    ELSE
        IF key$ <> "" THEN
            ' Player made some input
            needsUpdate = 1
            
            IF key$ = CHR$(128) THEN ' Up arrow
                ' Pitch down - camera rotates around X axis
                angX = angX + ROT_SPEED
            ENDIF
            
            IF key$ = CHR$(129) THEN ' Down arrow
                ' Pitch up - camera rotates around X axis
                angX = angX - ROT_SPEED
            ENDIF
            
            IF key$ = CHR$(130) THEN ' Left arrow
                ' Yaw left - camera rotates around Y axis
                angY = angY - ROT_SPEED
            ENDIF
            
            IF key$ = CHR$(131) THEN ' Right arrow
                ' Yaw right - camera rotates around Y axis
                angY = angY + ROT_SPEED
            ENDIF
            
            IF key$ = "r" OR key$ = "R" THEN
                ' Roll - camera rotates around Z axis
                angZ = angZ + ROT_SPEED
            ENDIF
            
            ' Throttle control with separate keys
            IF key$ = "w" OR key$ = "W" THEN
                IF shipSpeed < MAX_SPEED THEN shipSpeed = shipSpeed + ACCEL
            ENDIF
            
            IF key$ = "s" OR key$ = "S" THEN
                IF shipSpeed > -MAX_SPEED THEN shipSpeed = shipSpeed - ACCEL
            ENDIF
            
            ' H key for hyperspace map
            IF key$ = "h" OR key$ = "H" THEN
                CLS
                GOSUB DrawGalacticMap
                GOSUB WaitForKeypress
                needsUpdate = 1
            ENDIF
            
            ' J key for hyperspace jump (if target selected)
            IF (key$ = "j" OR key$ = "J") AND hyperspaceTarget >= 0 AND isDocked = 0 THEN
                ' Check if this is intergalactic jump
                IF targetGalaxy <> currentGalaxy THEN
                    ' Draw intergalactic jump confirmation
                    CLS
                    FONT #7
                    TEXT CENTERX, 50, "INTERGALACTIC HYPERSPACE", "CT", 7
                    TEXT CENTERX, 80, "Destination: GALAXY " + STR$(targetGalaxy + 1), "CT", 7
                    TEXT CENTERX, 100, galaxyNames$(targetGalaxy), "CT", 7
                    
                    ' In original Elite, this required a special item
                    TEXT CENTERX, 130, "WARNING: Intergalactic jump will use", "CT", 7
                    TEXT CENTERX, 150, "ALL remaining hyperspace fuel", "CT", 7
                    TEXT CENTERX, 180, "Proceed with jump? (Y/N)", "CT", 7
                    
                    ' Wait for confirmation
                    jumpConfirmed = 0
                    jumpCanceled = 0
                    DO
                        confirm$ = INKEY$
                        IF confirm$ = "y" OR confirm$ = "Y" THEN
                            inHyperspace = 1
                            fuel = 0  ' Use all fuel
                            jumpConfirmed = 1
                            EXIT DO
                        ELSEIF confirm$ = "n" OR confirm$ = "N" THEN
                            ' Cancel jump, return to main screen
                            needsUpdate = 1
                            jumpCanceled = 1
                            EXIT DO
                        ENDIF
                    LOOP
                    
                    IF jumpConfirmed OR jumpCanceled THEN
                        GOTO MainLoopContinue
                    ENDIF
                ELSE
                    ' Regular jump within same galaxy
                    ' Calculate distance to target system
                    tx = sysX(hyperspaceTarget)
                    ty = sysY(hyperspaceTarget)
                    tz = sysZ(hyperspaceTarget)
                    jumpDist = SQR(tx*tx + ty*ty + tz*tz)
                    
                    ' Check if we have enough fuel
                    IF jumpDist <= fuel THEN
                        ' Display jump confirmation
                        CLS
                        FONT #7
                        TEXT CENTERX, 60, "HYPERSPACE JUMP", "CT", 7
                        TEXT CENTERX, 90, "Target: " + sysName$(hyperspaceTarget), "CT", 7
                        TEXT CENTERX, 110, "Distance: " + STR$(INT(jumpDist * 10) / 10) + " LY", "CT", 7
                        TEXT CENTERX, 130, "Fuel required: " + STR$(INT(jumpDist * 10) / 10) + " LY", "CT", 7
                        TEXT CENTERX, 150, "Fuel remaining after jump: " + STR$(INT((fuel - jumpDist) * 10) / 10) + " LY", "CT", 7
                        TEXT CENTERX, 180, "Engage hyperspace drive? (Y/N)", "CT", 7
                        
                        ' Wait for confirmation
                        jumpConfirmed = 0
                        jumpCanceled = 0
                        DO
                            confirm$ = INKEY$
                            IF confirm$ = "y" OR confirm$ = "Y" THEN
                                inHyperspace = 1
                                fuel = fuel - jumpDist
                                jumpConfirmed = 1
                                EXIT DO
                            ELSEIF confirm$ = "n" OR confirm$ = "N" THEN
                                ' Cancel jump, return to main screen
                                needsUpdate = 1
                                jumpCanceled = 1
                                EXIT DO
                            ENDIF
                        LOOP
                        
                        IF jumpConfirmed OR jumpCanceled THEN
                            GOTO MainLoopContinue
                        ENDIF
                    ELSE
                        ' Not enough fuel
                        FONT #7
                        TEXT CENTERX, CENTERY, "INSUFFICIENT FUEL FOR JUMP", "CT", 7
                        PAUSE 1000
                        needsUpdate = 1
                    ENDIF
                ENDIF
            ENDIF
            
MainLoopContinue:
            ' D key to activate docking computer
            IF (key$ = "d" OR key$ = "D") AND isDocked = 0 AND (equipment AND EQUIP_DOCKING_COMPUTER) <> 0 THEN
                ' Only activate if near station
                IF currentMode = MODE_NEAR_STATION AND stationDistance < 100 THEN
                    dockingComputer = 1
                ENDIF
            ENDIF
            
            ' S key for sun skimming with fuel scoop
            IF (key$ = "s" OR key$ = "S") AND isDocked = 0 AND (equipment AND EQUIP_FUEL_SCOOP) <> 0 THEN
                ' Check if near star
                IF currentMode = MODE_NEAR_STAR THEN
                    ' Fuel scooping danger level based on how close to star
                    starProximity = starDist
                    
                    IF starProximity < 150 THEN
                        ' Dangerously close - damage!
                        FONT #7
                        TEXT CENTERX, CENTERY - 20, "WARNING: TEMPERATURE CRITICAL!", "CT", 7
                        TEXT CENTERX, CENTERY + 10, "MOVE AWAY FROM STAR NOW", "CT", 7
                        
                        ' Visual effect for critical temperature
                        FOR i = 1 TO 5
                            x1 = RND * SWIDTH
                            y1 = RND * SHEIGHT
                            CIRCLE x1, y1, 2 + RND * 3, 1
                        NEXT i
                    ELSEIF starProximity < 250 THEN
                        ' Optimal scooping range - scoop fuel effectively
                        IF fuel < MAX_FUEL THEN
                            scoopRate = 0.2  ' Faster fuel collection in optimal zone
                            fuel = fuel + scoopRate
                            IF fuel > MAX_FUEL THEN fuel = MAX_FUEL
                            
                            FONT #7
                            TEXT CENTERX, CENTERY - 20, "FUEL SCOOPING - OPTIMAL", "CT", 1
                            TEXT CENTERX, CENTERY + 10, "FUEL: " + STR$(INT(fuel * 10) / 10) + "/" + STR$(MAX_FUEL) + " LY", "CT", 1
                            
                            ' Visual effect for fuel scooping
                            FOR i = 1 TO 3
                                LINE CENTERX - 80 + i*40, CENTERY + 50, CENTERX, CENTERY - 50, 1
                            NEXT i
                        ELSE
                            FONT #7
                            TEXT CENTERX - 150, CENTERY - 20, "FUEL TANKS FULL", "CT", 1
                            TEXT CENTERX - 150, CENTERY + 10, "FUEL: " + STR$(MAX_FUEL) + " LY", "CT", 1
                        ENDIF
                    ELSEIF starProximity < 400 THEN
                        ' Less efficient range - slower fuel collection
                        IF fuel < MAX_FUEL THEN
                            scoopRate = 0.05  ' Slower fuel collection in suboptimal zone
                            fuel = fuel + scoopRate
                            IF fuel > MAX_FUEL THEN fuel = MAX_FUEL
                            
                            FONT #7
                            TEXT CENTERX, CENTERY - 20, "FUEL SCOOPING - MARGINAL", "CT", 1
                            TEXT CENTERX, CENTERY + 10, "FUEL: " + STR$(INT(fuel * 10) / 10) + "/" + STR$(MAX_FUEL) + " LY", "CT", 1
                        ELSE
                            FONT #7
                            TEXT CENTERX - 150, CENTERY - 20, "FUEL TANKS FULL", "CT", 1
                        ENDIF
                    ELSE
                        ' Too far
                        FONT #7
                        TEXT CENTERX - 150, CENTERY, "TOO FAR FROM STAR FOR FUEL SCOOPING", "CT", 1
                        TEXT CENTERX - 150, CENTERY + 20, "MOVE CLOSER TO INITIATE SCOOPING", "CT", 1
                    ENDIF
                ELSE
                    FONT #7
                    TEXT CENTERX - 150, CENTERY, "NO STAR DETECTED FOR FUEL SCOOP", "CT", 1
                    TEXT CENTERX - 150, CENTERY + 20, "NAVIGATE TO A NEARBY STAR", "CT", 1
                ENDIF
            ENDIF
            
            ' Space to launch when docked
            IF key$ = " " AND isDocked = 1 THEN
                isDocked = 0
                ' Launch a safe distance from station
                shipX = stationX + 100
                shipY = stationY
                shipZ = stationZ + 100
                shipSpeed = 0
            ENDIF
            
            ' Handle equipment purchasing when docked
            IF isDocked = 1 THEN
                ' Equipment purchase interface
                
                ' Fuel scoop purchase
                IF key$ = "1" AND (equipment AND EQUIP_FUEL_SCOOP) = 0 AND sysTech(0) >= 3 THEN
                    IF credits >= 600 THEN
                        ' Clear area and show purchase confirmation - 40-column format
                        BOX 40, CENTERY-60, 240, 120, 0, 0
                        BOX 40, CENTERY-60, 240, 120, 1, 0
                        
                        FONT #7
                        TEXT CENTERX, CENTERY-50, "FUEL SCOOP", "CT", 1
                        TEXT CENTERX, CENTERY-30, "Price: 600 CR", "CT", 1
                        TEXT CENTERX, CENTERY-10, "Collect fuel from stars", "CT", 1
                        TEXT CENTERX, CENTERY+10, "Use S key near star", "CT", 1
                        TEXT CENTERX, CENTERY+30, "Confirm? (Y/N)", "CT", 1
                        
                        ' Wait for confirmation
                        confirmation$ = ""
                        WHILE confirmation$ <> "y" AND confirmation$ <> "Y" AND confirmation$ <> "n" AND confirmation$ <> "N"
                            confirmation$ = INKEY$
                        WEND
                        
                        IF confirmation$ = "y" OR confirmation$ = "Y" THEN
                            credits = credits - 600
                            equipment = equipment OR EQUIP_FUEL_SCOOP
                            FONT #7
                            TEXT CENTERX, CENTERY+50, "FUEL SCOOP PURCHASED", "CT", 1
                            PAUSE 1000
                        ENDIF
                    ELSE
                        FONT #7
                        TEXT CENTERX - 100, CENTERY, "INSUFFICIENT CREDITS", "CT", 1
                        PAUSE 500
                    ENDIF
                    needsUpdate = 1  ' Redraw screen
                ENDIF
                
                ' Docking computer purchase
                IF key$ = "2" AND (equipment AND EQUIP_DOCKING_COMPUTER) = 0 AND sysTech(0) >= 5 THEN
                    IF credits >= 1500 THEN
                        ' Clear area and show purchase confirmation - 40-column format
                        BOX 40, CENTERY-60, 240, 120, 0, 0
                        BOX 40, CENTERY-60, 240, 120, 1, 0
                        
                        FONT #7
                        TEXT CENTERX, CENTERY-50, "DOCKING COMPUTER", "CT", 1
                        TEXT CENTERX, CENTERY-30, "Price: 1500 CR", "CT", 1
                        TEXT CENTERX, CENTERY-10, "Automated station docking", "CT", 1
                        TEXT CENTERX, CENTERY+10, "Use D key near station", "CT", 1
                        TEXT CENTERX, CENTERY+30, "Confirm? (Y/N)", "CT", 1
                        
                        ' Wait for confirmation
                        confirmation$ = ""
                        WHILE confirmation$ <> "y" AND confirmation$ <> "Y" AND confirmation$ <> "n" AND confirmation$ <> "N"
                            confirmation$ = INKEY$
                        WEND
                        
                        IF confirmation$ = "y" OR confirmation$ = "Y" THEN
                            credits = credits - 1500
                            equipment = equipment OR EQUIP_DOCKING_COMPUTER
                            FONT #7
                            TEXT CENTERX, CENTERY+50, "DOCKING COMPUTER PURCHASED", "CT", 1
                            PAUSE 1000
                        ENDIF
                    ELSE
                        FONT #7
                        TEXT CENTERX - 100, CENTERY, "INSUFFICIENT CREDITS", "CT", 1
                        PAUSE 500
                    ENDIF
                    needsUpdate = 1  ' Redraw screen
                ENDIF
                
                ' Cargo scoop purchase
                IF key$ = "3" AND (equipment AND EQUIP_CARGO_SCOOP) = 0 AND sysTech(0) >= 4 THEN
                    IF credits >= 900 THEN
                        ' Clear area and show purchase confirmation - 40-column format
                        BOX 40, CENTERY-60, 240, 120, 0, 0
                        BOX 40, CENTERY-60, 240, 120, 1, 0
                        
                        FONT #7
                        TEXT CENTERX, CENTERY-50, "CARGO SCOOP", "CT", 1
                        TEXT CENTERX, CENTERY-30, "Price: 900 CR", "CT", 1
                        TEXT CENTERX, CENTERY-10, "Collect cargo containers", "CT", 1
                        TEXT CENTERX, CENTERY+10, "Fly near containers", "CT", 1
                        TEXT CENTERX, CENTERY+30, "Confirm? (Y/N)", "CT", 1
                        
                        ' Wait for confirmation
                        confirmation$ = ""
                        WHILE confirmation$ <> "y" AND confirmation$ <> "Y" AND confirmation$ <> "n" AND confirmation$ <> "N"
                            confirmation$ = INKEY$
                        WEND
                        
                        IF confirmation$ = "y" OR confirmation$ = "Y" THEN
                            credits = credits - 900
                            equipment = equipment OR EQUIP_CARGO_SCOOP
                            FONT #7
                            TEXT CENTERX, CENTERY+50, "CARGO SCOOP PURCHASED", "CT", 1
                            PAUSE 1000
                        ENDIF
                    ELSE
                        FONT #7
                        TEXT CENTERX - 100, CENTERY, "INSUFFICIENT CREDITS", "CT", 1
                        PAUSE 500
                    ENDIF
                    needsUpdate = 1  ' Redraw screen
                ENDIF
                
                ' Refuel with detailed interface
                IF (key$ = "f" OR key$ = "F") AND fuel < MAX_FUEL THEN
                    maxFuelNeeded = MAX_FUEL - fuel
                    fuelCost = INT(maxFuelNeeded * 20)
                    
                    ' Clear area for refueling interface - 40-column format
                    BOX 40, CENTERY-70, 240, 140, 0, 0
                    BOX 40, CENTERY-70, 240, 140, 1, 0
                    
                    FONT #7
                    TEXT CENTERX, CENTERY-60, "STATION REFUELING", "CT", 1
                    TEXT CENTERX, CENTERY-40, "Curr: " + STR$(INT(fuel * 10) / 10) + " LY", "CT", 1
                    TEXT CENTERX, CENTERY-20, "Max: " + STR$(MAX_FUEL) + " LY", "CT", 1
                    TEXT CENTERX, CENTERY, "Need: " + STR$(INT(maxFuelNeeded * 10) / 10) + " LY", "CT", 1
                    TEXT CENTERX, CENTERY+20, "Cost: " + STR$(fuelCost) + " CR", "CT", 1
                    
                    IF credits >= fuelCost THEN
                        TEXT CENTERX, CENTERY+40, "Confirm purchase? (Y/N)", "CT", 1
                        
                        ' Wait for confirmation
                        confirmation$ = ""
                        WHILE confirmation$ <> "y" AND confirmation$ <> "Y" AND confirmation$ <> "n" AND confirmation$ <> "N"
                            confirmation$ = INKEY$
                        WEND
                        
                        IF confirmation$ = "y" OR confirmation$ = "Y" THEN
                            credits = credits - fuelCost
                            fuel = MAX_FUEL
                            
                            ' Show refueling animation
                            FOR i = 1 TO 5
                                BOX CENTERX-100, CENTERY+60, 200 * (i/5), 10, 1, 1
                                PAUSE 100
                            NEXT i
                            
                            TEXT CENTERX, CENTERY+80, "FUEL TANKS SUCCESSFULLY REFILLED", "CT", 1
                            PAUSE 1000
                        ENDIF
                    ELSE
                        TEXT CENTERX, CENTERY+40, "INSUFFICIENT CREDITS", "CT", 1
                        TEXT CENTERX, CENTERY+60, "Press any key to continue", "CT", 1
                        PAUSE 1000
                    ENDIF
                    
                    needsUpdate = 1  ' Redraw screen
                ENDIF
            ENDIF
        ENDIF  ' End of player input handling
        
        ' Update the space environment position relative to camera
        IF shipSpeed <> 0 THEN
            ' Calculate movement direction based on camera orientation
            ' Precalculate sine and cosine values
            sx = SIN(angX) : cx = COS(angX)
            sy = SIN(angY) : cy = COS(angY)
            sz = SIN(angZ) : cz = COS(angZ)
            
            ' Calculate forward vector based on camera orientation
            ' In a camera-centric view, we move in the direction the camera is facing
            forwardX = SIN(angY) * COS(angX)
            forwardY = SIN(angX)
            forwardZ = COS(angY) * COS(angX)
            
            ' Move ship position based on forward vector
            moveAmount = shipSpeed
            shipX = shipX + (moveAmount * forwardX)
            shipY = shipY + (moveAmount * forwardY)
            shipZ = shipZ + (moveAmount * forwardZ)
            
            ' Move background stars in the opposite direction of ship movement
            FOR i = 0 TO NUM_BG_STARS-1
                bgStarX(i) = bgStarX(i) - (moveAmount * forwardX)
                bgStarY(i) = bgStarY(i) - (moveAmount * forwardY)
                bgStarZ(i) = bgStarZ(i) - (moveAmount * forwardZ)
                
                ' If a star goes too far behind us, reset it ahead
                IF bgStarZ(i) < -500 THEN
                    bgStarZ(i) = 1500
                    bgStarX(i) = RND * 2000 - 1000
                    bgStarY(i) = RND * 2000 - 1000
                ENDIF
            NEXT i
            
            ' Update system mode based on position
            ' Calculate distance to system objects
            starDist = SQR(shipX*shipX + shipY*shipY + shipZ*shipZ)
            
            ' Vector to planet (relative to star)
            planetX = planetDist
            planetY = 0
            planetZ = 0
            
            ' Calculate distance to planet
            dx = planetX - shipX
            dy = planetY - shipY
            dz = planetZ - shipZ
            planetDist = SQR(dx*dx + dy*dy + dz*dz)
            
            ' Calculate station position (orbiting planet)
            stationOrbit = stationOrbit + 0.2  ' Slow orbit
            IF stationOrbit > 360 THEN stationOrbit = stationOrbit - 360
            
            stationX = planetX + stationDist * COS(stationOrbit)
            stationY = planetY + stationDist * SIN(stationOrbit)
            stationZ = planetZ
            
            ' Distance to station
            dx = stationX - shipX
            dy = stationY - shipY
            dz = stationZ - shipZ
            stationDist = SQR(dx*dx + dy*dy + dz*dz)
            
            ' Update mode based on what we're near
            IF starDist < 500 THEN
                currentMode = MODE_NEAR_STAR
            ELSEIF planetDist < 300 THEN
                currentMode = MODE_NEAR_PLANET
            ELSEIF stationDist < 100 THEN
                currentMode = MODE_NEAR_STATION
            ELSE
                currentMode = MODE_SPACE
            ENDIF
        ENDIF
    ENDIF
    
    ' Only redraw if player made a move
    IF needsUpdate = 1 THEN
        ' Use frame buffer for smooth rendering
        GOSUB ClearFrameBuffer
        GOSUB DrawEnvironment
        GOSUB DrawShip
        GOSUB DrawHUD
        GOSUB SwapFrameBuffers
        
        ' Brief pause to avoid excessive CPU usage
        PAUSE 5
    ENDIF
LOOP

' Subroutine for drawing the environment
DrawEnvironment:
    ' Set default font for consistent rendering
    GOSUB SetDefaultFont
    
    ' Check if we're in hyperspace
    IF inHyperspace = 1 THEN
        GOSUB DrawHyperspace
        RETURN
    ENDIF
    
    ' Draw background stars
    
    ' Calculate camera rotation values once per frame
    sx = SIN(angX) : cx = COS(angX)
    sy = SIN(angY) : cy = COS(angY)
    sz = SIN(angZ) : cz = COS(angZ)
    
    FOR i = 0 TO NUM_BG_STARS-1
        ' Get star position from world coordinates
        x = bgStarX(i)
        y = bgStarY(i)
        z = bgStarZ(i)
        
        ' Apply camera transformation to the star (inverse of camera rotation)
        ' First rotate around Y axis (yaw)
        tempX = x * cy + z * sy  ' Note: inverse rotation
        tempZ = -x * sy + z * cy
        
        ' Then rotate around X axis (pitch)
        tempY = y * cx + tempZ * sx
        z = -y * sx + tempZ * cx
        
        ' Then rotate around Z axis (roll)
        x = tempX * cz + tempY * sz
        y = -tempX * sz + tempY * cz
        
        ' Project to 2D if star is in front of ship
        IF z > 0 THEN
            scale = 200 / z
            screenX = x * scale + CENTERX
            screenY = y * scale + CENTERY
            
            ' Draw star if on screen
            IF screenX >= 0 AND screenX < SWIDTH AND screenY >= 0 AND screenY < SHEIGHT THEN
                ' Size based on distance
                starSize = 3 - INT(z / 500)
                IF starSize < 1 THEN starSize = 1
                
                ' Draw star as a point
                PIXEL screenX, screenY, 1
                
                ' For closer stars, make them brighter
                IF starSize > 1 THEN
                    CIRCLE screenX, screenY, 1, 1
                ENDIF
            ENDIF
        ENDIF
    NEXT i
    
    ' Draw system objects
    
    ' Draw star at the center of system
    IF currentMode = MODE_SPACE OR currentMode = MODE_NEAR_STAR THEN
        ' Calculate position relative to ship's heading
        x = 0 - shipX
        y = 0 - shipY
        z = 0 - shipZ
        
        ' Apply ship rotation
        ' First rotate around Y axis
        tempX = x * cy + z * sy
        tempZ = -x * sy + z * cy
        
        ' Then X axis
        tempY = y * cx + tempZ * sx
        z = -y * sx + tempZ * cx
        
        ' Then Z axis
        x = tempX * cz + tempY * sz
        y = -tempX * sz + tempY * cz
        
        ' Project to 2D if in front of ship
        IF z > 0 THEN
            scale = 200 / z
            screenX = x * scale + CENTERX
            screenY = y * scale + CENTERY
            
            ' Draw star if on screen
            IF screenX >= 0 AND screenX < SWIDTH AND screenY >= 0 AND screenY < SHEIGHT THEN
                starSize = 30 - MIN(30, z/100)
                IF starSize < 3 THEN starSize = 3
                
                ' Draw star as a circle
                CIRCLE screenX, screenY, starSize, 1
                CIRCLE screenX, screenY, starSize-1, 1
            ENDIF
        ENDIF
    ENDIF
    
    ' Draw planet
    ' Calculate planet position relative to ship
    x = planetDist - shipX
    y = 0 - shipY
    z = 0 - shipZ
    
    ' Apply ship rotation
    ' First rotate around Y axis
    tempX = x * cy + z * sy
    tempZ = -x * sy + z * cy
    
    ' Then X axis
    tempY = y * cx + tempZ * sx
    z = -y * sx + tempZ * cx
    
    ' Then Z axis
    x = tempX * cz + tempY * sz
    y = -tempX * sz + tempY * cz
    
    ' Project to 2D if in front of ship
    IF z > 0 THEN
        scale = 200 / z
        screenX = x * scale + CENTERX
        screenY = y * scale + CENTERY
        
        ' Draw planet if on screen
        IF screenX >= 0 AND screenX < SWIDTH AND screenY >= 0 AND screenY < SHEIGHT THEN
            planetSize = 100 - MIN(80, z/50)
            IF planetSize < 5 THEN planetSize = 5
            
            ' Draw planet as a filled circle with the color based on current system
            CIRCLE screenX, screenY, planetSize, 1, 1
            
            ' Draw atmosphere
            CIRCLE screenX, screenY, planetSize + 2, 1
        ENDIF
    ENDIF
    
    ' Draw space station if not docked
    IF isDocked = 0 THEN
        ' Calculate station rotation (stations rotate slowly)
        stationRotation = stationOrbit * 0.5
        stationSin = SIN(stationRotation)
        stationCos = COS(stationRotation)
        
        x = stationX - shipX
        y = stationY - shipY
        z = stationZ - shipZ
        
        ' Calculate distance to station for docking detection
        stationDistance = SQR(x*x + y*y + z*z)
        
        ' Apply ship rotation
        ' First rotate around Y axis
        tempX = x * cy + z * sy
        tempZ = -x * sy + z * cy
        
        ' Then X axis
        tempY = y * cx + tempZ * sx
        z = -y * sx + tempZ * cx
        
        ' Then Z axis
        x = tempX * cz + tempY * sz
        y = -tempX * sz + tempY * cz
        
        ' Project to 2D if in front of ship
        IF z > 0 THEN
            scale = 200 / z
            screenX = x * scale + CENTERX
            screenY = y * scale + CENTERY
            
            ' Draw station if on screen
            IF screenX >= 0 AND screenX < SWIDTH AND screenY >= 0 AND screenY < SHEIGHT THEN
                stationSize = 40 - MIN(30, z/20)
                IF stationSize < 3 THEN stationSize = 3
                
                ' Draw station as a rotating cuboid with docking bay
                
                ' Calculate station corners with rotation
                ' Front face (closest to player)
                fx1 = screenX - stationSize
                fy1 = screenY - stationSize
                fx2 = screenX + stationSize
                fy2 = screenY - stationSize
                fx3 = screenX + stationSize
                fy3 = screenY + stationSize
                fx4 = screenX - stationSize
                fy4 = screenY + stationSize
                
                ' Back face (furthest from player)
                bx1 = screenX - stationSize * 0.8
                by1 = screenY - stationSize * 0.8
                bx2 = screenX + stationSize * 0.8
                by2 = screenY - stationSize * 0.8
                bx3 = screenX + stationSize * 0.8
                by3 = screenY + stationSize * 0.8
                bx4 = screenX - stationSize * 0.8
                by4 = screenY + stationSize * 0.8
                
                ' Apply station's rotation to the corners
                ' Front face rotation
                FOR i = 1 TO 4
                    IF i = 1 THEN
                        rx = fx1 - screenX
                        ry = fy1 - screenY
                    ELSEIF i = 2 THEN
                        rx = fx2 - screenX
                        ry = fy2 - screenY
                    ELSEIF i = 3 THEN
                        rx = fx3 - screenX
                        ry = fy3 - screenY
                    ELSE
                        rx = fx4 - screenX
                        ry = fy4 - screenY
                    ENDIF
                    
                    ' Rotate point
                    nx = rx * stationCos - ry * stationSin
                    ny = rx * stationSin + ry * stationCos
                    
                    ' Update coordinates
                    IF i = 1 THEN
                        fx1 = nx + screenX
                        fy1 = ny + screenY
                    ELSEIF i = 2 THEN
                        fx2 = nx + screenX
                        fy2 = ny + screenY
                    ELSEIF i = 3 THEN
                        fx3 = nx + screenX
                        fy3 = ny + screenY
                    ELSE
                        fx4 = nx + screenX
                        fy4 = ny + screenY
                    ENDIF
                NEXT i
                
                ' Back face rotation
                FOR i = 1 TO 4
                    IF i = 1 THEN
                        rx = bx1 - screenX
                        ry = by1 - screenY
                    ELSEIF i = 2 THEN
                        rx = bx2 - screenX
                        ry = by2 - screenY
                    ELSEIF i = 3 THEN
                        rx = bx3 - screenX
                        ry = by3 - screenY
                    ELSE
                        rx = bx4 - screenX
                        ry = by4 - screenY
                    ENDIF
                    
                    ' Rotate point
                    nx = rx * stationCos - ry * stationSin
                    ny = rx * stationSin + ry * stationCos
                    
                    ' Update coordinates
                    IF i = 1 THEN
                        bx1 = nx + screenX
                        by1 = ny + screenY
                    ELSEIF i = 2 THEN
                        bx2 = nx + screenX
                        by2 = ny + screenY
                    ELSEIF i = 3 THEN
                        bx3 = nx + screenX
                        by3 = ny + screenY
                    ELSE
                        bx4 = nx + screenX
                        by4 = ny + screenY
                    ENDIF
                NEXT i
                
                ' Draw front face lines
                LINE fx1, fy1, fx2, fy2, 1
                LINE fx2, fy2, fx3, fy3, 1
                LINE fx3, fy3, fx4, fy4, 1
                LINE fx4, fy4, fx1, fy1, 1
                
                ' Draw back face lines
                LINE bx1, by1, bx2, by2, 1
                LINE bx2, by2, bx3, by3, 1
                LINE bx3, by3, bx4, by4, 1
                LINE bx4, by4, bx1, by1, 1
                
                ' Draw connecting lines
                LINE fx1, fy1, bx1, by1, 1
                LINE fx2, fy2, bx2, by2, 1
                LINE fx3, fy3, bx3, by3, 1
                LINE fx4, fy4, bx4, by4, 1
                
                ' Draw docking bay entrance on front face
                entranceSize = stationSize * 0.4
                
                ' Calculate entrance center - it rotates with the station
                entranceAngle = stationRotation
                entranceX = screenX + entranceSize * 1.2 * SIN(entranceAngle)
                entranceY = screenY + entranceSize * 1.2 * COS(entranceAngle)
                
                ' Draw entrance with a distinctive color to indicate entrance
                CIRCLE entranceX, entranceY, entranceSize, 1
                
                ' Draw a flashing entrance indicator if close enough
                IF stationDistance < 200 THEN
                    IF (TIMER MOD 10) < 5 THEN
                        CIRCLE entranceX, entranceY, entranceSize - 3, 1
                    ENDIF
                ENDIF
                
                ' Check if player is aligned for docking
                IF stationDistance < 100 THEN
                    ' Calculate alignment factors
                    ' 1. Distance to entrance
                    entranceDist = SQR((entranceX - screenX)^2 + (entranceY - screenY)^2)
                    
                    ' 2. Angle difference (ship should face station entrance)
                    shipFacing = (angY + angZ) MOD 360
                    entranceFacing = (stationRotation + 180) MOD 360
                    angleDiff = ABS(shipFacing - entranceFacing)
                    IF angleDiff > 180 THEN angleDiff = 360 - angleDiff
                    
                    ' Determine docking difficulty based on speed
                    speedFactor = 1 + shipSpeed * 2
                    
                    ' If ship has docking computer and it's activated
                    IF dockingComputer = 1 THEN
                        ' Auto-docking - gradually align ship with entrance
                        IF stationDistance > 20 THEN
                            ' Slow down as we approach
                            IF shipSpeed > 1 THEN shipSpeed = shipSpeed * 0.9
                        ELSE
                            ' Very close, final approach
                            shipSpeed = 0.5
                        ENDIF
                        
                        ' Start docking when well-aligned
                        IF stationDistance < 30 AND entranceDist < 20 AND angleDiff < 30 THEN
                            dockingInProgress = 1
                        ENDIF
                    ENDIF
                    
                    ' Check for manual docking alignment
                    IF dockingComputer = 0 AND stationDistance < 25 AND entranceDist < 15 AND angleDiff < 30 / speedFactor THEN
                        ' Start docking process - perfect manual alignment
                        dockingInProgress = 1
                    ENDIF
                ENDIF
                
                ' Show docking alignment indicator if close to station
                IF stationDistance < 100 THEN
                    GOSUB SetDefaultFont
                    TEXT 10, 190, "Docking Alignment: ", "LT", 7
                    
                    ' Draw alignment bars
                    barLength = 100
                    barHeight = 10
                    
                    ' Distance bar (closer = more filled)
                    distFill = MIN(100, (100 - stationDistance) * 2)
                    IF distFill < 0 THEN distFill = 0
                    
                    LINE 130, 190, 130 + barLength, 190, 1
                    LINE 130, 190 + barHeight, 130 + barLength, 190 + barHeight, 1
                    LINE 130, 190, 130, 190 + barHeight, 1
                    LINE 130 + barLength, 190, 130 + barLength, 190 + barHeight, 1
                    
                    ' Fill bar based on alignment
                    IF distFill > 0 THEN
                        fillWidth = (distFill * barLength) / 100
                        FOR i = 0 TO barHeight
                            LINE 130, 190 + i, 130 + fillWidth, 190 + i, 1
                        NEXT i
                    ENDIF
                ENDIF
                
                ' Display docking computer status if equipped
                IF (equipment AND EQUIP_DOCKING_COMPUTER) <> 0 THEN
                    GOSUB SetDefaultFont
                    IF dockingComputer = 1 THEN
                        TEXT 10, 210, "DOCKING COMPUTER ACTIVE", "LT", 7
                    ELSE
                        TEXT 10, 210, "Docking Computer Ready (D to activate)", "LT", 7
                    ENDIF
                ENDIF
                
                ' Handle docking process
                IF dockingInProgress = 1 THEN
                    ' Create a more dramatic docking sequence
                    dockingTimer = dockingTimer + 1
                    dockingStage = INT(dockingTimer / 10) + 1
                    
                    ' Different messages during docking stages - 40-column format
                    FONT #7
                    IF dockingStage = 1 THEN
                        TEXT CENTERX, CENTERY - 20, "DOCKING SEQUENCE INIT", "CT", 1
                        TEXT CENTERX, CENTERY, "Matching rotation...", "CT", 1
                    ELSEIF dockingStage = 2 THEN
                        TEXT CENTERX, CENTERY - 20, "ALIGNMENT CONFIRMED", "CT", 1
                        TEXT CENTERX, CENTERY, "Entering bay...", "CT", 1
                    ELSEIF dockingStage = 3 THEN
                        TEXT CENTERX, CENTERY, "Engaging clamps...", "CT", 1
                    ENDIF
                    
                    ' Visual effect - approaching the station
                    IF dockingStage <= 3 THEN
                        entranceRadius = entranceSize * (4 - dockingStage) / 2
                        CIRCLE CENTERX, CENTERY, entranceRadius, 1
                    ENDIF
                    
                    ' Docking complete
                    IF dockingTimer > 30 THEN
                        ' Successfully docked
                        isDocked = 1
                        dockingInProgress = 0
                        dockingTimer = 0
                        dockingComputer = 0
                        
                        ' Reset speed
                        shipSpeed = 0
                    ENDIF
                ENDIF
            ENDIF
        ENDIF
    ELSE
        ' We're docked - draw station interior (40-column format)
        FONT #7
        TEXT CENTERX, 20, "DOCKED AT " + sysName$(0), "CT", 1
        TEXT CENTERX, 30, "SPACE STATION", "CT", 1
        TEXT CENTERX, 50, "Press SPACE to launch", "CT", 1
        
        ' Display available equipment to purchase
        TEXT 10, 70, "EQUIPMENT SHOP:", "LT", 1
        
        ' Show equipment for sale based on tech level
        y = 85
        IF (equipment AND EQUIP_FUEL_SCOOP) = 0 AND sysTech(0) >= 3 THEN
            TEXT 10, y, "1. Fuel Scoop - 600 CR", "LT", 1
            y = y + 10
            TEXT 15, y, "Scoop fuel w/'S' key", "LT", 1
            y = y + 15
        ENDIF
        
        IF (equipment AND EQUIP_DOCKING_COMPUTER) = 0 AND sysTech(0) >= 5 THEN
            TEXT 10, y, "2. Docking Comp - 1500 CR", "LT", 1
            y = y + 10
            TEXT 15, y, "Auto-dock w/'D' key", "LT", 1
            y = y + 15
        ENDIF
        
        IF (equipment AND EQUIP_CARGO_SCOOP) = 0 AND sysTech(0) >= 4 THEN
            TEXT 10, y, "3. Cargo Scoop - 900 CR", "LT", 1
            y = y + 10
            TEXT 15, y, "Collect floating cargo", "LT", 1
            y = y + 15
        ENDIF
        
        ' Show current equipment
        TEXT 170, 70, "INSTALLED:", "LT", 1
        equipLine = 85
        
        IF (equipment AND EQUIP_DOCKING_COMPUTER) <> 0 THEN
            TEXT 170, equipLine, "Docking Computer", "LT", 1
            equipLine = equipLine + 12
        ENDIF
        
        IF (equipment AND EQUIP_FUEL_SCOOP) <> 0 THEN
            TEXT 170, equipLine, "Fuel Scoop", "LT", 1
            equipLine = equipLine + 12
        ENDIF
        
        IF (equipment AND EQUIP_CARGO_SCOOP) <> 0 THEN
            TEXT 170, equipLine, "Cargo Scoop", "LT", 1
            equipLine = equipLine + 12
        ENDIF
        
        ' Refuel option
        maxFuelNeeded = MAX_FUEL - fuel
        fuelCost = INT(maxFuelNeeded * 20)
        
        IF maxFuelNeeded > 0.1 THEN
            TEXT 20, 190, "F. Refuel (" + STR$(INT(maxFuelNeeded * 10) / 10) + " LY) - " + STR$(fuelCost) + " CR", "LT", 1
        ELSE
            TEXT 20, 190, "Fuel tanks full", "LT", 1
        ENDIF
        
        ' Credits display
        TEXT 20, SHEIGHT - 40, "Credits: " + STR$(credits) + " CR", "LT", 1
    ENDIF
RETURN

DrawHyperspace:
    ' Clear screen before drawing hyperspace effect
    CLS
    
    ' Draw hyperspace effect based on original Elite
    IF targetGalaxy <> currentGalaxy THEN
        ' Intergalactic hyperspace - expand and contract star field
        expandFactor = ABS(SIN(hyperspaceTimer / 5)) * 3
        
        ' Phase 1: Countdown
        IF hyperspaceTimer < 10 THEN
            countdownVal = 10 - hyperspaceTimer
            FONT #7
            TEXT CENTERX, 60, "INTERGALACTIC JUMP SEQUENCE", "CT", 1
            TEXT CENTERX, 100, "COUNTDOWN: " + STR$(countdownVal), "CT", 1
            
            ' Draw expanding star field
            FOR i = 0 TO 80
                angle = RND * 360
                radius = 20 + RND * 100 * expandFactor
                
                x = CENTERX + radius * COS(angle)
                y = CENTERY + radius * SIN(angle)
                
                PIXEL x, y, 1
            NEXT i
        ELSE
            ' Phase 2: Main hyperspace tunnel
            FOR i = 0 TO 80
                angle = RND * 360
                radius = RND * 150
                length = 5 + RND * 50 * (hyperspaceTimer / 10)
                
                x1 = CENTERX + radius * COS(angle)
                y1 = CENTERY + radius * SIN(angle)
                
                x2 = CENTERX + (radius + length) * COS(angle)
                y2 = CENTERY + (radius + length) * SIN(angle)
                
                LINE x1, y1, x2, y2, 1
            NEXT i
            
            ' Show galaxy change message
            FONT #7
            TEXT CENTERX, 60, "HYPERSPACE ENGAGED", "CT", 1
            TEXT CENTERX, 100, "Entering " + galaxyNames$(targetGalaxy), "CT", 1
        ENDIF
    ELSE
        ' Regular hyperspace - tunnel effect like original Elite
        FONT #7
        TEXT CENTERX, 30, "HYPERSPACE", "CT", 1
        
        ' Show system destination
        IF hyperspaceTimer > 10 THEN
            TEXT CENTERX, 60, "Destination: " + sysName$(hyperspaceTarget), "CT", 1
        ENDIF
        
        ' Phase 1: Initial acceleration - stars moving out
        IF hyperspaceTimer < 8 THEN
            FOR i = 0 TO 100
                angle = RND * 360
                radius = 10 + (hyperspaceTimer * 10) + RND * 50
                
                x = CENTERX + radius * COS(angle)
                y = CENTERY + radius * SIN(angle)
                
                PIXEL x, y, 1
            NEXT i
        ELSE
            ' Phase 2: Hyperspace tunnel
            FOR i = 0 TO 70
                angle = RND * 360
                radius = RND * 130
                length = 5 + RND * 30 * ((hyperspaceTimer-5) / 10)
                
                x1 = CENTERX + radius * COS(angle)
                y1 = CENTERY + radius * SIN(angle)
                
                x2 = CENTERX + (radius + length) * COS(angle)
                y2 = CENTERY + (radius + length) * SIN(angle)
                
                LINE x1, y1, x2, y2, 1
            NEXT i
            
            ' Show spinning ship silhouette in center
            shipSize = 20
            shipAngle = hyperspaceTimer * 30
            
            ' Draw simple ship shape
            x1 = CENTERX + shipSize * COS(shipAngle)
            y1 = CENTERY + shipSize * SIN(shipAngle) / 2
            x2 = CENTERX + shipSize * COS(shipAngle + 135)
            y2 = CENTERY + shipSize * SIN(shipAngle + 135) / 2
            x3 = CENTERX + shipSize * COS(shipAngle + 225)
            y3 = CENTERY + shipSize * SIN(shipAngle + 225) / 2
            
            LINE x1, y1, x2, y2, 1
            LINE x2, y2, x3, y3, 1
            LINE x3, y3, x1, y1, 1
        ENDIF
    ENDIF
RETURN

DrawHUD:
    IF isDocked = 0 THEN  ' Only show flight HUD when not docked
        ' Set font consistently throughout HUD
        GOSUB SetDefaultFont
        
        ' Left side HUD - Navigation info
        TEXT 5, 10, "NAVIGATION", "LT", 7
        TEXT 5, 22, "Speed: " + STR$(INT(shipSpeed * 100) / 100), "LT", 7
        TEXT 5, 34, "Galaxy: " + STR$(currentGalaxy+1), "LT", 7
        TEXT 5, 46, "System: " + LEFT$(sysName$(0), 15), "LT", 7
        
        ' Show current mode with clearer text
        modeText$ = "Deep Space"
        IF currentMode = MODE_NEAR_STAR THEN modeText$ = "Near Star"
        IF currentMode = MODE_NEAR_PLANET THEN modeText$ = "Near Planet"
        IF currentMode = MODE_NEAR_STATION THEN modeText$ = "Near Station"
        
        TEXT 5, 58, "Location: " + modeText$, "LT", 7
        TEXT 5, 70, "Fuel: " + STR$(INT(fuel * 10) / 10) + " LY", "LT", 7
        
        ' Credits display
        TEXT 5, 82, "Credits: " + STR$(credits), "LT", 7
        
        ' System info - right side of screen
        TEXT WIDTH-5, 10, "SYSTEM INFORMATION", "RT", 7
        govtText$ = LEFT$(governmentTypes$(sysGovt(0)), 14)
        TEXT WIDTH-5, 22, "Government: " + govtText$, "RT", 7
        econText$ = LEFT$(economyTypes$(sysEcon(0)), 14)
        TEXT WIDTH-5, 34, "Economy: " + econText$, "RT", 7
        TEXT WIDTH-5, 46, "Tech Level: " + STR$(sysTech(0)), "RT", 7
        
        ' Show active equipment with clear status indicators
        TEXT WIDTH-5, 58, "EQUIPMENT", "RT", 7
        equipLine = 70
        
        IF (equipment AND EQUIP_FUEL_SCOOP) <> 0 THEN
            ' Show active status if near star
            IF currentMode = MODE_NEAR_STAR AND starDist < 400 THEN
                IF starDist < 150 THEN
                    TEXT WIDTH-5, equipLine, "Fuel Scoop [DANGER ZONE] (S:activate)", "RT", 7
                ELSEIF starDist < 250 THEN
                    TEXT WIDTH-5, equipLine, "Fuel Scoop [OPTIMAL RANGE] (S:activate)", "RT", 7
                ELSE
                    TEXT WIDTH-5, equipLine, "Fuel Scoop [MARGINAL RANGE] (S:activate)", "RT", 7
                ENDIF
            ELSE
                TEXT WIDTH-5, equipLine, "Fuel Scoop (Press S to activate)", "RT", 7
            ENDIF
            equipLine = equipLine + 12
        ENDIF
        
        IF (equipment AND EQUIP_DOCKING_COMPUTER) <> 0 THEN
            ' Show status of docking computer
            IF dockingComputer = 1 THEN
                TEXT WIDTH-5, equipLine, "Docking Computer [ACTIVE]", "RT", 7
            ELSEIF currentMode = MODE_NEAR_STATION AND stationDist < 100 THEN
                TEXT WIDTH-5, equipLine, "Docking Computer [READY] (D:activate)", "RT", 7
            ELSE
                TEXT WIDTH-5, equipLine, "Docking Computer (Press D to activate)", "RT", 7
            ENDIF
            equipLine = equipLine + 12
        ENDIF
        
        IF (equipment AND EQUIP_CARGO_SCOOP) <> 0 THEN
            TEXT WIDTH-5, equipLine, "Cargo Scoop Installed", "RT", 7
            equipLine = equipLine + 12
        ENDIF
        
        ' Show proximity indicators when near station with improved formatting
        IF currentMode = MODE_NEAR_STATION THEN
            TEXT 5, SHEIGHT - 40, "Distance to Station: " + STR$(INT(stationDist)) + " units", "LT", 7
            
        ELSE
            ' Show control reminder at bottom of screen
            TEXT 5, SHEIGHT - 20, "Press ? for controls", "LT", 7
        ENDIF
            IF stationDist < 50 THEN
                TEXT 5, SHEIGHT - 30, "DOCK ZONE-Align w/entrance", "LT", 7
            ENDIF
        ENDIF
        
        ' Show target system if one is selected
        IF hyperspaceTarget >= 0 THEN
            TEXT 10, 110, "Target: " + sysName$(hyperspaceTarget), "LT", 7
            
            ' Calculate distance to target
            dx = sysX(hyperspaceTarget) - sysX(0)
            dy = sysY(hyperspaceTarget) - sysY(0)
            dz = sysZ(hyperspaceTarget) - sysZ(0)
            jumpDist = SQR(dx*dx + dy*dy + dz*dz) / mapScale
            
            TEXT 10, 130, "Jump dist: " + STR$(INT(jumpDist * 10) / 10) + " LY", "LT", 7
        ENDIF
        
        ' Command reference
        TEXT 10, SHEIGHT - 40, "Arrows: Move   R: Rotate   H: Map", "LT", 7
        TEXT 10, SHEIGHT - 20, "J: Jump   S: Fuel Scoop   D: Dock", "LT", 7
    ENDIF
RETURN

DrawGalacticMap:
    ' Clear screen before drawing galactic map
    CLS
    
    ' Set font consistently
    GOSUB SetDefaultFont
    
    ' Draw decorative border around the entire screen
    BOX 2, 2, SWIDTH-4, SHEIGHT-4, 1, 0
    BOX 4, 4, SWIDTH-8, SHEIGHT-8, 1, 0
    
    ' Show Elite-style galaxy header with proper name
    TEXT CENTERX, 8, "GALACTIC HYPERSPACE MAP", "CT", 7
    TEXT CENTERX, 20, galaxyNames$(currentGalaxy) + " GALAXY", "CT", 7
    
    ' Draw header separator line
    LINE 10, 32, SWIDTH-10, 32, 1
    
    ' Information panel
    TEXT 10, 40, "Fuel Range: " + STR$(INT(fuel * 10) / 10) + " LY", "LT", 7
    TEXT 10, 52, "Systems: 0-9 to select, G for galaxy menu", "LT", 7
    
    ' Define map area with border
    mapLeft = 10
    mapTop = 70
    mapWidth = 200
    mapHeight = 120
    mapCenterX = mapLeft + mapWidth / 2
    mapCenterY = mapTop + mapHeight / 2
    mapScale = 0.8
    
    ' Draw map border
    BOX mapLeft, mapTop, mapWidth, mapHeight, 1, 0
    
    ' Draw coordinate grid lines for reference
    FOR i = 1 TO 3
        gridX = mapLeft + (i * mapWidth / 4)
        LINE gridX, mapTop, gridX, mapTop + mapHeight, 1
    NEXT i
    FOR i = 1 TO 2
        gridY = mapTop + (i * mapHeight / 3)
        LINE mapLeft, gridY, mapLeft + mapWidth, gridY, 1
    NEXT i
    
    ' Draw fuel range circle
    CIRCLE mapCenterX, mapCenterY, fuel * mapScale * 15, 1
    
    ' Draw all visible systems
    FOR i = 0 TO CURRENT_VIEW_SYSTEMS-1
        ' Scale system coordinates to fit in map area
        mapX = mapCenterX + (sysX(i) * mapScale)
        mapY = mapCenterY + (sysZ(i) * mapScale)  ' Use Z as Y in top-down view
        
        ' Ensure systems stay within map bounds
        IF mapX < mapLeft + 5 THEN mapX = mapLeft + 5
        IF mapX > mapLeft + mapWidth - 5 THEN mapX = mapLeft + mapWidth - 5
        IF mapY < mapTop + 5 THEN mapY = mapTop + 5
        IF mapY > mapTop + mapHeight - 5 THEN mapY = mapTop + mapHeight - 5
        
        ' Calculate distance from current position
        IF i = 0 THEN
            dist = 0
        ELSE
            dx = sysX(i) - sysX(0)
            dy = sysY(i) - sysY(0)
            dz = sysZ(i) - sysZ(0)
            dist = SQR(dx*dx + dy*dy + dz*dz)
        ENDIF
        
        ' Draw system markers with different styles
        IF i = 0 THEN
            ' Current system - large filled circle with cross
            CIRCLE mapX, mapY, 4, 1, 1
            LINE mapX-6, mapY, mapX+6, mapY, 1
            LINE mapX, mapY-6, mapX, mapY+6, 1
        ELSE
            ' Other systems based on jump range
            IF dist <= fuel THEN
                ' In range - filled circle
                CIRCLE mapX, mapY, 3, 1, 1
            ELSE
                ' Out of range - hollow circle
                CIRCLE mapX, mapY, 2, 1, 0
            ENDIF
        ENDIF
        
        ' Show system numbers for accessible systems
        IF dist <= fuel OR i = 0 THEN
            displayIdx = i
            IF displayIdx >= 10 THEN
                displayChar$ = CHR$(55 + displayIdx)  ' A-F for 10-15
            ELSE
                displayChar$ = STR$(displayIdx)
            ENDIF
            
            ' Position labels to avoid overlap
            labelX = mapX + 6
            labelY = mapY - 2
            TEXT labelX, labelY, displayChar$, "LT", 7
            
        ENDIF
    NEXT i
    
    ' System information panel on the right
    infoLeft = 220
    infoWidth = 95
    BOX infoLeft, 70, infoWidth, 120, 1, 0
    TEXT infoLeft + 2, 75, "SYSTEM INFORMATION", "LT", 7
    LINE infoLeft + 2, 85, infoLeft + infoWidth - 2, 85, 1
    
    ' Show detailed info for accessible systems
    infoY = 90
    shownSystems = 0
    FOR i = 0 TO CURRENT_VIEW_SYSTEMS-1
        IF i = 0 THEN
            dist = 0
        ELSE
            dx = sysX(i) - sysX(0)
            dy = sysY(i) - sysY(0) 
            dz = sysZ(i) - sysZ(0)
            dist = SQR(dx*dx + dy*dy + dz*dz)
        ENDIF
        
        IF (dist <= fuel OR i = 0) AND shownSystems < 6 THEN
            displayIdx = i
            IF displayIdx >= 10 THEN
                displayChar$ = CHR$(55 + displayIdx)
            ELSE
                displayChar$ = STR$(displayIdx)
            ENDIF
            
            ' System name and key
            TEXT infoLeft + 2, infoY, displayChar$ + ": " + LEFT$(sysName$(i), 12), "LT", 7
            infoY = infoY + 10
            
            ' Government and economy (abbreviated)
            govText$ = LEFT$(governmentTypes$(sysGovt(i)), 8)
            econText$ = LEFT$(economyTypes$(sysEcon(i)), 8) 
            TEXT infoLeft + 4, infoY, govText$ + ", " + econText$, "LT", 7
            infoY = infoY + 12
            
            shownSystems = shownSystems + 1
        ENDIF
    NEXT i
    
    ' Legend box
    legendY = 200
    BOX 10, legendY, 300, 35, 1, 0
    TEXT 12, legendY + 5, "LEGEND:", "LT", 7
    TEXT 12, legendY + 15, "Current System   In Range   Out of Range", "LT", 7
    
    ' Legend symbols
    CIRCLE 88, legendY + 20, 3, 1, 1
    LINE 82, legendY + 20, 94, legendY + 20, 1
    LINE 88, legendY + 14, 88, legendY + 26, 1
    
    CIRCLE 150, legendY + 20, 2, 1, 1
    CIRCLE 210, legendY + 20, 2, 1, 0
    
    ' Navigation help
    TEXT CENTERX, SHEIGHT - 15, "G: Galaxy Menu  |  0-9: Select System  |  Any Key: Return", "CT", 7
RETURN

' Galaxy selection screen subroutine
DrawGalaxySelector:
    ' Clear screen before drawing galaxy selector
    CLS
    
    ' Set font consistently
    GOSUB SetDefaultFont
    
    ' Draw decorative border
    BOX 2, 2, SWIDTH-4, SHEIGHT-4, 1, 0
    BOX 4, 4, SWIDTH-8, SHEIGHT-8, 1, 0
    
    ' Header
    TEXT CENTERX, 10, "INTERGALACTIC HYPERSPACE", "CT", 7
    TEXT CENTERX, 22, "GALAXY SELECTION MATRIX", "CT", 7
    LINE 10, 35, SWIDTH-10, 35, 1
    
    ' Instructions
    TEXT CENTERX, 45, "Select destination galaxy (1-8)", "CT", 7
    
    ' Galaxy list in organized columns
    col1X = 30
    col2X = 170
    
    ' Draw galaxy selection boxes
    FOR i = 0 TO 7
        row = i MOD 4
        col = INT(i / 4)
        boxX = col1X + col * 140
        boxY = 65 + row * 25
        
        ' Highlight current galaxy
        IF i = currentGalaxy THEN
            BOX boxX - 2, boxY - 2, 130, 20, 1, 1
            TEXT boxX, boxY + 5, STR$(i+1) + ": " + galaxyNames$(i) + " [CURRENT]", "LT", 1
        ELSE
            BOX boxX - 2, boxY - 2, 130, 20, 1, 0
            TEXT boxX, boxY + 5, STR$(i+1) + ": " + galaxyNames$(i), "LT", 7
        ENDIF
    NEXT i
    
    ' Current location info
    BOX 20, 175, 280, 25, 1, 0
    TEXT CENTERX, 182, "Current Location: " + galaxyNames$(currentGalaxy) + " Galaxy", "CT", 7
    
    ' Warning panel about intergalactic jumps
    BOX 20, 210, 280, 25, 1, 0
    TEXT CENTERX, 217, "WARNING: Intergalactic hyperspace jumps consume ALL fuel", "CT", 7
    
    ' Controls help
    TEXT CENTERX, SHEIGHT - 10, "Press 1-8 to select galaxy, any other key to return", "CT", 7
    
    ' Wait for key press
    DO
        k$ = INKEY$
        
        ' Check for number keys 1-8 to select galaxy
        IF k$ >= "1" AND k$ <= "8" THEN
            ' Convert to 0-based index
            galaxyChoice = VAL(k$) - 1
            
            ' If selecting current galaxy, just return to map
            IF galaxyChoice = currentGalaxy THEN
                CLS
                GOSUB DrawGalacticMap
                RETURN
            ELSE
                ' For different galaxy, confirm selection
                BOX CENTERX-150, CENTERY-40, 300, 80, 1, 0
                TEXT CENTERX, CENTERY-25, "Jump to " + galaxyNames$(galaxyChoice) + "?", "CT", 1
                TEXT CENTERX, CENTERY, "(Y/N)", "CT", 1
                
                ' Wait for confirmation
                DO
                    confirm$ = INKEY$
                    IF confirm$ = "y" OR confirm$ = "Y" THEN
                        ' Set target galaxy for hyperspace jump
                        targetGalaxy = galaxyChoice
                        
                        ' Set system 0 (entry system) as the target
                        hyperspaceTarget = 0
                        
                        ' Return to game
                        RETURN
                    ELSEIF confirm$ = "n" OR confirm$ = "N" THEN
                        ' Redraw galaxy selector
                        CLS
                        GOSUB DrawGalaxySelector
                        RETURN
                    ENDIF
                LOOP
            ENDIF
        ENDIF
        
        IF k$ <> "" THEN
            CLS
            GOSUB DrawGalacticMap
            RETURN
        ENDIF
    LOOP
RETURN

WaitForKeypress:

    DO
        key$ = INKEY$
        

        valid = 0
        targetIdx = -1
        
        IF key$ >= "0" AND key$ <= "9" THEN
            targetIdx = VAL(key$)
            valid = 1
        ELSEIF key$ >= "a" AND key$ <= "f" OR key$ >= "A" AND key$ <= "F" THEN
            ' Convert A-F to values 10-15
            targetIdx = ASC(UCASE$(key$)) - 55
            valid = 1
        ENDIF
        
        IF valid = 1 AND targetIdx < CURRENT_VIEW_SYSTEMS THEN
            ' Calculate actual system ID in the galaxy
            actualSysID = sysID(targetIdx)
            hyperspaceTarget = targetIdx
            targetGalaxy = currentGalaxy  ' Same galaxy
            
            IF targetIdx = 0 THEN
                jumpDist = 0  ' Current system
            ELSE
                dx = sysX(targetIdx) - sysX(0)
                dy = sysY(targetIdx) - sysY(0)
                dz = sysZ(targetIdx) - sysZ(0)
                jumpDist = SQR(dx*dx + dy*dy + dz*dz) / mapScale
            ENDIF
            
            CLS
            FONT #7
            
            IF jumpDist <= fuel AND jumpDist > 0 THEN
                TEXT 10, 80, "TARGET SYSTEM SELECTED", "LT", 1
                TEXT 10, 100, "System: " + sysName$(hyperspaceTarget), "LT", 1
                TEXT 10, 120, "Government: " + governmentTypes$(sysGovt(hyperspaceTarget)), "LT", 1
                TEXT 10, 140, "Economy: " + economyTypes$(sysEcon(hyperspaceTarget)), "LT", 1
                TEXT 10, 160, "Tech Level: " + STR$(sysTech(hyperspaceTarget)), "LT", 1
                TEXT 10, 180, "Distance: " + STR$(INT(jumpDist * 10) / 10) + " LY", "LT", 1
                TEXT 10, 200, "Press J to initiate jump", "LT", 1
                
                desc$ = GeneratePlanetDescription$(sysDescSeed(hyperspaceTarget))
                
                IF LEN(desc$) > 45 THEN
                    splitPos = 45
                    WHILE MID$(desc$, splitPos, 1) <> " " AND splitPos > 1
                        splitPos = splitPos - 1
                    WEND
                    IF splitPos > 1 THEN
                        TEXT 10, 220, LEFT$(desc$, splitPos), "LT", 1
                        TEXT 10, 240, MID$(desc$, splitPos + 1), "LT", 1
                    ELSE
                        TEXT 10, 220, desc$, "LT", 1
                    ENDIF
                ELSE
                    TEXT 10, 220, desc$, "LT", 1
                ENDIF
            ELSEIF jumpDist = 0 THEN
                TEXT 10, 100, "Current system: " + sysName$(hyperspaceTarget), "LT", 1
                TEXT 10, 140, "No jump necessary", "LT", 1
                hyperspaceTarget = -1
            ELSE
                TEXT 10, 100, "System: " + sysName$(hyperspaceTarget), "LT", 1
                TEXT 10, 120, "Distance: " + STR$(INT(jumpDist * 10) / 10) + " LY", "LT", 1
                TEXT 10, 140, "INSUFFICIENT FUEL FOR JUMP", "LT", 1
                hyperspaceTarget = -1
            ENDIF
            
            PAUSE 2000
            RETURN
        ENDIF
        
            IF key$ = "g" OR key$ = "G" THEN
                CLS
                GOSUB DrawGalaxySelector
            ENDIF
            
            IF key$ = "?" OR key$ = "/" THEN
                GOSUB ShowControls
                needsUpdate = 1
            ENDIF
        IF key$ <> "" THEN RETURN
    LOOP
RETURN


DrawShip:
    FOR i = 0 TO 7
        x = vertices(i, 0)
        y = vertices(i, 1)
        z = vertices(i, 2)
        
        tempY = y * COS(0.2) - z * SIN(0.2)
        tempZ = y * SIN(0.2) + z * COS(0.2)
        
        x = x
        y = tempY
        z = tempZ
        
        z = z + 250
        
        IF z > 0 THEN
            scale = 200 / z
            points(i, 0) = x * scale + CENTERX
            points(i, 1) = y * scale + CENTERY
        ELSE
            ' Point behind camera
            points(i, 0) = -1
            points(i, 1) = -1
        ENDIF
    NEXT i
    
    FOR i = 0 TO 6
        v1 = faces(i, 0)
        v2 = faces(i, 1)
        v3 = faces(i, 2)
        
        x1 = points(v1, 0)
        y1 = points(v1, 1)
        x2 = points(v2, 0)
        y2 = points(v2, 1)
        x3 = points(v3, 0)
        y3 = points(v3, 1)
        
        IF x1 >= 0 AND x2 >= 0 AND x3 >= 0 THEN
            TRIANGLE x1,y1, x2,y2, x3,y3, 1, 1
        ENDIF
    NEXT i
    
    FOR i = 0 TO 11
        v1 = edges(i, 0)
        v2 = edges(i, 1)
        
        x1 = points(v1, 0)
        y1 = points(v1, 1)
        x2 = points(v2, 0)
        y2 = points(v2, 1)
        
        IF x1 >= 0 AND x2 >= 0 THEN
            LINE x1,y1, x2,y2, 1
        ENDIF
    NEXT i
RETURN

ShowControls:
    CLS
    GOSUB SetDefaultFont
    TEXT CENTERX, 30, "FLIGHT CONTROLS", "CT", 7
    TEXT CENTERX, 60, "Arrow Keys: Control ship orientation", "CT", 7
    TEXT CENTERX, 80, "← →: Turn left/right (yaw)", "CT", 7
    TEXT CENTERX, 100, "↑ ↓: Pitch down/up", "CT", 7
    TEXT CENTERX, 120, "R: Roll", "CT", 7
    TEXT CENTERX, 150, "W/S: Increase/decrease thrust", "CT", 7
    TEXT CENTERX, 180, "H: Hyperspace map", "CT", 7
    TEXT CENTERX, SHEIGHT-40, "Press any key to continue", "CT", 7
    
    DO
        key$ = INKEY$
        IF key$ <> "" THEN EXIT DO
    LOOP
RETURN

InitFrameBuffer:
    ' Initialize frame buffer system (software-based since BUFFER command not available)
    currentBuffer = BUFFER_BACK
RETURN

ClearFrameBuffer:
    ' Clear the screen for new frame
    CLS
RETURN

SwapFrameBuffers:
    ' Software frame buffer swap (no hardware double buffering available)
    ' Simply track current buffer state for future optimizations
    IF currentBuffer = BUFFER_BACK THEN
        currentBuffer = BUFFER_SCREEN
    ELSE
        currentBuffer = BUFFER_BACK
    ENDIF
RETURN

SetDefaultFont:
    FONT #7
RETURN

DrawText:
    GOSUB SetDefaultFont
    TEXT textX, textY, text$, textAlign$, 7  ' Use font 7 consistently
RETURN

' End of program
END
