@ECHO OFF
CLS
COLOR 0A
TITLE "DOWNLOAD TEST"

SET "URL=%~1"
SET "FILE=%~2"
SET "VERSION=1"

IF "%~3" NEQ "" ( CALL :%~3 & EXIT /B )

:ENVIROMENTCHECK
ECHO DOWNLOADING "%URL%" SAVING TO "%FILE%"
FOR %%I IN (powershell.exe) DO ( IF "%%~$path:i"=="" ( CALL :PS & EXIT /B ) )
IF EXIST ".\helpers\download.vbs" ( CALL :VBS & EXIT /B )
IF EXIST ".\bin\wget.exe" ( CALL :WGET & EXIT /B )
EXIT /B

:WGET
REM WINDOWS 95 [IE4]
.\bin\wget.exe -i "%URL%" -O "%FILE%" --show-progress --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101 Firefox/68.0"
EXIT /B

:PS
REM WINDOWS XP [SP3]
REM WINDOWS 2003 [SP2]
REM WINDOWS VISTA [SP1]
REM WINDOWS 2008 [R2]
REM WINDOWS 7 AND UP
powershell.exe -exec bypass -noprofile -command "(New-Object Net.WebClient).DownloadFile('%URL%', '%FILE%')"
EXIT /B

:VBS
REM WINDOWS 2000 SP3 AND UP
cscript .\helpers\download.vbs "%URL%" "%FILE%"
EXIT /B

:BITSADMIN
REM WINDOWS 2000
IF EXIST "%FILE%" DEL "%FILE%" >nul:
bitsadmin /transfer "n" "%URL%" "%FILE%"
EXIT /B

:MSHTA
REM PROBABLY WILL NEVER BE ADDED
EXIT /B

:VERSION
EXIT /B %VERSION%
