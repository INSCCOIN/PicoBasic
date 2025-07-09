' Text to Binary & Hex Converter
' INSCCOIN 2025
' Planned features: hex to text conversion. 


CLS
PRINT "        PICOTBH 1.0 "
PRINT 
PRINT "Text to Binary & Hex Converter"
PRINT
INPUT "Enter text: ", txt$

PRINT
PRINT "Character   Binary           Hex"
PRINT "-------------------------------------"

rowsPerPage = 10
rowCount = 0

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
    rowCount = rowCount + 1
    IF rowCount = rowsPerPage THEN
        PRINT : INPUT "Press Enter to continue...", dummy$
        PRINT "Character   Binary           Hex"
        PRINT "-------------------------------------"
        rowCount = 0
    ENDIF
NEXT i

PRINT
PRINT "Done."
END