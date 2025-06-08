' PicoBench 3.5 to 4.0 - CPU Stress Test
' INSCCOIN 2025
' 6.00.02 RC26

PRINT "PicoBench 3.7 - CPU Stress Test"
PRINT
PRINT "Select math mode:"
PRINT " 1. Trigonometric (SIN, COS, LOG)"
PRINT " 2. Exponential (EXP, LOG, ^)"
PRINT " 3. Square Root & Power (SQR, ^)"
PRINT " 4. Mixed/Heavy (SIN, COS, TAN, EXP, LOG, SQR, ATN)"
PRINT " 5. Integer Math (MOD, ABS, ^)"
PRINT " 6. Random & Conditional"
PRINT " 7. Factorial Approximation (Gamma)"
PRINT " 8. Sorting (Bubble Sort)"
PRINT " 9. String Manipulation"
PRINT "10. Matrix Multiplication (2x2)"
PRINT "11. Fibonacci Sequence (Iterative)"
PRINT "12. Prime Number Test"
PRINT "13. Array Sum"
PRINT "14. Bitwise Operations"
PRINT "15. Harmonic Series"
PRINT "16. Geometric Series"
PRINT "17. Logarithmic Series"
PRINT "18. Polynomial Evaluation"
PRINT "19. GCD (Greatest Common Divisor)"
PRINT "20. LCM (Least Common Multiple)"
INPUT "Enter mode (1-20): ", mode

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
            CASE 8
                ' Bubble sort on a small array
                DIM arr(5)
                FOR x = 1 TO 5: arr(x) = RND: NEXT
                FOR x = 1 TO 4
                    FOR y = x + 1 TO 5
                        IF arr(x) > arr(y) THEN
                            z = arr(x): arr(x) = arr(y): arr(y) = z
                        ENDIF
                    NEXT
                NEXT
                sum = sum + arr(1)
            CASE 9
                ' String manipulation
                s$ = "PicoBench"
                FOR x = 1 TO 5
                    s$ = s$ + MID$(s$, x, 1)
                NEXT
                sum = sum + LEN(s$)
            CASE 10
                ' 2x2 Matrix multiplication
                DIM a(2,2), b(2,2), c(2,2)
                a(1,1)=i: a(1,2)=i+1: a(2,1)=i+2: a(2,2)=i+3
                b(1,1)=i+4: b(1,2)=i+5: b(2,1)=i+6: b(2,2)=i+7
                c(1,1)=a(1,1)*b(1,1)+a(1,2)*b(2,1)
                c(1,2)=a(1,1)*b(1,2)+a(1,2)*b(2,2)
                c(2,1)=a(2,1)*b(1,1)+a(2,2)*b(2,1)
                c(2,2)=a(2,1)*b(1,2)+a(2,2)*b(2,2)
                sum = sum + c(1,1) + c(2,2)
            CASE 11
                ' Fibonacci sequence (iterative, up to n=20 for speed)
                a = 0: b = 1
                FOR x = 1 TO 20
                    c = a + b
                    a = b
                    b = c
                NEXT
                sum = sum + c
            CASE 12
                ' Prime number test (simple, for small n)
                isPrime = 1
                IF i < 2 THEN isPrime = 0
                FOR x = 2 TO SQR(i)
                    IF i MOD x = 0 THEN isPrime = 0: EXIT FOR
                NEXT
                sum = sum + isPrime
            CASE 13
                ' Array sum
                DIM arr2(10)
                FOR x = 1 TO 10: arr2(x) = x + i: NEXT
                FOR x = 1 TO 10: sum = sum + arr2(x): NEXT
            CASE 14
                ' Bitwise operations (simulate with INT and MOD)
                x = INT(i / 2)
                y = i MOD 2
                sum = sum + x + y
            CASE 15
                ' Harmonic series
                sum = sum + 1 / (i + 1)
            CASE 16
                ' Geometric series: sum += r^i, r=0.99
                sum = sum + 0.99 ^ i
            CASE 17
                ' Logarithmic series: sum += LOG(i+2)/(i+2)
                sum = sum + LOG(i + 2) / (i + 2)
            CASE 18
                ' Polynomial evaluation: sum += 3*i^3 + 2*i^2 + i + 5
                sum = sum + 3 * i ^ 3 + 2 * i ^ 2 + i + 5
            CASE 19
                ' GCD (Euclidean algorithm) for i and i+1
                a = i: b = i + 1
                DO WHILE b <> 0
                    t = b
                    b = a MOD b
                    a = t
                LOOP
                sum = sum + a
            CASE 20
                ' LCM for i and i+1
                a = i: b = i + 1
                ' GCD
                aa = a: bb = b
                DO WHILE bb <> 0
                    t = bb
                    bb = aa MOD bb
                    aa = t
                LOOP
                gcd = aa
                IF gcd <> 0 THEN
                    lcm = (a * b) / gcd
                    sum = sum + lcm
                ENDIF
        END SELECT
    NEXT i
    t2 = TIMER
    PRINT
    PRINT "Iteration complete. Result="; sum
    PRINT "Time taken: "; t2 - t1; " seconds"
    PRINT "Press Shift+Esc to stop or wait for the next iteration."
LOOP