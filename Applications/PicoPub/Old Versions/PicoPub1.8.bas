' PicoPub1.8
' INSCCOIN 2025

OPTION EXPLICIT

dim string FILENAME$, line$, displayLine$, k$, n$
dim integer pageStart, shownLines, totalLines, linesPerPage
dim integer HRES, VRES, CHAR_W, CHAR_H, MAX_LINE_LEN
dim integer firstLine, lastLine, currentPage, totalPages, wrapPos, displayLineNum, fsize

' i hate the picos tiny ass screen
HRES = MM.HRES : VRES = MM.VRES
CHAR_W = 8 : CHAR_H = 8
MAX_LINE_LEN = HRES / CHAR_W
linesPerPage = 25

input "Enter filename: ", FILENAME$

' total lines in file
on error skip 1
open FILENAME$ for input as #1
if MM.ERRNO then print "File not found." : end
on error skip
totalLines = 0
do while not eof(#1)
    line input #1, line$
    totalLines = totalLines + 1
loop
close #1

pageStart = 0

' main loop
do
    cls
    shownLines = 0
    open FILENAME$ for input as #1
    for firstLine = 1 to pageStart
        if not eof(#1) then line input #1, line$
    next firstLine

    ' page lines
    displayLineNum = pageStart + 1
    do while shownLines < linesPerPage and not eof(#1)
        line input #1, line$
        if len(line$) <= MAX_LINE_LEN then
            print left$(line$ + space$(MAX_LINE_LEN), MAX_LINE_LEN)
            shownLines = shownLines + 1
            displayLineNum = displayLineNum + 1
        else
            wrapPos = 1
            do while wrapPos <= len(line$) and shownLines < linesPerPage
                if wrapPos = 1 then
                    print left$(mid$(line$, wrapPos, MAX_LINE_LEN) + space$(MAX_LINE_LEN), MAX_LINE_LEN)
                else
                    print left$(mid$(line$, wrapPos, MAX_LINE_LEN) + space$(MAX_LINE_LEN), MAX_LINE_LEN)
                end if
                wrapPos = wrapPos + MAX_LINE_LEN
                shownLines = shownLines + 1
                if wrapPos = MAX_LINE_LEN + 1 then displayLineNum = displayLineNum + 1
            loop
            displayLineNum = displayLineNum + 1
        end if
    loop
    close #1

    firstLine = pageStart + 1
    lastLine = pageStart + shownLines
    if lastLine > totalLines then lastLine = totalLines
    currentPage = int((pageStart / linesPerPage) + 1)
    totalPages = int(((totalLines - 1) / linesPerPage) + 1)

    ' status bar
    print currentPage; "|"; totalPages; "|"; firstLine; "-"; lastLine; "|"; totalLines

    ' usr input
    do: k$ = inkey$: loop until k$ = chr$(129) or k$ = chr$(130) or k$ = "Q" or k$ = "q" or k$ = "J" or k$ = "j" or k$ = "I" or k$ = "i" or k$ = "L" or k$ = "l"

    select case k$
        case chr$(129) ' right arrow
            if pageStart + linesPerPage < totalLines then pageStart = pageStart + linesPerPage
        case chr$(130) ' left arrow
            if pageStart - linesPerPage >= 0 then
                pageStart = pageStart - linesPerPage
            else
                pageStart = 0
            end if
        case "J", "j"
            print "Jump to (P)age or (L)ine? ";
            input n$
            if ucase$(n$) = "P" then
                print "Enter page number: ";
                input n$
                if val(n$) >= 1 and val(n$) <= totalPages then
                    pageStart = (val(n$) - 1) * linesPerPage
                end if
            elseif ucase$(n$) = "L" then
                print "Enter line number: ";
                input n$
                if val(n$) >= 1 and val(n$) <= totalLines then
                    pageStart = int((val(n$) - 1) / linesPerPage) * linesPerPage
                end if
            end if
        case "L", "l"
            ' line cycle
            select case linesPerPage
                case 10: linesPerPage = 15
                case 15: linesPerPage = 20
                case 20: linesPerPage = 25
                case else: linesPerPage = 10
            end select
            ' redo page start from line cycles
            pageStart = int((firstLine - 1) / linesPerPage) * linesPerPage
        case "I", "i"
            ' file info 
            fsize = 0
            on error skip 1
            open FILENAME$ for input as #2
            if MM.ERRNO then
                print "File not found."
            else
                do while not eof(#2)
                    line input #2, line$
                    fsize = fsize + len(line$) + 2 
                loop
                close #2
                cls
                print "--- FILE INFO ---"
                print "Name: ", FILENAME$
                print "Size: ", fsize; " bytes"
                print "Lines: ", totalLines
                print "Pages: ", totalPages
                print "-----------------"
                print "Press any key to return..."
                do: loop until inkey$ <> ""
            end if
            on error skip
        case "Q", "q"
            end
    end select
loop
