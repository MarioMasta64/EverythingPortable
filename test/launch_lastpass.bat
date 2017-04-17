@echo off
setlocal enabledelayedexpansion
Color 0A
cls
title PORTABLE LASTPASS LAUNCHER
set nag=BE SURE TO TURN CAPS LOCK OFF! (never said it was on just make sure)
set new_version=OFFLINE
if exist replacer.bat del replacer.bat
if "%~1" neq "" (call :%~1 & exit /b !current_version!)

:FOLDERCHECK
cls
if not exist .\bin\lastpass\ mkdir .\bin\lastpass\
if not exist .\doc\ mkdir .\doc\
if not exist .\extra\ mkdir .\extra\
if not exist .\data\appdata\ mkdir .\data\appdata\
call :VERSION
goto CREDITS

:VERSION
cls
echo 6 > .\doc\version.txt
set /p current_version=<.\doc\version.txt
if exist .\doc\version.txt del .\doc\version.txt
exit /b

:CREDITS
cls
if exist .\doc\lastpass_license.txt goto ARCHCHECK
echo ================================================== > .\doc\lastpass_license.txt
echo =              Script by MarioMasta64            = >> .\doc\lastpass_license.txt
:: REMOVE SPACE AFTER VERSION HITS DOUBLE DIGITS
echo =           Script Version: v%current_version%- release         = >> .\doc\lastpass_license.txt
echo ================================================== >> .\doc\lastpass_license.txt
echo =You may Modify this WITH consent of the original= >> .\doc\lastpass_license.txt
echo = creator, as long as you include a copy of this = >> .\doc\lastpass_license.txt
echo =      as you include a copy of the License      = >> .\doc\lastpass_license.txt
echo ================================================== >> .\doc\lastpass_license.txt
echo =    You may also modify this script without     = >> .\doc\lastpass_license.txt
echo =         consent for PERSONAL USE ONLY          = >> .\doc\lastpass_license.txt
echo ================================================== >> .\doc\lastpass_license.txt

:CREDITSREAD
cls
title PORTABLE LASTPASS LAUNCHER - ABOUT
for /f "DELIMS=" %%i in (.\doc\lastpass_license.txt) do (echo %%i)
pause

:ARCHCHECK
cls
set arch=
if exist "%PROGRAMFILES(X86)%" set "arch=_x64" & goto LASTPASSCHECK

:LASTPASSCHECK
cls
if not exist .\bin\lastpass\lastapp%arch%.exe goto FILECHECK
if not exist .\bin\lastpass\lastapphook%arch%.dll goto FILECHECK
goto WGETUPDATE

:FILECHECK
cls
if not exist .\extra\lastappinstall%arch%.exe goto DOWNLOADLASTPASS
if not exist .\bin\7-ZipPortable\7-ZipPortable.exe goto 7ZIPINSTALLERCHECK
.\bin\7-ZipPortable\App\7-Zip%arch:~2,2%\7z.exe e .\extra\lastappinstall%arch%.exe lastapp%arch%.exe lastapphook%arch%.dll -o.\bin\lastpass\
goto LASTPASSCHECK

:DOWNLOADLASTPASS
cls
if exist lastappinstall%arch%.exe goto MOVELASTPASS
if not exist .\bin\wget.exe call :DOWNLOADWGET
.\bin\wget.exe https://lastpass.com/download/cdn/lastappinstall%arch%.exe

:MOVELASTPASS
cls
move lastappinstall%arch%.exe .\extra\lastappinstall%arch%.exe
goto FILECHECK

:7ZIPINSTALLERCHECK
if not exist .\extra\7-ZipPortable_16.04.paf.exe goto DOWNLOAD7ZIP
start .\extra\7-ZipPortable_16.04.paf.exe /destination="%CD%\bin\"
:: maybe a different approach of bringing this to the front
cls
title READMEREADMEREADMEREADMEREADMEREADMEREADMEREADMEREADMEREADMEREADMEREADMEREADMEREADMEREADME
echo go through the install directions as it says then press enter to continue
pause
goto FILECHECK

:DOWNLOAD7ZIP
cls
if exist 7-ZipPortable_16.04.paf.exe goto MOVE7ZIP
if not exist .\bin\wget.exe call :DOWNLOADWGET
.\bin\wget.exe http://downloads.sourceforge.net/portableapps/7-ZipPortable_16.04.paf.exe

:MOVE7ZIP
cls
move 7-ZipPortable_16.04.paf.exe .\extra\7-ZipPortable_16.04.paf.exe
goto FILECHECK

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
title PORTABLE LASTPASS LAUNCHER - DOWNLOAD WGET
cscript.exe .\bin\downloadwget.vbs
move wget.exe .\bin\
exit /b

:MENU
cls
title PORTABLE LASTPASS LAUNCHER - MAIN MENU
echo %NAG%
set nag=SELECTION TIME!
echo 1. reinstall lastpass [not a feature yet]
echo 2. launch lastpass
echo 3. reset lastpass [not a feature yet]
echo 4. uninstall lastpass [not a feature yet]
echo 5. update program
echo 6. about
echo 7. exit
echo.
echo b. download other projects
echo.
echo c. write a quicklauncher
echo.
set /p choice="enter a number and press enter to confirm: "
if "%choice%"=="1" goto NEW
if "%choice%"=="2" goto DEFAULT
if "%choice%"=="3" goto SELECT
if "%choice%"=="4" goto DELETE
if "%choice%"=="5" goto UPDATECHECK
if "%choice%"=="6" goto ABOUT
if "%choice%"=="7" goto EXIT
if "%CHOICE%"=="b" goto PORTABLEEVERYTHING
if "%CHOICE%"=="c" goto QUICKLAUNCHERCHECK
set nag="PLEASE SELECT A CHOICE 1-7 or b/c"
goto MENU

