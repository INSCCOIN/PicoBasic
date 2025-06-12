' INSCCOIN 2025 ©
' REQUIRES PICO 2 MINIMUM 
' ASTROX ONOSO V1.1
' Please report any found bugs or glitches, take a screenshot and send it to me.
' This is still a work in progress, so expect reworks and updates THERE WILL BE BUGS.
OPTION EXPLICIT

CONST MAPSIZE = 20 ' Size of the galaxy map (30x30)

DIM playerX, playerY, fuel, credits, hull, food
DIM map$(MAPSIZE, MAPSIZE)
DIM cmd$ AS STRING
DIM event$, row$ AS STRING
DIM medkits, upgrades
DIM x, y
DIM r
DIM planetType$ AS STRING, stationType$ AS STRING, asteroidType$ AS STRING
DIM enemyType, enemyHull, enemyDmg, dmg, reduced, reward
DIM enemy$ AS STRING
DIM lastCmd$ AS STRING
DIM log$(10)
DIM logPtr

' Art Title
CLS
PRINT "     ___   _   _   ___   ____   ___  "
PRINT "    / _ \ | \ | | / _ \ / ___| / _ \ "
PRINT "   | | | ||  \| || | | |\___ \| | | |"
PRINT "   | |_| || |\  || |_| | ___) | |_| |"
PRINT "    \___/ |_| \_| \___/ |____/ \___/ "
PRINT "              A S T R O X  "
PRINT "            V E R S I O N 1.1  "
PRINT "             INSCCOIN 2025  "
PRINT
PRINT "Commands: "
PRINT "N S E W SCAN LAND"
PRINT "STATUS MAP REST QUIT"
PRINT

' Initialize map with random events and types
FOR y = 1 TO MAPSIZE 
    FOR x = 1 TO MAPSIZE
        r = INT(RND * 20) 
        SELECT CASE r
            CASE 0: map$(y, x) = "Planet:Terra"
            CASE 1: map$(y, x) = "Planet:Ice"
            CASE 2: map$(y, x) = "Planet:Desert"
            CASE 3: map$(y, x) = "Planet:Gas Giant"
            CASE 4: map$(y, x) = "Planet:Volcanic"
            CASE 5: map$(y, x) = "Planet:Ocean"
            CASE 6: map$(y, x) = "Station:Trade"
            CASE 7: map$(y, x) = "Station:Military"
            CASE 8: map$(y, x) = "Station:Medical"
            CASE 9: map$(y, x) = "Station:Science"
            CASE 10: map$(y, x) = "Asteroid:Iron"
            CASE 11: map$(y, x) = "Asteroid:Ice"
            CASE 12: map$(y, x) = "Asteroid:Rare"
            CASE 13: map$(y, x) = "Asteroid:Carbon"
            CASE 14: map$(y, x) = "Asteroid:Radioactive"
            CASE ELSE: map$(y, x) = "Empty"
        END SELECT
    NEXT x
NEXT y

' Player stats
playerX = MAPSIZE \ 2
playerY = MAPSIZE \ 2
fuel = 50
credits = 10
hull = 20
food = 25
medkits = 1
upgrades = 0

