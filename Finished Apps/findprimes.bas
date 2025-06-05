' Prime Number Generator for PicoMite (MMBasic)
CLS
PRINT "Prime Number Generator"
PRINT "======================"
INPUT "Find primes up to: ", N

IF N < 2 THEN
    PRINT "No primes in this range."
    END
ENDIF

PRINT "Prime numbers up to"; N; ":"

FOR num = 2 TO N
    isPrime = 1
    FOR i = 2 TO INT(SQR(num))
        IF num MOD i = 0 THEN
            isPrime = 0
            EXIT FOR
        ENDIF
    NEXT i
    IF isPrime THEN
        PRINT num;
    ENDIF
NEXT num

PRINT
PRINT "Done!"
PRINT "Press any key to exit..."
DO: LOOP UNTIL INKEY$ <> ""