:NULL
cls
set nag="NOT A FEATURE YET!"
goto MENU

:NEW
cls
goto NULL

:DEFAULT
cls
title DO NOT CLOSE - Steam is Running
xcopy ".\data\appdata\locallow\lastpass\*" "%userprofile%\appdata\locallow\lastpass\" /e /i /y
set LOCALAPPDATA=.\data\appdata\local
set APPDATA=.\data\appdata\roaming
cls
echo LASTPASS IS RUNNING
.\bin\lastpass\lastapp_x64.exe
goto EXIT

:SELECT
cls
title PORTABLE LASTPASS LAUNCHER - RESET LASTPASS
echo %NAG%
set nag=SELECTION TIME!
echo type "yes" to reset lastpass
echo or anything else to cancel
set /p choice="are you sure: "
if "%choice%"=="yes" goto NOWRESETTING
goto MENU

:NOWRESETTING
goto NULL

:DELETE
goto NULL

:UPDATECHECK
cls
if exist version.txt del version.txt
if not exist .\bin\wget.exe call :DOWNLOADWGET
.\bin\wget.exe https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/version.txt
set Counter=0 & for /f "DELIMS=" %%i in ('type version.txt') do (set /a Counter+=1 & set "Line_!Counter!=%%i")
if exist version.txt del version.txt
set new_version=%Line_14%
if %new_version%==OFFLINE goto ERROROFFLINE
if %current_version% EQU %new_version% goto LATEST
if %current_version% LSS %new_version% goto NEWUPDATE
if %current_version% GTR %new_version% goto NEWEST
goto ERROROFFLINE

:LATEST
cls
title PORTABLE LASTPASS LAUNCHER - LATEST BUILD :D
echo you are using the latest version!!
echo Current Version: v%current_version%
echo New Version: v%new_version%
echo ENTER TO CONTINUE
pause
goto MENU

:NEWUPDATE
cls
title PORTABLE LASTPASS LAUNCHER - OLD BUILD D:
echo %NAG%
set nag=SELECTION TIME!
echo you are using an older version
echo enter yes or no
echo Current Version: v%current_version%
echo New Version: v%new_version%
set /p choice="Update?: "
if "%choice%"=="yes" goto UPDATE
if "%choice%"=="no" goto MENU
set nag="please enter YES or NO"
goto NEWUPDATE

:UPDATE
cls
if not exist .\bin\wget.exe call :DOWNLOADWGET
.\bin\wget.exe https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/launch_lastpass.bat
if exist launch_lastpass.bat.1 goto REPLACERCREATE
goto ERROROFFLINE

:REPLACERCREATE
cls
echo @echo off > replacer.bat
echo Color 0A >> replacer.bat
echo del launch_lastpass.bat >> replacer.bat
echo rename launch_lastpass.bat.1 launch_lastpass.bat >> replacer.bat
echo start launch_lastpass.bat >> replacer.bat
echo exit >> replacer.bat
start replacer.bat
exit

:NEWEST
cls
title PORTABLE LASTPASS LAUNCHER - TEST BUILD :0
echo YOURE USING A TEST BUILD MEANING YOURE EITHER
echo CLOSE TO ME OR YOURE SOME SORT OF PIRATE
echo Current Version: v%current_version%
echo New Version: v%new_version%
echo ENTER TO CONTINUE
pause
start launch_lastpass.bat
exit

:ABOUT
cls
del .\doc\lastpass_license.txt
start launch_lastpass.bat
exit

:PORTABLEEVERYTHING
cls
if not exist .\bin\wget.exe call :DOWNLOADWGET
if not exist launch_everything.bat .\bin\wget.exe https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/launch_everything.bat
cls
start launch_everything.bat
exit

:QUICKLAUNCHERCHECK
cls
title PORTABLE LASTPASS LAUNCHER - QUICKLAUNCHER WRITER
echo @echo off > quicklaunch_lastpass.bat
echo Color 0A >> quicklaunch_lastpass.bat
echo title DO NOT CLOSE >> quicklaunch_lastpass.bat
echo set path="%%path%%";.\dll >> quicklaunch_lastpass.bat
echo xcopy /q "%%CD%%\data\citra\*" "%%appdata%%\Citra\" /e /i /y >> quicklaunch_lastpass.bat
echo cls >> quicklaunch_lastpass.bat
echo echo CITRA IS RUNNING >> quicklaunch_lastpass.bat
echo "%%CD%%\bin\citra\citra-qt.exe" >> quicklaunch_lastpass.bat
echo xcopy /q "%%appdata%%\Citra\*" "%%CD%%\data\citra\" /e /i /y >> quicklaunch_lastpass.bat
echo cls >> quicklaunch_lastpass.bat
echo rmdir /s /q "%%appdata%%\Citra\" >> quicklaunch_lastpass.bat
echo exit >> quicklaunch_lastpass.bat
echo A QUICKLAUNCHER HAS BEEN WRITTEN TO: quicklaunch_lastpass.bat
pause
exit

:ERROROFFLINE
cls
set nag="YOU SEEM TO BE OFFLINE PLEASE RECONNECT TO THE INTERNET TO USE THIS FEATURE"
goto MENU

:ERROR
cls
echo ERROR OCCURED
pause

:EXIT
xcopy "%UserProfile%\AppData\LocalLow\lastpass\*" .\data\appdata\locallow\lastpass /e /i /y
rmdir /s /q "%UserProfile%\AppData\LocalLow\LastPass"
exit