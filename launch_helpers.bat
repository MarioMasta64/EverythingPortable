@echo off
setlocal enabledelayedexpansion
Color 0A
cls
title Helper Launcher Beta
set nag=BE SURE TO TURN CAPS LOCK OFF! (never said it was on just make sure)
set new_version=OFFLINE_OR_NO_UPDATES

REM Check For Helper Updates
if exist .\helpers\version.txt (
	set /p version_needed=<.\helpers\version.txt
	Call :Version
	if !current_version! LSS !version_needed! Call :Update
)

if "%~1" neq "" (title Helper Launcher Beta - %~1 & call :%~1 & exit /b !current_version!)

:Version
cls
echo 6 > .\doc\version.txt
set /p current_version=<.\doc\version.txt
if exist .\doc\version.txt del .\doc\version.txt
exit /b

:ReplaceText
set /p file=<.\helpers\file.txt
set /p oldtext=<.\helpers\oldtext.txt
set /p newtext=<.\helpers\newtext.txt
if not exist .\helpers\replacetext.vbs call :CreateReplaceTextVBS
cscript .\helpers\replacetext.vbs !file! !oldtext! !newtext! > nul
del .\helpers\*.txt > nul
exit /b

:Extract7zip
set /p file=<.\helpers\file.txt
set /p folder=<.\helpers\folder.txt
set "arch="
if exist "%PROGRAMFILES(X86)%" set "arch=64"
if not exist .\bin\7-ZipPortable\App\7-Zip!arch!\7z.exe call :Download7Zip
.\bin\7-ZipPortable\App\7-Zip!arch!\7z.exe x !file! * -o!folder!
echo .\bin\7-ZipPortable\App\7-Zip!arch!\7z.exe x !file! * -o!folder!
del .\helpers\*.txt > nul
exit /b

:Download7Zip
if not exist .\bin\wget.exe call :DownloadWget
.\bin\wget.exe -q --show-progress "http://downloads.sourceforge.net/portableapps/7-ZipPortable_16.04.paf.exe"
if not exist 7-ZipPortable_16.04.paf.exe goto :Download7zip
move 7-ZipPortable_16.04.paf.exe .\extra\7-ZipPortable_16.04.paf.exe
cls
echo README README README README
echo PLEASE PROCEED THROUGH ALL DIALOGUE OPTIONS
echo DO NOT HIT RUN
echo PRESS ENTER WHEN READ
pause>nul
.\extra\7-ZipPortable_16.04.paf.exe /destination="%CD%\bin\"
(goto) 2>nul

:Extract
set /p file=<.\helpers\file.txt
set /p folder=<.\helpers\folder.txt
if not exist .\helpers\extractzip.vbs call :CreateExtractZipVBS
cscript .\helpers\extractzip.vbs !file! !folder! > nul
del .\helpers\*.txt > nul
exit /b

:CreateReplaceTextVBS
echo Const ForReading = 1 > .\helpers\replacetext.vbs
echo Const ForWriting = 2 >> .\helpers\replacetext.vbs
echo. >> .\helpers\replacetext.vbs
echo strFileName = Wscript.Arguments(0) >> .\helpers\replacetext.vbs
echo strOldText = Wscript.Arguments(1) >> .\helpers\replacetext.vbs
echo strNewText = Wscript.Arguments(2) >> .\helpers\replacetext.vbs
echo. >> .\helpers\replacetext.vbs
echo Set objFSO = CreateObject("Scripting.FileSystemObject") >> .\helpers\replacetext.vbs
echo Set objFile = objFSO.OpenTextFile(strFileName, ForReading) >> .\helpers\replacetext.vbs
echo strText = objFile.ReadAll >> .\helpers\replacetext.vbs
echo objFile.Close >> .\helpers\replacetext.vbs
echo. >> .\helpers\replacetext.vbs
echo strNewText = Replace(strText, strOldText, strNewText) >> .\helpers\replacetext.vbs
echo Set objFile = objFSO.OpenTextFile(strFileName, ForWriting) >> .\helpers\replacetext.vbs
echo objFile.Write strNewText  'WriteLine adds extra CR/LF >> .\helpers\replacetext.vbs
echo objFile.Close >> .\helpers\replacetext.vbs
exit /b

