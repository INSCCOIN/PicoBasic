' PicoDraw Framework for INSCCOIN 2025 V6.00.02 RC26
' This program allows drawing on the screen using arrow keys and space bar.
' The Keyboard controls are janky as of 6/8/2025 on V6.00.02 RC26, tested on 5.00 it seems to work better.
' Future versions will improve this problem. 
' Planned features include: Full RGB support, line drawing, shape tools & saving/loading images.
CLS
Print "PicoDraw Framework 1.0"
Print 
Print "Supported colors: White"
Print "Use arrow keys to move."
Print "Space to draw. Q to quit."
x = 100
y = 100
step = 5

Do
  key$ = INKEY$
  If key$ = " " Then
    PIXEL x, y, RGB(255,255,255) ' Draw white pixel
  ElseIf UCASE$(key$) = "Q" Then
    Exit Do

  ElseIf key$ = CHR$(28) Then ' Left arrow
    x = x - step
    If x < 0 Then x = 0

  ElseIf key$ = CHR$(29) Then ' Right arrow
    x = x + step
    If x > MM.HRES Then x = MM.HRES

  ElseIf key$ = CHR$(30) Then ' Up arrow
    y = y - step
    If y < 0 Then y = 0

  ElseIf key$ = CHR$(31) Then ' Down arrow
    y = y + step
    If y > MM.VRES Then y = MM.VRES

  EndIf
  Pause 50
Loop

CLS
Print "Goodbye!"