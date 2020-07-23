@echo off
setlocal enabledelayedexpansion
Color 0A
cls
title Helper Launcher Beta
set nag=BE SURE TO TURN CAPS LOCK OFF! (never said it was on just make sure)
set new_version=OFFLINE_OR_NO_UPDATES
if exist replacer.bat del replacer.bat

REM Check For Helper Updates
if exist .\helpers\version.txt (
	set /p version_needed=<.\helpers\version.txt
	Call :Version
	if !current_version! LSS !version_needed! Call :Update
)

if "%~1" neq "" (title Helper Launcher Beta - %~1 & call :%~1 & exit /b !current_version!)

:Version
cls
echo 1 > .\doc\version.txt
set /p current_version=<.\doc\version.txt
if exist .\doc\version.txt del .\doc\version.txt
exit /b

:Extract
set /p file=<.\helpers\file.txt
set /p folder=<.\helpers\folder.txt
if not exist .\helpers\extractzip.vbs call :CreateExtractZipVBS
cscript .\helpers\extractzip.vbs !file! !folder! > nul
del .\helpers\*.txt > nul
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

:Download
set /p download=<.\helpers\download.txt
set /p file=<.\helpers\file.txt

REM Download Using VBS
if not exist .\helpers\download.vbs call :CreateDownloadVBS
cscript .\helpers\download.vbs "%download%" "%file%"

REM if not exist .\bin\wget.exe call :DownloadWget
REM .\bin\wget.exe -q --show-progress %download% %file%

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
echo dim xHttp: Set xHttp = createobject("Microsoft.XMLHTTP") >> .\helpers\download.vbs
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