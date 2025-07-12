' PicoPub 1.3
' Future framework for PicoPDF 
' INSCCOIN 2025

OPTION EXPLICIT


' config
DIM STRING FILENAME$
CONST STATEFILE$ = "STATE.DAT"

' screen size
DIM INTEGER HRES, VRES, CHAR_W, CHAR_H, MAX_LINES, MAX_COLS
HRES = MM.HRES
VRES = MM.VRES
CHAR_W = 8
CHAR_H = 8
MAX_COLS = HRES / CHAR_W
MAX_LINES = VRES / CHAR_H

' vars
DIM INTEGER pageStart, totalLines, curLine, i, highlightLine
DIM STRING line$
DIM STRING lines$(1000) ' max lines of a .txt HEAP CANT SUPPORT HIGHER THAN 1000 LINES / 64KB
CONST HIGHLIGHTFILE$ = "HIGHLIGHT.TXT"
CONST BOOKMARKFILE$ = "BOOKMARKS.TXT"

FUNCTION FileExists(fname$)
    LOCAL exists
    exists = 0
    ON ERROR SKIP 1
    OPEN fname$ FOR INPUT AS #99
    IF NOT MM.ERRNO THEN exists = 1 : CLOSE #99
    ON ERROR SKIP
    FileExists = exists
END FUNCTION

SUB SaveBookmark
    OPEN BOOKMARKFILE$ FOR APPEND AS #4
    PRINT #4, "Page:"; (pageStart / (MAX_LINES-1)) + 1; " Line:"; pageStart + highlightLine + 1
    CLOSE #4
END SUB

