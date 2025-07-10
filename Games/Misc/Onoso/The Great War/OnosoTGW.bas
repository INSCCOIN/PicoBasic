' ONOSO THE GREAT WAR 1.0
' INSCCOIN 2025
' Please report any found bugs or glitches, take a screenshot and send it to me.
' This is a work in progress. Expect updates!
' This is the best game ive ever made on any platform, please enjoy!
' GPT 4.1 was used for some of the design ideas / gameplay lines  360-420ish are GPT generated.

' I know i promised side quests but i was having difficulties getting them to work correctly, theyll be added in OnosoTGW 1.1
' THIS PROGRAM WAS WRITTEN WHEN I DIDNT HAVE A SCREEN FOR MY PICO, I USED WINDOWS MMBASIC AND IT WORKED FINE. TODAY, 7/10/25 I FIXED ALL DIM ISSUES & SCREEN TEXT ISSUES
' KNOWN BUGLIST:
' BUG 1: Using the command LOOK multiple times in a sector will result in resupply / re-fight, please dont abuse this, currently working on it.
' BUG 2: Sometimes when you reach an extraction point the game fails to end, this only happened once in testing out of the 9 times i played through the final 1.0 version.
' BUG 3: Fuel, Credits, Haul, Rations and medkits have no limit currently, future versions will have a cap of 100 for fuel, 100 for rations, 100 for haul, 5000 for credits and 25 for medkits. 
' BUG 4: The game will hang if you try to use a medkit when you have none 
' BUG 5: The game might crash if you try to fight in an empty sector
' BUG 6: The game might crash if you try to camp in a sector with no camp option
' BUG 7: On my 7th playthrough the game crashed when i tried to use a medkit? (i think it was a fluke, i tried recreating it but couldnt)
' BUG 8: Map sometimes glitches out when you use the command MAPKEY, MAPKEY was removed from the command list but can still be accessed. 
OPTION EXPLICIT

RANDOMIZE TIMER

' once again, im constricted by the size of the calcs display :(
CONST MAPSIZE = 12 ' (12x12)

DIM playerX, playerY, fuel, credits, hull, rations
DIM map$(MAPSIZE, MAPSIZE)
DIM cmd$
DIM event$, row$
DIM medkits, upgrades
DIM x, y, r
DIM sectorType$
DIM enemyType, enemyHull, enemyDmg, dmg, reduced, reward
DIM enemy$
DIM lastCmd$
DIM log$(10)
DIM logPtr
DIM personalLog$(20)
DIM personalLogPtr
DIM q$ 

' event flags
DIM storyEvent1, storyEvent2, storyEvent3
storyEvent1 = 0 ' found the Resistance
storyEvent2 = 0 ' discovered the Enemy Superweapon
storyEvent3 = 0 ' reached Extraction Point

' encounter flags
DIM metFactionA, metFactionB
metFactionA = 0 ' united Patrol
metFactionB = 0 ' orion Patrol

