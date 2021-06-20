@echo off
setlocal enabledelayedexpansion
Color 0A
title Helper Launcher Beta
set nag=Finally Getting Updates After 4 Years (Helper Update)
set new_version=OFFLINE_OR_NO_UPDATES

set "name=%~n0"
set "name=!name:launch_=!"
set "license=.\doc\!name!_license.txt"
set "main_launcher=%~n0.bat"
set "poc_launcher=%~n0_poc.bat"
set "quick_launcher=quick%~n0.bat"
set "folder=%CD%"
if "%CD%"=="%~d0\" set "folder=%CD:~0,2%"
setlocal enabledelayedexpansion

REM Check For Helper Updates
if exist .\helpers\version.txt (
	set /p version_needed=<.\helpers\version.txt
	Call :Version
	if !current_version! LSS !version_needed! Call :Update
)

if "%~1" neq "" (title Helper Launcher Beta - %~1 & call :%~1 & exit /b !current_version!)

:Version
echo 13 > .\doc\version.txt
set /p current_version=<.\doc\version.txt
if exist .\doc\version.txt del .\doc\version.txt >nul
exit /b

:ReplaceText
set /p filetxt=<.\helpers\file.txt
set /p oldtext=<.\helpers\oldtext.txt
set /p newtext=<.\helpers\newtext.txt
echo %file%
echo %oldtext%
echo %newtext%
if not exist .\helpers\replacetext.vbs call :CreateReplaceTextVBS
cscript .\helpers\replacetext.vbs !filetxt! !oldtext! !newtext! >nul
if exist .\helpers\*.txt del .\helpers\*.txt >nul
exit /b

:ExtractDirectX
if not exist .\bin\directx\DXSETUP.exe call :DownloadDirectX
if not exist .\dll\32\ mkdir .\dll\32\
if not exist .\dll\64\ mkdir .\dll\64\
FOR %%X in (.\bin\directx\*x86.cab) DO ( expand -R %%X .\dll\32\ -F:* )
FOR %%X in (.\bin\directx\*x64.cab) DO ( expand -R %%X .\dll\64\ -F:* )
exit /b

:DownloadDirectX
if not exist .\bin\wget.exe call :DownloadWget
if exist directx_Jun2010_redist.exe del directx_Jun2010_redist.exe >nul
.\bin\wget.exe -q --show-progress "https://download.microsoft.com/download/8/4/A/84A35BF1-DAFE-4AE8-82AF-AD2AE20B6B14/directx_Jun2010_redist.exe" ".directx_Jun2010_redist.exe"
if not exist .\bin\7-ZipPortable\App\7-Zip\7z.exe call :Download7Zip
move directx_Jun2010_redist.exe .\extra\directx_Jun2010_redist.exe
.\bin\7-ZipPortable\App\7-Zip\7z.exe x .\extra\directx_Jun2010_redist.exe * -obin\directx\ -aoa
exit /b

:ExtractWix
set /p filetxt=<.\helpers\file.txt
set /p foldertxt=<.\helpers\folder.txt
REM WIX WANTS AN ESCAPE CHARACTER IG
set foldertxt=!foldertxt:\^"=\\^"!

REM wix should always be updated
REM wix should always be updated
REM wix should always be updated
REM wix should always be updated
REM wix should always be updated
if exist .\bin\wix\ rmdir /s /q .\bin\wix\
REM wix should always be updated
REM wix should always be updated
REM wix should always be updated
REM wix should always be updated
REM wix should always be updated

if not exist .\bin\wix\dark.exe call :DownloadWix
.\bin\wix\dark.exe -x !foldertxt! !filetxt!
if exist .\helpers\*.txt del .\helpers\*.txt >nul
exit /b

