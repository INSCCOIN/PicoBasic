' PicoBench 2.6 - CPU Stress Test
' INSCCOIN 2025

PRINT "PicoBench 2.6 - CPU Stress Test"
PRINT "INSCCOIN 2025"
PRINT
PRINT "Select math mode:"
PRINT "1. Trigonometric (SIN, COS, LOG)"
PRINT "2. Exponential (EXP, LOG, ^)"
PRINT "3. Square Root & Power (SQR, ^)"
PRINT "4. Mixed/Heavy (SIN, COS, TAN, EXP, LOG, SQR, ATN)"
INPUT "Enter mode (1-4): ", mode

DIM i, sum, t1, t2, x, y, z

' array for logging 
DIM tempLog(1000), speedLog(1000)
DIM logCount

PRINT "Running stress test for 60 seconds..."
t1 = TIMER
logCount = 0
sum = 0

DO WHILE TIMER - t1 < 60
    ' Log temperature and speed
    IF logCount < 1000 THEN
        logCount = logCount + 1
        tempLog(logCount) = PIN(TEMP)
        speedLog(logCount) = 0 ' replace with correct method if known
    END IF
    FOR i = 1 TO 100000
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
LOOP

t2 = TIMER

' Calculate max, average, and median for temp and speed
maxTemp = tempLog(1): minTemp = tempLog(1): sumTemp = 0
maxSpeed = speedLog(1): minSpeed = speedLog(1): sumSpeed = 0
FOR i = 1 TO logCount
    IF tempLog(i) > maxTemp THEN maxTemp = tempLog(i)
    IF tempLog(i) < minTemp THEN minTemp = tempLog(i)
    sumTemp = sumTemp + tempLog(i)
    IF speedLog(i) > maxSpeed THEN maxSpeed = speedLog(i)
    IF speedLog(i) < minSpeed THEN minSpeed = speedLog(i)
    sumSpeed = sumSpeed + speedLog(i)
NEXT i
avgTemp = sumTemp / logCount
avgSpeed = sumSpeed / logCount

' Sort arrays for median
FOR i = 1 TO logCount - 1
    FOR j = i + 1 TO logCount
        IF tempLog(j) < tempLog(i) THEN SWAP tempLog(i), tempLog(j)
        IF speedLog(j) < speedLog(i) THEN SWAP speedLog(i), speedLog(j)
    NEXT j
NEXT i
IF logCount MOD 2 = 0 THEN
    medTemp = (tempLog(logCount / 2) + tempLog(logCount / 2 + 1)) / 2
    medSpeed = (speedLog(logCount / 2) + speedLog(logCount / 2 + 1)) / 2
ELSE
    medTemp = tempLog((logCount + 1) / 2)
    medSpeed = speedLog((logCount + 1) / 2)
END IF

PRINT
PRINT "Test complete!"
PRINT "Total time: "; INT(((t2 - t1) / 1000) * 100 + 0.5) / 100; " seconds"
PRINT "Result: ", sum
PRINT "Temperature (C): Max=", maxTemp, " Median=", medTemp, " Avg=", avgTemp
PRINT "CPU Speed (MHz): Max=", maxSpeed / 1000, " Median=", medSpeed / 1000, " Avg=", avgSpeed / 1000