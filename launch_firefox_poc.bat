@echo off
cls
Color 0A
title Firefox Portable PoC - MarioMasta64

set "folder=%CD%"
if "%CD%"=="%~d0\" set "folder=%CD:~0,2%"
:: set "userprofile=%folder%\data"

if not exist .\bin\ mkdir .\bin\
if not exist .\data\ mkdir .\data\
if not exist .\data\firefox\ mkdir .\data\firefox\
:: if not exist .\doc\ mkdir .\doc\
if not exist .\extra\ mkdir .\extra\

:menu
echo "l" to launch firefox
echo "f" run first time
echo "d59" to download firefox 59 (legacy drop "quantum")
echo "d58" to download firefox 58 (preparing for legacy drop)
echo "d57" to download firefox 57 (legacy)
set /p goto="choice: "
goto %goto%

:f
cls
echo ' Set your settings > .\bin\downloadwget.vbs
echo strFileURL = "https://eternallybored.org/misc/wget/current/wget.exe" >> .\bin\downloadwget.vbs
echo strHDLocation = "wget.exe" >> .\bin\downloadwget.vbs
echo. >> .\bin\downloadwget.vbs
echo ' Fetch the file >> .\bin\downloadwget.vbs
echo Set objXMLHTTP = CreateObject("MSXML2.XMLHTTP") >> .\bin\downloadwget.vbs
echo. >> .\bin\downloadwget.vbs
echo objXMLHTTP.open "GET", strFileURL, false >> .\bin\downloadwget.vbs
echo objXMLHTTP.send() >> .\bin\downloadwget.vbs
echo. >> .\bin\downloadwget.vbs
echo If objXMLHTTP.Status = 200 Then >> .\bin\downloadwget.vbs
echo Set objADOStream = CreateObject("ADODB.Stream") >> .\bin\downloadwget.vbs
echo objADOStream.Open >> .\bin\downloadwget.vbs
echo objADOStream.Type = 1 'adTypeBinary >> .\bin\downloadwget.vbs
echo. >> .\bin\downloadwget.vbs
echo objADOStream.Write objXMLHTTP.ResponseBody >> .\bin\downloadwget.vbs
echo objADOStream.Position = 0'Set the stream position to the start >> .\bin\downloadwget.vbs
echo. >> .\bin\downloadwget.vbs
echo Set objFSO = Createobject("Scripting.FileSystemObject") >> .\bin\downloadwget.vbs
echo If objFSO.Fileexists(strHDLocation) Then objFSO.DeleteFile strHDLocation >> .\bin\downloadwget.vbs
echo Set objFSO = Nothing >> .\bin\downloadwget.vbs
echo. >> .\bin\downloadwget.vbs
echo objADOStream.SaveToFile strHDLocation >> .\bin\downloadwget.vbs
echo objADOStream.Close >> .\bin\downloadwget.vbs
echo Set objADOStream = Nothing >> .\bin\downloadwget.vbs
echo End if >> .\bin\downloadwget.vbs
echo. >> .\bin\downloadwget.vbs
echo Set objXMLHTTP = Nothing >> .\bin\downloadwget.vbs
cscript.exe .\bin\downloadwget.vbs
move wget.exe .\bin\wget.exe
echo 'The location of the zip file. > .\bin\extractzip.vbs
echo ZipFile = Wscript.Arguments(0) >> .\bin\extractzip.vbs
echo 'The folder the contents should be extracted to. >> .\bin\extractzip.vbs
echo ExtractTo = Wscript.Arguments(1) >> .\bin\extractzip.vbs
echo. >> .\bin\extractzip.vbs
echo 'If the extraction location does not exist create it. >> .\bin\extractzip.vbs
echo Set fso = CreateObject("Scripting.FileSystemObject") >> .\bin\extractzip.vbs
echo If NOT fso.FolderExists(ExtractTo) Then >> .\bin\extractzip.vbs
echo fso.CreateFolder(ExtractTo) >> .\bin\extractzip.vbs
echo End If >> .\bin\extractzip.vbs
echo. >> .\bin\extractzip.vbs
echo 'Extract the contants of the zip file. >> .\bin\extractzip.vbs
echo set objShell = CreateObject("Shell.Application") >> .\bin\extractzip.vbs
echo set FilesInZip=objShell.NameSpace(ZipFile).items >> .\bin\extractzip.vbs
echo objShell.NameSpace(ExtractTo).CopyHere(FilesInZip) >> .\bin\extractzip.vbs
echo Set fso = Nothing >> .\bin\extractzip.vbs
echo Set objShell = Nothing >> .\bin\extractzip.vbs
goto menu

:d
echo "%firefox_url:~66%"
pause
.\bin\wget.exe -q --show-progress "%firefox_url%"
if exist "%firefox_url:~66%" move "%firefox_url:~66%" ".\extra\%firefox_url:~66%"
call :Extract-Zip "bin" "extra\%firefox_url:~66%"
pause
goto l

:d57
set "firefox_url=http://ftp.mozilla.org/pub/firefox/nightly/latest-mozilla-central/firefox-57.0a1.en-US.win32.zip"
goto d

:d58
set "firefox_url=http://ftp.mozilla.org/pub/firefox/nightly/latest-mozilla-central/firefox-58.0a1.en-US.win32.zip"
goto d

:d59
set "firefox_url=http://ftp.mozilla.org/pub/firefox/nightly/latest-mozilla-central/firefox-59.0a1.en-US.win32.zip"
goto d

:extract-zip
set "dir=%1"
set "file=%2"
set "folder=%CD%"
if "%CD%"=="%~d0\" set "folder=%CD:~0,2%"
cscript .\bin\extractzip.vbs "%folder%\%file%" "%folder%\%dir%"
(goto) 2>nul

:l
start .\bin\firefox\firefox.exe -Profile "data/firefox/" "https://github.com/MarioMasta64/EverythingPortable/releases/latest/"
exit
