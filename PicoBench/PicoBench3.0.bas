' PicoBench 3.0 - CPU Stress Test
' INSCCOIN 2025
' 6.00.02 RC26
PRINT "PicoBench 3.0 - CPU Stress Test"
PRINT
PRINT "Select math mode:"
PRINT "1. Trigonometric (SIN, COS, LOG)"
PRINT "2. Exponential (EXP, LOG, ^)"
PRINT "3. Square Root & Power (SQR, ^)"
PRINT "4. Mixed/Heavy (SIN, COS, TAN, EXP, LOG, SQR, ATN)"
PRINT "5. Integer Math (MOD, ABS, ^)"
PRINT "6. Random & Conditional"
PRINT "7. Factorial Approximation (Gamma)"
INPUT "Enter mode (1-7): ", mode

DIM i, sum, t1, t2, x, y, z, prog, steps
steps = 1000000
DIM barlen
barlen = 40

DO
    sum = 0
    t1 = TIMER
    FOR i = 1 TO steps
        ' Progress bar
        IF i MOD (steps \ barlen) = 0 THEN
            prog = INT(i / steps * barlen)
            PRINT CHR$(13); "["; STRING$(prog, "="); STRING$(barlen - prog, " "); "] "; INT(i / steps * 100); "%";
        ENDIF

        SELECT CASE mode
            CASE 1
                x = SIN(i / 1000)
                y = COS(i / 500)
                z = LOG(i + 1)
                sum = sum + x * y + z ^ 1.5
            CASE 2
                x = EXP(i / 10000)
                y = LOG(i + 1)
                sum = sum + x ^ 1.1 - y ^ 1.2
            CASE 3
                x = SQR(i)
                y = i ^ 1.2
                sum = sum + x + y
            CASE 4
                x = SIN(i / 1000) + TAN(i / 500)
                y = COS(i / 500) * EXP(i / 2000)
                z = LOG(i + 1) + SQR(i)
                sum = sum + x * y + z ^ 1.5 - ATN(i / 10000)
            CASE 5
                x = i MOD 97
                y = ABS(i - 500000)
                sum = sum + x ^ 2 - y ^ 0.5
            CASE 6
                x = RND
                IF x > 0.5 THEN
                    sum = sum + x * i
                ELSE
                    sum = sum - x * i
                ENDIF
            CASE 7
                ' Stirling's approximation for factorial: n! ≈ sqrt(2*pi*n)*(n/e)^n
                x = SQR(2 * 3.14159 * i)
                y = (i / 2.71828) ^ i
                sum = sum + x * y
        END SELECT
    NEXT i
    t2 = TIMER
    PRINT
    PRINT "Iteration complete. Result="; sum
    PRINT "Time taken: "; t2 - t1; " seconds"
    PRINT "Press Shift+Esc to stop or wait for the next iteration."
LOOP