' INSCCOIN 2025

OPTION LCDPANEL ILI9341, LANDSCAPE
CLS

' Projection parameters
CONST X0 = 160
CONST Y0 = 120
CONST SCALE = 30

' Global variables for projection
DIM sx, sy

' 3D to 2D projection subroutine
SUB Project3D(x, y, z)
    sx = X0 + SCALE * (x - y) * 0.866
    sy = Y0 - SCALE * (z + (x + y) * 0.5)
END SUB

' Function selector
FUNCTION F(x, y)
    SELECT CASE funcnum
        CASE 1
            F = SIN(x) * COS(y)
        CASE 2
            F = x * x - y * y
        CASE 3
            F = SIN(SQR(x * x + y * y))
        CASE ELSE
            F = 0
    END SELECT
END FUNCTION

' User input
PRINT "Enter minimum X:";
INPUT xmin
PRINT "Enter maximum X:";
INPUT xmax
PRINT "Enter minimum Y:";
INPUT ymin
PRINT "Enter maximum Y:";
INPUT ymax
PRINT "Enter step size (e.g. 0.2):";
INPUT stp
PRINT "Choose function:"
PRINT "1: z = sin(x)*cos(y)"
PRINT "2: z = x^2 - y^2"
PRINT "3: z = sin(sqrt(x^2 + y^2))"
INPUT funcnum

CLS

' Plot surface
FOR x = xmin TO xmax STEP stp
    FOR y = ymin TO ymax STEP stp
        z = F(x, y)
        Project3D x, y, z
        sx1 = sx : sy1 = sy
        z2 = F(x + stp, y)
        Project3D x + stp, y, z2
        sx2 = sx : sy2 = sy
        LINE sx1, sy1, sx2, sy2, 1
        z3 = F(x, y + stp)
        Project3D x, y + stp, z3
        sx3 = sx : sy3 = sy
        LINE sx1, sy1, sx3, sy3, 1
    NEXT y
NEXT x

TEXT 10, 10, "3D Plot", "L"
END