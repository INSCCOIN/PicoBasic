' INSCCOIN 2025
' Set cpuspeed to 300mhz+ for best performance
' Pico 2 reccomended for best performance




Const w = 320
Const h = 320

Const blk = RGB(0,0,0)
Const red = RGB(255,0,0)
Const grn = RGB(0,255,0)
Const blu = RGB(0,0,255)
Const ylw = RGB(255,255,0)
Const cyn = RGB(0,255,255)
Const mag = RGB(255,0,255)
Const wht = RGB(255,255,255)
Const gry = RGB(128,128,128)

Do
  CLS blk

  'circles
  Circle 60, 60, 40, 1, red, red
  Circle 260, 60, 40, 1, grn, grn
  Circle 160, 260, 50, 1, blu, blu

  ' rectangles
  Rect 30, 150, 60, 40, 1, ylw, ylw
  Rect 230, 150, 60, 40, 1, mag, mag

  'lines
  Line 0, 0, w-1, h-1, wht
  Line w-1, 0, 0, h-1, gry

  'triangle
  Poly 3, 160,40, 100,120, 220,120, 1, cyn, cyn

  'hexagon
  Poly 6, 160,180, 190,200, 190,240, 160,260, 130,240, 130,200, 1, mag, mag

  'text
  Font 2
  Text 60, 300, "Shapes Demo", wht, blk

  Pause 1000
Loop