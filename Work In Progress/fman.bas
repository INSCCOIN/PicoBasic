

OPTION EXPLICIT

CONST FILES_PER_PAGE = 12
DIM SHARED file$(50), attr%(50), totalFiles%, selected%

DIM drive$ = "A:"
DIM cwd$ = "/"

CLS RGB(BLACK)

SUB ShowHeader()
    CLS RGB(BLACK)
    TEXT 0, 0, "PicoFileManager", "L", , RGB(WHITE)
    TEXT 0, 20, "Drive: " + drive$ + "   Dir: " + cwd$, "L", , RGB(YELLOW)
    TEXT 0, 40, "F1: Switch Drive   Enter: Run BAS   B: Up Dir   Q: Quit", "L", , RGB(GRAY)

    TEXT 0, MM.VRES - 40, "Free: " + STR$(MM.INFO("free space") \ 1024) + " KB", "L", , RGB(GREEN)
    TEXT 0, MM.VRES - 20, "Total: " + STR$(MM.INFO("disk size") \ 1024) + " KB", "L", , RGB(GREEN)
END SUB

SUB ListDir()
    totalFiles% = 0
    ERASE file$(), attr%()
    CHDIR drive$ + cwd$
    TEXT 0, 60, "Reading directory...", "L", , RGB(CYAN)

    LOCAL fname$ = DIR$("*", 0)
    WHILE fname$ <> ""
        totalFiles% = totalFiles% + 1
        file$(totalFiles%) = fname$
        attr%(totalFiles%) = MM.INFO("EXISTS DIR " + CHR$(34) + fname$ + CHR$(34))
        fname$ = DIR$("", 0)
    WEND

    IF totalFiles% = 0 THEN
        TEXT 0, 80, "-- No files found --", "L", , RGB(RED)
    ENDIF
END SUB

SUB ShowFileList()
    LOCAL i%, base%, maxDisplay%
    base% = INT((selected% - 1) / FILES_PER_PAGE) * FILES_PER_PAGE + 1
    maxDisplay% = base% + FILES_PER_PAGE - 1
    IF maxDisplay% > totalFiles% THEN maxDisplay% = totalFiles%

    CLS RGB(BLACK)
    ShowHeader()

    FOR i% = base% TO maxDisplay%
        LOCAL fg = RGB(WHITE)
        IF attr%(i%) THEN fg = RGB(CYAN)
        IF UCASE$(RIGHT$(file$(i%), 4)) = ".BAS" THEN fg = RGB(YELLOW)

        IF i% = selected% THEN
            BOX 0, 70 + (i% - base%) * 12, MM.HRES, 12, , RGB(GRAY), -1
            fg = RGB(BLACK)
        ENDIF

        TEXT 4, 70 + (i% - base%) * 12, file$(i%), "L", , fg
    NEXT
END SUB

' -------- MAIN LOOP --------

drive$ = "A:"
cwd$ = "/"
selected% = 1

ShowHeader()
ListDir()
ShowFileList()

DO
    k$ = INKEY$
    IF k$ = "" THEN CONTINUE DO

    SELECT CASE UCASE$(k$)
        CASE "Q"
            CLS : END

        CASE "B"
            IF cwd$ <> "/" THEN
                cwd$ = LEFT$(cwd$, INSTR(-1, cwd$, "/") - 1)
                IF cwd$ = "" THEN cwd$ = "/"
                selected% = 1
                ListDir()
                ShowFileList()
            ENDIF

        CASE CHR$(13) ' Enter key
            IF attr%(selected%) THEN
                ' Change into directory
                IF RIGHT$(cwd$, 1) <> "/" THEN cwd$ = cwd$ + "/"
                cwd$ = cwd$ + file$(selected%)
                selected% = 1
                ListDir()
                ShowFileList()
            ELSEIF UCASE$(RIGHT$(file$(selected%), 4)) = ".BAS" THEN
                CLS
                RUN drive$ + cwd$ + "/" + file$(selected%)
            ENDIF

        CASE CHR$(9) ' Tab (switch drive)
            IF drive$ = "A:" THEN drive$ = "B:" ELSE drive$ = "A:"
            cwd$ = "/"
            selected% = 1
            ListDir()
            ShowFileList()

        CASE ELSE ' Up/down arrows (in extended keyboards)
            IF ASC(k$) = 27 THEN ' ANSI ESC sequence for arrows
                k2$ = INKEY$
                IF k2$ = "[" THEN
                    k3$ = INKEY$
                    SELECT CASE k3$
                        CASE "A" ' Up
                            selected% = selected% - 1
                            IF selected% < 1 THEN selected% = totalFiles%
                            ShowFileList()
                        CASE "B" ' Down
                            selected% = selected% + 1
                            IF selected% > totalFiles% THEN selected% = 1
                            ShowFileList()
                    END SELECT
                ENDIF
            ENDIF
    END SELECT
LOOP