CLS
PRINT "     ___   _   _   ___   ____   ___  "
PRINT "    / _ \ | \ | | / _ \ / ___| / _ \ "
PRINT "   | | | ||  \| || | | |\___ \| | | |"
PRINT "   | |_| || |\  || |_| | ___) | |_| |"
PRINT "    \___/ |_| \_| \___/ |____/ \___/ "
PRINT "       T H E   G R E A T   W A R     "
PRINT "            INSCCOIN 2025            "
PRINT
INPUT "Press ENTER to see your mission...", q$
CLS
PRINT "STORY:"
PRINT "The year is 2233. The galaxy is torn apart by the Great War, a conflict between the United Colonies and the Dominion of Orion."
PRINT "You are Commander Veyra, leader of a small but elite strike unit stranded behind enemy lines after a failed assault on the Orion stronghold."
PRINT "Your mission: survive, gather resources, and find a way to break through the front and deliver critical intelligence that could end the war."
PRINT "Every sector is a risk—battlefields, ruined outposts, and the wreckage of war."
PRINT "Allies are rare, enemies are everywhere, and the fate of millions may rest on your choices."
INPUT "Press ENTER to continue...", q$
CLS
PRINT "The United Colonies, once a beacon of hope and unity, now fights desperately to hold back the relentless advance of the Dominion of Orion. The Dominion,"
PRINT "ruled by the enigmatic Warlord Kael, seeks to impose order through conquest, wielding advanced technology and ruthless tactics."
PRINT "The war has left entire worlds scarred. Cities lie in ruins, and ancient relics of lost civilizations are unearthed by the chaos. Resistance cells operate" 
PRINT "in secret, sabotaging Dominion supply lines and gathering intelligence for the Colonies."
INPUT "Press ENTER to continue...", q$
CLS
PRINT "You and your crew were tasked with infiltrating the Orion stronghold to uncover the secret behind their new superweapon—a weapon rumored to have the power to"
PRINT "end the war in a single strike. The mission went wrong: your dropship was shot down, and you awoke in the heart of enemy territory, your unit scattered and supplies low."
PRINT "Now, you must navigate the war-torn sectors, seeking out allies among the Resistance, scavenging for resources, and avoiding Dominion patrols. The intelligence you carry "
PRINT "could turn the tide, but only if you can survive long enough to reach the extraction point."
INPUT "Press ENTER to begin your mission...", q$
PRINT
CLS
PRINT "Commands: "
PRINT "N S E W SCAN CAMP"
PRINT "STATUS MAP REST QUIT"
PRINT

' random map gen
FOR y = 1 TO MAPSIZE
    FOR x = 1 TO MAPSIZE
        r = INT(RND * 30)
        SELECT CASE r
            CASE 0: map$(y, x) = "Battlefield:Ruins"
            CASE 1: map$(y, x) = "Battlefield:Trenches"
            CASE 2: map$(y, x) = "Battlefield:No Man's Land"
            CASE 3: map$(y, x) = "Outpost:Supply"
            CASE 4: map$(y, x) = "Outpost:Medical"
            CASE 5: map$(y, x) = "Outpost:Command"
            CASE 6: map$(y, x) = "Depot:Ammo"
            CASE 7: map$(y, x) = "Depot:Fuel"
            CASE 8: map$(y, x) = "Depot:Rations"
            CASE 9: map$(y, x) = "Depot:Tech"
            CASE 10: map$(y, x) = "Wreckage:Tank"
            CASE 11: map$(y, x) = "Wreckage:Ship"
            CASE 12: map$(y, x) = "Wreckage:Drone"
            CASE 13: map$(y, x) = "Wreckage:Artillery"
            CASE 14: map$(y, x) = "Wreckage:Relic"
            CASE ELSE: map$(y, x) = "Empty"
        END SELECT
    NEXT x
NEXT y

' stats
playerX = MAPSIZE \ 2
playerY = MAPSIZE \ 2
fuel = 50
credits = 10
hull = 20
rations = 25
medkits = 1
upgrades = 0

