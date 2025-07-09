' PicoPub1.5 - Streamed paging, no array
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
dim string k$
do
    cls
    shownLines = 0
    i = 0
    open FILENAME$ for input as #1
    ' Skip lines before this page
    for i = 1 to pageStart
        if not eof(#1) then line input #1, line$
    next i
    ' Show up to linesPerPage lines
    i = 0
    do while shownLines < linesPerPage and not eof(#1)
        line input #1, line$
        print line$
        shownLines = shownLines + 1
        i = i + 1
    loop
    close #1
    print "Pg:"; (pageStart / linesPerPage) + 1; "/"; (totalLines / linesPerPage) + 1; "  [Q]uit";
    ' Wait for a valid key
    do
        k$ = inkey$
    loop until k$ = chr$(129) or k$ = chr$(130) or k$ = "Q" or k$ = "q"
    select case k$
        case chr$(129) ' right arrow
            if pageStart + linesPerPage < totalLines then pageStart = pageStart + linesPerPage
        case chr$(130) ' left arrow
            if pageStart - linesPerPage >= 0 then pageStart = pageStart - linesPerPage else pageStart = 0
        case "Q", "q"
            end
    end select
loop
