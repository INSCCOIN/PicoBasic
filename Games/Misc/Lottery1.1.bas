' INSCCOIN 2025
' Pico 1h & 2h

CLS
PRINT "Pico Lottery 1.01"
PRINT "Would you like to pick 6 or 8 numbers? (Enter 6 or 8): ";
INPUT numPicks

IF numPicks <> 6 AND numPicks <> 8 THEN
    PRINT "Invalid choice. Please restart and enter 6 or 8."
    END
END IF

DIM userNums(numPicks)
DIM sysNums(numPicks)

PRINT "Enter your "; numPicks; " numbers (between 1 and 49):"
FOR i = 1 TO numPicks
    INPUT "Number " + STR$(i) + ": ", n
    IF n < 1 OR n > 49 THEN
        PRINT "Number must be between 1 and 49. Restarting."
        END
    END IF
    ' Check for duplicates
    FOR j = 1 TO i - 1
        IF n = userNums(j) THEN
            PRINT "Duplicate number entered. Restarting."
            END
        END IF
    NEXT j
    userNums(i) = n
NEXT i

' Generate system numbers
RANDOMIZE TIMER
FOR i = 1 TO numPicks
    DO
        n = INT(RND * 49) + 1
        duplicate = 0
        FOR j = 1 TO i - 1
            IF n = sysNums(j) THEN duplicate = 1
        NEXT j
    LOOP WHILE duplicate
    sysNums(i) = n
NEXT i

PRINT
PRINT "Your numbers: ";
FOR i = 1 TO numPicks
    PRINT userNums(i);
NEXT i
PRINT

PRINT "System numbers: ";
FOR i = 1 TO numPicks
    PRINT sysNums(i);
NEXT i
PRINT

' Check for matches
matches = 0
FOR i = 1 TO numPicks
    FOR j = 1 TO numPicks
        IF userNums(i) = sysNums(j) THEN matches = matches + 1
    NEXT j
NEXT i

PRINT "You matched "; matches; " number(s)!"

END