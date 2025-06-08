' PicoBench 2.0 - CPU Stress Test
' This is a CPU stress test that performs complex calculations in a loop.
' It calculates sine, cosine, and logarithm values to keep the CPU busy.
' It runs indefinitely until the user interrupts it with Shift+Esc.
' Planned enhancements include: Improved logging, adjustable iterations, and performance metrics.


PRINT "PicoBench 2.0 - CPU Stress Test"
PRINT "INSCCOIN 2025"

DIM i, sum, t1, t2, x, y, z

DO
    sum = 0
    t1 = TIMER
    FOR i = 1 TO 1000000
        x = SIN(i / 1000)
        y = COS(i / 500)
        z = LOG(i + 1)
        sum = sum + x * y + z ^ 1.5
    NEXT i
    t2 = TIMER
    PRINT "Iteration complete. Result="; sum
    PRINT "Time taken: "; t2 - t1; " seconds"
    PRINT "Press Shift+Esc to stop or wait for the next iteration."
LOOP