:DownloadWix
if not exist .\bin\wget.exe call :DownloadWget
.\bin\wget.exe -q --show-progress "https://github.com/wixtoolset/wix3/releases/latest" "latest"
if not exist "latest" goto :DownloadWix
echo.> latest.txt
TYPE latest | MORE /P > latest.txt
for /f tokens^=2delims^=^" %%A in (
  'findstr /i /c:"-binaries.zip" latest.txt'
) Do > .\doc\wix_link.txt Echo:%%A& goto ContinueWix
:ContinueWix
if exist latest del latest >nul
if exist latest.txt del latest.txt >nul
set /p wix_link=<.\doc\wix_link.txt
set "wix_link=https://github.com!wix_link!"
set "wix_zip=!wix_link!"
REM listen, it works, im lazy, let it be, can handle a depth of 8 directories and helps future proof if they change the paths.
for /f "delims=/" %%A in ("!wix_zip!") do set wix_zip=!wix_zip:%%~nxA/=!
for /f "delims=/" %%A in ("!wix_zip!") do set wix_zip=!wix_zip:%%~nxA/=!
for /f "delims=/" %%A in ("!wix_zip!") do set wix_zip=!wix_zip:%%~nxA/=!
for /f "delims=/" %%A in ("!wix_zip!") do set wix_zip=!wix_zip:%%~nxA/=!
for /f "delims=/" %%A in ("!wix_zip!") do set wix_zip=!wix_zip:%%~nxA/=!
for /f "delims=/" %%A in ("!wix_zip!") do set wix_zip=!wix_zip:%%~nxA/=!
for /f "delims=/" %%A in ("!wix_zip!") do set wix_zip=!wix_zip:%%~nxA/=!
for /f "delims=/" %%A in ("!wix_zip!") do set wix_zip=!wix_zip:%%~nxA/=!
set "wix_zip=!wix_zip:/=!"
cls
echo "!wix_link!"
echo "!wix_zip!"
if exist "!wix_zip!" "!wix_zip!" >nul
if exist ".\extra\!wix_zip!" (
  echo wix is updated.
  REM pause
  REM exit /b
  goto ExtractWixZip
)
REM pause
if not exist .\bin\wget.exe call :DownloadWget
.\bin\wget.exe -q --show-progress "!wix_link!" "!wix_zip!"
move "!wix_zip!" ".\extra\!wix_zip!"
:ExtractWixZip
if not exist .\helpers\extractzip.vbs call :CreateExtractZipVBS
cscript .\helpers\extractzip.vbs "!folder!\extra\!wix_zip!" "!folder!\bin\wix\" >nul
exit /b

:ExtractMSI
set /p filetxt=<.\helpers\file.txt
set /p foldertxt=<.\helpers\folder.txt

REM lessmsi should always be updated
REM lessmsi should always be updated
REM lessmsi should always be updated
REM lessmsi should always be updated
REM lessmsi should always be updated
if exist .\bin\lessmsi\ rmdir /s /q .\bin\lessmsi\
REM lessmsi should always be updated
REM lessmsi should always be updated
REM lessmsi should always be updated
REM lessmsi should always be updated
REM lessmsi should always be updated

if not exist .\bin\lessmsi\lessmsi.exe call :DownloadMSI
.\bin\lessmsi\lessmsi.exe x !filetxt! "!foldertxt!"
if exist .\helpers\*.txt del .\helpers\*.txt >nul
exit /b

:DownloadMSI
if not exist .\bin\wget.exe call :DownloadWget
.\bin\wget.exe -q --show-progress "https://github.com/activescott/lessmsi/releases/latest" "latest"
if not exist "latest" goto :DownloadMSI
echo.> latest.txt
TYPE latest | MORE /P > latest.txt
for /f tokens^=2delims^=^" %%A in (
  'findstr /i /c:".zip" latest.txt'
) Do > .\doc\lessmsi_link.txt Echo:%%A& goto ContinueMSI
:ContinueMSI
if exist latest del latest >nul
if exist latest.txt del latest.txt >nul
set /p lessmsi_link=<.\doc\lessmsi_link.txt
set "lessmsi_link=https://github.com!lessmsi_link!"
set "lessmsi_zip=!lessmsi_link!"
REM listen, it works, im lazy, let it be, can handle a depth of 8 directories and helps future proof if they change the paths.
for /f "delims=/" %%A in ("!lessmsi_zip!") do set lessmsi_zip=!lessmsi_zip:%%~nxA/=!
for /f "delims=/" %%A in ("!lessmsi_zip!") do set lessmsi_zip=!lessmsi_zip:%%~nxA/=!
for /f "delims=/" %%A in ("!lessmsi_zip!") do set lessmsi_zip=!lessmsi_zip:%%~nxA/=!
for /f "delims=/" %%A in ("!lessmsi_zip!") do set lessmsi_zip=!lessmsi_zip:%%~nxA/=!
for /f "delims=/" %%A in ("!lessmsi_zip!") do set lessmsi_zip=!lessmsi_zip:%%~nxA/=!
for /f "delims=/" %%A in ("!lessmsi_zip!") do set lessmsi_zip=!lessmsi_zip:%%~nxA/=!
for /f "delims=/" %%A in ("!lessmsi_zip!") do set lessmsi_zip=!lessmsi_zip:%%~nxA/=!
for /f "delims=/" %%A in ("!lessmsi_zip!") do set lessmsi_zip=!lessmsi_zip:%%~nxA/=!
set "lessmsi_zip=!lessmsi_zip:/=!"
cls
echo "!lessmsi_link!"
echo "!lessmsi_zip!"
if exist "!lessmsi_zip!" "!lessmsi_zip!" >nul
if exist ".\extra\!lessmsi_zip!" (
  echo lessmsi is updated.
  REM pause
  REM exit /b
  goto ExtractMSIZip
)
REM pause
if not exist .\bin\wget.exe call :DownloadWget
.\bin\wget.exe -q --show-progress "!lessmsi_link!" "!lessmsi_zip!"
move "!lessmsi_zip!" ".\extra\!lessmsi_zip!"
:ExtractMSIZip
if not exist .\helpers\extractzip.vbs call :CreateExtractZipVBS
echo cscript .\helpers\extractzip.vbs "!folder!\extra\!lessmsi_zip!" "!folder!\bin\lessmsi\" >nul
cscript .\helpers\extractzip.vbs "!folder!\extra\!lessmsi_zip!" "!folder!\bin\lessmsi\" >nul
exit /b

