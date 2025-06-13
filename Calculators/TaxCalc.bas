' INSCCOIN 2025
' PicoCalc Tax Calculator

OPTION LCDPANEL ILI9341, LANDSCAPE
CLS

PRINT "Tax Calculator"
PRINT "--------------"
PRINT "Enter gross income:"
INPUT income
PRINT "Enter tax rate (%):"
INPUT taxrate

' Calculate tax and net income
tax = income * taxrate / 100
net = income - tax

' Round to two decimal places
tax = INT(tax * 100 + 0.5) / 100
net = INT(net * 100 + 0.5) / 100

CLS
PRINT "Gross Income: $"; income
PRINT "Tax Rate: "; taxrate; "%"
PRINT "--------------------------"
PRINT "Tax Owed: $"; tax
PRINT "Net Income: