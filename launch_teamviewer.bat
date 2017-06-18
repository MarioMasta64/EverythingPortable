@echo off
cls
Color 0A
cls
title PORTABLE TEAMVIEWER LAUNCHER
set nag=BE SURE TO TURN CAPS LOCK OFF! (never said it was on just make sure)
set new_version=OFFLINE
if exist replacer.bat del replacer.bat
if exist launch_teamviewer_poc.bat del launch_teamviewer_poc.bat
if "%~1" neq "" (call :%~1 & exit /b !current_version!)

:FOLDERCHECK
cls
if not exist .\bin\teamviewer\ mkdir .\bin\teamviewer\
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
if exist .\doc\teamviewer_license.txt goto TEAMVIEWERCHECK
echo ================================================== > .\doc\teamviewer_license.txt
echo =              Script by MarioMasta64            = >> .\doc\teamviewer_license.txt
:: REMOVE SPACE AFTER VERSION HITS DOUBLE DIGITS
echo =           Script Version: v%current_version%- release         = >> .\doc\teamviewer_license.txt
echo ================================================== >> .\doc\teamviewer_license.txt
echo =You may Modify this WITH consent of the original= >> .\doc\teamviewer_license.txt
echo = creator, as long as you include a copy of this = >> .\doc\teamviewer_license.txt
echo =      as you include a copy of the License      = >> .\doc\teamviewer_license.txt
echo ================================================== >> .\doc\teamviewer_license.txt
echo =    You may also modify this script without     = >> .\doc\teamviewer_license.txt
echo =         consent for PERSONAL USE ONLY          = >> .\doc\teamviewer_license.txt
echo ================================================== >> .\doc\teamviewer_license.txt

:CREDITSREAD
cls
title PORTABLE TEAMVIEWER LAUNCHER - ABOUT
for /f "DELIMS=" %%i in (.\doc\teamviewer_license.txt) do (echo %%i)
pause

:TEAMVIEWERCHECK
cls
if not exist .\bin\teamviewer\TeamViewer.exe goto FILECHECK
goto WGETUPDATE

:FILECHECK
cls
if not exist .\extra\TeamViewerPortable.zip goto DOWNLOADTEAMVIEWER
call :EXTRACTTEAMVIEWER
goto TEAMVIEWERCHECK

:DOWNLOADTEAMVIEWER
cls
title PORTABLE TEAMVIEWER LAUNCHER - DOWNLOAD TEAMVIEWER
if exist TeamViewerPortable.zip goto MOVETEAMVIEWER
if not exist .\bin\wget.exe call :DOWNLOADWGET
.\bin\wget.exe -q --show-progress https://download.teamviewer.com/download/TeamViewerPortable.zip

:MOVETEAMVIEWER
cls
move TeamViewerPortable.zip .\extra\TeamViewerPortable.zip
goto FILECHECK

:WGETUPDATE
cls
title PORTABLE TEAMVIEWER LAUNCHER - UPDATE WGET
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
title PORTABLE TEAMVIEWER LAUNCHER - DOWNLOAD WGET
cscript.exe .\bin\downloadwget.vbs
move wget.exe .\bin\
exit /b

:EXTRACTTEAMVIEWER
cls
title PORTABLE TEAMVIEWER LAUNCHER - EXTRACT TEAMVIEWER
set folder=%CD%
if %CD%==%~d0\ set folder=%CD:~0,2%
cls
echo. > .\bin\extractteamviewer.vbs
echo 'The location of the zip file. >> .\bin\extractteamviewer.vbs
echo ZipFile="%folder%\extra\TeamViewerPortable.zip" >> .\bin\extractteamviewer.vbs
echo 'The folder the contents should be extracted to. >> .\bin\extractteamviewer.vbs
:: change to %folder%\bin\ on regular builds (ones that dont have a folder inside the zip)
echo ExtractTo="%folder%\bin\TeamViewer\" >> .\bin\extractteamviewer.vbs
echo. >> .\bin\extractteamviewer.vbs
echo 'If the extraction location does not exist create it. >> .\bin\extractteamviewer.vbs
echo Set fso = CreateObject("Scripting.FileSystemObject") >> .\bin\extractteamviewer.vbs
echo If NOT fso.FolderExists(ExtractTo) Then >> .\bin\extractteamviewer.vbs
echo    fso.CreateFolder(ExtractTo) >> .\bin\extractteamviewer.vbs
echo End If >> .\bin\extractteamviewer.vbs
echo. >> .\bin\extractteamviewer.vbs
echo 'Extract the contants of the zip file. >> .\bin\extractteamviewer.vbs
echo set objShell = CreateObject("Shell.Application") >> .\bin\extractteamviewer.vbs
echo set FilesInZip=objShell.NameSpace(ZipFile).items >> .\bin\extractteamviewer.vbs
echo objShell.NameSpace(ExtractTo).CopyHere(FilesInZip) >> .\bin\extractteamviewer.vbs
echo Set fso = Nothing >> .\bin\extractteamviewer.vbs
echo Set objShell = Nothing >> .\bin\extractteamviewer.vbs
echo. >> .\bin\extractteamviewer.vbs
title PORTABLE CEMU LAUNCHER - EXTRACT ZIP
cscript.exe .\bin\extractteamviewer.vbs
exit /b

