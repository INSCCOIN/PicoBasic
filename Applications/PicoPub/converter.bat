@echo off
REM INSCCOIN 2025
REM Usage: converter.bat input.txt output.txt

if "%~2"=="" (
    echo Usage: %0 input.txt output.txt
    exit /b 1
)

setlocal enabledelayedexpansion
set "infile=%~1"
set "outfile=%~2"
if exist "%outfile%" del "%outfile%"

for /f "usebackq delims=" %%L in ("%infile%") do call :wrapline "%%L"

REM github signature at eof
>>"%outfile%" echo INSCCOIN Converter 2.0

goto :eof

:wrapline
set "line=%~1"
:wraploop
if "!line!"=="" exit /b
set "chunk=!line:~0,36!"
REM break at 36 or space before 
for /l %%i in (36,-1,1) do (
    if not defined breakpos if "!chunk:~%%i,1!"==" " set "breakpos=%%i"
)
if defined breakpos (
    set "out=!chunk:~0,%breakpos%!"
    set "line=!line:~%breakpos%!"
    set "line=!line:~1!"  REM Remove leading space
    set "breakpos="
) else (
    set "out=!chunk!"
    set "line=!line:~36!"
)
>>"%outfile%" echo(!out!
goto wraploop
