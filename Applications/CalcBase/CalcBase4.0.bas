' CalcBase 4.0 Standard Edition
' INSCCOIN 2025


CONST FILENAME$ = "calcbase.cb3"


PRINT "CalcBase 4.0  Standard Edition"
PRINT "------------------------------"
DO
    PRINT "Menu:"
    PRINT "1. Add Record"
    PRINT "2. List Records"
    PRINT "3. Find Record"
    PRINT "4. Delete Record"
    PRINT "5. Modify Record"
    PRINT "6. Show Record Count"
    PRINT "7. Exit"
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
            GOSUB ShowCount
        CASE 7
            PRINT "Exiting..."
            END
        CASE ELSE
            PRINT "Invalid option."
    END SELECT
LOOP
ModifyRecord:
    PRINT "Modify Record"
    INPUT "Enter Record ID to modify: ", modid$
    addr$ = RIGHT$("00000000" + modid$, 8)
    ' if record exists
    found = 0
    DIM lines$(1000)
    n = 0
    OPEN FILENAME$ FOR INPUT AS #1
    WHILE NOT EOF(#1)
        LINE INPUT #1, line$
        fields = SPLIT(line$, ",")
        IF fields(2) = addr$ THEN
            found = 1
        ENDIF
        lines$(n) = line$
        n = n + 1
    WEND
    CLOSE #1
    IF found = 0 THEN
        PRINT "Error: Record ID does not exist."
        RETURN
    ENDIF
    ' modify the record
    n = 0
    found = 0
    DIM newlines$(1000)
    OPEN FILENAME$ FOR INPUT AS #1
    WHILE NOT EOF(#1)
        LINE INPUT #1, line$
        fields = SPLIT(line$, ",")
        IF fields(2) = addr$ THEN
            PRINT "Current: " + line$
            INPUT "New First Name: ", newfname$
            INPUT "New Last Name: ", newlname$
            INPUT "New Amount: ", newamt$
            newrec$ = "CB3,04," + addr$ + "," + newfname$ + "," + newlname$ + "," + newamt$ + ",00"
            newlines$(n) = newrec$
            found = 1
        ELSE
            newlines$(n) = line$
        ENDIF
        n = n + 1
    WEND
    CLOSE #1
    OPEN FILENAME$ FOR OUTPUT AS #1
    FOR i = 0 TO n - 1
        PRINT #1, newlines$(i)
    NEXT i
    CLOSE #1
    PRINT "Record modified."
    RETURN

' Sub

AddRecord:
    PRINT "Add Record"
    INPUT "Record ID: ", rid$
    addr$ = RIGHT$("00000000" + rid$, 8)
    ' Check for uniqueness
    found = 0
    OPEN FILENAME$ FOR INPUT AS #1
    WHILE NOT EOF(#1)
        LINE INPUT #1, line$
        fields = SPLIT(line$, ",")
        IF fields(2) = addr$ THEN
            found = 1
        ENDIF
    WEND
    CLOSE #1
    IF found = 1 THEN
        PRINT "Error: Record ID already exists."
        RETURN
    ENDIF
    INPUT "First Name: ", fname$
    INPUT "Last Name: ", lname$
    INPUT "Amount: ", amt$
    rec$ = "CB3,04," + addr$ + "," + fname$ + "," + lname$ + "," + amt$ + ",00"
    OPEN FILENAME$ FOR APPEND AS #1
    PRINT #1, rec$
    CLOSE #1
    PRINT "Record added."
    RETURN

ListRecords:
    PRINT "Records:"
    OPEN FILENAME$ FOR INPUT AS #1
    WHILE NOT EOF(#1)
        LINE INPUT #1, line$
        PRINT line$
    WEND
    CLOSE #1
    RETURN

FindRecord:
    PRINT "Find Record"
    INPUT "Enter Record ID to find: ", search$
    found = 0
    OPEN FILENAME$ FOR INPUT AS #1
    WHILE NOT EOF(#1)
        LINE INPUT #1, line$
        fields = SPLIT(line$, ",")
        IF fields(2) = RIGHT$("00000000" + search$, 8) THEN
            PRINT "Found: " + line$
            found = 1
        ENDIF
    WEND
    CLOSE #1
    IF found = 0 THEN PRINT "Not found."
    RETURN

DeleteRecord:
    PRINT "Delete Record"
    INPUT "Enter Record ID to delete: ", del$
    DIM lines$(1000) ' anything larger than 1000 records may crash program
    n = 0
    OPEN FILENAME$ FOR INPUT AS #1
    WHILE NOT EOF(#1)
        LINE INPUT #1, line$
        fields = SPLIT(line$, ",")
        IF fields(2) <> RIGHT$("00000000" + del$, 8) THEN
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
    PRINT "Record deleted (if existed)."
    RETURN

ShowCount:
    PRINT "Show Record Count"
    count = 0
    OPEN FILENAME$ FOR INPUT AS #1
    WHILE NOT EOF(#1)
        LINE INPUT #1, line$
        count = count + 1
    WEND
    CLOSE #1
    PRINT "Total records: "; count
    RETURN
