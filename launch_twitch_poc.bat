@echo off
cls
Color 0A
title Twitch PoC - MarioMasta64

set "folder=%CD%"
if "%CD%"=="%~d0\" set "folder=%CD:~0,2%"
set "userprofile=%folder%\data"

if not exist .\bin\ mkdir .\bin\
if not exist .\data\ mkdir .\data\
if not exist .\dll\32\ mkdir .\dll\32\
:: if not exist .\doc\ mkdir .\doc\
if not exist .\extra\ mkdir .\extra\
echo "l" to launch twitch
echo "d" to download twitch (first time)
echo "e" to run twitch setup
set /p goto="choice: "
goto %goto%

:d
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
call :select
.\bin\wget.exe "https://updates.twitchapp.net/windows/installer/%twitch%"
move %twitch% .\extra\%twitch%
:: is not required to be set. will be set in release
goto e-continue

:e
call :select
:e-continue

:: echo let the installer run>bin.txt
:: echo select advanced>>bin.txt
:: echo select the inatall location bar>>bin.txt
:: echo copy and paste this into the explorer window at the top and press enter to enter the directory>>bin.txt
:: echo "%folder%\bin\">>bin.txt
:: echo now click select folder>>bin.txt
:: echo click install>>bin.txt
:: echo you are now done it will launch automatically>>bin.txt
:: start notepad.exe bin.txt

:: call :timeout 40
:: del bin.txt >nul:

.\extra\%twitch%
exit

:l
set "path=%path%;%folder%\dll\32\;"
start .\bin\Twitch\Bin\Twitch.exe
exit

:timeout
set /a timeout=0
:timeout-count
set /a loop+=1
if %loop% LEQ %1 goto timeout
exit /b

:select
cls
echo Twitch Stable vs. Twitch Beta
echo 1. Twitch Stable
echo 2. Twitch Beta
set /p twitchver="Your Choice: "
if "%twitchver%"=="1" (
  set twitch=TwitchSetup.exe
  exit /b
)
if "%twitchver%"=="2" (
  set twitch=TwitchBetaSetup.exe
  exit /b
)
goto select