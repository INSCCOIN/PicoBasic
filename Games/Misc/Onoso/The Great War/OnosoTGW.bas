' ONOSO THE GREAT WAR 1.3
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
' BUG 7: On my 7th playthrough the game crashed when i tried to use a medkit? (i think it was a fluke, i tried recreating it but couldnt) 
OPTION EXPLICIT

RANDOMIZE TIMER

' once again, im constricted by the size of the calcs display :(
CONST MAPWIDTH = 40
CONST MAPHEIGHT = 15

DIM playerX, playerY, fuel, credits, hull, rations
DIM map$(MAPHEIGHT, MAPWIDTH)
DIM cmd$
DIM event$, row$
DIM medkits, upgrades
DIM x, y, r
DIM i
DIM sectorType$
DIM enemyType, enemyHull, enemyDmg, dmg, reduced, reward
DIM enemy$
DIM lastCmd$
DIM log$(10)
DIM logPtr
DIM personalLog$(20)
DIM personalLogPtr
DIM q$
DIM saveFile$

' notes
DIM notes1$(10)
DIM notes2$(10)
DIM notes1Count, notes2Count

' side quests
DIM activeQuests$(5)
DIM questProgress(5)
DIM questComplete(5)
DIM questCount
DIM questGiver$
DIM questReward
DIM sectorsVisited
DIM enemiesDefeated

' event flags
DIM storyEvent1, storyEvent2, storyEvent3
storyEvent1 = 0 ' found the Resistance
storyEvent2 = 0 ' discovered the Enemy Superweapon
storyEvent3 = 0 ' reached Extraction Point

' encounter flags
DIM metFactionA, metFactionB
metFactionA = 0 ' united Patrol
metFactionB = 0 ' orion Patrol

' initialize notes
notes1Count = 0
notes2Count = 0
FOR i = 1 TO 10
    notes1$(i) = ""
    notes2$(i) = ""
NEXT i

' initialize quest system
questCount = 0
sectorsVisited = 0
enemiesDefeated = 0
FOR i = 1 TO 5
    activeQuests$(i) = ""
    questProgress(i) = 0
    questComplete(i) = 0
NEXT i

CLS
Color RGB(143,39,183)
Print "     ___   _   _   ___   ____   ___  "
Print "    / _ \ | \ | | / _ \ / ___| / _ \ "
Color RGB(239,189,11)
Print "   | | | ||  \| || | | |\___ \| | | |"
Print "   | |_| || |\  || |_| | ___) | |_| |"
Color RGB(143,39,183)
Print "    \___/ |_| \_| \___/ |____/ \___/ "
Color RGB(239,189,11)
Print "       T H E   G R E A T   W A R     "
Color RGB(143,39,183)
Print "            INSCCOIN 2025            "
Print "             Version 1.3             "
Color RGB(white)
PRINT
PRINT "1. New Game"
PRINT "2. Load Game"
INPUT "Choose option (1-2): ", q$
IF q$ = "2" THEN
    GOSUB LoadGame
    IF saveFile$ = "" THEN GOTO NewGame
END IF
NewGame:
    INPUT "Press ENTER to see your mission...", q$
