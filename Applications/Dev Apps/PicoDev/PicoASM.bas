' INSCCOIN 2025
' PicoASM 1.0 - Interactive RAW Assembly Runner for the picocalc
' WARNING: Running arbitrary code can crash or damage your device! (I killed a pico 1h on accident)
' Only use this for safe, known-good opcodes.

OPTION EXPLICIT
DIM code$(16)
DIM code(16)
DIM addr% = &H20020000 ' Safe RAM area for code
DIM i%, n%, choice%, idx%, fname$

SUB ShowMenu
  PRINT "\nPicoASM Menu:"
  PRINT "1. Enter new code"
  PRINT "2. View current code"
  PRINT "3. Edit a byte"
  PRINT "4. Clear code"
  PRINT "5. Save code to file"
  PRINT "6. Load code from file"
  PRINT "7. Run code"
  PRINT "8. Exit"
END SUB

SUB EnterCode
  n% = 0
  PRINT "Enter up to 16 bytes of ARM Thumb code (hex, e.g. 00 for NOP)"
  PRINT "Enter blank line to finish."
  DO
    INPUT "Byte " + STR$(n%+1) + " (hex): ", code$(n%+1)
    IF TRIM$(code$(n%+1)) = "" THEN EXIT DO
    code(n%+1) = VAL("&H" + code$(n%+1))
    n% = n% + 1
    IF n% >= 16 THEN EXIT DO
  LOOP
END SUB

SUB ViewCode
  IF n% = 0 THEN PRINT "No code loaded." : EXIT SUB
  PRINT "Current code ("; n%; " bytes):"
  FOR i% = 1 TO n%
    PRINT HEX$(code(i%),2); " ",
  NEXT
  PRINT
END SUB

SUB EditByte
  IF n% = 0 THEN PRINT "No code loaded." : EXIT SUB
  INPUT "Byte to edit (1-" + STR$(n%) + "): ", idx%
  IF idx% < 1 OR idx% > n% THEN PRINT "Invalid index." : EXIT SUB
  INPUT "New value (hex): ", code$(idx%)
  code(idx%) = VAL("&H" + code$(idx%))
END SUB

SUB ClearCode
  n% = 0
  PRINT "Code cleared."
END SUB

SUB SaveCode
  IF n% = 0 THEN PRINT "No code to save." : EXIT SUB
  INPUT "Filename to save: ", fname$
  OPEN fname$ FOR OUTPUT AS #1
  FOR i% = 1 TO n%
    PRINT #1, code$(i%)
  NEXT
  CLOSE #1
  PRINT "Code saved to "; fname$
END SUB

SUB LoadCode
  INPUT "Filename to load: ", fname$
  OPEN fname$ FOR INPUT AS #1
  n% = 0
  DO WHILE NOT EOF(1) AND n% < 16
    LINE INPUT #1, code$(n%+1)
    code(n%+1) = VAL("&H" + code$(n%+1))
    n% = n% + 1
  LOOP
  CLOSE #1
  PRINT n%; " bytes loaded from "; fname$
END SUB

SUB RunCode
  IF n% = 0 THEN PRINT "No code to run." : EXIT SUB
  FOR i% = 1 TO n%
    POKE BYTE addr% + i% - 1, code(i%)
  NEXT
  PRINT "Code written to RAM at "; HEX$(addr%)
  INPUT "Press Enter to run...", dummy$
  CALL addr%
  PRINT "Execution returned to BASIC."
END SUB

' Main loop
DO
  ShowMenu
  INPUT "Select option (1-8): ", choice%
  SELECT CASE choice%
    CASE 1: EnterCode
    CASE 2: ViewCode
    CASE 3: EditByte
    CASE 4: ClearCode
    CASE 5: SaveCode
    CASE 6: LoadCode
    CASE 7: RunCode
    CASE 8: PRINT "Exiting PicoASM." : EXIT DO
    CASE ELSE: PRINT "Invalid option."
  END SELECT
LOOP
