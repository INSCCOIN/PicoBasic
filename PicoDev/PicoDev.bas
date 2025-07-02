' INSCCOIN 2025
' PicoDev - Interactive RAW Binary Runner for PicoMite (PicoCalc)
' WARNING: Running arbitrary code can crash or damage your device! (I killed a pico 1h on accident)
' Only use this for safe, known-good bytes.

OPTION EXPLICIT
DIM code(16)
DIM code$(16)
DIM addr% = &H20020000 ' Safe RAM area for code (adjust if needed)
DIM i%, n%, choice%, idx%, fname$

SUB ShowMenu
  PRINT "\nPicoDev Binary Menu:"
  PRINT "1. Enter new code (binary or decimal)"
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
  PRINT "Enter up to 16 bytes (binary e.g. 10101010 or decimal 0-255)"
  PRINT "Enter blank line to finish."
  DO
    INPUT "Byte " + STR$(n%+1) + ": ", code$(n%+1)
    IF TRIM$(code$(n%+1)) = "" THEN EXIT DO
    IF INSTR(code$(n%+1),"0b") = 1 THEN
      code(n%+1) = VAL(MID$(code$(n%+1),3),2)
    ELSEIF code$(n%+1) LIKE "[01]*" AND LEN(code$(n%+1))=8 THEN
      code(n%+1) = VAL("&B"+code$(n%+1))
    ELSE
      code(n%+1) = VAL(code$(n%+1))
    ENDIF
    n% = n% + 1
    IF n% >= 16 THEN EXIT DO
  LOOP
END SUB

SUB ViewCode
  IF n% = 0 THEN PRINT "No code loaded." : EXIT SUB
  PRINT "Current code ("; n%; " bytes):"
  FOR i% = 1 TO n%
    PRINT RIGHT$("00000000"+BIN$(code(i%)),8); " ("; code(i%); ") ",
  NEXT
  PRINT
END SUB

SUB EditByte
  IF n% = 0 THEN PRINT "No code loaded." : EXIT SUB
  INPUT "Byte to edit (1-" + STR$(n%) + "): ", idx%
  IF idx% < 1 OR idx% > n% THEN PRINT "Invalid index." : EXIT SUB
  INPUT "New value (binary or decimal): ", code$(idx%)
  IF INSTR(code$(idx%),"0b") = 1 THEN
    code(idx%) = VAL(MID$(code$(idx%),3),2)
  ELSEIF code$(idx%) LIKE "[01]*" AND LEN(code$(idx%))=8 THEN
    code(idx%) = VAL("&B"+code$(idx%))
  ELSE
    code(idx%) = VAL(code$(idx%))
  ENDIF
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
    PRINT #1, code(i%)
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
    code(n%+1) = VAL(code$(n%+1))
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
    CASE 8: PRINT "Exiting PicoDev." : EXIT DO
    CASE ELSE: PRINT "Invalid option."
  END SELECT
LOOP
