' PicoPub1.6
' Command list: Left arrow, down arrow, Q, J (Jump) after j enter P for page or L for line.
' INSCCOIN 2025
OPTION EXPLICIT

dim string FILENAME$, line$
dim integer pageStart, i, shownLines, totalLines, linesPerPage

dim integer HRES, VRES, CHAR_W, CHAR_H, MAX_LINES
HRES = MM.HRES
VRES = MM.VRES
CHAR_W = 8
CHAR_H = 8
MAX_LINES = VRES / CHAR_H
linesPerPage = 25

dim string k$
dim integer firstLine, lastLine

input "Enter filename: ", FILENAME$

' Count total lines
on error skip 1
open FILENAME$ for input as #1
if MM.ERRNO then
    print "File not found." : end
end if
on error skip
totalLines = 0
do while not eof(#1)
    line input #1, line$
    totalLines = totalLines + 1
loop
close #1

pageStart = 0
do
    cls
    shownLines = 0
    i = 0
    open FILENAME$ for input as #1
    for i = 1 to pageStart
        if not eof(#1) then line input #1, line$
    next i
    i = 0
    do while shownLines < linesPerPage and not eof(#1)
        line input #1, line$
        print line$
        shownLines = shownLines + 1
        i = i + 1
    loop
    close #1
    firstLine = pageStart + 1
    lastLine = pageStart + shownLines
    if lastLine > totalLines then lastLine = totalLines
    print "Pg:"; (pageStart / linesPerPage) + 1; "/"; (totalLines / linesPerPage) + 1; "  [Q]uit  ";
    print firstLine;"-"; lastLine; ":";totalLines;
    do
        k$ = inkey$
    loop until k$ = chr$(129) or k$ = chr$(130) or k$ = "Q" or k$ = "q" or k$ = "J" or k$ = "j"
    select case k$
        case chr$(129) ' right arrow
            if pageStart + linesPerPage < totalLines then pageStart = pageStart + linesPerPage
        case chr$(130) ' left arrow
            if pageStart - linesPerPage >= 0 then pageStart = pageStart - linesPerPage else pageStart = 0
        case "J", "j"
            dim string n$
            print "Jump to (P)age or (L)ine? ";
            input n$
            if ucase$(n$) = "P" then
                print "Enter page number: ";
                input n$
                if val(n$) >= 1 and val(n$) <= (totalLines-1) / linesPerPage + 1 then
                    pageStart = (val(n$) - 1) * linesPerPage
                end if
            elseif ucase$(n$) = "L" then
                print "Enter line number: ";
                input n$
                if val(n$) >= 1 and val(n$) <= totalLines then
                    pageStart = int((val(n$) - 1) / linesPerPage) * linesPerPage
                end if
            end if
        case "Q", "q"
            end
    end select
loop