:CreateExtractZipVBS
echo Dim Arg, zipfile, folder > .\helpers\extractzip.vbs
echo Set Arg = WScript.Arguments >> .\helpers\extractzip.vbs
echo. >> .\helpers\extractzip.vbs
echo zipfile = Arg(0) >> .\helpers\extractzip.vbs
echo folder = Arg(1) >> .\helpers\extractzip.vbs
:: 'The location of the zip file.
:: ZipFile="C:\Test.Zip"
:: 'The folder the contents should be extracted to.
:: ExtractTo="C:\Test\"
echo. >> .\helpers\extractzip.vbs
echo 'If the extraction location does not exist create it. >> .\helpers\extractzip.vbs
echo Set fso = CreateObject("Scripting.FileSystemObject") >> .\helpers\extractzip.vbs
echo If NOT fso.FolderExists(folder) Then >> .\helpers\extractzip.vbs
echo    fso.CreateFolder(folder) >> .\helpers\extractzip.vbs
echo End If >> .\helpers\extractzip.vbs
echo. >> .\helpers\extractzip.vbs
echo 'Extract the contants of the zip file. >> .\helpers\extractzip.vbs
echo set objShell = CreateObject("Shell.Application") >> .\helpers\extractzip.vbs
echo set FilesInZip=objShell.NameSpace(zipfile).items >> .\helpers\extractzip.vbs
echo objShell.NameSpace(folder).CopyHere(FilesInZip) >> .\helpers\extractzip.vbs
echo Set fso = Nothing >> .\helpers\extractzip.vbs
echo Set objShell = Nothing >> .\helpers\extractzip.vbs
exit /b

:Hide
set /p file=<.\helpers\file.txt
if not exist .\helpers\hide.vbs call :CreateHideVBS
wscript .\helpers\hide.vbs !file!
del .\helpers\*.txt > nul
exit /b

:CreateHideVBS
echo CreateObject("Wscript.Shell").Run """" ^& WScript.Arguments(0) ^& """", 0, False > .\helpers\hide.vbs
exit /b

:Download
set /p download=<.\helpers\download.txt
set /p file=<.\helpers\file.txt

REM Download Using VBS
REM if not exist .\helpers\download.vbs call :CreateDownloadVBS
REM cscript .\helpers\download.vbs "%download%" "%file%"

if not exist .\bin\wget.exe call :DownloadWget
.\bin\wget.exe -q --show-progress %download% %file%

del .\helpers\*.txt > nul
exit /b

:DownloadWget
if not exist .\helpers\download.vbs call :CreateDownloadVBS
cscript .\helpers\download.vbs https://eternallybored.org/misc/wget/current/wget.exe .\bin\wget.exe > nul
exit /b

:CreateDownloadVBS
echo Dim Arg, download, file > .\helpers\download.vbs
echo Set Arg = WScript.Arguments >> .\helpers\download.vbs
echo. >> .\helpers\download.vbs
echo download = Arg(0) >> .\helpers\download.vbs
echo file = Arg(1) >> .\helpers\download.vbs
echo. >> .\helpers\download.vbs
echo dim xHttp: Set xHttp = CreateObject("Msxml2.XMLHttp.6.0")>> .\helpers\download.vbs
echo dim bStrm: Set bStrm = createobject("Adodb.Stream") >> .\helpers\download.vbs
echo xHttp.Open "GET", download, False >> .\helpers\download.vbs
echo xHttp.Send >> .\helpers\download.vbs
echo. >> .\helpers\download.vbs
echo with bStrm >> .\helpers\download.vbs
echo     .type = 1 '//binary >> .\helpers\download.vbs
echo     .open >> .\helpers\download.vbs
echo     .write xHttp.responseBody >> .\helpers\download.vbs
echo     .savetofile file, 2 '//overwrite >> .\helpers\download.vbs
echo end with >> .\helpers\download.vbs
exit /b

:Update
if not exist .\helpers\download.vbs call :CreateDownloadVBS
cscript .\helpers\download.vbs https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/launch_helpers.bat launch_helpers.bat > nul
exit /b