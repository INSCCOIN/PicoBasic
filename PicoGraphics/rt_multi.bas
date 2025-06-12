' INSCCOIN 2025
' Raytraced Sphere Demo

Const w = 320
Const h = 320

' Sphere definitions
Dim sx(2), sy(2), sz(2), sr(2)
sx(0) = 110: sy(0) = 160: sz(0) = 0: sr(0) = 80  ' Red/Blue sphere
sx(1) = 200: sy(1) = 160: sz(1) = 40: sr(1) = 60 ' Green sphere

' Light direction
Const lx = -0.6
Const ly = -0.7
Const lz = 1

CLS RGB(20,20,40)

For y = 0 To h-1
  For x = 0 To w-1
    maxz = -10000
    sph = -1
    For i = 0 To 1
      dx = x - sx(i)
      dy = y - sy(i)
      r2 = sr(i)*sr(i)
      d2 = dx*dx + dy*dy
      If d2 <= r2 Then
        dz = Sqr(r2 - d2) + sz(i)
        If dz > maxz Then
          maxz = dz
          sph = i
          sdx = dx: sdy = dy: sdz = dz
        EndIf
      EndIf
    Next i
    If sph <> -1 Then
      ' Surface normal
      nx = sdx / sr(sph)
      ny = sdy / sr(sph)
      nz = sdz / sr(sph)
      dot = nx*lx + ny*ly + nz*lz
      If dot < 0 Then dot = 0
      shade = 40 + Int(180 * dot)
      If shade > 255 Then shade = 255
      If shade < 0 Then shade = 0
      If sph = 0 Then
        c = RGB(255 - shade, 0, shade) ' Red/Blue
      Else
        c = RGB(0, shade, 0)           ' Green
      EndIf
      Pixel x, y, c
    Else
      Pixel x, y, RGB(20,20,40)
    EndIf
  Next x
Next y

Font 2
Text 60, 300, "Raytraced Multiple Spheres"
Pause 5000
CLS RGB(20,20,40)
