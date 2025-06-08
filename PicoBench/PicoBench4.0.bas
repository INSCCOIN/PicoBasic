' PicoBench 4.0 First - CPU Stress Test
' INSCCOIN 2025
' 6.00.02 RC26
' This program is not complete but works decent enough to release.
' Planned enhancements: Logging, adjustable iterations, and performance metrics 
' (Pico 1w/2w required for performance metrics).



PRINT "PicoBench 4.0 - CPU Stress Test"
PAUSE 1000

DO
    PRINT
    PRINT "Main Menu:"
    PRINT " 1. Run Benchmark"
    PRINT " 2. Info: Math Modes"
    PRINT " 3. Exit"
    INPUT "Select option (1-3): ", mainopt

    IF mainopt = 2 THEN
        DO
            PRINT
            PRINT "Math Modes Info Menu:"
            PRINT " 1. Trig         2. Exp/Log      3. Sqrt/Pow"
            PRINT " 4. Mixed        5. Integer      6. Random"
            PRINT " 7. Factorial    8. Sort         9. String"
            PRINT "10. Matrix      11. Fibonacci   12. Prime"
            PRINT "13. ArraySum    14. Bitwise     15. Harmonic"
            PRINT "16. Geometric   17. LogSeries   18. PolyEval"
            PRINT "19. GCD         20. LCM         21. Ackermann"
            PRINT "22. Collatz     23. Pascal Row  24. Catalan"
            PRINT "25. Digital Root"
            PRINT "26. Return to Main Menu"
            INPUT "Select math mode for details (1-26): ", infomode

            IF infomode = 26 THEN EXIT DO

            SELECT CASE infomode
                CASE 1
                    PRINT "Trig: Uses SIN, COS, and LOG to stress floating-point math and transcendental functions."
                CASE 2
                    PRINT "Exp/Log: Uses EXP, LOG, and exponentiation to test exponential and logarithmic calculations."
                CASE 3
                    PRINT "Sqrt/Pow: Uses SQR and exponentiation to test root and power operations."
                CASE 4
                    PRINT "Mixed: Combines trigonometric, exponential, logarithmic, square root, and arctangent for a heavy mixed workload."
                CASE 5
                    PRINT "Integer: Uses MOD, ABS, and exponentiation to stress integer and absolute value operations."
                CASE 6
                    PRINT "Random: Uses RND and conditional logic to test random number generation and branching."
                CASE 7
                    PRINT "Factorial: Uses Stirling's approximation for factorial, stressing multiplication and exponentiation."
                CASE 8
                    PRINT "Sort: Performs bubble sort on a small array, stressing comparison and swapping."
                CASE 9
                    PRINT "String: Manipulates strings and measures length, stressing string handling."
                CASE 10
                    PRINT "Matrix: Multiplies two 2x2 matrices, stressing array and multiplication operations."
                CASE 11
                    PRINT "Fibonacci: Iterative calculation of Fibonacci numbers, stressing addition and looping."
                CASE 12
                    PRINT "Prime: Simple primality test, stressing division and conditional logic."
                CASE 13
                    PRINT "ArraySum: Sums elements of an array, stressing array access and addition."
                CASE 14
                    PRINT "Bitwise: Simulates bitwise operations using INT and MOD, stressing integer math."
                CASE 15
                    PRINT "Harmonic: Sums the harmonic series, stressing division and floating-point addition."
                CASE 16
                    PRINT "Geometric: Sums a geometric series, stressing exponentiation and addition."
                CASE 17
                    PRINT "LogSeries: Sums a logarithmic series, stressing LOG and division."
                CASE 18
                    PRINT "PolyEval: Evaluates a cubic polynomial, stressing exponentiation and addition."
                CASE 19
                    PRINT "GCD: Uses the Euclidean algorithm to find the greatest common divisor, stressing MOD and looping."
                CASE 20
                    PRINT "LCM: Computes least common multiple using GCD, stressing multiplication and division."
                CASE 21
                    PRINT "Ackermann: Recursive Ackermann function, a classic benchmark for recursion and stack depth."
                CASE 22
                    PRINT "Collatz: Computes Collatz sequence length, stressing division, multiplication, and looping."
                CASE 23
                    PRINT "Pascal Row: Computes sum of a row in Pascal's triangle (2^n), stressing exponentiation."
                CASE 24
                    PRINT "Catalan: Approximates Catalan numbers, stressing factorial-like multiplication and division."
                CASE 25
                    PRINT "Digital Root: Computes the digital root, stressing integer division and modular arithmetic."
                CASE ELSE
                    PRINT "Invalid selection. Please choose a valid math mode."
            END SELECT
            PRINT
            INPUT "Press Enter to return to the info menu.", dummy$
        LOOP
    ELSEIF mainopt = 1 THEN
        PRINT
        PRINT "Math Modes:"
        PRINT " 1. Trig    2. Exp/Log   3. Sqrt/Pow   4. Mixed    5. Integer"
        PRINT " 6. Random  7. Factorial 8. Sort       9. String  10. Matrix"
        PRINT "11. Fibonacci 12. Prime 13. ArraySum 14. Bitwise 15. Harmonic"
        PRINT "16. Geometric 17. LogSeries 18. PolyEval 19. GCD 20. LCM"
        PRINT "21. Ackermann 22. Collatz 23. Pascal Row 24. Catalan 25. Digital Root"
        INPUT "Mode (1-25): ", mode

        DIM i, sum, t1, t2, x, y, z, prog, steps
        steps = 1000000
        DIM barlen
        barlen = 40

        sum = 0
        t1 = TIMER
        FOR i = 1 TO steps
            IF i MOD (steps \ barlen) = 0 THEN
                prog = INT(i / steps * barlen)
                PRINT CHR$(13); "["; STRING$(prog, "="); STRING$(barlen - prog, " "); "] "; INT(i / steps * 100); "%";
            ENDIF

            SELECT CASE mode
                CASE 1
                    x = SIN(i / 1000): y = COS(i / 500): z = LOG(i + 1)
                    sum = sum + x * y + z ^ 1.5
                CASE 2
                    x = EXP(i / 10000): y = LOG(i + 1)
                    sum = sum + x ^ 1.1 - y ^ 1.2
                CASE 3
                    x = SQR(i): y = i ^ 1.2
                    sum = sum + x + y
                CASE 4
                    x = SIN(i / 1000) + TAN(i / 500)
                    y = COS(i / 500) * EXP(i / 2000)
                    z = LOG(i + 1) + SQR(i)
                    sum = sum + x * y + z ^ 1.5 - ATN(i / 10000)
                CASE 5
                    x = i MOD 97: y = ABS(i - 500000)
                    sum = sum + x ^ 2 - y ^ 0.5
                CASE 6
                    x = RND
                    IF x > 0.5 THEN sum = sum + x * i ELSE sum = sum - x * i
                CASE 7
                    x = SQR(2 * 3.14159 * i): y = (i / 2.71828) ^ i
                    sum = sum + x * y
                CASE 8
                    DIM arr(5)
                    FOR x = 1 TO 5: arr(x) = RND: NEXT
                    FOR x = 1 TO 4: FOR y = x + 1 TO 5
                        IF arr(x) > arr(y) THEN z = arr(x): arr(x) = arr(y): arr(y) = z
                    NEXT: NEXT
                    sum = sum + arr(1)
                CASE 9
                    s$ = "PicoBench"
                    FOR x = 1 TO 5: s$ = s$ + MID$(s$, x, 1): NEXT
                    sum = sum + LEN(s$)
                CASE 10
                    DIM a(2,2), b(2,2), c(2,2)
                    a(1,1)=i: a(1,2)=i+1: a(2,1)=i+2: a(2,2)=i+3
                    b(1,1)=i+4: b(1,2)=i+5: b(2,1)=i+6: b(2,2)=i+7
                    c(1,1)=a(1,1)*b(1,1)+a(1,2)*b(2,1)
                    c(1,2)=a(1,1)*b(1,2)+a(1,2)*b(2,2)
                    c(2,1)=a(2,1)*b(1,1)+a(2,2)*b(2,1)
                    c(2,2)=a(2,1)*b(1,2)+a(2,2)*b(2,2)
                    sum = sum + c(1,1) + c(2,2)
                CASE 11
                    a = 0: b = 1
                    FOR x = 1 TO 20: c = a + b: a = b: b = c: NEXT
                    sum = sum + c
                CASE 12
                    isPrime = 1
                    IF i < 2 THEN isPrime = 0
                    FOR x = 2 TO SQR(i)
                        IF i MOD x = 0 THEN isPrime = 0: EXIT FOR
                    NEXT
                    sum = sum + isPrime
                CASE 13
                    DIM arr2(10)
                    FOR x = 1 TO 10: arr2(x) = x + i: NEXT
                    FOR x = 1 TO 10: sum = sum + arr2(x): NEXT
                CASE 14
                    x = INT(i / 2): y = i MOD 2
                    sum = sum + x + y
                CASE 15
                    sum = sum + 1 / (i + 1)
                CASE 16
                    sum = sum + 0.99 ^ i
                CASE 17
                    sum = sum + LOG(i + 2) / (i + 2)
                CASE 18
                    sum = sum + 3 * i ^ 3 + 2 * i ^ 2 + i + 5
                CASE 19
                    a = i: b = i + 1
                    DO WHILE b <> 0: t = b: b = a MOD b: a = t: LOOP
                    sum = sum + a
                CASE 20
                    a = i: b = i + 1: aa = a: bb = b
                    DO WHILE bb <> 0: t = bb: bb = aa MOD bb: aa = t: LOOP
                    gcd = aa
                    IF gcd <> 0 THEN lcm = (a * b) / gcd: sum = sum + lcm
                CASE 21
                    FUNCTION Ack(m, n)
                        IF m = 0 THEN Ack = n + 1: EXIT FUNCTION
                        IF n = 0 THEN Ack = Ack(m - 1, 1): EXIT FUNCTION
                        Ack = Ack(m - 1, Ack(m, n - 1))
                    END FUNCTION
                    sum = sum + Ack(2, 2)
                CASE 22
                    n = i: count = 0
                    DO WHILE n > 1
                        IF n MOD 2 = 0 THEN n = n / 2 ELSE n = 3 * n + 1
                        count = count + 1
                    LOOP
                    sum = sum + count
                CASE 23
                    sum = sum + 2 ^ i
                CASE 24
                    n = i MOD 20
                    f = 1: FOR x = 2 TO 2 * n: f = f * x: NEXT
                    g = 1: FOR x = 2 TO n: g = g * x: NEXT
                    h = 1: FOR x = 2 TO n + 1: h = h * x: NEXT
                    IF g * h <> 0 THEN sum = sum + f / (g * h)
                CASE 25
                    n = i
                    DO WHILE n > 9
                        s = 0
                        DO WHILE n > 0
                            s = s + (n MOD 10)
                            n = INT(n / 10)
                        LOOP
                        n = s
                    LOOP
                    sum = sum + n
            END SELECT
        NEXT i
        t2 = TIMER
        PRINT
        PRINT "Iteration complete. Result="; sum
        PRINT "Time taken: "; t2 - t1; " seconds"
        PRINT "Press Shift+Esc to stop or wait for the next iteration."
    ELSEIF mainopt = 3 THEN
        PRINT "Exiting PicoBench."
        END
    ENDIF
LOOP