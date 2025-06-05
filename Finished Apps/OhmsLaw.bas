'written in MMBASIC for the Raspberry Pi Pico
'This program is a simple Ohm's Law calculator.
'It allows the user to calculate voltage, current, or resistance based on the other two values.
'It prompts the user to select which value they want to calculate and then takes the necessary inputs.
'This program calculates voltage, current, or resistance using Ohm's Law.
'Ohm's Law: V = I * R, where V is voltage, I is current, and R is resistance.


CLS
PRINT "Ohm's Law Calculator"
PRINT "===================="
PRINT "Select what to calculate:"
PRINT "1. Voltage (V)"
PRINT "2. Current (I)"
PRINT "3. Resistance (R)"
PRINT
INPUT "Enter choice (1-3): ", choice

IF choice = 1 THEN
    PRINT "Calculate Voltage (V = I * R)"
    INPUT "Enter Current (I) in Amps: ", I
    INPUT "Enter Resistance (R) in Ohms: ", R
    V = I * R
    PRINT "Voltage (V) = "; V; " Volts"
ELSEIF choice = 2 THEN
    PRINT "Calculate Current (I = V / R)"
    INPUT "Enter Voltage (V) in Volts: ", V
    INPUT "Enter Resistance (R) in Ohms: ", R
    IF R = 0 THEN
        PRINT "Resistance cannot be zero!"
    ELSE
        I = V / R
        PRINT "Current (I) = "; I; " Amps"
    ENDIF
ELSEIF choice = 3 THEN
    PRINT "Calculate Resistance (R = V / I)"
    INPUT "Enter Voltage (V) in Volts: ", V
    INPUT "Enter Current (I) in Amps: ", I
    IF I = 0 THEN
        PRINT "Current cannot be zero!"
    ELSE
        R = V / I
        PRINT "Resistance (R) = "; R; " Ohms"
    ENDIF
ELSE
    PRINT "Invalid choice. Please restart the program."
ENDIF

PRINT
PRINT "Press any key to exit..."
DO: LOOP UNTIL INKEY$ <> ""