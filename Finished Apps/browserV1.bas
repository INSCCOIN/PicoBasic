' A & B Drive require manual switching
' Before program load
' A: & B:
' You can try CHDIR "A:" or CHDIR "B:" 
' Above DIM statement is for 100 files max

CLS
Print "Browser 1.0"
Print "INSCCOIN 2025"
Print "V6.00.02 RC26"
Print

Dim fileList$(100)
count = 0

file$ = DIR$("*.*")
Do While files$ <> ""
  count = count + 1
  fileList$(count) = file$
  Print count; ": "; file$
  file$ = DIR$("")
Loop

If count = 0 Then
  Print "No files found."
  End
EndIf

Print
Input "Enter file number to view, or 0 to exit: ", choice

If choice < 1 Or choice > count Then
  Print "Exiting."
  End
EndIf

filename$ = fileList$(choice)
Print
Print "Contents of "; filename$; ":"
Print String$(40, "-")

Open filename$ For Input As #1
Do While Not EOF(1)
  Line Input #1, line$
  Print line$
Loop
Close #1

Print
Print "End of file."