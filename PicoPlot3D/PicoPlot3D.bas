' INSCCOIN 2025
' Plots z = f(x, y) in 3D

OPTION LCDPANEL ILI9341, LANDSCAPE
CLS

' Projection parameters
CONST X0 = 160   ' Screen center X
CONST Y0 = 120   ' Screen center Y
CONST SCALE = 30 ' Zoom factor

' Function to plot (change as desired)
FUNCTION F(x, y)
    F = SIN(x) * COS(y)
END FUNCTION

' Global variables for projection
DIM sx, sy

' 3D to 2D projection subroutine
SUB Project3D(x, y, z)
    sx = X0 + SCALE * (x - y) * 0.866 ' 0.866 = cos(30deg)
    sy = Y0 - SCALE * (z + (x + y) * 0.5)
END SUB

' Plot surface
FOR x = -2 TO 2 STEP 0.2
    FOR y = -2 TO 2 STEP 0.2
        z = F(x, y)
        Project3D x, y, z
        sx1 = sx : sy1 = sy
        z2 = F(x + 0.2, y)
        Project3D x + 0.2, y, z2
        sx2 = sx : sy2 = sy
        LINE sx1, sy1, sx2, sy2, RGB(0, 255, 0)
        z3 = F(x, y + 0.2)
        Project3D x, y + 0.2, z3
        sx3 = sx : sy3 = sy
        LINE sx1, sy1, sx3, sy3, RGB(0, 255, 0)
    NEXT y
NEXT x

TEXT 10, 10, "3D Surface: z = sin(x)*cos(y)", "L"
END