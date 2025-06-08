' Simple Spreadsheet in MMBasic
' 3x3 grid with row/column sums
' Author: ICS   Date: 2025-6-08
' Tested on MMBasic 6.0002
' This program creates a simple 3x3 spreadsheet where the user can input values.
' It calculates the sum of each row and each column, displaying the results.
' THIS PROGRAM IS A WORK IN PROGRESS AND MAY NOT BE FULLY FUNCTIONAL.
DIM grid(3,3)
DIM rowSum(3), colSum(3)
CLS

' Input values
FOR r = 1 TO 3
    FOR c = 1 TO 3
        PRINT "Enter value for cell ("; r; ","; c; "): ";
        INPUT grid(r, c)
    NEXT c
NEXT r

' Calculate sums
FOR r = 1 TO 3
    rowSum(r) = 0
    FOR c = 1 TO 3
        rowSum(r) = rowSum(r) + grid(r, c)
        colSum(c) = colSum(c) + grid(r, c)
    NEXT c
NEXT r

' Display grid and sums
PRINT
PRINT "Spreadsheet:"
FOR r = 1 TO 3
    FOR c = 1 TO 3
        PRINT grid(r, c); TAB(6);
    NEXT c
    PRINT "| "; rowSum(r)
NEXT r

PRINT STRING$(20, "-")
FOR c = 1 TO 3
    PRINT colSum(c); TAB(6);
NEXT c
PRINT

' End of program