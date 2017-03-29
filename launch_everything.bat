@echo off
setlocal enabledelayedexpansion
Color 0A
cls
title PORTABLE EVERYTHING LAUNCHER
set nag=BE SURE TO TURN CAPS LOCK OFF! (never said it was on just make sure)
set new_version=OFFLINE
if exist replacer.bat del replacer.bat

:FOLDERCHECK
cls
if not exist .\bin\ mkdir .\bin\
if not exist .\doc\ mkdir .\doc\

:VERSION
cls
echo 1 > .\doc\version.txt
set /p current_version=<.\doc\version.txt
if exist .\doc\version.txt del .\doc\version.txt

:CREDITS
cls
if exist .\doc\everything_license.txt goto FILECHECK
echo ================================================== > .\doc\everything_license.txt
echo =              Script by MarioMasta64            = >> .\doc\everything_license.txt
:: remove space when version reaches 2 digits
echo =           Script Version: v%current_version%- release         = >> .\doc\everything_license.txt
echo ================================================== >> .\doc\everything_license.txt
echo =You may Modify this WITH consent of the original= >> .\doc\everything_license.txt
echo = creator, as long as you include a copy of this = >> .\doc\everything_license.txt
echo =      as you include a copy of the License      = >> .\doc\everything_license.txt
echo ================================================== >> .\doc\everything_license.txt
echo =    You may also modify this script without     = >> .\doc\everything_license.txt
echo =         consent for PERSONAL USE ONLY          = >> .\doc\everything_license.txt
echo ================================================== >> .\doc\everything_license.txt

:CREDITSREAD
cls
title PORTABLE MINECRAFT LAUNCHER - ABOUT
for /f "DELIMS=" %%i in (.\doc\everything_license.txt) do (echo %%i)
pause

:FILECHECK
cls

:WGETUPDATE
cls
wget https://eternallybored.org/misc/wget/current/wget.exe
move wget.exe .\bin\
goto MENU

:DOWNLOADWGET
cls
call :CHECKWGETDOWNLOADER
exit /b

:CHECKWGETDOWNLOADER
cls
if not exist .\bin\downloadwget.vbs call :CREATEWGETDOWNLOADER
if exist .\bin\downloadwget.vbs call :EXECUTEWGETDOWNLOADER
exit /b

:CREATEWGETDOWNLOADER
cls
echo ' Set your settings > .\bin\downloadwget.vbs
echo    strFileURL = "https://eternallybored.org/misc/wget/current/wget.exe" >> .\bin\downloadwget.vbs
echo    strHDLocation = "wget.exe" >> .\bin\downloadwget.vbs
echo. >> .\bin\downloadwget.vbs
echo ' Fetch the file >> .\bin\downloadwget.vbs
echo     Set objXMLHTTP = CreateObject("MSXML2.XMLHTTP") >> .\bin\downloadwget.vbs
echo. >> .\bin\downloadwget.vbs
echo     objXMLHTTP.open "GET", strFileURL, false >> .\bin\downloadwget.vbs
echo     objXMLHTTP.send() >> .\bin\downloadwget.vbs
echo. >> .\bin\downloadwget.vbs
echo If objXMLHTTP.Status = 200 Then >> .\bin\downloadwget.vbs
echo Set objADOStream = CreateObject("ADODB.Stream") >> .\bin\downloadwget.vbs
echo objADOStream.Open >> .\bin\downloadwget.vbs
echo objADOStream.Type = 1 'adTypeBinary >> .\bin\downloadwget.vbs
echo. >> .\bin\downloadwget.vbs
echo objADOStream.Write objXMLHTTP.ResponseBody >> .\bin\downloadwget.vbs
echo objADOStream.Position = 0    'Set the stream position to the start >> .\bin\downloadwget.vbs
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
exit /b

:EXECUTEWGETDOWNLOADER
cls
title PORTABLE OBS LAUNCHER - DOWNLOAD WGET
cscript.exe .\bin\downloadwget.vbs
move wget.exe .\bin\
exit /b

:MENU
cls
title PORTABLE MINECRAFT LAUNCHER - MAIN MENU
echo %NAG%
set nag=SELECTION TIME!
echo 1. download a program
echo 2. launch a program
echo 3. delete a program
echo 4. update a program
echo 5. about
echo 6. exit
echo.
set /p choice="enter a number and press enter to confirm: "
if "%CHOICE%"=="1" goto DOWNLOAD
if "%CHOICE%"=="2" goto LAUNCH
if "%CHOICE%"=="3" goto DELETE
if "%CHOICE%"=="4" goto UPDATECHECK
if "%CHOICE%"=="5" goto ABOUT
if "%CHOICE%"=="6" exit
set nag="PLEASE SELECT A CHOICE 1-6"
goto MENU

:GET_LAUNCHERS
dir /b /a-d launch_*.bat > .\doc\launchers.txt
set Counter=0
for /f "DELIMS=" %%i in ('type .\doc\launchers.txt') do (
    set /a Counter+=1
    set "Line_!Counter!=%%i"
)
if exist .\doc\launchers.txt del .\doc\launchers.txt
exit /b

:GET_DOWNLOADS
set "num=1"
set "counter=0"
for /f "DELIMS=" %%i in (version.txt) do (
    set /a num+=1
:: this line says if num is equal to blah execute this. basically it counts by this many lines it also resets the counter on completion
    if "!num!"=="2" (set /a counter+=1&set "line_!counter!=%%i"&set num=0)
)
if exist version.txt del version.txt
set nag="if it wasnt for http://stackoverflow.com/users/5269570/sam-denty this wouldnt work"
exit /b

:DOWNLOAD

:: put this somewhere else
.\bin\wget.exe https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/version.txt

cls
title PORTABLE MINECRAFT LAUNCHER - DOWNLOAD LAUNCHER
echo %NAG%
set nag=SELECTION TIME!
call :GET_DOWNLOADS
:: first number is which line to start second number is how many lines to count by
For /L %%C in (1,1,%Counter%) Do (echo %%C. !Line_%%C!)
echo type menu to return to the main menu
set /p choice="launcher to download: "
set launcher=!Line_%CHOICE%!
if "%CHOICE%"=="menu" goto MENU
if "%CHOICE%"=="default" goto DEFAULT

:: cap output somehow

echo %launcher%
pause

goto LAUNCHERCHECK

:LAUNCHERCHECK
cls
if not