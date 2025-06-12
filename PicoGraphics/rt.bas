' INSCCOIN 2025
' Raytraced Sphere Demo

Const w = 320
Const h = 320
Const cx = 160
Const cy = 160
Const r = 80

' Light direction
Const lx = -0.6
Const ly = -0.7
Const lz = 1

' Colors (adjust as needed for your system)
Const col_bg = RGB(20,20,40)
Const col_sphere = RGB(200,180,80)

CLS col_bg

For y = 0 To h-1
  For x = 0 To w-1
    ' Sphere equation: (x-cx)^2 + (y-cy)^2 <= r^2
    dx = x - cx
    dy = y - cy
    If dx*dx + dy*dy <= r*r Then
      ' Calculate z on sphere surface
      dz = Sqr(r*r - dx*dx - dy*dy)
      ' Surface normal
      nx = dx / r
      ny = dy / r
      nz = dz / r
      ' Lambertian shading
      dot = nx*lx + ny*ly + nz*lz
      If dot < 0 Then dot = 0
      ' Shade color
      shade = 40 + Int(180 * dot)
      If shade > 255 Then shade = 255
      If shade < 0 Then shade = 0
      ' Blue/red sphere: blue increases with shade, red decreases
      c = RGB(255 - shade, 0, shade)
      Pixel x, y, c
    Else
      ' Background
      Pixel x, y, col_bg
    EndIf
  Next x
Next y

' Draw a ground shadow (simple ellipse)
For x = cx-r To cx+r
  For y = cy+r To cy+r+20
    dx = (x-cx)/r
    dy = (y-(cy+r))/20
    If dx*dx + dy*dy <= 1 Then
      c = RGB(30,30,30)
      Pixel x, y, c
    EndIf
  Next y
Next x

' Optional: Draw a highlight
For y = cy-r To cy+r
  For x = cx-r To cx+r
    dx = x - (cx-0.4*r)
    dy = y - (cy-0.5*r)
    If dx*dx + dy*dy < (0.1*r)^2 Then
      Pixel x, y, RGB(255,255,200)
    EndIf
  Next x
Next y

' Show text
Font 2
Text 60, 300, "Raytraced Sphere Demo"
Save image "sphere.bmp"
Pause 5000
CLS col_bg