DO
    ' Persistent status bar
    PRINT
    PRINT STRING$(30, "_")
    PRINT "Location (";playerX; ","; playerY;") - "; map$(playerY,playerX)
    PRINT "Fuel:"; fuel; "  Credits:"; credits; "  Hull:"; hull
    PRINT "Food:"; food; " Medkits:"; medkits; ' " Upgrades:"; upgrades   being reworked
    PRINT 
    PRINT STRING$(20, "-")
    PRINT "Type HELP for commands."
    PRINT "Use LOOK for sector details."
    PRINT

    INPUT "Command: ", cmd$
    cmd$ = UCASE$(cmd$)
    IF cmd$ = "" THEN cmd$ = lastCmd$
    lastCmd$ = cmd$

    SELECT CASE cmd$
        CASE "N", "NORTH"
            IF playerY > 1 THEN
                playerY = playerY - 1
                fuel = fuel - 1
                food = food - 1
                PRINT "You travel north."
                GOSUB Encounter
            ELSE
                PRINT "You can't go further north."
            END IF
        CASE "S", "SOUTH"
            IF playerY < MAPSIZE THEN
                playerY = playerY + 1
                fuel = fuel - 1
                food = food - 1
                PRINT "You travel south."
                GOSUB Encounter
            ELSE
                PRINT "You can't go further south."
            END IF
        CASE "E", "EAST"
            IF playerX < MAPSIZE THEN
                playerX = playerX + 1
                fuel = fuel - 1
                food = food - 1
                PRINT "You travel east."
                GOSUB Encounter
            ELSE
                PRINT "You can't go further east."
            END IF
        CASE "W", "WEST"
            IF playerX > 1 THEN
                playerX = playerX - 1
                fuel = fuel - 1
                food = food - 1
                PRINT "You travel west."
                GOSUB Encounter
            ELSE
                PRINT "You can't go further west."
            END IF
        CASE "LOOK"
            PRINT "Sector details:"
            PRINT "Type: "; map$(playerY, playerX)
            IF LEFT$(map$(playerY, playerX), 6) = "Planet" THEN
                PRINT "You can LAND here for resources."
            ELSEIF LEFT$(map$(playerY, playerX), 8) = "Station:" THEN
                PRINT "You can LAND here to trade or repair."
            ELSEIF LEFT$(map$(playerY, playerX), 9) = "Asteroid:" THEN
                PRINT "You can LAND here to mine."
            ELSE
                PRINT "Empty space. Nothing of interest."
            END IF
        CASE "SCAN"
            PRINT "Scanning..."
            PRINT "Sector: "; map$(playerY, playerX)
        CASE "LAND"
            GOSUB LandAction
        CASE "STATUS"
            PRINT "Location: ("; playerX; ","; playerY; ")"
            PRINT "Fuel:"; fuel; "  Credits:"; credits; "  Hull:"; hull; "  Food:"; food; "  Medkits:"; medkits; "  Upgrades:"; upgrades
        CASE "MAP"
            GOSUB ShowMap
        CASE "REST"
            PRINT "You rest and consume 2 food."
            food = food - 2
            hull = hull + 5
            IF hull > 100 + upgrades * 20 THEN hull = 100 + upgrades * 20
            GOSUB Encounter
        CASE "USE MEDKIT"
            IF medkits > 0 THEN
                INPUT "Use a medkit to heal 30 hull? (Y/N): ", q$
                IF UCASE$(q$) = "Y" THEN
                    PRINT "You use a medkit. +30 hull."
                    hull = hull + 30
                    IF hull > 100 + upgrades * 20 THEN hull = 100 + upgrades * 20
                    medkits = medkits - 1
                ELSE
                    PRINT "Medkit not used."
                END IF
            ELSE
                PRINT "You have no medkits."
            END IF
        CASE "FIGHT"
            IF map$(playerY, playerX) = "Empty" THEN
                PRINT "There's nothing to fight here."
            ELSE
                GOSUB Combat
            END IF
        CASE "CLEAR"
            CLS
        CASE "REPEAT"
            PRINT "Repeating last command: "; lastCmd$
            cmd$ = lastCmd$
            ' The loop will repeat the last command
        CASE "HINT"
            PRINT "Hints:"
            PRINT "- Visit stations to buy fuel, food, and upgrades."
            PRINT "- Use REST to recover hull (uses food)."
            PRINT "- Use LOOK to get details about your current sector."
            PRINT "- Use MAP to see your position and plan routes."
            PRINT "- Use FIGHT to engage in combat if available."
            PRINT "- Use USE MEDKIT to heal hull damage."
        CASE "LOG"
            PRINT "Recent Events:"
            FOR i = 1 TO 10
                IF log$(i) <> "" THEN PRINT log$(i)
            NEXT i
        CASE "HELP", "?"

            PRINT "Available Commands:"
            PRINT "N, S, E, W  - Move North, South, East, West"
            PRINT "LOOK        - Describe current sector"
            PRINT "SCAN        - Scan the current sector"
            PRINT "LAND        - Land or dock if possible"
            PRINT "STATUS      - Show ship status"
            PRINT "MAP         - Show galaxy map"
            PRINT "REST        - Rest and recover hull"
            PRINT "USE MEDKIT  - Use a medkit to heal"
            PRINT "FIGHT       - Engage in combat"
            PRINT "CLEAR       - Clear the screen"
            PRINT "REPEAT      - Repeat last command"
            PRINT "HINT        - Show gameplay tips"
            PRINT "QUIT        - Exit the game"
        CASE "QUIT"
            INPUT "Are you sure you want to quit? (Y/N): ", q$
            IF UCASE$(q$) = "Y" THEN
                PRINT "Goodbye, Captain!"
                END
            ELSE
                PRINT "Quit cancelled."
            END IF
        CASE ELSE
            PRINT "Invalid command. Type HELP for a list of commands."
    END SELECT

    IF fuel <= 0 THEN
        PRINT "You are out of fuel! Game Over."
        END
    END IF
    IF food <= 0 THEN
        PRINT "You have no food left! Game Over."
        END
    END IF
    IF hull <= 0 THEN
        PRINT "Your ship is destroyed! Game Over."
        END
    END IF