DO
    PRINT
    PRINT STRING$(30, "_")
    PRINT "Location (";playerX; ","; playerY;") - "; map$(playerY,playerX)
    PRINT "Fuel:"; fuel; "  Credits:"; credits; "  Hull:"; hull; " ("; INT(100 * hull / (100 + upgrades * 20)); "%)"
    PRINT "Rations:"; rations; " Medkits:"; medkits
    PRINT
    PRINT STRING$(20, "-")
    PRINT "Type HELP for commands."
    PRINT "Use LOOK for sector details."
    PRINT

    INPUT "Command (ENTER=repeat): ", cmd$
    cmd$ = UCASE$(cmd$)
    IF cmd$ = "0" OR cmd$ = "" THEN cmd$ = lastCmd$
    lastCmd$ = cmd$

    SELECT CASE cmd$
        CASE "N", "NORTH"
            IF playerY > 1 THEN
                playerY = playerY - 1
                fuel = fuel - 1
                rations = rations - 1
                PRINT "You advance north."
                GOSUB Encounter
            ELSE
                PRINT "You can't go further north."
            END IF
        CASE "S", "SOUTH"
            IF playerY < MAPSIZE THEN
                playerY = playerY + 1
                fuel = fuel - 1
                rations = rations - 1
                PRINT "You advance south."
                GOSUB Encounter
            ELSE
                PRINT "You can't go further south."
            END IF
        CASE "E", "EAST"
            IF playerX < MAPSIZE THEN
                playerX = playerX + 1
                fuel = fuel - 1
                rations = rations - 1
                PRINT "You advance east."
                GOSUB Encounter
            ELSE
                PRINT "You can't go further east."
            END IF
        CASE "W", "WEST"
            IF playerX > 1 THEN
                playerX = playerX - 1
                fuel = fuel - 1
                rations = rations - 1
                PRINT "You advance west."
                GOSUB Encounter
            ELSE
                PRINT "You can't go further west."
            END IF
        CASE "LOOK"
            PRINT "Sector details:"
            PRINT "Type: "; map$(playerY, playerX)
            IF LEFT$(map$(playerY, playerX), 11) = "Battlefield" THEN
                PRINT "You can CAMP here for resources."
            ELSEIF LEFT$(map$(playerY, playerX), 7) = "Outpost" THEN
                PRINT "You can CAMP here to trade or heal."
            ELSEIF LEFT$(map$(playerY, playerX), 6) = "Depot:" THEN
                PRINT "You can CAMP here to resupply."
            ELSEIF LEFT$(map$(playerY, playerX), 9) = "Wreckage:" THEN
                PRINT "You can search for salvage."
            ELSE
                PRINT "Empty sector. Nothing of interest."
            END IF
        CASE "SCAN"
            PRINT "Scanning..."
            PRINT "Sector: "; map$(playerY, playerX)
        CASE "CAMP"
            GOSUB CampAction
        CASE "STATUS"
            PRINT "Location: ("; playerX; ","; playerY; ")"
            PRINT "Fuel:"; fuel; "  Credits:"; credits; "  Hull:"; hull; " ("; INT(100 * hull / (100 + upgrades * 20)); "%)"; "  Rations:"; rations; "  Medkits:"; medkits; "  Upgrades:"; upgrades
        CASE "MAP"
            CLS
            GOSUB ShowMap
        CASE "MAPKEY"
            PRINT "Map Key:" 
            PRINT "R = Ruins        S = Supply Outpost     t = Tank Wreck     * = Resistance"
            PRINT "T = Trenches     M = Medical Outpost    s = Ship Wreck     $ = Superweapon"
            PRINT "N = No Man's Land C = Command Outpost   d = Drone Wreck    E = Extraction"
            PRINT "A = Ammo Depot   F = Fuel Depot         a = Artillery Wreck"
            PRINT "Q = Rations Depot X = Tech Depot        l = Relic Wreck"
            PRINT ". = Empty        @ = You"
        CASE "REST"
            PRINT "You rest and consume 2 rations."
            rations = rations - 2
            hull = hull + 5
            IF hull > 100 + upgrades * 20 THEN hull = 100 + upgrades * 20
            GOSUB Encounter
            GOSUB StatusAfterRest
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
        CASE "HINT"
            PRINT "Hints:"
            PRINT "- Visit outposts to buy fuel, rations, and upgrades."
            PRINT "- Use REST to recover hull (uses rations)."
            PRINT "- Use LOOK to get details about your current sector."
            PRINT "- Use MAP to see your position and plan routes."
            PRINT "- Use FIGHT to engage in combat if available."
            PRINT "- Use USE MEDKIT to heal hull damage."
        CASE "LOG"
            PRINT "Recent Events:"
            FOR i = 1 TO 10
                IF log$(i) <> "" THEN PRINT log$(i)
            NEXT i
            PRINT "Personal Log:"
            FOR i = 1 TO 20
                IF personalLog$(i) <> "" THEN PRINT personalLog$(i)
            NEXT i
        CASE "INV", "INVENTORY"
            PRINT "Inventory:" 
            PRINT "Fuel:"; fuel; "  Rations:"; rations; "  Medkits:"; medkits
            PRINT "Credits:"; credits; "  Upgrades:"; upgrades
            PRINT "Hull:"; hull; "/"; 100 + upgrades * 20
            PRINT "Special Items:"
            IF upgrades > 0 THEN PRINT " - Unit Upgrades x"; upgrades
            IF medkits > 0 THEN PRINT " - Medkits x"; medkits
            IF credits > 0 THEN PRINT " - Credits: "; credits
            IF rations > 0 THEN PRINT " - Rations: "; rations
            IF fuel > 0 THEN PRINT " - Fuel: "; fuel
            IF hull < 100 + upgrades * 20 THEN PRINT " - Hull damaged!"
            IF hull = 100 + upgrades * 20 THEN PRINT " - Hull at maximum."
            IF upgrades = 0 AND medkits = 0 AND credits = 0 AND rations = 0 AND fuel = 0 THEN PRINT " (none)"
        CASE "HELP", "?"
            PRINT "Available Commands:"
            PRINT "N, S, E, W  - North, South, East, West"
            PRINT "LOOK        - Describe current sector"
            PRINT "SCAN        - Scan the current sector"
            PRINT "CAMP        - Camp or resupply if possible"
            PRINT "STATUS      - Show unit status"
            PRINT "MAP         - Show war map"
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
                PRINT "Farewell, Commander!"
                END
            ELSE
                PRINT "Quit cancelled."
            END IF
        CASE ELSE
            PRINT "Invalid command. Type HELP for a list of commands."
    END SELECT

    ' event triggers
    IF playerX = 3 AND playerY = 3 AND storyEvent1 = 0 THEN
        PRINT "--- STORY EVENT: The Resistance ---"
        PRINT "You discover a hidden bunker. Inside, the local Resistance offers you supplies and vital intel."
        PRINT "They warn you of a new enemy superweapon and mark its last known location on your map."
        rations = rations + 10: medkits = medkits + 1: credits = credits + 20
        storyEvent1 = 1
        logPtr = logPtr + 1: IF logPtr > 10 THEN logPtr = 1
        log$(logPtr) = "Met the Resistance and received supplies."
        personalLogPtr = personalLogPtr + 1: IF personalLogPtr > 20 THEN personalLogPtr = 1
        personalLog$(personalLogPtr) = "Day " + STR$(personalLogPtr) + ": Met the Resistance."
    END IF
    IF playerX = 10 AND playerY = 2 AND storyEvent2 = 0 THEN
        PRINT "--- STORY EVENT: Enemy Superweapon ---"
        PRINT "You find the wreckage of a massive enemy weapon. The data you recover reveals a weakness in the Dominion's defenses!"
        upgrades = upgrades + 1: credits = credits + 30
        storyEvent2 = 1
        logPtr = logPtr + 1: IF logPtr > 10 THEN logPtr = 1
        log$(logPtr) = "Discovered enemy superweapon wreckage."
        personalLogPtr = personalLogPtr + 1: IF personalLogPtr > 20 THEN personalLogPtr = 1
        personalLog$(personalLogPtr) = "Day " + STR$(personalLogPtr) + ": Found enemy superweapon wreckage."
    END IF
    IF playerX = 12 AND playerY = 12 AND storyEvent3 = 0 THEN
        PRINT "--- STORY EVENT: Extraction Point ---"
        PRINT "You reach the extraction point! A United Colonies dropship lands under fire and whisks you away."
        PRINT "Your intelligence will help end the war. Congratulations, Commander Veyra!"
        PRINT "GAME WON!"
        personalLogPtr = personalLogPtr + 1: IF personalLogPtr > 20 THEN personalLogPtr = 1
        personalLog$(personalLogPtr) = "Day " + STR$(personalLogPtr) + ": Escaped to extraction."
        END
    END IF

    IF fuel <= 0 THEN
        PRINT "You are out of fuel! Game Over."
        END
    END IF
    IF rations <= 0 THEN
        PRINT "You have no rations left! Game Over."
        END
    END IF
    IF hull <= 0 THEN
        PRINT "Your unit is destroyed! Game Over."
        END
    END IF
