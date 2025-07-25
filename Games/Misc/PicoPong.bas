' INSCCOIN 2025
' PicoPong 1.0


OPTION EXPLICIT

CONST WIDTH = 20
CONST HEIGHT = 10
CONST PADDLE_SIZE = 3

DIM ballX, ballY, ballDX, ballDY
DIM paddleY
DIM score
DIM key$
DIM x, y
DIM l1$

' Initialize game
ballX = WIDTH \ 2
ballY = HEIGHT \ 2
ballDX = 1
ballDY = 1
paddleY = HEIGHT \ 2
score = 0

CLS

DO
    ' Draw field
    CLS
    FOR y = 1 TO HEIGHT
        l1$ = ""
        FOR x = 1 TO WIDTH
            IF x = 1 AND y >= paddleY AND y < paddleY + PADDLE_SIZE THEN
                l1$ = l1$ + "|"
            ELSEIF x = ballX AND y = ballY THEN
                l1$ = l1$ + "O"
            ELSEIF x = WIDTH THEN
                l1$ = l1$ + "|"
            ELSE
                l1$ = l1$ + " "
            END IF
        NEXT x
        PRINT l1$
    NEXT y
    PRINT "Score: "; score
    PRINT "W/S=Up/Down, Q=Quit"

    ' Input
    key$ = INKEY$
    IF UCASE$(key$) = "W" AND paddleY > 1 THEN paddleY = paddleY - 1
    IF UCASE$(key$) = "S" AND paddleY < HEIGHT - PADDLE_SIZE + 1 THEN paddleY = paddleY + 1
    IF UCASE$(key$) = "Q" THEN END

    ' Move ball
    ballX = ballX + ballDX
    ballY = ballY + ballDY

    ' Bounce off top/bottom
    IF ballY = 1 OR ballY = HEIGHT THEN ballDY = -ballDY

    ' Bounce off paddle
    IF ballX = 2 AND ballY >= paddleY AND ballY < paddleY + PADDLE_SIZE THEN
        ballDX = -ballDX
        score = score + 1
    END IF

    ' Missed paddle
    IF ballX = 1 THEN
        PRINT "Game Over! Final Score: "; score
        END
    END IF

    ' Bounce off right wall
    IF ballX = WIDTH THEN ballDX = -ballDX

    PAUSE 100
LOOP
