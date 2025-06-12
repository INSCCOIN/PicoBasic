' INSCCOIN 2025
' Set cpuspeed to 300mhz+ for best performance
' Pico 2 reccomended for best performance


Const w = 320
Const h = 320

' Square center and size
Const cx = 160
Const cy = 160
Const half = 60

' Light direction (normalized)
Const lx = -0.6
Const ly = -0.7
Const lz = 1

' Colors
Const col_bg = RGB(20,20,40)

CLS col_bg

' For each pixel, check if inside square and shade
For y = 0 To h-1
  For x = 0 To w-1
    dx = x - cx
    dy = y - cy
    If Abs(dx) <= half And Abs(dy) <= half Then
      ' "Raytraced" z for flat square: z = 0
      ' Normal is always (0,0,1)
      dot = lz
      If dot < 0 Then dot = 0
      shade = 40 + Int(180 * dot)
      If shade > 255 Then shade = 255
      If shade < 0 Then shade = 0
      c = RGB(shade, shade, 255 - shade) ' Blueish square
      Pixel x, y, c
    Else
      Pixel x, y, col_bg
    EndIf
  Next x
Next y

Font 2
Text 70, 300, "Raytraced Square"
Pause 5000
CLS col_bg