CLS
Color RGB(white)
PRINT "STORY:"
PRINT "The year is 2233. The galaxy is torn apart by the Great War, a conflict between the United Colonies and the Dominion of Orion."
PRINT "You are Commander Veyra, leader of a small but elite strike unit stranded behind enemy lines after a failed assault on the Orion stronghold."
PRINT "Your mission: survive, gather resources, and find a way to break through the front and deliver critical intelligence that could end the war."
PRINT "Every sector is a risk—battlefields, ruined outposts, and the wreckage of war."
PRINT "Allies are rare, enemies are everywhere, and the fate of millions may rest on your choices."
INPUT "Press ENTER to continue...", q$
CLS
Color RGB(white)
PRINT "The United Colonies, once a beacon of hope and unity, now fights desperately to hold back the relentless advance of the Dominion of Orion. The Dominion,"
PRINT "ruled by the enigmatic Warlord Kael, seeks to impose order through conquest, wielding advanced technology and ruthless tactics."
PRINT "The war has left entire worlds scarred. Cities lie in ruins, and ancient relics of lost civilizations are unearthed by the chaos. Resistance cells operate" 
PRINT "in secret, sabotaging Dominion supply lines and gathering intelligence for the Colonies."
INPUT "Press ENTER to continue...", q$
CLS
Color RGB(white)
PRINT "You and your crew were tasked with infiltrating the Orion stronghold to uncover the secret behind their new superweapon—a weapon rumored to have the power to"
PRINT "end the war in a single strike. The mission went wrong: your dropship was shot down, and you awoke in the heart of enemy territory, your unit scattered and supplies low."
PRINT "Now, you must navigate the war-torn sectors, seeking out allies among the Resistance, scavenging for resources, and avoiding Dominion patrols. The intelligence you carry "
PRINT "could turn the tide, but only if you can survive long enough to reach the extraction point."
INPUT "Press ENTER to begin your mission...", q$
PRINT
CLS
Color RGB(143,39,183)
PRINT "Commands: "
Color RGB(239,189,11)
PRINT "N S E W NE NW SE SW"
PRINT "SCAN CAMP STATUS MAP REST QUIT"
PRINT

' random map gen
FOR y = 1 TO MAPHEIGHT
    FOR x = 1 TO MAPWIDTH
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
playerX = MAPWIDTH \ 2
playerY = MAPHEIGHT \ 2
fuel = 100
credits = 50
hull = 50
rations = 50
medkits = 2
upgrades = 0

