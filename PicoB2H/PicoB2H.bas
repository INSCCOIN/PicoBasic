' Text to Binary & Hex Converter
' INSCCOIN 2025
' Planned features: hex to text conversion. 


CLS
PRINT "Text to Binary & Hex Converter"
PRINT
INPUT "Enter text: ", txt$

PRINT
PRINT "Character   Binary           Hex"
PRINT "-------------------------------------"

FOR i = 1 TO LEN(txt$)
    ch$ = MID$(txt$, i, 1)
    code = ASC(ch$)
    ' Convert to 8-bit binary
    bin$ = ""
    FOR b = 7 TO 0 STEP -1
        IF (code AND (2^b)) THEN
            bin$ = bin$ + "1"
        ELSE
            bin$ = bin$ + "0"
        ENDIF
    NEXT b
    ' Convert to 2-digit hex
    hex$ = HEX$(code,2)
    PRINT "    "; ch$; "      "; bin$; "      "; hex$
NEXT i

PRINT
PRINT "Done."
END