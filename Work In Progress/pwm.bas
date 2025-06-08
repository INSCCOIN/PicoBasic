' PWM Audio Tone Generator for PicoCalc
' Author: ChatGPT for OpenAI User
' Date: 2025-05-31

CONST SPEAKER_PIN = GP16
SETPIN SPEAKER_PIN, PWM

DIM note$(7) = ("C","D","E","F","G","A","B")
DIM freq(7)  = (261, 294, 329, 349, 392, 440, 494)

CLS RGB(BLACK)
TEXT MM.HRES/2, 10, "PWM Tone Generator", "CT", , RGB(WHITE)

DO
    TEXT MM.HRES/2, 40, "Press 1–7 to play a note", "CT", , RGB(YELLOW)
    TEXT MM.HRES/2, 70, "1=C  2=D  3=E  4=F  5=G  6=A  7=B", "CT", , RGB(CYAN)
    TEXT MM.HRES/2, 110, "Press Q to quit", "CT", , RGB(RED)

    k$ = INKEY$
    IF k$ <> "" THEN
        IF k$ = "Q" OR k$ = "q" THEN
            PWM SPEAKER_PIN, OFF
            CLS
            END
        ENDIF

        n = VAL(k$)
        IF n >= 1 AND n <= 7 THEN
            PWM SPEAKER_PIN, freq(n), 50    ' 50% duty
            TEXT MM.HRES/2, 150, "Playing: " + note$(n) + " (" + STR$(freq(n)) + " Hz)", "CT", , RGB(GREEN)
            PAUSE 500
            PWM SPEAKER_PIN, OFF
        ENDIF
    ENDIF
LOOP
