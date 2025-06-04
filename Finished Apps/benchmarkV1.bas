PRINT "Simple CPU stress test. Press CTRL+C to stop."

DIM i, sum, t1, t2


DO
    sum = 0
    t1 = TIMER
    FOR i = 1 TO 10000000
        sum = sum + i
    NEXT i
    t2 = TIMER
    PRINT "Iteration complete. Sum="; sum
    PRINT "Time taken: "; t2 - t1; " seconds"
    PRINT "Press Shift+Esc to stop or wait for the next iteration."
LOOP