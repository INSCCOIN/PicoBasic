@echo off
REM INSCCOIN 2025
REM Usage: converter.bat input.txt output.txt [-h] [-ct] [-rt] [-w N]

if "%~2"=="" (
    echo Usage: %0 input.txt output.txt [-h] [-ct] [-rt] [-w N]
    exit /b 1
)

setlocal enabledelayedexpansion
set "infile=%~1"
set "outfile=%~2"
set "hyphenate=0"
set "ctabs=0"
set "rtabs=0"
set "wrapwidth=36"

set i=3
:parseopts
set opt=!%i%!
if "!opt!"=="" goto endopts
if /i "!opt!"=="-h" set "hyphenate=1"
if /i "!opt!"=="-ct" set "ctabs=1"
if /i "!opt!"=="-rt" set "rtabs=1"
if /i "!opt!"=="-w" (
    set /a i=i+1
    set wrapwidth=!%i%!
)
set /a i=i+1
goto parseopts
:endopts

if exist "%outfile%" del "%outfile%"

for /f "usebackq delims=" %%L in ("%infile%") do call :wrapline "%%L"

REM github signature at eof
>>"%outfile%" echo INSCCOIN Converter 2.3

goto :eof

:wrapline
set "line=%~1"
REM ct & rt
if !ctabs! == 1 set "line=!line:  =    !"
if !rtabs! == 1 set "line=!line:  =!"
:wraploop
if "!line!"=="" exit /b
set "chunk=!line:~0,%wrapwidth%!"
REM break at wrapwidth or space before
set "breakpos="
for /l %%i in (!wrapwidth!,-1,1) do (
    if not defined breakpos if "!chunk:~%%i,1!"==" " set "breakpos=%%i"
)
if defined breakpos (
    set "out=!chunk:~0,%breakpos%!"
    set "line=!line:~%breakpos%!"
    set "line=!line:~1!"  REM Remove leading space
) else (
    set "out=!chunk!"
    set "line=!line:~%wrapwidth%!"
    REM hyphenate (would you believe me if i told you i had to look up how to spell it?)
    if !hyphenate! == 1 if not "!line!"=="" set "out=!out:~0,!wrapwidth!-1!-"
)
>>"%outfile%" echo(!out!
goto wraploop