:MENU
cls
title PORTABLE TEAMVIEWER LAUNCHER - MAIN MENU
echo %NAG%
set nag=SELECTION TIME!
echo 1. reinstall teamviewer [not a feature yet]
echo 2. launch teamviewer
echo 3. reset teamviewer [not a feature yet]
echo 4. uninstall teamviewer [not a feature yet]
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
if "%choice%"=="7" EXIT
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
start .\bin\teamviewer\TeamViewer.exe
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
set new_version=%Line_22%
if "%new_version%"=="OFFLINE" goto ERROROFFLINE
if %current_version% EQU %new_version% goto LATEST
if %current_version% LSS %new_version% goto NEWUPDATE
if %current_version% GTR %new_version% goto NEWEST
goto ERROROFFLINE

:LATEST
cls
title PORTABLE TEAMVIEWER LAUNCHER - LATEST BUILD :D
echo you are using the latest version!!
echo Current Version: v%current_version%
echo New Version: v%new_version%
echo ENTER TO CONTINUE
pause
goto MENU

:NEWUPDATE
cls
title PORTABLE TEAMVIEWER LAUNCHER - OLD BUILD D:
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
.\bin\wget.exe -q --show-progress https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/launch_teamviewer.bat
cls
if exist launch_teamviewer.bat.1 goto REPLACERCREATE
goto ERROROFFLINE

:REPLACERCREATE
cls
echo @echo off > replacer.bat
echo Color 0A >> replacer.bat
echo del launch_teamviewer.bat >> replacer.bat
echo rename launch_teamviewer.bat.1 launch_teamviewer.bat >> replacer.bat
echo start launch_teamviewer.bat >> replacer.bat
echo exit >> replacer.bat
start replacer.bat
exit

:NEWEST
cls
title PORTABLE TEAMVIEWER LAUNCHER - TEST BUILD :0
echo YOURE USING A TEST BUILD MEANING YOURE EITHER
echo CLOSE TO ME OR YOURE SOME SORT OF PIRATE
echo Current Version: v%current_version%
echo New Version: v%new_version%
echo ENTER TO CONTINUE
pause
start launch_teamviewer.bat
exit

:ABOUT
cls
del .\doc\qtemu_license.txt
start launch_teamviewer.bat
exit

:PORTABLEEVERYTHING
cls
title PORTABLE TEAMVIEWER LAUNCHER - DOWNLOAD SUITE
if not exist .\bin\wget.exe call :DOWNLOADWGET
if not exist launch_everything.bat .\bin\wget.exe -q --show-progress https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/launch_everything.bat
cls
start launch_everything.bat
exit

:QUICKLAUNCHERCHECK
cls
title PORTABLE TEAMVIEWER LAUNCHER - QUICKLAUNCHER WRITER
echo @echo off > quicklaunch_teamviewer.bat
echo Color 0A >> quicklaunch_teamviewer.bat
echo cls >> quicklaunch_teamviewer.bat
echo set "AppData=%CD%\data\AppData\Roaming" >> quicklaunch_teamviewer.bat
echo start .\bin\teamviewer\TeamViewer.exe >> quicklaunch_teamviewer.bat
echo exit >> quicklaunch_teamviewer.bat
echo A QUICKLAUNCHER HAS BEEN WRITTEN TO: quicklaunch_teamviewer.bat
pause
exit

:ERROROFFLINE
cls
set nag="YOU SEEM TO BE OFFLINE PLEASE RECONNECT TO THE INTERNET TO USE THIS FEATURE"
goto MENU