' INSCCOIN 2025
' Loan Calculator

OPTION LCDPANEL ILI9341, LANDSCAPE
CLS

PRINT "Loan Calculator"
PRINT "----------------"
PRINT "Enter loan amount:"
INPUT loan
PRINT "Enter annual interest rate (%):"
INPUT rate
PRINT "Enter number of monthly payments:"
INPUT n

' Convert annual rate to monthly decimal
monthly_rate = rate / 1200

' Calculate monthly payment
IF monthly_rate = 0 THEN
    payment = loan / n
ELSE
    payment = loan * (monthly_rate * (1 + monthly_rate) ^ n) / ((1 + monthly_rate) ^ n - 1)
END IF

' Round to two decimal places
payment = INT(payment * 100 + 0.5) / 100

CLS
PRINT "Loan Amount: $"; loan
PRINT "Annual Rate: "; rate; "%"
PRINT "Payments: "; n
PRINT "--------------------------"
PRINT "Monthly Payment: $"; payment

END