DO
    
    Color RGB(143,39,183)
    PRINT STRING$(40, "_")
    Color RGB(239,189,11)
    PRINT "Location (";playerX; ","; playerY;") - "; map$(playerY,playerX)
    PRINT "Fuel:"; fuel; "  Credits:"; credits
    PRINT "Hull:"; hull; " ("; INT(100 * hull / (100 + upgrades * 20)); "%)"
    PRINT "Rations:"; rations; " Medkits:"; medkits
    Color RGB(143,39,183)
    PRINT STRING$(40, "-")
    Color RGB(239,189,11)
    PRINT "Type HELP for commands."
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
                sectorsVisited = sectorsVisited + 1
                GOSUB Encounter
            ELSE
                PRINT "You can't go further north."
            END IF
        CASE "S", "SOUTH"
            IF playerY < MAPHEIGHT THEN
                playerY = playerY + 1
                fuel = fuel - 1
                rations = rations - 1
                PRINT "You advance south."
                sectorsVisited = sectorsVisited + 1
                GOSUB Encounter
            ELSE
                PRINT "You can't go further south."
            END IF
        CASE "E", "EAST"
            IF playerX < MAPWIDTH THEN
                playerX = playerX + 1
                fuel = fuel - 1
                rations = rations - 1
                PRINT "You advance east."
                sectorsVisited = sectorsVisited + 1
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
                sectorsVisited = sectorsVisited + 1
                GOSUB Encounter
            ELSE
                PRINT "You can't go further west."
            END IF
        CASE "NE", "NORTHEAST"
            IF playerY > 1 AND playerX < MAPWIDTH THEN
                playerY = playerY - 1
                playerX = playerX + 1
                fuel = fuel - 1
                rations = rations - 1
                PRINT "You advance northeast."
                sectorsVisited = sectorsVisited + 1
                GOSUB Encounter
            ELSE
                PRINT "You can't go further northeast."
            END IF
        CASE "NW", "NORTHWEST"
            IF playerY > 1 AND playerX > 1 THEN
                playerY = playerY - 1
                playerX = playerX - 1
                fuel = fuel - 1
                rations = rations - 1
                PRINT "You advance northwest."
                sectorsVisited = sectorsVisited + 1
                GOSUB Encounter
            ELSE
                PRINT "You can't go further northwest."
            END IF
        CASE "SE", "SOUTHEAST"
            IF playerY < MAPHEIGHT AND playerX < MAPWIDTH THEN
                playerY = playerY + 1
                playerX = playerX + 1
                fuel = fuel - 1
                rations = rations - 1
                PRINT "You advance southeast."
                sectorsVisited = sectorsVisited + 1
                GOSUB Encounter
            ELSE
                PRINT "You can't go further southeast."
            END IF
        CASE "SW", "SOUTHWEST"
            IF playerY < MAPHEIGHT AND playerX > 1 THEN
                playerY = playerY + 1
                playerX = playerX - 1
                fuel = fuel - 1
                rations = rations - 1
                PRINT "You advance southwest."
                sectorsVisited = sectorsVisited + 1
                GOSUB Encounter
            ELSE
                PRINT "You can't go further southwest."
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
            CLS
            PRINT "Map Key:" 
            PRINT "R = Ruins        S = Supply Outpost     t = Tank Wreck     * = Resistance"
            PRINT "T = Trenches     M = Medical Outpost    s = Ship Wreck     $ = Superweapon"
            PRINT "N = No Man's Land C = Command Outpost   d = Drone Wreck    E = Extraction"
            PRINT "A = Ammo Depot   F = Fuel Depot         a = Artillery Wreck"
            PRINT "Q = Rations Depot X = Tech Depot        l = Relic Wreck"
            PRINT ". = Empty        @ = You"
            INPUT "Press ENTER to continue...", q$
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
            Color RGB(239,189,11)
            PRINT "Available Commands:"
            PRINT "N, S, E, W  NE, SE, NW, SW"
            PRINT "NE, NW, SE, SW - Diagonal movement"
            PRINT "LOOK        - Describe current sector"
            PRINT "SCAN        - Scan the current sector"
            PRINT "CAMP        - Camp or resupply"
            PRINT "STATUS      - Show unit status"
            PRINT "MAP         - Show war map"
            PRINT "REST        - Rest and recover hull"
            PRINT "USE MEDKIT  - Use a medkit to heal"
            PRINT "FIGHT       - Engage in combat"
            PRINT "CLEAR       - Clear the screen"
            PRINT "REPEAT      - Repeat last command"
            PRINT "HINT        - Show gameplay tips"
            PRINT "NOTES1      - View/edit notes page 1"
            PRINT "NOTES2      - View/edit notes page 2"
            PRINT "QUESTS      - View active side quests"
            PRINT "SAVE        - Save current game"
            PRINT "QUIT        - Exit the game"
            PRINT
            INPUT "Press ENTER to continue...", q$
        CASE "QUIT"
            INPUT "Are you sure you want to quit? (Y/N): ", q$
            IF UCASE$(q$) = "Y" THEN
                PRINT "Farewell, Commander!"
                END
            ELSE
                PRINT "Quit cancelled."
            END IF
        CASE "SAVE"
            GOSUB SaveGame
        CASE "NOTES1"
            GOSUB NotesPage1
        CASE "NOTES2"
            GOSUB NotesPage2
        CASE "QUESTS"
            GOSUB ShowQuests
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
    IF playerX = 40 AND playerY = 15 AND storyEvent3 = 0 THEN
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
    SELECT CASE INT(RND * 18)
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
        CASE 12
            ' stranded civilian
            IF questCount < 5 THEN
                PRINT "You find a stranded civilian calling for help from a damaged bunker."
                questGiver$ = "Stranded Civilian"
                GOSUB OfferQuest
            END IF
        CASE 13
            ' wounded soldier
            IF questCount < 5 THEN
                PRINT "A wounded United Colonies soldier staggers towards you."
                questGiver$ = "Wounded Soldier"
                GOSUB OfferQuest
            END IF
        CASE 14
            ' resistance scout
            IF questCount < 5 THEN
                PRINT "A Resistance scout emerges from the shadows."
                questGiver$ = "Resistance Scout"
                GOSUB OfferQuest
            END IF
        CASE 15
            ' engineer
            IF questCount < 5 THEN
                PRINT "You find a stranded engineer working on damaged equipment."
                questGiver$ = "Engineer"
                GOSUB OfferQuest
            END IF
        CASE 16
            ' refugee leader
            IF questCount < 5 THEN
                PRINT "A group of refugees approaches, led by their desperate leader."
                questGiver$ = "Refugee Leader"
                GOSUB OfferQuest
            END IF
        CASE 17
            ' intelligence officer
            IF questCount < 5 THEN
                PRINT "A United Colonies intelligence officer contacts you via secure comm."
                questGiver$ = "Intelligence Officer"
                GOSUB OfferQuest
            END IF
    END SELECT