LOOP

'-------------------------
Encounter:
' 1 in 4 chance of random event
IF INT(RND * 4) = 0 THEN
    SELECT CASE INT(RND * 8)
        CASE 0
            PRINT "      .---."
            PRINT "   _/     \\_"
            PRINT "  / |     | \\"
            PRINT " |  |     |  |"
            PRINT " |  |     |  |"
            PRINT "  \\_|_____|_/"
            PRINT "   (  o o  )"
            PRINT "    \\_v_/"
            PRINT "  SPACE PIRATES!"
            PRINT "They fire on your ship! Hull damage and lose 10 credits."
            hull = hull - 20
            IF credits >= 10 THEN
                credits = credits - 10
            ELSE
                credits = 0
            END IF
        CASE 1
            PRINT "      .     ."
            PRINT "   .:        :."
            PRINT "  :  NEBULA   :"
            PRINT "   ':        :' "
            PRINT "      ':::'"
            PRINT "You pass through a nebula. Sensors scrambled, lose 2 fuel."
            fuel = fuel - 2
        CASE 2
            PRINT "      ______"
            PRINT "   .-'      '-."
            PRINT "  /  DERELICT  \\"
            PRINT " |    SHIP      |"
            PRINT "  \\            /"
            PRINT "   '-.______. -'"
            PRINT "You find a derelict ship. Salvage 15 credits and 3 food."
            credits = credits + 15
            food = food + 3
        CASE 3
            PRINT "      .-~~-."
            PRINT "     (      )"
            PRINT "   (  STORM  )"
            PRINT "     (      )"
            PRINT "      `-~~-'"
            PRINT "Cosmic storm! Hull takes 15 damage."
            hull = hull - 15
        CASE 4
            PRINT "      .-''''-."
            PRINT "     /        \\"
            PRINT "    |  (o o)   |"
            PRINT "    |   |=|    |"
            PRINT "     \\__|__/ "
            PRINT "Friendly trader gives you 5 food."
            food = food + 5
        CASE 5
            PRINT "      /\\"
            PRINT "     /__\\"
            PRINT "    |    |"
            PRINT "    |    |"
            PRINT "   /______\\"
            PRINT "You discover a rare mineral. +20 credits!"
            credits = credits + 20
        CASE 6
            PRINT "      .---."
            PRINT "     /     \\"
            PRINT "    | (   ) |"
            PRINT "     \\  -  /"
            PRINT "      '---'"
            PRINT "You hit a micro-meteor! Hull takes 10 damage."
            hull = hull - 10
        CASE 7
            PRINT "      ______"
            PRINT "     /      \\"
            PRINT "    | CARGO  |"
            PRINT "    |  POD   |"
            PRINT "     \\______/ "
            PRINT "You find a lost cargo pod. +10 credits, +2 food."
            credits = credits + 10
            food = food + 2
        CASE 8
            PRINT "      .-''''-."
            PRINT "     /        \\"
            PRINT "    |  SCIENCE |"
            PRINT "    |  ANOMALY |"
            PRINT "     \\______/"
            PRINT "You study a strange anomaly. +10 credits, +1 upgrade!"
            credits = credits + 10
            upgrades = upgrades + 1
        CASE 9
            PRINT "      .-^-."
            PRINT "     /     \\"
            PRINT "    |  PLAGUE |"
            PRINT "     \\_____/ "
            PRINT "A space plague sweeps your ship! -10 food, -10 hull."
            food = food - 10
            hull = hull - 10
    END SELECT
END IF
RETURN

'-------------------------
Combat:
' random enemy, attack/defend/run options

PRINT " "
PRINT "=== COMBAT ENGAGED! ==="
enemyType = INT(RND * 3)
SELECT CASE enemyType
    CASE 0
        enemy$ = "Space Pirate"
        enemyHull = 40
        enemyDmg = 15
    CASE 1
        enemy$ = "Alien Raider"
        enemyHull = 30
        enemyDmg = 10
    CASE 2
        enemy$ = "Rogue Drone"
        enemyHull = 20
        enemyDmg = 8
END SELECT

