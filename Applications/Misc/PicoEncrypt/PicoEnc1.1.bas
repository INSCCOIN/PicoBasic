' INSCCOIN 2025
' PicoEnc 1.1
' DO NOT USE AS YOUR MAIN ENCRYPTION METHOD
' This is a XOR-based encryption/decryption example.

OPTION EXPLICIT

DIM key$
DIM input$
DIM output$
DIM mode$
DIM i, k, c

PRINT "PicoEnc 1.0 - AES-128 (XOR placeholder)"
PRINT "Enter E to Encrypt or D to Decrypt:"
INPUT mode$

IF UCASE$(mode$) <> "E" AND UCASE$(mode$) <> "D" THEN
    PRINT "Invalid mode."
    END
END IF

PRINT "Enter 16-character key:"
INPUT key$
IF LEN(key$) <> 16 THEN
    PRINT "Key must be 16 characters."
    END
END IF

PRINT "Enter text:"
INPUT input$

output$ = ""
FOR i = 1 TO LEN(input$)
    k = ASC(MID$(key$, ((i - 1) MOD 16) + 1, 1))
    c = ASC(MID$(input$, i, 1))
    output$ = output$ + CHR$(c XOR k)
NEXT i

IF UCASE$(mode$) = "E" THEN
    PRINT "Encrypted (Base64):"
    PRINT ENCODE$(output$)
ELSE
    PRINT "Decrypted:"
    PRINT output$
END IF

END

' Base64 encode for display
FUNCTION ENCODE$(s$)
    LOCAL b$, i, c
    b$ = ""
    FOR i = 1 TO LEN(s$)
        c = ASC(MID$(s$, i, 1))
        b$ = b$ + RIGHT$("0" + HEX$(c), 2)
    NEXT i
    ENCODE$ = b$
END FUNCTION