:ExtractInno
set /p filetxt=<.\helpers\file.txt
set /p foldertxt=<.\helpers\folder.txt

REM innounp should always be updated
REM innounp should always be updated
REM innounp should always be updated
REM innounp should always be updated
REM innounp should always be updated
if exist .\bin\innounp\ rmdir /s /q .\bin\innounp\
REM innounp should always be updated
REM innounp should always be updated
REM innounp should always be updated
REM innounp should always be updated
REM innounp should always be updated

if not exist .\bin\innounp\innounp.exe call :DownloadInno
.\bin\innounp\innounp.exe -q -x -y -d!foldertxt! !filetxt!
if exist .\helpers\*.txt del .\helpers\*.txt >nul
exit /b

:DownloadInno
if not exist .\bin\wget.exe call :DownloadWget
.\bin\wget.exe -q --show-progress "https://sourceforge.net/projects/innounp/files/latest/download?source=typ_redirect" "download@source=typ_redirect"
if not exist "download@source=typ_redirect" goto :DownloadInno
if not exist .\bin\7-ZipPortable\App\7-Zip\7z.exe call :Download7Zip
.\bin\7-ZipPortable\App\7-Zip\7z.exe x download@source=typ_redirect * -obin\innounp\ -aoa
if exist "download@source=typ_redirect" del "download@source=typ_redirect" >nul
exit /b

:DownloadJava
set "arch="
if exist "%PROGRAMFILES(X86)%" set "arch=64"
if not exist .\bin\wget.exe call :DownloadWget
if exist .\extra\jPortable%arch%_8_Update_291_online.paf.exe exit /b
.\bin\wget.exe -q --show-progress "https://downloads.sourceforge.net/portableapps/jPortable%arch%_8_Update_291_online.paf.exe"
if not exist jPortable%arch%_8_Update_291_online.paf.exe goto :DownloadJava
move jPortable%arch%_8_Update_291_online.paf.exe .\extra\jPortable%arch%_8_Update_291_online.paf.exe
cls
echo README README README README
echo PLEASE PROCEED THROUGH ALL DIALOGUE OPTIONS
echo DO NOT HIT RUN
echo PRESS ENTER WHEN READ
pause >nul
.\extra\jPortable%arch%_8_Update_291_online.paf.exe /destination="!folder!\bin\"
exit /b

:Extract7zip
set /p filetxt=<.\helpers\file.txt
set /p foldertxt=<.\helpers\folder.txt
if not exist .\bin\7-ZipPortable\App\7-Zip\7z.exe call :Download7Zip
.\bin\7-ZipPortable\App\7-Zip\7z.exe x !filetxt! * -o!foldertxt! -aoa
if exist .\helpers\*.txt del .\helpers\*.txt >nul
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
pause >nul
.\extra\7-ZipPortable_16.04.paf.exe /destination="%CD%\bin\"
exit /b

:Extract
set /p filetxt=<.\helpers\file.txt
set /p foldertxt=<.\helpers\folder.txt
if not exist .\helpers\extractzip.vbs call :CreateExtractZipVBS
cscript .\helpers\extractzip.vbs !filetxt! !foldertxt! >nul
if exist .\helpers\*.txt del .\helpers\*.txt >nul
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
set /p filetxt=<.\helpers\file.txt
if not exist .\helpers\hide.vbs call :CreateHideVBS
wscript .\helpers\hide.vbs !filetxt!
if exist .\helpers\*.txt del .\helpers\*.txt >nul
exit /b

:CreateHideVBS
echo CreateObject("Wscript.Shell").Run """" ^& WScript.Arguments(0) ^& """", 0, False > .\helpers\hide.vbs
exit /b

:Download
set /p download=<.\helpers\download.txt
set /p filetxt=<.\helpers\file.txt

REM Download Using VBS
REM if not exist .\helpers\download.vbs call :CreateDownloadVBS
REM cscript .\helpers\download.vbs "%download%" "%file%"

if not exist .\bin\wget.exe call :DownloadWget
.\bin\wget.exe -q --show-progress %download% %file%

if exist .\helpers\*.txt del .\helpers\*.txt >nul
exit /b

:DownloadWget
if not exist .\helpers\download.vbs call :CreateDownloadVBS
cscript .\helpers\download.vbs https://eternallybored.org/misc/wget/current/wget.exe .\bin\wget.exe >nul
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
cscript .\helpers\download.vbs https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/launch_helpers.bat launch_helpers.bat >nul
exit /b
