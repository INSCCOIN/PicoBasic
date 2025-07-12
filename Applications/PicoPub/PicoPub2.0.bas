' PicoPub2.0
' INSCCOIN 2025
' FOR PROPER TEXT DISPLAY, AT THE BEGINING OF ALL TEXT FILES PLEASE PLACE A BLANK LINE.

Option EXPLICIT

Dim string FILENAME$, line$, displayLine$, k$, n$
Dim integer pageStart, shownLines, totalLines, linesPerPage
Dim integer HRES, VRES, CHAR_W, CHAR_H, MAX_LINE_LEN
Dim integer firstLine, lastLine, currentPage, totalPages, wrapPos, displayLineNum, fsize
Dim integer colorIndex
Dim integer colorList(5)

' i hate the picos tiny ass screen
HRES = MM.HRES : VRES = MM.VRES
CHAR_W = 8 : CHAR_H = 8
MAX_LINE_LEN = HRES / CHAR_W
linesPerPage = 37

Input "Enter filename: ", FILENAME$

' total lines in file
On error skip 1
Open FILENAME$ For input As #1
If MM.Errno Then Print "File not found." : End
On error skip
totalLines = 0
Do While Not Eof(#1)
    Line Input #1, line$
    totalLines = totalLines + 1
Loop
Close #1

pageStart = 0

' main loop

' keep till 2.5
colorIndex = 0
colorList(0) = RGB(white)
colorList(1) = RGB(yellow)
colorList(2) = RGB(green)
colorList(3) = RGB(cyan)
colorList(4) = RGB(magenta)
colorList(5) = RGB(red)

' nice purple color
' 120,33,215


' used MADCOCK's example as a base
DefineFont #10
  E0200808 00000000 00000000 18181818 00180018 006C6C6C 00000000 6CFE6C6C
  006C6CFE 7CC07E18 0018FC06 18CCC600 00C66630 76386C38 0076CCDC 00603030
  00000000 3030180C 000C1830 0C0C1830 0030180C FF3C6600 0000663C 7E181800
  00001818 00000000 30181800 7E000000 00000000 00000000 00181800 30180C06
  0080C060 F6DECE7C 007CC6E6 18183818 007E1818 7C06C67C 00FEC0C0 3C0606FC
  00FC0606 CCCCCC0C 000C0CFE 06FCC0FE 007CC606 FCC0C07C 007CC6C6 0C0606FE
  00303018 7CC6C67C 007CC6C6 7EC6C67C 007C0606 00181800 00181800 00181800
  30181800 6030180C 000C1830 007E0000 0000007E 060C1830 0030180C 180C663C
  00180018 DEDEC67C 007EC0DE C6C66C38 00C6C6FE FCC6C6FC 00FCC6C6 C0C0C67C
  007CC6C0 C6C6CCF8 00F8CCC6 F8C0C0FE 00FEC0C0 F8C0C0FE 00C0C0C0 C0C0C67C
  007CC6CE FEC6C6C6 00C6C6C6 1818187E 007E1818 06060606 007CC606 F0D8CCC6
  00C6CCD8 C0C0C0C0 00FEC0C0 FEFEEEC6 00C6C6D6 DEF6E6C6 00C6C6CE C6C6C67C
  007CC6C6 FCC6C6FC 00C0C0C0 C6C6C67C 067CDED6 FCC6C6FC 00C6CCD8 7CC0C67C
  007CC606 181818FF 00181818 C6C6C6C6 00FEC6C6 C6C6C6C6 00387CC6 C6C6C6C6
  006CFED6 386CC6C6 00C6C66C 7CC6C6C6 00E03018 180C06FE 00FE6030 3030303C
  003C3030 183060C0 0002060C 0C0C0C3C 003C0C0C C66C3810 00000000 00000000
  FF000000 386C6C38 00000000 067C0000 007EC67E FCC0C0C0 00FCC6C6 C67C0000
  007CC6C0 7E060606 007EC6C6 C67C0000 007CC0FE 7830361C 00783030 C67E0000
  FC067EC6 C6FCC0C0 00C6C6C6 18380018 003C1818 06060006 7CC60606 D8CCC0C0
  00C6CCF8 18181838 003C1818 FECC0000 00D6D6FE C6FC0000 00C6C6C6 C67C0000
  007CC6C6 C6FC0000 C0C0FCC6 C67E0000 06067EC6 C6FC0000 00C0C0C0 C07E0000
  00FC067C 187E1818 000E1818 C6C60000 007EC6C6 C6C60000 00387CC6 C6C60000
  006CFED6 6CC60000 00C66C38 C6C60000 FC067EC6 0CFE0000 00FE6038 7018180E
  000E1818 00181818 00181818 0E181870 00701818 0000DC76 00000000 6C381000
  00FEC6C6 818181FF FF818181 858581FF FF8191A9 99A581FF FF81A599 998181FF
  FF818199 818181FF FF81BD81 999981FF FF819981 A59981FF FF818989 FED6FE7C
  7CFEEED6 82AA827C 7C8292AA FE7C3810 0010387C FE387C38 7C1010FE 7E3C1800
  7E187EFF FEFEFE6C 0010387C BD99C3FF FFC399BD 3C180000 0000183C 303E323E
  60F07030 187E3C18 183C7E18 FF662400 00002466 187E3C18 00181818 18181818
  00183C7E FE0C0800 00080CFE 7F301000 0010307F 92541000 007C8282 BA824438
  38003854 3C001818 1818183C D3BFCEFC FFF395E5 42422418 24247E7E 7E7E3C18
  24247E7E E5E96224 2462E9E5 3B4B4B3F 000B0B0B 6648447E 60502824 3C1E3621
  10101BFE AA824438 384482AA 9A924438 3844929A BA824438 384482BA 48483000
  0103063C 207C201C 1C207C20 8142261A 7E424242 FE283800 7C444444 42663C00
  00242466 8282FE00 7C38FE82 38383810 00100010 83415628 20100CFE 4A4A4830
  0002324A 7E662418 38183818 FF00FF00 FF00FF00 55555555 55555555 3333CCCC
  3333CCCC 92244992 49922449 AA55AA55 AA55AA55 B6DB6DB6 6DB6DB6D 18181818
  18181818 18181818 181818F8 18F81818 181818F8 36363636 363636F6 00000000
  363636FE 18F80000 181818F8 06F63636 363636F6 36363636 36363636 06FE0000
  363636F6 06F63636 000000FE 36363636 000000FE 18F81818 000000F8 00000000
  181818F8 18181818 0000001F 18181818 000000FF 00000000 181818FF 18181818
  1818181F 00000000 000000FF 18181818 181818FF 181F1818 1818181F 36363636
  36363637 30373636 0000003F 303F0000 36363637 00F73636 000000FF 00FF0000
  363636F7 30373636 36363637 00FF0000 000000FF 00F73636 363636F7 00FF1818
  000000FF 36363636 000000FF 00FF0000 181818FF 00000000 363636FF 36363636
  0000003F 181F1818 0000001F 181F0000 1818181F 00000000 3636363F 36363636
  363636FF 18FF1818 181818FF 18181818 000000F8 00000000 1818181F FFFFFFFF
  FFFFFFFF 00000000 FFFFFFFF F0F0F0F0 F0F0F0F0 0F0F0F0F 0F0F0F0F FFFFFFFF
  00000000 DC760000 0076DCC8 786C6C38 606C666C C0C6FE00 00C0C0C0 6CFE0000
  006C6C6C 183060FE 00FE6030 D87E0000 0070D8D8 66666600 C0607C66 18DC7600
  00181818 663C187E 7E183C66 FFC3663C 003C66C3 C3C3663C 00E76666 7E0C180E
  007CC6C6 DB7E0000 00007EDB DB7E0C06 C0607EDB F8C06038 003860C0 CCCCCC78
  00CCCCCC 7E007E00 00007E00 187E1818 007E0018 30183060 00FC0060 30603018
  00FC0018 2C504844 1E088452 2C544844 04049E54 7E001818 00181800 00DC7600
  0000DC76 000C1818 00000000 18000000 00000018 00000000 00000018 0C0C0C0F
  1C3C6CEC 6C6C6C78 0000006C 607C0C7C 0000007C 3C3C0000 00003C3C E73C5A99
  995A3CE7
End DefineFont
Font 10, 1

Do
    CLS
    shownLines = -1
    Open FILENAME$ For input As #1
    For firstLine = 1 To pageStart
        If Not Eof(#1) Then Line Input #1, line$
    Next firstLine


    displayLineNum = pageStart + 1
    Do While shownLines < linesPerPage And Not Eof(#1)
        Line Input #1, line$
        Color colorList(colorIndex)
        If Len(line$) <= MAX_LINE_LEN Then
            Print Left$(line$ + Space$(MAX_LINE_LEN), MAX_LINE_LEN)
            shownLines = shownLines + 1
            displayLineNum = displayLineNum + 1
        Else
            wrapPos = 1
            Do While wrapPos <= Len(line$) And shownLines < linesPerPage
                Print Left$(Mid$(line$, wrapPos, MAX_LINE_LEN) + Space$(MAX_LINE_LEN), MAX_LINE_LEN)
                wrapPos = wrapPos + MAX_LINE_LEN
                shownLines = shownLines + 1
                If wrapPos = MAX_LINE_LEN + 1 Then displayLineNum = displayLineNum + 1
            Loop
            displayLineNum = displayLineNum + 1
        End If
        Color RGB(white)
    Loop
    Close #1

    firstLine = pageStart + 1
    lastLine = pageStart + shownLines
    If lastLine > totalLines Then lastLine = totalLines
    currentPage = Int((pageStart / linesPerPage) + 1)
    totalPages = Int(((totalLines - 1) / linesPerPage) + 1)

    ' status bar & text color
   ' Box 1, VRES-CHAR_H, HRES, CHAR_H, 100
   ' Box 0,0,80,24,,RGB(white),RGB(white)
    Color RGB(yellow)
    Print @(-2, VRES-CHAR_H-2) currentPage; " of"; totalPages; " |"; firstLine; " -"; lastLine; " |"; totalLines
    Color RGB(yellow)

    ' usr input
    Do : k$ = Inkey$: Loop Until k$ = Chr$(129) Or k$ = Chr$(130) Or k$ = "Q" Or k$ = "q" Or k$ = "J" Or k$ = "j" Or k$ = "I" Or k$ = "i" Or k$ = "L" Or k$ = "l" Or k$ = "S" Or k$ = "s" Or k$ = "C" Or k$ = "c"

    Select Case k$
        Case "C", "c"
            ' prompt for color
            Dim integer r, g, b
            Print "Enter R (0-255): ";
            Input r
            Print "Enter G (0-255): ";
            Input g
            Print "Enter B (0-255): ";
            Input b
            colorList(colorIndex) = RGB(r, g, b)
        Case "S", "s"
            ' takes a screenshot and plays tone
            Save image "p2.bmp"
            Play tone 1000,2000,40
            Pause 200
            Play tone 3000,4000,20
            Pause 200
            Play tone 4000,5000,40
        Case Chr$(129) ' right arrow
            If pageStart + linesPerPage < totalLines Then pageStart = pageStart + linesPerPage
        Case Chr$(130) ' left arrow
            If pageStart - linesPerPage >= 0 Then
                pageStart = pageStart - linesPerPage
            Else
                pageStart = 0
            End If
        Case "J", "j"
            Print "Jump to (P)age or (L)ine? ";
            Input n$
            If UCase$(n$) = "P" Then
                Print "Enter page number: ";
                Input n$
                If Val(n$) >= 1 And Val(n$) <= totalPages Then
                    pageStart = (Val(n$) - 1) * linesPerPage
                End If
            ElseIf UCase$(n$) = "L" Then
                Print "Enter line number: ";
                Input n$
                If Val(n$) >= 1 And Val(n$) <= totalLines Then
                    pageStart = Int((Val(n$) - 1) / linesPerPage) * linesPerPage
                End If
            End If
       ' Case "L", "l"
            ' rework for new font by v2.5
        Case "I", "i"
            ' file info & sys info
            fsize = 0
            On error skip 1
            Open FILENAME$ For input As #2
            If MM.Errno Then
                Print "File not found."
            Else
                Do While Not Eof(#2)
                    Line Input #2, line$
                    fsize = fsize + Len(line$) + 2
                Loop
                Close #2
                CLS
                Print "--- BOOK INFO ---"
                Print "Name: ", FILENAME$
                Print "Size: ", fsize; " bytes"
                Print "Lines: ", totalLines
                Print "Pages: ", totalPages
                Print "-----------------"
                Print "Press any key to return..."
                Do : Loop Until Inkey$ <> ""
            End If
            On error skip
        Case "Q", "q"
            End
    End Select
Loop