PRINT "You encounter a "; enemy$; "!"
DO WHILE enemyHull > 0 AND hull > 0
    PRINT "Your Hull:"; hull; " | "; enemy$; " Hull:"; enemyHull
    PRINT "Choose: ATTACK / DEFEND / RUN"
    INPUT "Action: ", cmd$
    cmd$ = UCASE$(cmd$)
    IF cmd$ = "ATTACK" THEN
        dmg = 10 + INT(RND * 10)
        PRINT "You fire and deal "; dmg; " damage!"
        enemyHull = enemyHull - dmg
        IF enemyHull > 0 THEN
            PRINT enemy$; " fires back!"
            hull = hull - enemyDmg
        END IF
    ELSEIF cmd$ = "DEFEND" THEN
        PRINT "You brace for impact. Damage reduced."
        reduced = INT(enemyDmg / 2)
        hull = hull - reduced
        PRINT enemy$; " attacks! You take "; reduced; " damage."
    ELSEIF cmd$ = "RUN" THEN
        IF RND < 0.5 THEN
            PRINT "You escape successfully!"
            RETURN
        ELSE
            PRINT "Failed to escape! The enemy attacks."
            hull = hull - enemyDmg
        END IF
    ELSE
        PRINT "Invalid action."
    END IF
LOOP

IF hull <= 0 THEN
    PRINT "Your ship is destroyed in battle!"
    END
ELSEIF enemyHull <= 0 THEN
    reward = 10 + INT(RND * 20)
    PRINT "You defeated the "; enemy$; "! You salvage "; reward; " credits."
    credits = credits + reward
END IF
RETURN

'-------------------------
LandAction:
    event$ = map$(playerY, playerX)
    IF LEFT$(event$, 6) = "Planet" THEN
        planetType$ = MID$(event$, 8)
        SELECT CASE planetType$
            CASE "Terra"
                PRINT "You land on a lush Terra planet. +10 credits, +8 food!"
                credits = credits + 10
                food = food + 8
            CASE "Ice"
                PRINT "You land on a frozen Ice planet. +8 credits, +4 food."
                credits = credits + 8
                food = food + 4
            CASE "Desert"
                PRINT "You land on a harsh Desert planet. +12 credits, +2 food."
                credits = credits + 12
                food = food + 2
            CASE "Gas Giant"
                PRINT "You skim a Gas Giant's atmosphere. +15 credits, -2 hull."
                credits = credits + 15
                hull = hull - 2
            CASE "Volcanic"
                PRINT "You land on a volcanic planet. +20 credits, -10 hull!"
                credits = credits + 20
                hull = hull - 10
            CASE "Ocean"
                PRINT "You land on an ocean world. +6 credits, +12 food!"
                credits = credits + 6
                food = food + 12
            CASE ELSE
                PRINT "You land on an unknown world. +5 credits."
                credits = credits + 5
        END SELECT
    ELSEIF LEFT$(event$, 8) = "Station:" THEN
        stationType$ = MID$(event$, 9)
        PRINT "You dock at a "; stationType$; " station. Welcome to the shop!"
        PRINT "Items for sale:"
        PRINT "1. Fuel (10 units) ........ 10 credits"
        PRINT "2. Hull Repair (full) ..... 20 credits"
        PRINT "3. Food (10 units) ........ 8 credits"
        PRINT "4. Medkit (+30 hull) ...... 25 credits"
        PRINT "5. Ship Upgrade (max hull+20) 50 credits"
        IF stationType$ = "Medical" THEN PRINT "6. Medkit (discount) ...... 15 credits"
        IF stationType$ = "Military" THEN PRINT "7. Weapon Upgrade ......... 40 credits"
        IF stationType$ = "Science" THEN PRINT "8. Scan Booster ........... 30 credits"
        PRINT "Enter item number to buy or 0 to exit:"
        INPUT "Buy: ", cmd$
        IF cmd$ = "1" AND credits >= 10 THEN
            fuel = fuel + 10
            credits = credits - 10
            PRINT "Purchased 10 fuel."
        ELSEIF cmd$ = "2" AND credits >= 20 THEN
            hull = 100 + upgrades * 20
            credits = credits - 20
            PRINT "Hull fully repaired."
        ELSEIF cmd$ = "3" AND credits >= 8 THEN
            food = food + 10
            credits = credits - 8
            PRINT "Purchased 10 food."
        ELSEIF cmd$ = "4" AND credits >= 25 THEN
            medkits = medkits + 1
            credits = credits - 25
            PRINT "Purchased a medkit."
        ELSEIF cmd$ = "5" AND credits >= 50 THEN
            upgrades = upgrades + 1
            credits = credits - 50
            PRINT "Ship upgraded! Max hull is now "; 100 + upgrades * 20
        ELSEIF cmd$ = "6" AND stationType$ = "Medical" AND credits >= 15 THEN
            medkits = medkits + 1
            credits = credits - 15
            PRINT "Purchased a medkit at discount!"
        ELSEIF cmd$ = "7" AND stationType$ = "Military" AND credits >= 40 THEN
            upgrades = upgrades + 1
            credits = credits - 40
            PRINT "Weapon upgraded! Combat damage increased."
        ELSEIF cmd$ = "8" AND stationType$ = "Science" AND credits >= 30 THEN
            PRINT "You install a scan booster. SCAN now reveals adjacent sectors!"
            credits = credits - 30
            ' You can implement scan booster logic as a flag if you wish
        ELSEIF cmd$ <> "0" THEN
            PRINT "Not enough credits or invalid choice."
        END IF
    ELSEIF LEFT$(event$, 9) = "Asteroid:" THEN
        asteroidType$ = MID$(event$, 10)
        SELECT CASE asteroidType$
            CASE "Iron"
                PRINT "You mine an iron asteroid. +5 credits!"
                credits = credits + 5
            CASE "Ice"
                PRINT "You mine an ice asteroid. +3 credits, +2 food."
                credits = credits + 3
                food = food + 2
            CASE "Rare"
                PRINT "You mine a rare asteroid. +15 credits!"
                credits = credits + 15
            CASE "Carbon"
                PRINT "You mine a carbon asteroid. +7 credits!"
                credits = credits + 7
            CASE "Radioactive"
                PRINT "You mine a radioactive asteroid. +25 credits, -10 hull!"
                credits = credits + 25
                hull = hull - 10
            CASE ELSE
                PRINT "You mine a small asteroid. +2 credits."
                credits = credits + 2
        END SELECT
    ELSE
        PRINT "Nothing to land on here."
    END IF

    logPtr = logPtr + 1
    IF logPtr > 10 THEN logPtr = 1
    log$(logPtr) = "You land on a lush Terra planet. +10 credits, +8 food!"