LOOP


Encounter:
IF INT(RND * 4) = 0 THEN
    SELECT CASE INT(RND * 12)
        CASE 0
            PRINT "Enemy ambush! You take heavy fire. Hull -20, lose 10 credits."
            hull = hull - 20
            IF credits >= 10 THEN
                credits = credits - 10
            ELSE
                credits = 0
            END IF
        CASE 1
            PRINT "Minefield! You lose 2 fuel."
            fuel = fuel - 2
        CASE 2
            PRINT "Abandoned supply cache! +15 credits, +3 rations."
            credits = credits + 15
            rations = rations + 3
        CASE 3
            PRINT "Artillery barrage! Hull -15."
            hull = hull - 15
        CASE 4
            PRINT "Friendly medics! +5 rations."
            rations = rations + 5
        CASE 5
            PRINT "War relic found! +20 credits!"
            credits = credits + 20
        CASE 6
            PRINT "Sniper attack! Hull -10."
            hull = hull - 10
        CASE 7
            PRINT "Lost supply drop! +10 credits, +2 rations."
            credits = credits + 10
            rations = rations + 2
        CASE 8
            PRINT "Experimental tech! +10 credits, +1 upgrade!"
            credits = credits + 10
            upgrades = upgrades + 1
        CASE 9
            PRINT "Disease outbreak! -10 rations, -10 hull."
            rations = rations - 10
            hull = hull - 10
        CASE 10
            ' patrol ally
            IF metFactionA = 0 THEN
                PRINT "You encounter a United Colonies patrol. They offer you a choice:"
                PRINT "1. Request supplies (+5 rations, +5 fuel)"
                PRINT "2. Request medical aid (+20 hull)"
                PRINT "3. Request information (next Resistance location revealed)"
                PRINT "4. Request backup (chance for a combat ally in next battle)"
                PRINT "5. Request news (learn about the war's progress)"
                INPUT "Choose (1-5): ", cmd$
                IF cmd$ = "1" THEN
                    rations = rations + 5: fuel = fuel + 5
                    PRINT "They share supplies."
                ELSEIF cmd$ = "2" THEN
                    hull = hull + 20: IF hull > 100 + upgrades * 20 THEN hull = 100 + upgrades * 20
                    PRINT "They patch up your wounds."
                ELSEIF cmd$ = "3" THEN
                    PRINT "They mark a possible Resistance cell at (5,8) on your map."
                ELSEIF cmd$ = "4" THEN
                    PRINT "A marine from the patrol volunteers to join you for a while. In your next battle, you will take less damage!"
                    upgrades = upgrades + 1
                    logPtr = logPtr + 1: IF logPtr > 10 THEN logPtr = 1
                    log$(logPtr) = "Received backup from United Colonies patrol."
                ELSEIF cmd$ = "5" THEN
                    PRINT "They share news: The Dominion has suffered heavy losses on the outer rim, but their superweapon remains a threat."
                    PRINT "Morale among the Colonies is rising, but the war is far from over."
                ELSE
                    PRINT "They wish you luck."
                END IF
                metFactionA = 1
                logPtr = logPtr + 1: IF logPtr > 10 THEN logPtr = 1
                log$(logPtr) = "Met United Colonies patrol."
            END IF
        CASE 11
            ' patrol enemy
            IF metFactionB = 0 THEN
                PRINT "You are intercepted by an Orion Dominion patrol. They demand your surrender."
                PRINT "1. Attempt to bribe them (-15 credits, avoid combat)"
                PRINT "2. Attempt to talk your way out (50% chance)"
                PRINT "3. Prepare to fight"
                INPUT "Choose (1-3): ", cmd$
                IF cmd$ = "1" AND credits >= 15 THEN
                    credits = credits - 15
                    PRINT "They accept your bribe and let you go."
                ELSEIF cmd$ = "2" THEN
                    IF RND < 0.5 THEN
                        PRINT "You convince them you're not worth the trouble. They let you go."
                    ELSE
                        PRINT "They don't believe you. Prepare for battle!"
                        GOSUB Combat
                    END IF
                ELSE
                    PRINT "You ready your weapons!"
                    GOSUB Combat
                END IF
                metFactionB = 1
                logPtr = logPtr + 1: IF logPtr > 10 THEN logPtr = 1
                log$(logPtr) = "Encountered Orion Dominion patrol."
            END IF
    END SELECT
