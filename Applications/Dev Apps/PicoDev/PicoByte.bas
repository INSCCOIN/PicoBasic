' INSCCOIN 2025

' PicoByte 1.3
OPTION EXPLICIT

CONST BUFSIZE = 4096 ' Max file size (4KB adjust as needed)
DIM buffer(BUFSIZE) AS INTEGER
DIM filesize AS INTEGER
DIM filename$ AS STRING
DIM copybuf(256) AS INTEGER ' Buffer for copy/paste (max 256 bytes)
DIM copylen AS INTEGER
DIM edited(BUFSIZE) AS INTEGER ' Track edited bytes
DIM undoBuf(BUFSIZE, 10) AS INTEGER ' Undo stack (10 levels)
DIM undoSize(10) AS INTEGER
DIM undoTop AS INTEGER
DIM redoBuf(BUFSIZE, 10) AS INTEGER ' Redo stack (10 levels)
DIM redoSize(10) AS INTEGER
DIM redoTop AS INTEGER

SUB MainMenu
    CLS
    PRINT "PicoHex - HEX Viewer, Creator & Editor"
    PRINT "1. Open HEX File"
    PRINT "2. Create New HEX File"
    PRINT "3. Exit"
    PRINT "Select option: ";
    INPUT opt
    SELECT CASE opt
        CASE 1: Call OpenFile
        CASE 2: Call NewFile
        CASE 3: END
        CASE ELSE: PRINT "Invalid option." : PAUSE 1000 : MainMenu
    END SELECT
END SUB

