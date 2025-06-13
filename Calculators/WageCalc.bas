' INSCCOIN 2025
' PicoCalc Salary/Hourly Converter Calculator

OPTION LCDPANEL ILI9341, LANDSCAPE
CLS

PRINT "Salary/Hourly Converter"
PRINT "-----------------------"
PRINT "Choose conversion type:"
PRINT "1: Salary to Hourly"
PRINT "2: Hourly to Salary"
INPUT choice

IF choice = 1 THEN
    PRINT "Enter annual salary ($):"
    INPUT salary
    PRINT "Enter hours per week:"
    INPUT hours
    PRINT "Enter weeks per year (e.g. 52):"
    INPUT weeks
    hourly = salary / (hours * weeks)
    hourly = INT(hourly * 100 + 0.5) / 100
    CLS
    PRINT "Annual Salary: $"; salary
    PRINT "Hours/Week: "; hours
    PRINT "Weeks/Year: "; weeks
    PRINT "--------------------------"
    PRINT "Equivalent Hourly Rate: $"; hourly
ELSEIF choice = 2 THEN
    PRINT "Enter hourly wage ($):"
    INPUT hourly
    PRINT "Enter hours per week:"
    INPUT hours
    PRINT "Enter weeks per year (e.g. 52):"
    INPUT weeks
    salary = hourly * hours * weeks
    salary = INT(salary * 100 + 0.5) / 100
    CLS
    PRINT "Hourly Wage: $"; hourly
    PRINT "Hours/Week: "; hours
    PRINT "Weeks/Year: "; weeks
    PRINT "--------------------------"
    PRINT "Equivalent Annual Salary: $"; salary
ELSE
    PRINT "Invalid choice."
ENDIF
END