SUB ShowBookmarks
    LOCAL b$, n$
    CLS
    PRINT "Bookmarks:" : PRINT ""
    IF NOT FileExists(BOOKMARKFILE$) THEN
        PRINT "No bookmarks set. Press any key to return."
        DO: LOOP UNTIL INKEY$ <> "" : EXIT SUB
    END IF
    OPEN BOOKMARKFILE$ FOR INPUT AS #4
    DO WHILE NOT EOF(#4)
        LINE INPUT #4, b$
        PRINT b$
    LOOP
    CLOSE #4
    PRINT "Enter line number to jump, or just press Enter to return: ";
    INPUT n$
    IF VAL(n$) > 0 AND VAL(n$) <= totalLines THEN
        pageStart = VAL(n$) - 1
        highlightLine = 0
    END IF
END SUB

' functions

SUB FileSelectMenu
    LOCAL i, c$, fileCount
    DIM STRING files$(100)
    fileCount = 0
    CLS
    PRINT "Select a .TXT file:"
    OPEN "DIR.TXT" FOR INPUT AS #10
    DO WHILE NOT EOF(#10)
        LINE INPUT #10, c$
        IF UCASE$(RIGHT$(c$, 4)) = ".TXT" THEN
            files$(fileCount) = c$
            PRINT fileCount + 1; ": "; c$
            fileCount = fileCount + 1
            IF fileCount >= 100 THEN EXIT DO
        END IF
    LOOP
    CLOSE #10
    IF fileCount = 0 THEN
        PRINT "No .TXT files found. Press any key to exit."
        DO: LOOP UNTIL INKEY$ <> ""
        END
    END IF
    PRINT "Enter file number: ";
    DO
        INPUT c$
        i = VAL(c$)
    LOOP UNTIL i >= 1 AND i <= fileCount
    FILENAME$ = files$(i - 1)
END SUB

SUB LoadFile
    LOCAL i
    totalLines = 0
    OPEN FILENAME$ FOR INPUT AS #1
    DO WHILE NOT EOF(#1)
        IF totalLines > 999 THEN
            PRINT "File too large (over 1000 lines). Only first 1000 lines loaded."
            EXIT DO
        END IF
        LINE INPUT #1, line$
        lines$(totalLines) = line$
        totalLines = totalLines + 1
    LOOP
    CLOSE #1
END SUB

SUB SaveState
    OPEN STATEFILE$ FOR OUTPUT AS #2
    PRINT #2, pageStart
    CLOSE #2
END SUB

SUB LoadState
    IF FileExists(STATEFILE$) THEN
        OPEN STATEFILE$ FOR INPUT AS #2
        INPUT #2, pageStart
        CLOSE #2
    ELSE
        pageStart = 0
    END IF
END SUB

SUB ShowPage
    CLS
    LOCAL shownLines, wrapLine$, wrapPos, wrapLen, wrapStart, wrapEnd, isHighlight
    LOCAL highlightCount, l$
    shownLines = 0
    i = 0
    highlightCount = 0
    IF FileExists(HIGHLIGHTFILE$) THEN
        OPEN HIGHLIGHTFILE$ FOR INPUT AS #11
        DO WHILE NOT EOF(#11)
            LINE INPUT #11, l$
            IF INSTR(l$, "File:" + FILENAME$) > 0 THEN highlightCount = highlightCount + 1
        LOOP
        CLOSE #11
    END IF
    DO WHILE shownLines < MAX_LINES - 1 AND (pageStart + i) < totalLines
        line$ = lines$(pageStart + i)
        wrapStart = 1
        DO WHILE wrapStart <= LEN(line$) AND shownLines < MAX_LINES - 1
            wrapLen = MAX_COLS
            IF LEN(line$) - wrapStart + 1 < wrapLen THEN wrapLen = LEN(line$) - wrapStart + 1
            wrapEnd = wrapStart + wrapLen - 1
            IF wrapEnd < LEN(line$) THEN
                wrapPos = wrapEnd
                DO WHILE wrapPos > wrapStart AND MID$(line$, wrapPos, 1) <> " "
                    wrapPos = wrapPos - 1
                LOOP
                IF wrapPos > wrapStart THEN
                    wrapLen = wrapPos - wrapStart + 1
                END IF
            END IF
            wrapLine$ = MID$(line$, wrapStart, wrapLen)
            isHighlight = (i = highlightLine AND wrapStart = 1)
            IF isHighlight THEN
                IF LEN(wrapLine$) > MAX_COLS-2 THEN
                    PRINT "> " + LEFT$(wrapLine$, MAX_COLS-2)
                ELSE
                    PRINT "> " + wrapLine$
                END IF
            ELSE
                PRINT wrapLine$
            END IF
            shownLines = shownLines + 1
            wrapStart = wrapStart + wrapLen
            IF wrapStart <= LEN(line$) AND MID$(line$, wrapStart, 1) = " " THEN wrapStart = wrapStart + 1
        LOOP
        i = i + 1
    LOOP
    LOCATE 1, MAX_LINES
    PRINT "Pg:"; (pageStart / (MAX_LINES-1)) + 1; "/"; (totalLines / (MAX_LINES-1)) + 1; "  L:"; pageStart + 1; "/"; totalLines; "  [N]ext [P]rev [J]ump [Q]uit [H]elp [Up/Down]Highlight [S]ave";
    DIM STRING status$
    status$ = "  File: " + FILENAME$ + "  HL:" + STR$(highlightCount)
    IF LEN(status$) + POS < MAX_COLS THEN
        PRINT status$
    ELSE
        DIM STRING shortFile$
        shortFile$ = FILENAME$
        IF LEN(shortFile$) > 12 THEN shortFile$ = LEFT$(shortFile$, 12) + ".."
        status$ = "  File: " + shortFile$ + "  HL:" + STR$(highlightCount)
        PRINT status$
    END IF
END SUB

SUB SaveHighlight
    LOCAL f$
    f$ = lines$(pageStart + highlightLine)
    OPEN HIGHLIGHTFILE$ FOR APPEND AS #3
    PRINT #3, "File:"; FILENAME$; " Page:"; (pageStart / (MAX_LINES-1)) + 1; " Line:"; pageStart + highlightLine + 1; ": "; f$
    CLOSE #3
END SUB

SUB ClearHighlightsMenu
    LOCAL c$
    CLS
    PRINT "Clear Highlights"
    PRINT "1: Clear highlights for current book ("; FILENAME$; ")"
    PRINT "2: Clear ALL highlights (all books)"
    PRINT "Press any other key to cancel."
    INPUT c$
    IF c$ = "1" THEN
        IF NOT FileExists(HIGHLIGHTFILE$) THEN PRINT "No highlights to clear." : PAUSE 1000 : EXIT SUB
        OPEN HIGHLIGHTFILE$ FOR INPUT AS #5
        OPEN "TEMP.TXT" FOR OUTPUT AS #6
        LOCAL l$
        DO WHILE NOT EOF(#5)
            LINE INPUT #5, l$
            IF INSTR(l$, "File:" + FILENAME$) = 0 THEN PRINT #6, l$
        LOOP
        CLOSE #5: CLOSE #6
        KILL HIGHLIGHTFILE$
        NAME "TEMP.TXT" AS HIGHLIGHTFILE$
        PRINT "Highlights for this book cleared." : PAUSE 1000
    ELSEIF c$ = "2" THEN
        IF NOT FileExists(HIGHLIGHTFILE$) THEN PRINT "No highlights to clear." : PAUSE 1000 : EXIT SUB
        KILL HIGHLIGHTFILE$
        PRINT "All highlights cleared." : PAUSE 1000
    ELSE
        PRINT "Cancelled." : PAUSE 1000
    END IF
END SUB

SUB JumpToLine
    LOCAL l$
    CLS: PRINT "Jump to line (1-"; totalLines; "): ";
    INPUT l$
    IF VAL(l$) >= 1 AND VAL(l$) <= totalLines THEN
        pageStart = VAL(l$) - 1
    END IF
END SUB

SUB NextHighlight
    LOCAL l$, found, idx, lineNum
    found = 0
    idx = pageStart + highlightLine + 1
    IF NOT FileExists(HIGHLIGHTFILE$) THEN PRINT "No highlights." : PAUSE 500 : EXIT SUB
    OPEN HIGHLIGHTFILE$ FOR INPUT AS #7
    DO WHILE NOT EOF(#7)
        LINE INPUT #7, l$
        IF INSTR(l$, "File:" + FILENAME$) > 0 THEN
            lineNum = VAL(MID$(l$, INSTR(l$, "Line:") + 5))
            IF lineNum > idx THEN
                pageStart = lineNum - 1
                highlightLine = 0
                found = 1
                EXIT DO
            END IF
        END IF
    LOOP
    CLOSE #7
    IF found = 0 THEN PRINT "No next highlight." : PAUSE 500
END SUB

SUB NextBookmark
    LOCAL l$, found, lineNum
    found = 0
    idx = pageStart + highlightLine + 1
    IF NOT FileExists(BOOKMARKFILE$) THEN PRINT "No bookmarks." : PAUSE 500 : EXIT SUB
    OPEN BOOKMARKFILE$ FOR INPUT AS #8
    DO WHILE NOT EOF(#8)
        LINE INPUT #8, l$
        lineNum = VAL(MID$(l$, INSTR(l$, "Line:") + 5))
        IF lineNum > idx THEN
            pageStart = lineNum - 1
            highlightLine = 0
            found = 1
            EXIT DO
        END IF
    LOOP
    CLOSE #8
    IF found = 0 THEN PRINT "No next bookmark." : PAUSE 500
END SUB

SUB PrevHighlight
    LOCAL l$, found, idx, lineNum, lastLine
    found = 0
    idx = pageStart + highlightLine - 1
    lastLine = -1
    IF NOT FileExists(HIGHLIGHTFILE$) THEN PRINT "No highlights." : PAUSE 500 : EXIT SUB
    OPEN HIGHLIGHTFILE$ FOR INPUT AS #9
    DO WHILE NOT EOF(#9)
        LINE INPUT #9, l$
        IF INSTR(l$, "File:" + FILENAME$) > 0 THEN
            lineNum = VAL(MID$(l$, INSTR(l$, "Line:") + 5))
            IF lineNum < idx THEN
                lastLine = lineNum
            END IF
        END IF
    LOOP
    CLOSE #9
    IF lastLine <> -1 THEN
        pageStart = lastLine - 1
        highlightLine = 0
        found = 1
    END IF
    IF found = 0 THEN PRINT "No previous highlight." : PAUSE 500
END SUB

SUB PrevBookmark
    LOCAL l$, found, idx, lineNum, lastLine
    found = 0
    idx = pageStart + highlightLine - 1
    lastLine = -1
    IF NOT FileExists(BOOKMARKFILE$) THEN PRINT "No bookmarks." : PAUSE 500 : EXIT SUB
    OPEN BOOKMARKFILE$ FOR INPUT AS #10
    DO WHILE NOT EOF(#10)
        LINE INPUT #10, l$
        lineNum = VAL(MID$(l$, INSTR(l$, "Line:") + 5))
        IF lineNum < idx THEN
            lastLine = lineNum
        END IF
    LOOP
    CLOSE #10
    IF lastLine <> -1 THEN
        pageStart = lastLine - 1
        highlightLine = 0
        found = 1
    END IF
    IF found = 0 THEN PRINT "No previous bookmark." : PAUSE 500
END SUB

SUB ShowHelp
    CLS
    PRINT "PicoPub Help"
    PRINT "Right Arrow: Next page"
    PRINT "Left Arrow: Previous page"
    PRINT "F4: Jump to line"
    PRINT "F5: Move highlight up"
    PRINT "F6: Move highlight down"
    PRINT "F7: Save highlighted line"
    PRINT "F8: Clear highlights (book/all)"
    PRINT "F9: Set bookmark at current line"
    PRINT "F10: Show bookmarks and jump"
    PRINT "F11: Next highlight"
    PRINT "F12: Next bookmark"
    PRINT "F1: Show this help"
    PRINT "Q: Quit and save position"
    PRINT "Press any key to return..."
    DO: LOOP UNTIL INKEY$ <> ""
END SUB

' main
FILENAME$ = "FEATURES.TXT" ' set the file to open here
IF NOT FileExists(FILENAME$) THEN
    PRINT "File '" + FILENAME$ + "' not found. Please check the filename and try again."
    END
END IF
LoadFile
LoadState
highlightLine = 0
DO
    ShowPage
    SELECT CASE INKEY$
        CASE CHR$(129)
            IF pageStart + (MAX_LINES-1) < totalLines THEN
                pageStart = pageStart + (MAX_LINES-1)
                highlightLine = 0
            END IF
        CASE CHR$(130)
            IF pageStart - (MAX_LINES-1) >= 0 THEN
                pageStart = pageStart - (MAX_LINES-1)
                highlightLine = 0
            ELSE
                pageStart = 0
                highlightLine = 0
            END IF
        CASE CHR$(134)
            IF highlightLine > 0 THEN
                highlightLine = highlightLine - 1
            END IF
        CASE CHR$(135)
            IF highlightLine < (MAX_LINES-2) AND (pageStart + highlightLine + 1) < totalLines THEN
                highlightLine = highlightLine + 1
            END IF
        CASE CHR$(133)
            JumpToLine
            highlightLine = 0
        CASE CHR$(128)
            ShowHelp
        CASE CHR$(136)
            SaveHighlight
        CASE CHR$(137)
            ClearHighlightsMenu
        CASE CHR$(138)
            SaveBookmark
        CASE CHR$(139)
            ShowBookmarks
        CASE CHR$(140)
            NextHighlight
        CASE CHR$(141)
            NextBookmark
        CASE "Q"
            SaveState
            END
    END SELECT
LOOP
