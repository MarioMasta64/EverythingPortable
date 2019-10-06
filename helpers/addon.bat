@ECHO OFF
CLS
COLOR 0A
TITLE "ADDON TEST"

SET "ADDON=%~1"
SET "VERSION=1"

IF "%~3" NEQ "" ( CALL :%~3 & EXIT /B )

:ENVIROMENTCHECK
CALL :%ADDON%
EXIT /B

:7ZIP
IF EXIST .\bin\7-ZipPortable\7-ZipPortable.exe EXIT /B
IF NOT EXIST .\extra\7-ZipPortable_19.00.paf.exe CALL .\helpers\download "https://portableapps.com/redirect/?a=7-ZipPortable&s=s&d=pa&f=7-ZipPortable_19.00.paf.exe" "%CD%\extra\7-ZipPortable_19.00.paf.exe"
IF EXIST .\extra\7-ZipPortable_19.00.paf.exe .\extra\7-ZipPortable_19.00.paf.exe /destination="%CD%\bin\"
EXIT /B

:INNOUNP
IF EXIST .\bin\innounp\innounp.exe EXIT /B
REM USE POWERSHELL FOR REDIRECT PAGES
IF NOT EXIST .\extra\innounp.rar CALL .\helpers\download "https://sourceforge.net/projects/innounp/files/latest/download?source=typ_redirect" "%CD%\extra\innounp.rar" "PS"
IF EXIST .\extra\innounp.rar .\bin\7-ZipPortable\App\7-Zip\7z.exe x .\extra\innounp.rar * -o.\bin\innounp\
EXIT /B

:VERSION
EXIT /B %VERSION%