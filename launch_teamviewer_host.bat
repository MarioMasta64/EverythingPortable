@echo off
cls
Color 0A
cls
title PORTABLE TEAMVIEWER HOST LAUNCHER
set nag=BE SURE TO TURN CAPS LOCK OFF! (never said it was on just make sure)
set new_version=OFFLINE
if exist replacer.bat del replacer.bat
if "%~1" neq "" (call :%~1 & exit /b !current_version!)

:FOLDERCHECK
cls
if not exist .\bin\teamviewer_host\ mkdir .\bin\teamviewer_host\
if not exist .\doc\ mkdir .\doc\
if not exist .\data\AppData\Roaming\ mkdir .\data\AppData\Roaming\
if not exist .\extra\ mkdir .\extra\
call :VERSION
goto CREDITS

:VERSION
cls
echo 2 > .\doc\version.txt
set /p current_version=<.\doc\version.txt
if exist .\doc\version.txt del .\doc\version.txt
exit /b

:CREDITS
cls
if exist .\doc\teamviewer_host_license.txt goto TEAMVIEWERHOSTCHECK
echo ================================================== > .\doc\teamviewer_host_license.txt
echo =              Script by MarioMasta64            = >> .\doc\teamviewer_host_license.txt
:: REMOVE SPACE AFTER VERSION HITS DOUBLE DIGITS
echo =           Script Version: v%current_version%- release         = >> .\doc\teamviewer_host_license.txt
echo ================================================== >> .\doc\teamviewer_host_license.txt
echo =You may Modify this WITH consent of the original= >> .\doc\teamviewer_host_license.txt
echo = creator, as long as you include a copy of this = >> .\doc\teamviewer_host_license.txt
echo =      as you include a copy of the License      = >> .\doc\teamviewer_host_license.txt
echo ================================================== >> .\doc\teamviewer_host_license.txt
echo =    You may also modify this script without     = >> .\doc\teamviewer_host_license.txt
echo =         consent for PERSONAL USE ONLY          = >> .\doc\teamviewer_host_license.txt
echo ================================================== >> .\doc\teamviewer_host_license.txt

:CREDITSREAD
cls
title PORTABLE TEAMVIEWER HOST LAUNCHER - ABOUT
for /f "DELIMS=" %%i in (.\doc\teamviewer_host_license.txt) do (echo %%i)
pause

:TEAMVIEWERHOSTCHECK
cls
if not exist .\bin\teamviewer_host\TeamViewer.exe goto ARCHCHECK
goto WGETUPDATE

:ARCHCHECK
cls
set arch=
if exist "%PROGRAMFILES(X86)%" set arch=64

:FILECHECK
cls
if not exist .\extra\TeamViewer_Host_Setup.exe goto DOWNLOADTEAMVIEWERHOST
if not exist .\bin\7-ZipPortable\7-ZipPortable.exe goto 7ZIPINSTALLERCHECK
if not exist .\temp\ mkdir .\temp\
.\bin\7-ZipPortable\App\7-Zip%arch%\7z.exe x .\extra\TeamViewer_Host_Setup.exe * -o.\temp\
rmdir /s /q .\temp\$PLUGINSDIR\
del .\temp\tvfilesx64.7z
del .\temp\tvfilesx86.7z
.\bin\7-ZipPortable\App\7-Zip%arch%\7z.exe x .\temp\tvfiles.7z * -o.\bin\teamviewer_host\
rmdir /s /q .\temp\
del .\bin\teamviewer_host\Uninstall.exe
goto TEAMVIEWERHOSTCHECK

:DOWNLOADTEAMVIEWERHOST
cls
title PORTABLE TEAMVIEWER HOST LAUNCHER - DOWNLOAD TEAMVIEWER HOST
if exist TeamViewer_Host_Setup.exe goto MOVETEAMVIEWERHOST
if not exist .\bin\wget.exe call :DOWNLOADWGET
.\bin\wget.exe -q --show-progress https://download.teamviewer.com/download/TeamViewer_Host_Setup.exe

:MOVETEAMVIEWERHOST
cls
move TeamViewer_Host_Setup.exe .\extra\TeamViewer_Host_Setup.exe
goto FILECHECK

:7ZIPINSTALLERCHECK
if not exist .\extra\7-ZipPortable_16.04.paf.exe goto DOWNLOAD7ZIP
title PORTABLE TEAMVIEWER HOST LAUNCHER - RUNNING 7ZIP INSTALLER
.\extra\7-ZipPortable_16.04.paf.exe /destination="%CD%\bin\"
goto FILECHECK

:DOWNLOAD7ZIP
cls
title PORTABLE TEAMVIEWER HOST LAUNCHER - DOWNLOAD 7ZIP
if exist 7-ZipPortable_16.04.paf.exe goto MOVE7ZIP
if not exist .\bin\wget.exe call :DOWNLOADWGET
.\bin\wget.exe -q --show-progress http://downloads.sourceforge.net/portableapps/7-ZipPortable_16.04.paf.exe

