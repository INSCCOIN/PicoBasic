' PicoBench 2.0 - CPU Stress Test
' This is a CPU stress test that performs complex calculations in a loop.
' It calculates sine, cosine, and logarithm values to keep the CPU busy.
' It runs indefinitely until the user interrupts it with Shift+Esc.
' Planned enhancements include: Improved logging, adjustable iterations, and performance metrics.


PRINT "PicoBench 2.5 - CPU Stress Test"
PRINT "INSCCOIN 2025"
PRINT
PRINT "Select math mode:"
PRINT "1. Trigonometric (SIN, COS, LOG)"
PRINT "2. Exponential (EXP, LOG, ^)"
PRINT "3. Square Root & Power (SQR, ^)"
PRINT "4. Mixed/Heavy (SIN, COS, TAN, EXP, LOG, SQR, ATN)"
INPUT "Enter mode (1-4): ", mode

DIM i, sum, t1, t2, x, y, z

DO
    sum = 0
    t1 = TIMER
    FOR i = 1 TO 1000000
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
        END SELECT
    NEXT i
    t2 = TIMER
    PRINT "Iteration complete. Result="; sum
    PRINT "Time taken: "; t2 - t1; " seconds"
    PRINT "Press Shift+Esc to stop or wait for the next iteration."
LOOP