END IF

' check quest progress
GOSUB CheckQuestProgress
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
    enemiesDefeated = enemiesDefeated + 1
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

    ' check for quest completion opportunities
    GOSUB CheckQuestCompletion

RETURN

ShowMap:
    FOR y = 1 TO MAPHEIGHT
        row$ = ""
        FOR x = 1 TO MAPWIDTH
            IF x = playerX AND y = playerY THEN
                row$ = row$ + "@"
            ELSEIF x = 3 AND y = 3 THEN
                row$ = row$ + "*"
            ELSEIF x = 10 AND y = 2 THEN
                row$ = row$ + "$"
            ELSEIF x = 40 AND y = 15 THEN
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
    INPUT "Press ENTER to continue...", q$
RETURN

SaveGame:
    INPUT "Enter save filename (without .txt): ", saveFile$
    IF saveFile$ = "" THEN
        PRINT "Save cancelled."
        RETURN
    END IF
    saveFile$ = saveFile$ + ".txt"
    
    OPEN saveFile$ FOR OUTPUT AS #1
    PRINT #1, playerX
    PRINT #1, playerY
    PRINT #1, fuel
    PRINT #1, credits
    PRINT #1, hull
    PRINT #1, rations
    PRINT #1, medkits
    PRINT #1, upgrades
    PRINT #1, storyEvent1
    PRINT #1, storyEvent2
    PRINT #1, storyEvent3
    PRINT #1, metFactionA
    PRINT #1, metFactionB
    PRINT #1, logPtr
    PRINT #1, personalLogPtr
    PRINT #1, notes1Count
    PRINT #1, notes2Count
    PRINT #1, questCount
    PRINT #1, sectorsVisited
    PRINT #1, enemiesDefeated
    
    ' save quest data
    FOR i = 1 TO 5
        PRINT #1, activeQuests$(i)
        PRINT #1, questProgress(i)
        PRINT #1, questComplete(i)
    NEXT i
    
    ' save the map
    FOR y = 1 TO MAPHEIGHT
        FOR x = 1 TO MAPWIDTH
            PRINT #1, map$(y, x)
        NEXT x
    NEXT y
    
    ' save logs
    FOR i = 1 TO 10
        PRINT #1, log$(i)
    NEXT i
    
    FOR i = 1 TO 20
        PRINT #1, personalLog$(i)
    NEXT i
    
    ' save notes
    FOR i = 1 TO 10
        PRINT #1, notes1$(i)
    NEXT i
    
    FOR i = 1 TO 10
        PRINT #1, notes2$(i)
    NEXT i
    
    CLOSE #1
    PRINT "Game saved as "; saveFile$
RETURN