:MOVE7ZIP
cls
move 7-ZipPortable_16.04.paf.exe .\extra\7-ZipPortable_16.04.paf.exe
goto FILECHECK

:WGETUPDATE
cls
title PORTABLE TEAMVIEWER HOST LAUNCHER - UPDATE WGET
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
title PORTABLE TEAMVIEWER HOST LAUNCHER - DOWNLOAD WGET
cscript.exe .\bin\downloadwget.vbs
move wget.exe .\bin\
exit /b

:MENU
cls
title PORTABLE TEAMVIEWER HOST LAUNCHER - MAIN MENU
echo %NAG%
set nag=SELECTION TIME!
echo 1. reinstall teamviewer host [not a feature yet]
echo 2. launch teamviewer host
echo 3. reset teamviewer host [not a feature yet]
echo 4. uninstall teamviewer host [not a feature yet]
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
if "%choice%"=="7" exit
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
set "AppData=%CD%\data\AppData\Roaming"
start .\bin\teamviewer_host\TeamViewer.exe
exit

:NOWRESETTING
goto NULL

:DELETE
goto NULL

:UPDATECHECK
cls
if exist version.txt del version.txt
if not exist .\bin\wget.exe call :DOWNLOADWGET
.\bin\wget.exe -q --show-progress https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/version.txt
cls
set Counter=0 & for /f "DELIMS=" %%i in ('type version.txt') do (set /a Counter+=1 & set "Line_!Counter!=%%i")
if exist version.txt del version.txt
set new_version=%Line_20%
if "%new_version%"=="OFFLINE" goto ERROROFFLINE
if %current_version% EQU %new_version% goto LATEST
if %current_version% LSS %new_version% goto NEWUPDATE
if %current_version% GTR %new_version% goto NEWEST
goto ERROROFFLINE

:LATEST
cls
title PORTABLE TEAMVIEWER HOST LAUNCHER - LATEST BUILD :D
echo you are using the latest version!!
echo Current Version: v%current_version%
echo New Version: v%new_version%
echo ENTER TO CONTINUE
pause
goto MENU

:NEWUPDATE
cls
title PORTABLE TEAMVIEWER HOST LAUNCHER - OLD BUILD D:
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
.\bin\wget.exe -q --show-progress https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/launch_teamviewer_host.bat
cls
if exist launch_teamviewer_host.bat.1 goto REPLACERCREATE
goto ERROROFFLINE

:REPLACERCREATE
cls
echo @echo off > replacer.bat
echo Color 0A >> replacer.bat
echo del launch_teamviewer_host.bat >> replacer.bat
echo rename launch_teamviewer_host.bat.1 launch_teamviewer_host.bat >> replacer.bat
echo start launch_teamviewer_host.bat >> replacer.bat
echo exit >> replacer.bat
start replacer.bat
exit

:NEWEST
cls
title PORTABLE TEAMVIEWER HOST LAUNCHER - TEST BUILD :0
echo YOURE USING A TEST BUILD MEANING YOURE EITHER
echo CLOSE TO ME OR YOURE SOME SORT OF PIRATE
echo Current Version: v%current_version%
echo New Version: v%new_version%
echo ENTER TO CONTINUE
pause
start launch_teamviewer_host.bat
exit

:ABOUT
cls
del .\doc\teamviewer_host_license.txt
start launch_teamviewer_host.bat
exit

:PORTABLEEVERYTHING
cls
title PORTABLE TEAMVIEWER HOST LAUNCHER - DOWNLOAD SUITE
if not exist .\bin\wget.exe call :DOWNLOADWGET
if not exist launch_everything.bat .\bin\wget.exe -q --show-progress https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/launch_everything.bat
cls
start launch_everything.bat
exit

:QUICKLAUNCHERCHECK
cls
title PORTABLE TEAMVIEWER HOST LAUNCHER - QUICKLAUNCHER WRITER
echo @echo off > quicklaunch_teamviewer_host.bat
echo Color 0A >> quicklaunch_teamviewer_host.bat
echo cls >> quicklaunch_teamviewer_host.bat
echo set "AppData=%CD%\data\AppData\Roaming" >> quicklaunch_teamviewer_host.bat
echo start .\bin\teamviewer_host\TeamViewer.exe >> quicklaunch_teamviewer_host.bat
echo exit >> quicklaunch_teamviewer_host.bat
echo A QUICKLAUNCHER HAS BEEN WRITTEN TO: quicklaunch_teamviewer_host.bat
pause
exit

:ERROROFFLINE
cls
set nag="YOU SEEM TO BE OFFLINE PLEASE RECONNECT TO THE INTERNET TO USE THIS FEATURE"
goto MENU
