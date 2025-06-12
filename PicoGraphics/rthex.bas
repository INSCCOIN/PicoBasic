' INSCCOIN 2025
' Set cpuspeed to 300mhz+ for best performance
' Pico 2 reccomended for best performance


Const w = 320
Const h = 320

' Hexagon center and size
Const cx = 160
Const cy = 160
Const radius = 70

' Light direction
Const lx = -0.6
Const ly = -0.7
Const lz = 1

' Colors
Const col_bg = RGB(20,20,40)

CLS col_bg

' Function to check if point (px,py) is inside a regular hexagon
Function InHex(px, py, cx, cy, radius)
  dx = Abs(px - cx)
  dy = Abs(py - cy)
  If dx > radius * 0.866 Or dy > radius Then
    InHex = 0
    Exit Function
  EndIf
  If radius * 0.5 * 0.866 - dx * 0.5 < dy Then
    InHex = 0
    Exit Function
  EndIf
  InHex = 1
End Function

' For each pixel, check if inside hexagon and shade
For y = 0 To h-1
  For x = 0 To w-1
    If InHex(x, y, cx, cy, radius) Then
      ' Simulate a 3D hexagonal prism
      ' Compute local coordinates
      dx = x - cx
      dy = y - cy
      ' Give the hexagon a 3D bulge: z = sqrt(r^2 - (dx^2 + dy^2 * 1.2))
      d2 = dx*dx + (dy*dy)*1.2
      If d2 <= radius*radius Then
        dz = Sqr(radius*radius - d2)
      Else
        dz = 0
      EndIf
      ' Surface normal (approximate)
      nx = dx / radius
      ny = dy / radius
      nz = dz / radius
      ' Lambertian shading
      dot = nx*lx + ny*ly + nz*lz
      If dot < 0 Then dot = 0
      shade = 40 + Int(180 * dot)
      If shade > 255 Then shade = 255
      If shade < 0 Then shade = 0
      ' Blue/red color: blue increases with shade, red decreases
      c = RGB(255 - shade, 0, shade)
      Pixel x, y, c
    Else
      Pixel x, y, col_bg
    EndIf
  Next x
Next y

Font 2
Text 60, 300, "3D Raytraced Hexagon", RGB(255,255,255), col_bg
Pause 5000
CLS col_bg