LoadGame:
    INPUT "Enter save filename (without .txt): ", saveFile$
    IF saveFile$ = "" THEN
        saveFile$ = ""
        RETURN
    END IF
    saveFile$ = saveFile$ + ".txt"
    
    ' trys to open file
    OPEN saveFile$ FOR INPUT AS #1
    
    INPUT #1, playerX
    INPUT #1, playerY
    INPUT #1, fuel
    INPUT #1, credits
    INPUT #1, hull
    INPUT #1, rations
    INPUT #1, medkits
    INPUT #1, upgrades
    INPUT #1, storyEvent1
    INPUT #1, storyEvent2
    INPUT #1, storyEvent3
    INPUT #1, metFactionA
    INPUT #1, metFactionB
    INPUT #1, logPtr
    INPUT #1, personalLogPtr
    INPUT #1, notes1Count
    INPUT #1, notes2Count
    INPUT #1, questCount
    INPUT #1, sectorsVisited
    INPUT #1, enemiesDefeated
    
    ' load quest data
    FOR i = 1 TO 5
        INPUT #1, activeQuests$(i)
        INPUT #1, questProgress(i)
        INPUT #1, questComplete(i)
    NEXT i
    
    ' load the map
    FOR y = 1 TO MAPHEIGHT
        FOR x = 1 TO MAPWIDTH
            INPUT #1, map$(y, x)
        NEXT x
    NEXT y
    
    ' load logs
    FOR i = 1 TO 10
        INPUT #1, log$(i)
    NEXT i
    
    FOR i = 1 TO 20
        INPUT #1, personalLog$(i)
    NEXT i
    
    ' load notes
    FOR i = 1 TO 10
        INPUT #1, notes1$(i)
    NEXT i
    
    FOR i = 1 TO 10
        INPUT #1, notes2$(i)
    NEXT i
    
    CLOSE #1
    PRINT "Game loaded from "; saveFile$
    PRINT "Press ENTER to continue..."
    INPUT "", q$
    CLS
RETURN

NotesPage1:
    Color RGB(white)
    PRINT "=== NOTES PAGE 1 ==="
    PRINT "Current notes ("; notes1Count; "/10):"
    FOR i = 1 TO notes1Count
        PRINT STR$(i); ". "; notes1$(i)
    NEXT i
    PRINT
    PRINT "Commands: ADD (add note), DEL (delete note), CLEAR (clear all), EXIT"
    INPUT "Notes command: ", cmd$
    cmd$ = UCASE$(cmd$)
    
    IF cmd$ = "ADD" THEN
        IF notes1Count < 10 THEN
            INPUT "Enter your note: ", q$
            IF q$ <> "" THEN
                notes1Count = notes1Count + 1
                notes1$(notes1Count) = q$
                PRINT "Note added."
            END IF
        ELSE
            PRINT "Notes page 1 is full (10/10). Delete a note first."
        END IF
    ELSEIF cmd$ = "DEL" THEN
        IF notes1Count > 0 THEN
            INPUT "Delete which note number (1-" + STR$(notes1Count) + "): ", q$
            i = VAL(q$)
            IF i >= 1 AND i <= notes1Count THEN
                ' shift notes down
                FOR x = i TO notes1Count - 1
                    notes1$(x) = notes1$(x + 1)
                NEXT x
                notes1$(notes1Count) = ""
                notes1Count = notes1Count - 1
                PRINT "Note deleted."
            ELSE
                PRINT "Invalid note number."
            END IF
        ELSE
            PRINT "No notes to delete."
        END IF
    ELSEIF cmd$ = "CLEAR" THEN
        INPUT "Clear all notes on page 1? (Y/N): ", q$
        IF UCASE$(q$) = "Y" THEN
            FOR i = 1 TO 10
                notes1$(i) = ""
            NEXT i
            notes1Count = 0
            PRINT "All notes cleared."
        END IF
    ELSEIF cmd$ <> "EXIT" THEN
        PRINT "Invalid command."
    END IF
RETURN

