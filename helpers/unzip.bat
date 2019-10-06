@ECHO OFF
CLS
COLOR 0A
TITLE "UNZIP TEST"

SET "ZIP=%~1"
SET "DIR=%~2"
SET "VERSION=1"

IF "%~3" NEQ "" ( CALL :%~3 & EXIT /B )

:ENVIROMENTCHECK
ECHO UNZIPPING "%ZIP%" TO "%DIR%"
IF EXIST ".\bin\wget.exe" (
  CALL :7Z
  EXIT /B
)
IF EXIST ".\helpers\unzip.vbs" (
  CALL :VBS
  EXIT /B
)
FOR %%I IN (powershell.exe) DO (
  IF "%%~$path:i"=="" (
    CALL :PS
    EXIT /B
  )
)
EXIT /B

:7Z
REM WINDOWS 2000 AND UP
EXIT /B

:PS
REM WINDOWS XP [SP3]
REM WINDOWS 2003 [SP2]
REM WINDOWS VISTA [SP1]
REM WINDOWS 2008 [R2]
REM WINDOWS 7 AND UP
IF NOT EXIST "%DIR%" MKDIR "%DIR%"
powershell.exe -exec bypass -noprofile -command "(New-Object -Com Shell.Application).NameSpace('%DIR%').CopyHere((New-Object -Com Shell.Application).NameSpace('%ZIP%').Items())"
EXIT /B

:VBS
REM WINDOWS 2000 AND UP
cscript .\helpers\unzip.vbs "%ZIP%" "%DIR%"
EXIT /B

:VERSION
EXIT /B %VERSION%