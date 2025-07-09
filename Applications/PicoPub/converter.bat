@echo off
REM INSCCOIN 2025


if "%~2"=="" (
    echo Usage: %0 input.txt output.txt
    exit /b 1
)

setlocal enabledelayedexpansion
set "infile=%~1"
set "outfile=%~2"
if exist "%outfile%" del "%outfile%"

for /f "usebackq delims=" %%L in ("%infile%") do call :wrapline "%%L"

REM Add signature line at the end
>>"%outfile%" echo INSCCOIN Converter 1.0

goto :eof

:wrapline
set "line=%~1"
:wraploop
set "chunk=!line:~0,36!"
>>"%outfile%" echo(!chunk!
set "line=!line:~36!"
if not "!line!"=="" goto wraploop
exit /b

echo Done. Output: %outfile%
