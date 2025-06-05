' Password Generator for PicoMite (MMBasic)
CLS
PRINT "Password Generator"
PRINT "=================="
INPUT "Enter desired password length (e.g. 8-20): ", plen

IF plen < 4 THEN
    PRINT "Password too short! Must be at least 4 characters."
    END
ENDIF

LET chars$ = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
LET chars$ = chars$ + "abcdefghijklmnopqrstuvwxyz"
LET chars$ = chars$ + "0123456789"
LET chars$ = chars$ + "!@#$%^&*()-_=+[]{};:,.<>?/"

LET pass$ = ""
RANDOMIZE TIMER

FOR i = 1 TO plen
    index = INT(RND * LEN(chars$)) + 1
    pass$ = pass$ + MID$(chars$, index, 1)
NEXT i

PRINT "Generated password: "; pass$
PRINT
PRINT "Press any key to exit..."
DO: LOOP UNTIL INKEY$ <> ""