END IF
RETURN

Combat:
PRINT " "
PRINT "=== BATTLE ENGAGED! ==="
enemyType = INT(RND * 3)
SELECT CASE enemyType
    CASE 0
        enemy$ = "Enemy Infantry"
        enemyHull = 40
        enemyDmg = 15
    CASE 1
        enemy$ = "Enemy Tank"
        enemyHull = 30
        enemyDmg = 10
    CASE 2
        enemy$ = "Enemy Drone"
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
        PRINT "You attack and deal "; dmg; " damage!"
        enemyHull = enemyHull - dmg
        IF enemyHull > 0 THEN
            PRINT enemy$; " fires back!"
            hull = hull - enemyDmg
        END IF
    ELSEIF cmd$ = "DEFEND" THEN
        PRINT "You take cover. Damage reduced."
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
    PRINT "Your unit is destroyed in battle!"
    END
ELSEIF enemyHull <= 0 THEN
    reward = 10 + INT(RND * 20)
    PRINT "You defeated the "; enemy$; "! You salvage "; reward; " credits."
    credits = credits + reward
END IF
RETURN

CampAction:
    event$ = map$(playerY, playerX)
    IF LEFT$(event$, 11) = "Battlefield" THEN
        sectorType$ = MID$(event$, 13)
        SELECT CASE sectorType$
            CASE "Ruins"
                PRINT "You scavenge the ruins. +10 credits, +8 rations!"
                credits = credits + 10
                rations = rations + 8
            CASE "Trenches"
                PRINT "You search the trenches. +8 credits, +4 rations."
                credits = credits + 8
                rations = rations + 4
            CASE "No Man's Land"
                PRINT "You risk No Man's Land. +12 credits, +2 rations."
                credits = credits + 12
                rations = rations + 2
            CASE ELSE
                PRINT "You find some supplies. +5 credits."
                credits = credits + 5
        END SELECT
    ELSEIF LEFT$(event$, 7) = "Outpost" THEN
        sectorType$ = MID$(event$, 9)
        PRINT "You enter an outpost. Welcome to the quartermaster!"
        PRINT "Items for sale:"
        PRINT "1. Fuel (10 units) ........ 10 credits"
        PRINT "2. Hull Repair (full) ..... 20 credits"
        PRINT "3. Rations (10 units) ..... 8 credits"
        PRINT "4. Medkit (+30 hull) ...... 25 credits"
        PRINT "5. Upgrade (max hull+20) .. 50 credits"
        IF sectorType$ = "Medical" THEN PRINT "6. Medkit (discount) ...... 15 credits"
        IF sectorType$ = "Command" THEN PRINT "7. Tactics Upgrade ........ 40 credits"
        IF sectorType$ = "Tech" THEN PRINT "8. Tech Booster ........... 30 credits"
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
            rations = rations + 10
            credits = credits - 8
            PRINT "Purchased 10 rations."
        ELSEIF cmd$ = "4" AND credits >= 25 THEN
            medkits = medkits + 1
            credits = credits - 25
            PRINT "Purchased a medkit."
        ELSEIF cmd$ = "5" AND credits >= 50 THEN
            upgrades = upgrades + 1
            credits = credits - 50
            PRINT "Unit upgraded! Max hull is now "; 100 + upgrades * 20
        ELSEIF cmd$ = "6" AND sectorType$ = "Medical" AND credits >= 15 THEN
            medkits = medkits + 1
            credits = credits - 15
            PRINT "Purchased a medkit at discount!"
        ELSEIF cmd$ = "7" AND sectorType$ = "Command" AND credits >= 40 THEN
            upgrades = upgrades + 1
            credits = credits - 40
            PRINT "Tactics upgraded! Combat damage increased."
        ELSEIF cmd$ = "8" AND sectorType$ = "Tech" AND credits >= 30 THEN
            PRINT "You install a tech booster. SCAN now reveals adjacent sectors!"
            credits = credits - 30
        ELSEIF cmd$ <> "0" THEN
            PRINT "Not enough credits or invalid choice."
        END IF
    ELSEIF LEFT$(event$, 6) = "Depot:" THEN
        sectorType$ = MID$(event$, 7)
        SELECT CASE sectorType$
            CASE "Ammo"
                PRINT "You resupply at the ammo depot. +5 credits!"
                credits = credits + 5
            CASE "Fuel"
                PRINT "You resupply at the fuel depot. +10 fuel."
                fuel = fuel + 10
            CASE "Rations"
                PRINT "You resupply at the rations depot. +10 rations."
                rations = rations + 10
            CASE "Tech"
                PRINT "You resupply at the tech depot. +15 credits!"
                credits = credits + 15
            CASE ELSE
                PRINT "You find a few supplies. +2 credits."
                credits = credits + 2
        END SELECT
    ELSEIF LEFT$(event$, 9) = "Wreckage:" THEN
        sectorType$ = MID$(event$, 10)
        SELECT CASE sectorType$
            CASE "Tank"
                PRINT "You salvage a tank wreck. +5 credits!"
                credits = credits + 5
            CASE "Ship"
                PRINT "You salvage a ship wreck. +3 credits, +2 rations."
                credits = credits + 3
                rations = rations + 2
            CASE "Drone"
                PRINT "You salvage a drone wreck. +15 credits!"
                credits = credits + 15
            CASE "Artillery"
                PRINT "You salvage artillery wreckage. +7 credits!"
                credits = credits + 7
            CASE "Relic"
                PRINT "You find a war relic. +25 credits!"
                credits = credits + 25
            CASE ELSE
                PRINT "You salvage some scrap. +2 credits."
                credits = credits + 2
        END SELECT
    ELSE
        PRINT "Nothing to camp or salvage here."
    END IF

    logPtr = logPtr + 1
    IF logPtr > 10 THEN logPtr = 1
    log$(logPtr) = "You camped in a war zone."

