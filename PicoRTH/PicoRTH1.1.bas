' RGB to Hex Color Converter
' This program converts RGB values to a Hex color code and displays a color preview.
' INSCCOIN 2025 
' 6.00.02 RC26
' Planned features: input validation, color preview, and user-friendly interface.

CLS
PRINT "RGB <-> Hex Color Converter"
PRINT
PRINT "1. RGB to Hex"
PRINT "2. Hex to RGB"
PRINT
INPUT "Choose mode (1 or 2): ", mode

IF mode = 1 THEN
    ' --- RGB to Hex ---
    INPUT "Enter Red (0-255): ", r
    INPUT "Enter Green (0-255): ", g
    INPUT "Enter Blue (0-255): ", b

    ' Clamp values to 0-255
    IF r < 0 THEN r = 0
    IF r > 255 THEN r = 255
    IF g < 0 THEN g = 0
    IF g > 255 THEN g = 255
    IF b < 0 THEN b = 0
    IF b > 255 THEN b = 255

    ' Convert to Hex
    hex$ = HEX$(r,2) + HEX$(g,2) + HEX$(b,2)
    PRINT
    PRINT "Hex Color: #" + hex$
    PRINT "Red:   "; r
    PRINT "Green: "; g
    PRINT "Blue:  "; b

ELSEIF mode = 2 THEN
    ' --- Hex to RGB ---
    INPUT "Enter Hex Color (e.g. FF8800 or #FF8800): ", hexin$
    ' Remove # if present
    IF LEFT$(hexin$,1) = "#" THEN hexin$ = MID$(hexin$,2)
    IF LEN(hexin$) <> 6 THEN
        PRINT "Invalid hex code length."
        END
    ENDIF

    r = VAL("&H" + MID$(hexin$,1,2))
    g = VAL("&H" + MID$(hexin$,3,2))
    b = VAL("&H" + MID$(hexin$,5,2))

    PRINT
    PRINT "Hex Color: #" + hexin$
    PRINT "Red:   "; r
    PRINT "Green: "; g
    PRINT "Blue:  "; b

ELSE
    PRINT "Invalid mode selected."
ENDIF

END