SUB OpenFile
    CLS
    PRINT "Enter filename to open: ";
    INPUT filename$
    filesize = 0
    OPEN filename$ FOR BINARY AS #1
    DO WHILE NOT EOF(1) AND filesize < BUFSIZE
        filesize = filesize + 1
        buffer(filesize) = ASC(INPUT$(1, #1))
    LOOP
    CLOSE #1
    PRINT "Loaded ", filesize, " bytes."
    PAUSE 1000
    Call HexView
END SUB

SUB NewFile
    CLS
    PRINT "Enter new filename: ";
    INPUT filename$
    filesize = 0
    PRINT "New file created."
    PAUSE 1000
    Call HexView
END SUB

SUB HexView
    LOCAL i, j, ch, pageOffset AS INTEGER
    LOCAL line$, asc$, a$, hexbyte$
    pageOffset = 1
    DO
        CLS
        PRINT "File: ", filename$, " Size: ", filesize, " bytes"
        PRINT "Offset   ", "Hexadecimal Bytes", SPACE$(5), "ASCII"
        FOR i = pageOffset TO MIN(filesize, pageOffset+127) STEP 16
            line$ = RIGHT$("0000" + HEX$(i-1), 4) + ":  "
            asc$ = ""
            FOR j = 0 TO 15
                IF i+j <= filesize THEN
                    hexbyte$ = RIGHT$("0" + HEX$(buffer(i+j)), 2)
                    IF edited(i+j) = 1 THEN
                        line$ = line$ + CHR$(27) + "[33m" + hexbyte$ + CHR$(27) + "[0m "
                    ELSE
                        line$ = line$ + hexbyte$ + " "
                    END IF
                    ch = buffer(i+j)
                    IF ch >= 32 AND ch <= 126 THEN
                        asc$ = asc$ + CHR$(ch)
                    ELSE
                        asc$ = asc$ + "."
                    END IF
                ELSE
                    line$ = line$ + "   "
                    asc$ = asc$ + " "
                END IF
            NEXT j
            PRINT line$, SPACE$(2), asc$
        NEXT i
        PRINT
        PRINT "F1=Edit  F2=Save  F3=Quit  F4=Copy  F5=Paste  F6=Insert  F7=Delete"  
        PRINT "F8=NextPg  F9=PrevPg  F10=Jump  F11=Undo  F12=Redo  H=Help"
        PRINT "Page: ", ((pageOffset-1)\128)+1, "/", ((filesize-1)\128)+1
        PRINT "Press function key..."
        a$ = INKEY$
        IF a$ = "F1" THEN Call EditByte
        IF a$ = "F2" THEN Call SaveFile
        IF a$ = "F3" THEN EXIT SUB
        IF a$ = "F4" THEN Call CopyBytes
        IF a$ = "F5" THEN Call PasteBytes
        IF a$ = "F6" THEN Call InsertBytes
        IF a$ = "F7" THEN Call DeleteBytes
        IF a$ = "F8" THEN IF pageOffset+128 <= filesize THEN pageOffset = pageOffset + 128
        IF a$ = "F9" THEN IF pageOffset-128 >= 1 THEN pageOffset = pageOffset - 128 ELSE pageOffset = 1
        IF a$ = "F10" THEN Call JumpToPage(pageOffset, filesize)
        IF a$ = "F11" THEN Call Undo(pageOffset, filesize)
        IF a$ = "F12" THEN Call Redo(pageOffset, filesize)
        IF UCASE$(a$) = "H" THEN Call ShowHelp
        PAUSE 100
    LOOP
END SUB

SUB ShowHelp
    CLS
    PRINT "PicoByte 1.3 - HEX Viewer, Creator & Editor"
    PRINT "by INSCCOIN 2025"
    PRINT
    PRINT "Function Key Assignments:"
    PRINT " F1  = Edit Byte"
    PRINT " F2  = Save File"
    PRINT " F3  = Quit to Menu"
    PRINT " F4  = Copy Bytes"
    PRINT " F5  = Paste Bytes"
    PRINT " F6  = Insert Bytes"
    PRINT " F7  = Delete Bytes"
    PRINT " F8  = Next Page"
    PRINT " F9  = Previous Page"
    PRINT " F10 = Jump to Page/Offset"
    PRINT " F11 = Undo"
    PRINT " F12 = Redo"
    PRINT "  H  = Help/About"
    PRINT
    PRINT "- Use hex offsets for byte locations."
    PRINT "- Edited bytes are shown in yellow."
    PRINT "- Undo/Redo supports up to 10 levels."
    PRINT "- Paging allows navigation of large files."
    PRINT
    PRINT "Press any key to return..."
    DO WHILE INKEY$ = "": LOOP
END SUB

SUB JumpToPage(BYREF pageOffset AS INTEGER, BYVAL filesize AS INTEGER)
    LOCAL mode$, val$
    PRINT "Jump to (P=Page, O=Offset): ";
    INPUT mode$
    mode$ = UCASE$(LEFT$(mode$,1))
    IF mode$ = "P" THEN
        PRINT "Enter page number: ";
        INPUT val$
        pageOffset = (VAL(val$)-1)*128+1
        IF pageOffset < 1 THEN pageOffset = 1
        IF pageOffset > filesize THEN pageOffset = ((filesize-1)\128)*128+1
    ELSEIF mode$ = "O" THEN
        PRINT "Enter offset (hex): ";
        INPUT val$
        pageOffset = VAL("&H"+val$)+1
        IF pageOffset < 1 THEN pageOffset = 1
        IF pageOffset > filesize THEN pageOffset = ((filesize-1)\128)*128+1
    END IF
END SUB

SUB PushUndo
    LOCAL i
    IF undoTop < 10 THEN undoTop = undoTop + 1 ELSE
        FOR i = 1 TO 9
            FOR j = 1 TO BUFSIZE
                undoBuf(j,i) = undoBuf(j,i+1)
            NEXT j
            undoSize(i) = undoSize(i+1)
        NEXT i
        undoTop = 10
    END IF
    FOR i = 1 TO filesize
        undoBuf(i,undoTop) = buffer(i)
    NEXT i
    undoSize(undoTop) = filesize
    redoTop = 0 ' Clear redo stack
END SUB

SUB Undo(BYREF pageOffset AS INTEGER, BYREF filesize AS INTEGER)
    LOCAL i
    IF undoTop = 0 THEN PRINT "Nothing to undo." : PAUSE 1000 : RETURN
    IF redoTop < 10 THEN redoTop = redoTop + 1
    FOR i = 1 TO filesize
        redoBuf(i,redoTop) = buffer(i)
    NEXT i
    redoSize(redoTop) = filesize
    FOR i = 1 TO undoSize(undoTop)
        buffer(i) = undoBuf(i,undoTop)
    NEXT i
    filesize = undoSize(undoTop)
    undoTop = undoTop - 1
    PRINT "Undo complete." : PAUSE 1000
END SUB

SUB Redo(BYREF pageOffset AS INTEGER, BYREF filesize AS INTEGER)
    LOCAL i
    IF redoTop = 0 THEN PRINT "Nothing to redo." : PAUSE 1000 : RETURN
    IF undoTop < 10 THEN undoTop = undoTop + 1
    FOR i = 1 TO filesize
        undoBuf(i,undoTop) = buffer(i)
    NEXT i
    undoSize(undoTop) = filesize
    FOR i = 1 TO redoSize(redoTop)
        buffer(i) = redoBuf(i,redoTop)
    NEXT i
    filesize = redoSize(redoTop)
    redoTop = redoTop - 1
    PRINT "Redo complete." : PAUSE 1000
END SUB

SUB EditByte
    LOCAL offset, value AS INTEGER
    Call PushUndo
    PRINT "Enter offset (hex): ";
    INPUT off$
    offset = VAL("&H" + off$) + 1
    IF offset < 1 OR offset > filesize THEN PRINT "Invalid offset." : PAUSE 1000 : RETURN
    PRINT "Current value: ", RIGHT$("0" + HEX$(buffer(offset)), 2)
    PRINT "Enter new value (hex): ";
    INPUT val$
    value = VAL("&H" + val$)
    IF value < 0 OR value > 255 THEN PRINT "Invalid value." : PAUSE 1000 : RETURN
    buffer(offset) = value
    edited(offset) = 1
    PRINT "Byte updated."
    PAUSE 1000
END SUB

SUB SaveFile
    OPEN filename$ FOR BINARY OUTPUT AS #1
    FOR i = 1 TO filesize
        PRINT #1, CHR$(buffer(i));
    NEXT i
    CLOSE #1
    ' Clear highlights
    FOR i = 1 TO BUFSIZE
        edited(i) = 0
    NEXT i
    PRINT "File saved."
    PAUSE 1000
END SUB

SUB CopyBytes
    LOCAL off$, len$, i, offset, length AS INTEGER
    PRINT "Copy start offset (hex): ";
    INPUT off$
    offset = VAL("&H" + off$) + 1
    IF offset < 1 OR offset > filesize THEN PRINT "Invalid offset." : PAUSE 1000 : RETURN
    PRINT "Number of bytes to copy (dec, max 256): ";
    INPUT len$
    length = VAL(len$)
    IF length < 1 OR offset+length-1 > filesize OR length > 256 THEN PRINT "Invalid length." : PAUSE 1000 : RETURN
    FOR i = 1 TO length
        copybuf(i) = buffer(offset + i - 1)
    NEXT i
    copylen = length
    PRINT "Copied ", copylen, " bytes."
    PAUSE 1000
END SUB

SUB PasteBytes
    LOCAL off$, offset, i AS INTEGER
    IF copylen = 0 THEN PRINT "Nothing to paste." : PAUSE 1000 : RETURN
    Call PushUndo
    PRINT "Paste at offset (hex): ";
    INPUT off$
    offset = VAL("&H" + off$) + 1
    IF offset < 1 OR offset > filesize+1 OR filesize+copylen > BUFSIZE THEN PRINT "Invalid offset or not enough space." : PAUSE 1000 : RETURN
    ' Shift bytes to make room
    FOR i = filesize TO offset STEP -1
        buffer(i+copylen) = buffer(i)
    NEXT i
    ' Paste
    FOR i = 1 TO copylen
        buffer(offset + i - 1) = copybuf(i)
    NEXT i
    filesize = filesize + copylen
    PRINT "Pasted ", copylen, " bytes."
    PAUSE 1000
END SUB

SUB InsertBytes
    LOCAL off$, val$, offset, value, count, i AS INTEGER
    Call PushUndo
    PRINT "Insert at offset (hex): ";
    INPUT off$
    offset = VAL("&H" + off$) + 1
    IF offset < 1 OR offset > filesize+1 OR filesize = BUFSIZE THEN PRINT "Invalid offset or file full." : PAUSE 1000 : RETURN
    PRINT "Number of bytes to insert (dec): ";
    INPUT val$
    count = VAL(val$)
    IF count < 1 OR filesize+count > BUFSIZE THEN PRINT "Invalid count or not enough space." : PAUSE 1000 : RETURN
    PRINT "Value to fill (hex): ";
    INPUT val$
    value = VAL("&H" + val$)
    IF value < 0 OR value > 255 THEN PRINT "Invalid value." : PAUSE 1000 : RETURN
    ' Shift bytes
    FOR i = filesize TO offset STEP -1
        buffer(i+count) = buffer(i)
    NEXT i
    ' Fill
    FOR i = 0 TO count-1
        buffer(offset+i) = value
    NEXT i
    filesize = filesize + count
    PRINT "Inserted ", count, " bytes."
    PAUSE 1000
END SUB

SUB DeleteBytes
    LOCAL off$, val$, offset, count, i AS INTEGER
    Call PushUndo
    PRINT "Delete start offset (hex): ";
    INPUT off$
    offset = VAL("&H" + off$) + 1
    IF offset < 1 OR offset > filesize THEN PRINT "Invalid offset." : PAUSE 1000 : RETURN
    PRINT "Number of bytes to delete (dec): ";
    INPUT val$
    count = VAL(val$)
    IF count < 1 OR offset+count-1 > filesize THEN PRINT "Invalid count." : PAUSE 1000 : RETURN
    ' Shift bytes
    FOR i = offset+count TO filesize
        buffer(i-count) = buffer(i)
    NEXT i
    filesize = filesize - count
    PRINT "Deleted ", count, " bytes."
    PAUSE 1000
END SUB

' Start program
MainMenu
