' Basic Calculator and Graph Plotter
' MMBasic

CLS
PRINT "MMBasic Calculator & Grapher"
PRINT "1. Calculate"
PRINT "2. Plot y = f(x)"
INPUT "Choose option (1 or 2): ", opt

IF opt = 1 THEN
    INPUT "Enter expression (e.g., 2+3*4): ", expr$
    result = EVAL(expr$)
    PRINT "Result: "; result
ELSEIF opt = 2 THEN
    INPUT "Enter function of x (e.g., x^2, SIN(x)): ", func$
    INPUT "x start: ", x1
    INPUT "x end: ", x2
    INPUT "Step size: ", step
    CLS
    PRINT " x", " y"
    FOR x = x1 TO x2 STEP step
        y = EVAL(REPLACE$(func$, "x", STR$(x)))
        PRINT USING "####.##  ####.##", x, y
    NEXT
    ' Optional: Plot on screen if you have a display
    ' FOR x = x1 TO x2 STEP step
    '     y = EVAL(REPLACE$(func$, "x", STR$(x)))
    '     PSET x*scaleX, y*scaleY
    ' NEXT
ELSE
    PRINT "Invalid option."
END IF