NotesPage2:
    Color RGB(white)
    PRINT "=== NOTES PAGE 2 ==="
    PRINT "Current notes ("; notes2Count; "/10):"
    FOR i = 1 TO notes2Count
        PRINT STR$(i); ". "; notes2$(i)
    NEXT i
    PRINT
    PRINT "Commands: ADD (add note), DEL (delete note), CLEAR (clear all), EXIT"
    INPUT "Notes command: ", cmd$
    cmd$ = UCASE$(cmd$)
    
    IF cmd$ = "ADD" THEN
        IF notes2Count < 10 THEN
            INPUT "Enter your note: ", q$
            IF q$ <> "" THEN
                notes2Count = notes2Count + 1
                notes2$(notes2Count) = q$
                PRINT "Note added."
            END IF
        ELSE
            PRINT "Notes page 2 is full (10/10). Delete a note first."
        END IF
    ELSEIF cmd$ = "DEL" THEN
        IF notes2Count > 0 THEN
            INPUT "Delete which note number (1-" + STR$(notes2Count) + "): ", q$
            i = VAL(q$)
            IF i >= 1 AND i <= notes2Count THEN
                ' shift notes down
                FOR x = i TO notes2Count - 1
                    notes2$(x) = notes2$(x + 1)
                NEXT x
                notes2$(notes2Count) = ""
                notes2Count = notes2Count - 1
                PRINT "Note deleted."
            ELSE
                PRINT "Invalid note number."
            END IF
        ELSE
            PRINT "No notes to delete."
        END IF
    ELSEIF cmd$ = "CLEAR" THEN
        INPUT "Clear all notes on page 2? (Y/N): ", q$
        IF UCASE$(q$) = "Y" THEN
            FOR i = 1 TO 10
                notes2$(i) = ""
            NEXT i
            notes2Count = 0
            PRINT "All notes cleared."
        END IF
    ELSEIF cmd$ <> "EXIT" THEN
        PRINT "Invalid command."
    END IF
RETURN

ShowQuests:
    Color RGB(white)
    PRINT "=== ACTIVE SIDE QUESTS ==="
    IF questCount = 0 THEN
        PRINT "No active quests."
    ELSE
        FOR i = 1 TO 5
            IF activeQuests$(i) <> "" THEN
                PRINT STR$(i); ". "; activeQuests$(i)
                IF questComplete(i) = 1 THEN
                    PRINT "   [COMPLETE - Return to quest giver]"
                ELSE
                    PRINT "   Progress: "; questProgress(i); "/"; GetQuestTarget(i)
                END IF
            END IF
        NEXT i
    END IF
    PRINT "Use QUESTS to check your progress anytime."
RETURN

OfferQuest:
    IF questGiver$ = "Stranded Civilian" THEN
        PRINT "Civilian: 'Please help! I need medical supplies for my family.'"
        PRINT "Quest: Collect 3 medkits and return them."
        PRINT "Reward: 50 credits and information about a hidden cache."
        INPUT "Accept this quest? (Y/N): ", q$
        IF UCASE$(q$) = "Y" THEN
            GOSUB AddQuest
            activeQuests$(questCount) = "Collect 3 medkits for stranded civilian"
            PRINT "Quest accepted! Check QUESTS to track progress."
        END IF
    ELSEIF questGiver$ = "Wounded Soldier" THEN
        PRINT "Soldier: 'I need to get a message to sector (25,8). Can you help?'"
        PRINT "Quest: Travel to sector (25,8) and deliver the message."
        PRINT "Reward: 30 credits and 5 rations."
        INPUT "Accept this quest? (Y/N): ", q$
        IF UCASE$(q$) = "Y" THEN
            GOSUB AddQuest
            activeQuests$(questCount) = "Deliver message to sector (25,8)"
            PRINT "Quest accepted! Check QUESTS to track progress."
        END IF
    ELSEIF questGiver$ = "Resistance Scout" THEN
        PRINT "Scout: 'We need intel on enemy positions. Scout 5 different sectors for us.'"
        PRINT "Quest: Visit 5 different sectors and report back."
        PRINT "Reward: 40 credits and 1 upgrade."
        INPUT "Accept this quest? (Y/N): ", q$
        IF UCASE$(q$) = "Y" THEN
            GOSUB AddQuest
            activeQuests$(questCount) = "Scout 5 sectors for Resistance"
            PRINT "Quest accepted! Move around to scout sectors."
        END IF
    ELSEIF questGiver$ = "Engineer" THEN
        PRINT "Engineer: 'I need 100 credits to buy parts for a crucial repair.'"
        PRINT "Quest: Gather 100 credits for engineering supplies."
        PRINT "Reward: 2 medkits and 10 fuel."
        INPUT "Accept this quest? (Y/N): ", q$
        IF UCASE$(q$) = "Y" THEN
            GOSUB AddQuest
            activeQuests$(questCount) = "Gather 100 credits for engineer"
            PRINT "Quest accepted! Collect credits and return."
        END IF
    ELSEIF questGiver$ = "Refugee Leader" THEN
        PRINT "Leader: 'Our people are starving. Can you spare 20 rations?'"
        PRINT "Quest: Collect 20 rations for the refugee camp."
        PRINT "Reward: 60 credits and valuable map information."
        INPUT "Accept this quest? (Y/N): ", q$
        IF UCASE$(q$) = "Y" THEN
            GOSUB AddQuest
            activeQuests$(questCount) = "Collect 20 rations for refugees"
            PRINT "Quest accepted! Gather rations to help the refugees."
        END IF
    ELSEIF questGiver$ = "Intelligence Officer" THEN
        PRINT "Officer: 'Eliminate 3 enemy units and report their positions.'"
        PRINT "Quest: Defeat 3 enemies in combat."
        PRINT "Reward: 70 credits and tactical intel."
        INPUT "Accept this quest? (Y/N): ", q$
        IF UCASE$(q$) = "Y" THEN
            GOSUB AddQuest
            activeQuests$(questCount) = "Defeat 3 enemy units"
            PRINT "Quest accepted! Engage and defeat enemy units."
        END IF
    END IF
