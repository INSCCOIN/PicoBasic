' INSCCOIN 2025
' PicoCalc Interest Calculator

OPTION LCDPANEL ILI9341, LANDSCAPE
CLS

PRINT "Interest Calculator"
PRINT "-------------------"
PRINT "Choose calculation type:"
PRINT "1: Simple Interest"
PRINT "2: Compound Interest"
INPUT choice

PRINT "Enter principal amount ($):"
INPUT principal
PRINT "Enter annual interest rate (%):"
INPUT rate
PRINT "Enter number of years:"
INPUT years

IF choice = 1 THEN
    ' Simple Interest
    interest = principal * rate * years / 100
    total = principal + interest
    interest = INT(interest * 100 + 0.5) / 100
    total = INT(total * 100 + 0.5) / 100
    CLS
    PRINT "Simple Interest: $"; interest
    PRINT "Total Amount: $"; total
ELSEIF choice = 2 THEN
    PRINT "Enter number of times interest is compounded per year:"
    INPUT n
    ' Compound Interest
    total = principal * (1 + rate / (100 * n)) ^ (n * years)
    interest = total - principal
    interest = INT(interest * 100 + 0.5) / 100
    total = INT(total * 100 + 0.5) / 100
    CLS
    PRINT "Compound Interest: $"; interest
    PRINT "Total Amount: $"; total
ELSE
    PRINT "Invalid choice."
ENDIF
END