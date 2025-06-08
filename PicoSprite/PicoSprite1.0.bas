' PicoSprite 1.0
' Framework: Version 1.0
' INSCCOIN 2025
' MMBasic V6.00.02 RC26



CLS
PRINT "PicoSprite 1.0"
PRINT "Arrow keys: Move cursor | Space: Toggle pixel | S: Save | Q: Quit"
PRINT

DIM sprite$(8)
FOR y = 1 TO 8: sprite$(y) = STRING$(8, "."): NEXT

x = 1: y = 1

DO
    CLS
    PRINT "PicoSprite 1.0"
    PRINT "Arrow keys: Move | Space: Toggle | S: Save | Q: Quit"
    PRINT
    FOR row = 1 TO 8
        FOR col = 1 TO 8
            IF x = col AND y = row THEN
                PRINT "["; MID$(sprite$(row), col, 1); "]";
            ELSE
                PRINT " "; MID$(sprite$(row), col, 1); " ";
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
        c$ = MID$(sprite$(y), x, 1)
        IF c$ = "." THEN
            MID$(sprite$(y), x, 1) = "#"
        ELSE
            MID$(sprite$(y), x, 1) = "."
        ENDIF
    ENDIF
    IF UCASE$(key$) = "S" THEN
        OPEN "sprite.txt" FOR OUTPUT AS #1
        FOR row = 1 TO 8: PRINT #1, sprite$(row): NEXT
        CLOSE #1
        PRINT "Sprite saved to sprite.txt"
        PAUSE 1000
    ENDIF
    IF UCASE$(key$) = "Q" THEN EXIT DO
    PAUSE 50
LOOP

PRINT "Goodbye!"