' PicoMazeGen (PMG) 1.0
' INSCCOIN 2025
' 6.00.02 RC26
' Pico 1 & 2 Wireless not required
' Planned improvements: Different maze sizes, more complex algorithms, Color support, Save image to png.
CLS
Print "PMG 1.0"
pause 100
CLS
width = 21   ' Must be odd for best results
height = 11  ' Must be odd for best results

Dim maze$(height)

' Initialize maze with walls
For y = 1 To height
  maze$(y) = String$(width, "#")
Next y

' Carve out the maze using a random walk
x = 2
y = 2
maze$(y) = Mid$(maze$(y), 1, x - 1) + " " + Mid$(maze$(y), x + 1)

For steps = 1 To (width * height)
  dir = Int(Rnd * 4)
  Select Case dir
    Case 0: If x > 2 Then x = x - 2
    Case 1: If x < width - 1 Then x = x + 2
    Case 2: If y > 2 Then y = y - 2
    Case 3: If y < height - 1 Then y = y + 2
  End Select
  maze$(y) = Mid$(maze$(y), 1, x - 1) + " " + Mid$(maze$(y), x + 1)
  ' Remove wall between cells
  If dir = 0 Then maze$(y) = Mid$(maze$(y), 1, x) + " " + Mid$(maze$(y), x + 2)
  If dir = 1 Then maze$(y) = Mid$(maze$(y), 1, x - 2) + " " + Mid$(maze$(y), x)
  If dir = 2 Then maze$(y + 1) = Mid$(maze$(y + 1), 1, x - 1) + " " + Mid$(maze$(y + 1), x + 1)
  If dir = 3 Then maze$(y - 1) = Mid$(maze$(y - 1), 1, x - 1) + " " + Mid$(maze$(y - 1), x + 1)
Next steps

' Print the maze
For y = 1 To height
  Print maze$(y)
Next y

Print "Maze complete!"