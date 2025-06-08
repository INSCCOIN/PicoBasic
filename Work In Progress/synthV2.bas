' Simple Synthesizer in MMBasic

CLS
Print "Synthesizer 1.2"
Print "INSCCOIN 2025"
Print "V6.00.02 RC26"
Print
Print "Enter frequency (Hz) and duration (ms)."
Print "Enter 0 for frequency to quit."
Print

Do
  Input "Frequency (Hz): ", freq
  If freq = 0 Then Exit Do
  Input "Duration (ms): ", dur
  PLAY SOUND 1, 100, Str$(freq), Str$(dur)
Loop

Print "Goodbye!"