RETURN

AddQuest:
    FOR i = 1 TO 5
        IF activeQuests$(i) = "" THEN
            questCount = questCount + 1
            questProgress(i) = 0
            questComplete(i) = 0
            RETURN
        END IF
    NEXT i
    PRINT "Quest log is full! Complete some quests first."
RETURN

CheckQuestProgress:
    FOR i = 1 TO 5
        IF activeQuests$(i) <> "" AND questComplete(i) = 0 THEN
            IF LEFT$(activeQuests$(i), 7) = "Collect" THEN
                ' medkit collection quest
                IF medkits >= 3 AND LEFT$(activeQuests$(i), 15) = "Collect 3 medki" THEN
                    questComplete(i) = 1
                    PRINT "Quest Update: You have collected enough medkits!"
                ' rations collection quest
                ELSEIF rations >= 20 AND LEFT$(activeQuests$(i), 15) = "Collect 20 rati" THEN
                    questComplete(i) = 1
                    PRINT "Quest Update: You have collected enough rations!"
                END IF
            ELSEIF LEFT$(activeQuests$(i), 7) = "Deliver" THEN
                ' message delivery quest
                IF playerX = 25 AND playerY = 8 THEN
                    questComplete(i) = 1
                    PRINT "Quest Complete: Message delivered!"
                    PRINT "You receive 30 credits and 5 rations."
                    credits = credits + 30
                    rations = rations + 5
                    activeQuests$(i) = ""
                    questCount = questCount - 1
                END IF
            ELSEIF LEFT$(activeQuests$(i), 5) = "Scout" THEN
                ' track movement
                questProgress(i) = sectorsVisited
                IF sectorsVisited >= 5 THEN
                    questComplete(i) = 1
                    PRINT "Quest Update: You have scouted enough sectors!"
                END IF
            ELSEIF LEFT$(activeQuests$(i), 6) = "Gather" THEN
                ' credits gathering
                IF credits >= 100 THEN
                    questComplete(i) = 1
                    PRINT "Quest Update: You have gathered enough credits!"
                END IF
            ELSEIF LEFT$(activeQuests$(i), 6) = "Defeat" THEN
                ' track enemy defeats
                questProgress(i) = enemiesDefeated
                IF enemiesDefeated >= 3 THEN
                    questComplete(i) = 1
                    PRINT "Quest Update: You have defeated enough enemies!"
                END IF
            END IF
        END IF
    NEXT i
RETURN

GetQuestTarget:
    ' target number for quest progress
    IF LEFT$(activeQuests$(i), 15) = "Collect 3 medki" THEN
        GetQuestTarget = 3
    ELSEIF LEFT$(activeQuests$(i), 15) = "Collect 20 rati" THEN
        GetQuestTarget = 20
    ELSEIF LEFT$(activeQuests$(i), 5) = "Scout" THEN
        GetQuestTarget = 5
    ELSEIF LEFT$(activeQuests$(i), 6) = "Gather" THEN
        GetQuestTarget = 100
    ELSEIF LEFT$(activeQuests$(i), 6) = "Defeat" THEN
        GetQuestTarget = 3
    ELSE
        GetQuestTarget = 1
    END IF
