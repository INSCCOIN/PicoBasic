' CalcBase 1.0 COLOR EDITION
' INSCCOIN 2025


CONST FILENAME$ = "calcbase.cb1"

' yellow

DIM YELLOW_R, YELLOW_G, YELLOW_B
YELLOW_R = 255: YELLOW_G = 255: YELLOW_B = 0

' red
DIM RED_R, RED_G, RED_B
RED_R = 255: RED_G = 0: RED_B = 0


Text 0, 0, "CalcBase 1.0  Color Edition", "", 1, 1, RGB(YELLOW_R, YELLOW_G, YELLOW_B)
Text 0, 12, "--------------------------", "", 1, 1, RGB(YELLOW_R, YELLOW_G, YELLOW_B)

DO
    Text 0, 32, "Menu:", "", 1, 1, RGB(YELLOW_R, YELLOW_G, YELLOW_B)
    Text 0, 44, "1. Add Record", "", 1, 1, RGB(YELLOW_R, YELLOW_G, YELLOW_B)
    Text 0, 56, "2. List Records", "", 1, 1, RGB(YELLOW_R, YELLOW_G, YELLOW_B)
    Text 0, 68, "3. Find Record", "", 1, 1, RGB(YELLOW_R, YELLOW_G, YELLOW_B)
    Text 0, 80, "4. Delete Record", "", 1, 1, RGB(YELLOW_R, YELLOW_G, YELLOW_B)
    Text 0, 92, "5. Modify Record", "", 1, 1, RGB(YELLOW_R, YELLOW_G, YELLOW_B)
    Text 0, 104, "6. Exit", "", 1, 1, RGB(YELLOW_R, YELLOW_G, YELLOW_B)
    INPUT "Select option: ", opt
    SELECT CASE opt
        CASE 1
            GOSUB AddRecord
        CASE 2
            GOSUB ListRecords
        CASE 3
            GOSUB FindRecord
        CASE 4
            GOSUB DeleteRecord
        CASE 5
            GOSUB ModifyRecord
        CASE 6
            Text 0, 120, "Exiting...", "", 1, 1, RGB(YELLOW_R, YELLOW_G, YELLOW_B)
            END
        CASE ELSE
            Text 0, 132, "Invalid option.", "", 1, 1, RGB(RED_R, RED_G, RED_B)
    END SELECT
LOOP
ModifyRecord:
    Text 0, 144, "Modify Record", "", 1, 1, RGB(YELLOW_R, YELLOW_G, YELLOW_B)
    INPUT "Enter Record ID to modify: ", modid$
    DIM lines$(1000)
    n = 0
    found = 0
    OPEN FILENAME$ FOR INPUT AS #1
    WHILE NOT EOF(#1)
        LINE INPUT #1, line$
        fields = SPLIT(line$, ",")
        IF fields(2) = modid$ THEN
            Text 0, 156, "Current: " + line$, "", 1, 1, RGB(YELLOW_R, YELLOW_G, YELLOW_B)
            INPUT "New First Name: ", newfname$
            INPUT "New Last Name: ", newlname$
            INPUT "New Amount: ", newamt$
            newrec$ = "CB1,04," + modid$ + "," + newfname$ + "," + newlname$ + "," + newamt$ + ",00"
            lines$(n) = newrec$
            found = 1
        ELSE
            lines$(n) = line$
        ENDIF
        n = n + 1
    WEND
    CLOSE #1
    IF found = 0 THEN
        Text 0, 168, "Record not found.", "", 1, 1, RGB(YELLOW_R, YELLOW_G, YELLOW_B)
        RETURN
    ENDIF
    OPEN FILENAME$ FOR OUTPUT AS #1
    FOR i = 0 TO n - 1
        PRINT #1, lines$(i)
    NEXT i
    CLOSE #1
    Text 0, 180, "Record modified.", "", 1, 1, RGB(YELLOW_R, YELLOW_G, YELLOW_B)
    RETURN

' Sub

AddRecord:
    Text 0, 144, "Add Record", "", 1, 1, RGB(YELLOW_R, YELLOW_G, YELLOW_B)
    INPUT "Record ID: ", rid$
    INPUT "First Name: ", fname$
    INPUT "Last Name: ", lname$
    INPUT "Amount: ", amt$
    rec$ = "CB1,04," + rid$ + "," + fname$ + "," + lname$ + "," + amt$ + ",00"
    OPEN FILENAME$ FOR APPEND AS #1
    PRINT #1, rec$
    CLOSE #1
    Text 0, 156, "Record added.", "", 1, 1, RGB(YELLOW_R, YELLOW_G, YELLOW_B)
    RETURN

ListRecords:
    Text 0, 144, "Records:", "", 1, 1, RGB(YELLOW_R, YELLOW_G, YELLOW_B)
    OPEN FILENAME$ FOR INPUT AS #1
    WHILE NOT EOF(#1)
        LINE INPUT #1, line$
        Text 0, 156 + (n * 12), line$, "", 1, 1, RGB(YELLOW_R, YELLOW_G, YELLOW_B)
        n = n + 1
    WEND
    CLOSE #1
    RETURN

FindRecord:
    Text 0, 144, "Find Record", "", 1, 1, RGB(YELLOW_R, YELLOW_G, YELLOW_B)
    INPUT "Enter Record ID to find: ", search$
    found = 0
    OPEN FILENAME$ FOR INPUT AS #1
    WHILE NOT EOF(#1)
        LINE INPUT #1, line$
        fields = SPLIT(line$, ",")
        IF fields(2) = search$ THEN
            Text 0, 156, "Found: " + line$, "", 1, 1, RGB(YELLOW_R, YELLOW_G, YELLOW_B)
            found = 1
        ENDIF
    WEND
    CLOSE #1
    IF found = 0 THEN Text 0, 168, "Not found.", "", 1, 1, RGB(YELLOW_R, YELLOW_G, YELLOW_B)
    RETURN

DeleteRecord:
    Text 0, 144, "Delete Record", "", 1, 1, RGB(YELLOW_R, YELLOW_G, YELLOW_B)
    INPUT "Enter Record ID to delete: ", del$
    DIM lines$(1000) ' anything larger than 1000 records may crash program
    n = 0
    OPEN FILENAME$ FOR INPUT AS #1
    WHILE NOT EOF(#1)
        LINE INPUT #1, line$
        fields = SPLIT(line$, ",")
        IF fields(2) <> del$ THEN
            lines$(n) = line$
            n = n + 1
        ENDIF
    WEND
    CLOSE #1
    OPEN FILENAME$ FOR OUTPUT AS #1
    FOR i = 0 TO n - 1
        PRINT #1, lines$(i)
    NEXT i
    CLOSE #1
    Text 0, 156, "Record deleted (if existed).", "", 1, 1, RGB(YELLOW_R, YELLOW_G, YELLOW_B)
    RETURN