RETURN

ShowMap:
    FOR y = 1 TO MAPSIZE
        row$ = ""
        FOR x = 1 TO MAPSIZE
            IF x = playerX AND y = playerY THEN
                row$ = row$ + "@"
            ELSEIF x = 3 AND y = 3 THEN
                row$ = row$ + "*"
            ELSEIF x = 10 AND y = 2 THEN
                row$ = row$ + "$"
            ELSEIF x = 12 AND y = 12 THEN
                row$ = row$ + "E"
            ELSEIF LEFT$(map$(y, x), 18) = "Battlefield:Ruins" THEN
                row$ = row$ + "R"
            ELSEIF LEFT$(map$(y, x), 20) = "Battlefield:Trenches" THEN
                row$ = row$ + "T"
            ELSEIF LEFT$(map$(y, x), 25) = "Battlefield:No Man's Land" THEN
                row$ = row$ + "N"
            ELSEIF map$(y, x) = "Outpost:Supply" THEN
                row$ = row$ + "S"
            ELSEIF map$(y, x) = "Outpost:Medical" THEN
                row$ = row$ + "M"
            ELSEIF map$(y, x) = "Outpost:Command" THEN
                row$ = row$ + "C"
            ELSEIF map$(y, x) = "Depot:Ammo" THEN
                row$ = row$ + "A"
            ELSEIF map$(y, x) = "Depot:Fuel" THEN
                row$ = row$ + "F"
            ELSEIF map$(y, x) = "Depot:Rations" THEN
                row$ = row$ + "Q"
            ELSEIF map$(y, x) = "Depot:Tech" THEN
                row$ = row$ + "X"
            ELSEIF map$(y, x) = "Wreckage:Tank" THEN
                row$ = row$ + "t"
            ELSEIF map$(y, x) = "Wreckage:Ship" THEN
                row$ = row$ + "s"
            ELSEIF map$(y, x) = "Wreckage:Drone" THEN
                row$ = row$ + "d"
            ELSEIF map$(y, x) = "Wreckage:Artillery" THEN
                row$ = row$ + "a"
            ELSEIF map$(y, x) = "Wreckage:Relic" THEN
                row$ = row$ + "l"
            ELSE
                row$ = row$ + "."
            END IF
        NEXT x
        PRINT row$
    NEXT y
RETURN