RETURN

'-------------------------
ShowMap:
    PRINT "Galaxy Map (T=Terra, I=Ice, D=Desert, G=Gas, V=Volcanic, O=Ocean, t=Trade, m=Med, M=Mil, s=Science, i=Iron, r=Rare, c=IceAst, b=Carbon, x=Rad, .=Empty, @=You):"
    FOR y = 1 TO MAPSIZE
        row$ = ""
        FOR x = 1 TO MAPSIZE
            IF x = playerX AND y = playerY THEN
                row$ = row$ + "@"
            ELSEIF LEFT$(map$(y, x), 12) = "Planet:Terra" THEN
                row$ = row$ + "T"
            ELSEIF LEFT$(map$(y, x), 10) = "Planet:Ice" THEN
                row$ = row$ + "I"
            ELSEIF LEFT$(map$(y, x), 13) = "Planet:Desert" THEN
                row$ = row$ + "D"
            ELSEIF LEFT$(map$(y, x), 15) = "Planet:Gas Giant" THEN
                row$ = row$ + "G"
            ELSEIF LEFT$(map$(y, x), 14) = "Planet:Volcanic" THEN
                row$ = row$ + "V"
            ELSEIF LEFT$(map$(y, x), 11) = "Planet:Ocean" THEN
                row$ = row$ + "O"
            ELSEIF map$(y, x) = "Station:Trade" THEN
                row$ = row$ + "t"
            ELSEIF map$(y, x) = "Station:Medical" THEN
                row$ = row$ + "m"
            ELSEIF map$(y, x) = "Station:Military" THEN
                row$ = row$ + "M"
            ELSEIF map$(y, x) = "Station:Science" THEN
                row$ = row$ + "s"
            ELSEIF map$(y, x) = "Asteroid:Iron" THEN
                row$ = row$ + "i"
            ELSEIF map$(y, x) = "Asteroid:Rare" THEN
                row$ = row$ + "r"
            ELSEIF map$(y, x) = "Asteroid:Ice" THEN
                row$ = row$ + "c"
            ELSEIF map$(y, x) = "Asteroid:Carbon" THEN
                row$ = row$ + "b"
            ELSEIF map$(y, x) = "Asteroid:Radioactive" THEN
                row$ = row$ + "x"
            ELSE
                row$ = row$ + "."
            END IF
        NEXT x
        PRINT row$
    NEXT y
RETURN
