' PicoSprite 1.1
' Framework: Version 1.5
' INSCCOIN 2025
' MMBasic V6.00.02 RC26

CLS
PRINT "PicoSprite 1.1"
PRINT "Arrow keys: Move | Space: Toggle | S: Save | L: Load | Q: Quit"
PRINT "F/G: Prev/Next Frame | A: Animate"
PRINT

CONST MAXFRAMES = 8
DIM sprite$(MAXFRAMES, 8)
frame = 1

' Initialize all frames to blank
FOR f = 1 TO MAXFRAMES
    FOR y = 1 TO 8: sprite$(f, y) = STRING$(8, "."): NEXT
NEXT

x = 1: y = 1

DO
    CLS
    PRINT "PicoSprite 1.2  Frame:"; frame; "/"; MAXFRAMES
    PRINT "Arrow keys: Move | Space: Toggle | S: Save | L: Load | Q: Quit"
    PRINT "F/G: Prev/Next Frame | A: Animate"
    PRINT
    FOR row = 1 TO 8
        FOR col = 1 TO 8
            IF x = col AND y = row THEN
                PRINT "["; MID$(sprite$(frame, row), col, 1); "]";
            ELSE
                PRINT " "; MID$(sprite$(frame, row), col, 1); " ";
            ENDIF
        NEXT
        PRINT
    NEXT

    key$ = INKEY$
    IF key$ = CHR$(28) AND x > 1 THEN x = x - 1 ' Left
    IF key$ = CHR$(29) AND x < 8 THEN x = x + 1 ' Right
    IF key$ = CHR$(30) AND y > 1 THEN y = y - 1 ' Up
    IF key$ = CHR$(31) AND y < 8 THEN y = y + 1 ' Down
    IF UCASE$(key$) = " " THEN
        c$ = MID$(sprite$(frame, y), x, 1)
        IF c$ = "." THEN
            MID$(sprite$(frame, y), x, 1) = "#"
        ELSE
            MID$(sprite$(frame, y), x, 1) = "."
        ENDIF
    ENDIF
    IF UCASE$(key$) = "F" THEN
        IF frame > 1 THEN frame = frame - 1
    ENDIF
    IF UCASE$(key$) = "G" THEN
        IF frame < MAXFRAMES THEN frame = frame + 1
    ENDIF
    IF UCASE$(key$) = "S" THEN
        OPEN "sprite.txt" FOR OUTPUT AS #1
        FOR f = 1 TO MAXFRAMES
            FOR row = 1 TO 8: PRINT #1, sprite$(f, row): NEXT
        NEXT
        CLOSE #1
        PRINT "All frames saved to sprite.txt"
        PAUSE 1000
    ENDIF
    IF UCASE$(key$) = "L" THEN
        IF FILEEXISTS("sprite.txt") THEN
            OPEN "sprite.txt" FOR INPUT AS #1
            FOR f = 1 TO MAXFRAMES
                FOR row = 1 TO 8
                    LINE INPUT #1, sprite$(f, row)
                NEXT
            NEXT
            CLOSE #1
            PRINT "All frames loaded from sprite.txt"
        ELSE
            PRINT "No sprite.txt found!"
        ENDIF
        PAUSE 1000
    ENDIF
    IF UCASE$(key$) = "A" THEN
        FOR af = 1 TO MAXFRAMES
            CLS
            PRINT "Animation Preview - Frame"; af; "/"; MAXFRAMES
            PRINT
            FOR row = 1 TO 8
                FOR col = 1 TO 8
                    PRINT " "; MID$(sprite$(af, row), col, 1); " ";
                NEXT
                PRINT
            NEXT
            PAUSE 200
        NEXT
        PRINT "Press any key to continue..."
        DO: LOOP UNTIL INKEY$ <> ""
    ENDIF
    IF UCASE$(key$) = "Q" THEN EXIT DO
    PAUSE 50
LOOP

PRINT "Goodbye!"