RETURN

CheckQuestCompletion:
    FOR i = 1 TO 5
        IF activeQuests$(i) <> "" AND questComplete(i) = 1 THEN
            IF LEFT$(activeQuests$(i), 15) = "Collect 3 medki" THEN
                PRINT "You can turn in your medkit collection quest here."
                INPUT "Turn in 3 medkits for 50 credits? (Y/N): ", q$
                IF UCASE$(q$) = "Y" AND medkits >= 3 THEN
                    medkits = medkits - 3
                    credits = credits + 50
                    PRINT "Quest completed! You receive 50 credits."
                    PRINT "Civilian: 'Thank you! There's a hidden cache at (15,12).'"
                    activeQuests$(i) = ""
                    questComplete(i) = 0
                    questCount = questCount - 1
                ELSEIF UCASE$(q$) = "Y" THEN
                    PRINT "You don't have enough medkits."
                END IF
            ELSEIF LEFT$(activeQuests$(i), 15) = "Collect 20 rati" THEN
                PRINT "You can help the refugees with their rations quest."
                INPUT "Give 20 rations to refugees for 60 credits? (Y/N): ", q$
                IF UCASE$(q$) = "Y" AND rations >= 20 THEN
                    rations = rations - 20
                    credits = credits + 60
                    PRINT "Quest completed! You receive 60 credits."
                    PRINT "Leader: 'Bless you! There are supply depots at (8,5) and (30,12).'"
                    activeQuests$(i) = ""
                    questComplete(i) = 0
                    questCount = questCount - 1
                ELSEIF UCASE$(q$) = "Y" THEN
                    PRINT "You don't have enough rations."
                END IF
            ELSEIF LEFT$(activeQuests$(i), 5) = "Scout" THEN
                PRINT "You can report your scouting findings."
                INPUT "Report scouting data for 40 credits and 1 upgrade? (Y/N): ", q$
                IF UCASE$(q$) = "Y" THEN
                    credits = credits + 40
                    upgrades = upgrades + 1
                    PRINT "Quest completed! You receive 40 credits and an upgrade."
                    PRINT "Scout: 'Excellent work! Intel shows enemy weakness at (22,10).'"
                    activeQuests$(i) = ""
                    questComplete(i) = 0
                    questCount = questCount - 1
                    sectorsVisited = 0
                END IF
            ELSEIF LEFT$(activeQuests$(i), 6) = "Gather" THEN
                PRINT "You can deliver the credits to the engineer."
                INPUT "Give 100 credits for 2 medkits and 10 fuel? (Y/N): ", q$
                IF UCASE$(q$) = "Y" AND credits >= 100 THEN
                    credits = credits - 100
                    medkits = medkits + 2
                    fuel = fuel + 10
                    PRINT "Quest completed! You receive 2 medkits and 10 fuel."
                    PRINT "Engineer: 'Perfect! I've marked a fuel depot at (18,7) for you.'"
                    activeQuests$(i) = ""
                    questComplete(i) = 0
                    questCount = questCount - 1
                ELSEIF UCASE$(q$) = "Y" THEN
                    PRINT "You don't have enough credits."
                END IF
            ELSEIF LEFT$(activeQuests$(i), 6) = "Defeat" THEN
                PRINT "You can report your combat victories."
                INPUT "Report enemy defeats for 70 credits? (Y/N): ", q$
                IF UCASE$(q$) = "Y" THEN
                    credits = credits + 70
                    PRINT "Quest completed! You receive 70 credits."
                    PRINT "Officer: 'Outstanding! Enemy reinforcements are thin at (35,3).'"
                    activeQuests$(i) = ""
                    questComplete(i) = 0
                    questCount = questCount - 1
                    enemiesDefeated = 0
                END IF
            END IF
        END IF
    NEXT i
RETURN
