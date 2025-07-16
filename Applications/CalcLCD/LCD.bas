' CalcLCD 0.6
' INSCCOIN 2025

Dim r As Integer, g As Integer, b As Integer
Dim choice As String
Dim menuColor As Integer

Randomize Timer

Do
    ShowRainbowMenu()
    choice = GetUserChoice()
    Select Case choice
        Case "1"
            RandomColorTest()
        Case "2"
            RandomBoxTest()
        Case "3"
            RandomLineTest()
        Case "4"
            RandomCircleTest()
        Case "5"
            RandomAllShapesTest()
        Case "6", "Q", "q"
            Exit Do
    End Select
Loop

Cls
Print "PicoCalc LCD Tester"
End

Sub ShowRainbowMenu()
    Cls
    Local i As Integer, colorStep As Integer
    colorStep = 0
    For i = 1 To Len("LCD TEST SUITE")
        r = Int(Sin(colorStep * 0.5) * 127 + 128)
        g = Int(Sin(colorStep * 0.5 + 2) * 127 + 128)
        b = Int(Sin(colorStep * 0.5 + 4) * 127 + 128)
        Colour RGB(r, g, b)
        Text 10 + i * 8, 10, Mid$("LCD TEST SUITE", i, 1)
        colorStep = colorStep + 1
    Next i
    
    colorStep = 20
    Colour RGB(255, 100, 100)  ' Red
    Text 10, 40, "1. Random Color Screen Test"
    
    Colour RGB(100, 255, 100)  ' Green
    Text 10, 55, "2. Random Colored Boxes Test"
    
    Colour RGB(100, 100, 255)  ' Blue
    Text 10, 70, "3. Random Colored Lines Test"
    
    Colour RGB(255, 100, 255)  ' Magenta
    Text 10, 85, "4. Random Colored Circles Test"
    
    Colour RGB(100, 255, 255)  ' Cyan
    Text 10, 100, "5. Random All Shapes Test"
    
    Colour RGB(255, 255, 100)  ' Yellow
    Text 10, 115, "6. Exit (Q)"
    
    Colour RGB(255, 255, 255)  ' White
    Text 10, 130, "Enter choice (1-6): "
End Sub

Function GetUserChoice() As String
    Local key As String
    Do
        key = Inkey$
        If key <> "" Then
            Print key
            GetUserChoice = key
            Exit Function
        EndIf
        Pause 50
    Loop
End Function

' 1
Sub RandomColorTest()
    Cls
    Colour RGB(255, 255, 255)
    Text 10, 10, "Random Color Screen Test"
    Pause 1000
    
    Do
        r = Int(Rnd * 256)
        g = Int(Rnd * 256)
        b = Int(Rnd * 256)
        
        Colour RGB(r, g, b)
        Box 0, 0, MM.HRes, MM.VRes, , RGB(r, g, b), RGB(r, g, b)
        
        Colour RGB(255, 255, 255)
       ' Text 5, 5, "R:" + Str$(r) + " G:" + Str$(g) + " B:" + Str$(b), "L"
        
        Pause 200
        
        If Inkey$ <> "" Then Exit Sub
    Loop
End Sub

' 2
Sub RandomBoxTest()
    Cls
    Colour RGB(255, 255, 255)
    Text 10, 10, "Colored Boxes Test"
    Pause 1000
    Cls
    
    Local x1 As Integer, y1 As Integer, x2 As Integer, y2 As Integer
    
    Do
        x1 = Int(Rnd * (MM.HRes - 50))
        y1 = Int(Rnd * (MM.VRes - 50))
        x2 = x1 + Int(Rnd * 50) + 10  ' 10-60 pixel width
        y2 = y1 + Int(Rnd * 50) + 10  
        
        r = Int(Rnd * 256)
        g = Int(Rnd * 256)
        b = Int(Rnd * 256)
        
        Colour RGB(r, g, b)
        Box x1, y1, x2, y2, , RGB(r, g, b), RGB(r, g, b)
        
        Colour RGB(255, 255, 255)
       ' Text 5, 5, "R:" + Str$(r) + " G:" + Str$(g) + " B:" + Str$(b), "L"
        
        Pause 100
        
        If Inkey$ <> "" Then Exit Sub
    Loop
End Sub

' 3
Sub RandomLineTest()
    Cls
    Colour RGB(255, 255, 255)
    Text 10, 10, "Colored Lines Test"
    Pause 1000
    Cls
    
    Local x1 As Integer, y1 As Integer, x2 As Integer, y2 As Integer
    
    Do
        x1 = Int(Rnd * MM.HRes)
        y1 = Int(Rnd * MM.VRes)
        x2 = Int(Rnd * MM.HRes)
        y2 = Int(Rnd * MM.VRes)
        
        r = Int(Rnd * 256)
        g = Int(Rnd * 256)
        b = Int(Rnd * 256)

        Colour RGB(r, g, b)
        Line x1, y1, x2, y2
        
        Colour RGB(255, 255, 255)
      '  Text 5, 5, "R:" + Str$(r) + " G:" + Str$(g) + " B:" + Str$(b), "L"
        
        Pause 50
        
        If Inkey$ <> "" Then Exit Sub
    Loop
End Sub

' 4
Sub RandomCircleTest()
    Cls
    Colour RGB(255, 255, 255)
    Text 10, 10, "Colored Circles Test"
    Pause 1000
    Cls
    
    Local x As Integer, y As Integer, radius As Integer
    
    Do
        x = Int(Rnd * MM.HRes)
        y = Int(Rnd * MM.VRes)
        radius = Int(Rnd * 30) + 5
        
        r = Int(Rnd * 256)
        g = Int(Rnd * 256)
        b = Int(Rnd * 256)

        Colour RGB(r, g, b)
        Circle x, y, radius, , , RGB(r, g, b), RGB(r, g, b)
        
        Pause 100
        
        If Inkey$ <> "" Then Exit Sub
    Loop
End Sub

' 5
Sub RandomAllShapesTest()
    Cls
    Colour RGB(255, 255, 255)
    Text 10, 10, "All Shapes Test"
    Pause 1000
    Cls
    
    Local x1 As Integer, y1 As Integer, x2 As Integer, y2 As Integer
    Local x As Integer, y As Integer, radius As Integer
    Local shapeType As Integer
    
    Do
        shapeType = Int(Rnd * 3) + 1
        
        r = Int(Rnd * 256)
        g = Int(Rnd * 256)
        b = Int(Rnd * 256)
        
        Colour RGB(r, g, b)
        
        Select Case shapeType
            Case 1
                x1 = Int(Rnd * (MM.HRes - 50))
                y1 = Int(Rnd * (MM.VRes - 50))
                x2 = x1 + Int(Rnd * 50) + 10
                y2 = y1 + Int(Rnd * 50) + 10
                Box x1, y1, x2, y2, , RGB(r, g, b), RGB(r, g, b)
            Case 2
                x = Int(Rnd * MM.HRes)
                y = Int(Rnd * MM.VRes)
                radius = Int(Rnd * 30) + 5
                Circle x, y, radius, , , RGB(r, g, b), RGB(r, g, b)
            Case 3
                x1 = Int(Rnd * MM.HRes)
                y1 = Int(Rnd * MM.VRes)
                x2 = Int(Rnd * MM.HRes)
                y2 = Int(Rnd * MM.VRes)
                Line x1, y1, x2, y2
        End Select
        
        Pause 75
        
        If Inkey$ <> "" Then Exit Sub
    Loop
End Sub