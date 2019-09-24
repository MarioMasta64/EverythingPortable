@echo off
setlocal enabledelayedexpansion
Color 0A
cls
title PORTABLE UWAMP LAUNCHER
set nag=BE SURE TO TURN CAPS LOCK OFF! (never said it was on just make sure)
set new_version=OFFLINE
if exist replacer.bat del replacer.bat
if "%~1" neq "" (call :%~1 & exit /b !current_version!)

:FOLDERCHECK
cls
if not exist .\doc\ mkdir .\doc\
if not exist .\data\ mkdir .\data\
if not exist .\data\.UWAMP\ mkdir .\data\.UWAMP\
if not exist .\data\AppData\Roaming\ mkdir .\data\AppData\Roaming\
if not exist .\extra\ mkdir .\extra\
call :VERSION
goto CREDITS

:VERSION
cls
echo 1 > .\doc\version.txt
set /p current_version=<.\doc\version.txt
if exist .\doc\version.txt del .\doc\version.txt
exit /b

:CREDITS
cls
if exist .\doc\uwamp_license.txt goto UWAMPCHECK
echo ================================================== > .\doc\uwamp_license.txt
echo =              Script by MarioMasta64            = >> .\doc\uwamp_license.txt
:: remove space when version reaches 2 digits
echo =           Script Version: v%current_version%- release         = >> .\doc\uwamp_license.txt
echo ================================================== >> .\doc\uwamp_license.txt
echo =You may Modify this WITH consent of the original= >> .\doc\uwamp_license.txt
echo = creator, as long as you include a copy of this = >> .\doc\uwamp_license.txt
echo =      as you include a copy of the License      = >> .\doc\uwamp_license.txt
echo ================================================== >> .\doc\uwamp_license.txt
echo =    You may also modify this script without     = >> .\doc\uwamp_license.txt
echo =         consent for PERSONAL USE ONLY          = >> .\doc\uwamp_license.txt
echo ================================================== >> .\doc\uwamp_license.txt

:CREDITSREAD
cls
title PORTABLE UWAMP LAUNCHER - ABOUT
for /f "DELIMS=" %%i in (.\doc\uwamp_license.txt) do (echo %%i)
pause

:UWAMPCHECK
cls
if not exist .\bin\UwAmp\UwAmp.exe goto FILECHECK
goto WGETUPDATE

:FILECHECK
if not exist .\extra\UwAmp.zip goto DOWNLOADUWAMP
call :EXTRACTUWAMP
goto UWAMPCHECK

:DOWNLOADUWAMP
cls
title PORTABLE UWAMP LAUNCHER - DOWNLOAD UWAMP
if exist UwAmp.zip goto MOVEUWAMP
if not exist .\bin\wget.exe call :DOWNLOADWGET
.\bin\wget.exe -q --show-progress "https://www.uwamp.com/file/UwAmp.zip"

:MOVEUWAMP
cls
title PORTABLE UWAMP LAUNCHER - MOVE UWAMP
move UwAmp.zip .\extra\UwAmp.zip
if not exist .\bin\wget.exe call :DOWNLOADWGET
goto UWAMPCHECK

:WGETUPDATE
cls
title PORTABLE UWAMP LAUNCHER - UPDATE WGET
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
title PORTABLE UWAMP LAUNCHER - DOWNLOAD WGET
cscript.exe .\bin\downloadwget.vbs
move wget.exe .\bin\
exit /b

:EXTRACTUWAMP
cls
title PORTABLE UWAMP LAUNCHER - EXTRACT UWAMP
set "folder=%CD%"
if "%CD%"=="%~d0\" set "folder=%CD:~0,2%"
cls

echo. > .\bin\extractuwamp.vbs
echo 'The location of the zip file. >> .\bin\extractuwamp.vbs
echo ZipFile="%folder%\extra\UwAmp.zip" >> .\bin\extractuwamp.vbs
echo 'The folder the contents should be extracted to. >> .\bin\extractuwamp.vbs
echo ExtractTo="%folder%\bin\" >> .\bin\extractuwamp.vbs
echo. >> .\bin\extractuwamp.vbs
echo 'If the extraction location does not exist create it. >> .\bin\extractuwamp.vbs
echo Set fso = CreateObject("Scripting.FileSystemObject") >> .\bin\extractuwamp.vbs
echo If NOT fso.FolderExists(ExtractTo) Then >> .\bin\extractuwamp.vbs
echo    fso.CreateFolder(ExtractTo) >> .\bin\extractuwamp.vbs
echo End If >> .\bin\extractuwamp.vbs
echo. >> .\bin\extractuwamp.vbs
echo 'Extract the contants of the zip file. >> .\bin\extractuwamp.vbs
echo set objShell = CreateObject("Shell.Application") >> .\bin\extractuwamp.vbs
echo set FilesInZip=objShell.NameSpace(ZipFile).items >> .\bin\extractuwamp.vbs
echo objShell.NameSpace(ExtractTo).CopyHere(FilesInZip) >> .\bin\extractuwamp.vbs
echo Set fso = Nothing >> .\bin\extractuwamp.vbs
echo Set objShell = Nothing >> .\bin\extractuwamp.vbs
echo. >> .\bin\extractuwamp.vbs

title PORTABLE UWAMP LAUNCHER - EXTRACT ZIP
cscript.exe .\bin\extractuwamp.vbs
exit /b

:MENU
cls
title PORTABLE UWAMP LAUNCHER - MAIN MENU
echo %NAG%
set nag="SELECTION TIME!"
echo 1. reinstall UWAMP [not a feature yet]
echo 2. launch UWAMP
echo 3. reset UWAMP [not a feature yet]
echo 4. uninstall UWAMP [not a feature yet]
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
goto NULL

:DEFAULT
cls
set "AppData=%CD%\data\AppData\Roaming\"
start .\bin\UwAmp\UwAmp.exe
goto MENU

:SELECT
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
set new_version=%Line_42%
if "%new_version%"=="OFFLINE" goto ERROROFFLINE
if %current_version% EQU %new_version% goto LATEST
if %current_version% LSS %new_version% goto NEWUPDATE
if %current_version% GTR %new_version% goto NEWEST
goto ERROROFFLINE

:LATEST
cls
title PORTABLE UWAMP LAUNCHER - LATEST BUILD :D
echo you are using the latest version!!
echo Current Version: v%current_version%
echo New Version: v%new_version%
pause
start launch_uwamp.bat
exit

:NEWUPDATE
cls
title PORTABLE UWAMP LAUNCHER - OLD BUILD D:
echo %NAG%
set nag="SELECTION TIME!"
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
.\bin\wget.exe -q --show-progress https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/launch_uwamp.bat
cls
if exist launch_uwamp.bat.1 goto REPLACERCREATE
goto ERROROFFLINE

:REPLACERCREATE
cls
echo @echo off > replacer.bat
echo Color 0A >> replacer.bat
echo del launch_uwamp.bat >> replacer.bat
echo rename launch_uwamp.bat.1 launch_uwamp.bat >> replacer.bat
echo start launch_uwamp.bat >> replacer.bat
echo exit >> replacer.bat
start replacer.bat
exit

:NEWEST
cls
title PORTABLE UWAMP LAUNCHER - TEST BUILD :0
echo YOURE USING A TEST BUILD MEANING YOURE EITHER
echo CLOSE TO ME OR YOURE SOME SORT OF PIRATE
echo Current Version: v%current_version%
echo New Version: v%new_version%
echo ENTER TO CONTINUE
pause
start launch_uwamp.bat
exit

:ABOUT
cls
del .\doc\uwamp_license.txt
start launch_uwamp.bat
exit

:PORTABLEEVERYTHING
cls
title PORTABLE UWAMP LAUNCHER - DOWNLOAD SUITE
if not exist .\bin\wget.exe call :DOWNLOADWGET
if not exist launch_everything.bat .\bin\wget.exe -q --show-progress https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/launch_everything.bat
cls
start launch_everything.bat
exit

:QUICKLAUNCHERCHECK
cls
title PORTABLE UWAMP LAUNCHER - QUICKLAUNCHER WRITER
echo @echo off > quicklaunch_uwamp.bat >> quicklaunch_uwamp.bat
echo Color 0A >> quicklaunch_uwamp.bat >> quicklaunch_uwamp.bat
echo cls >> quicklaunch_uwamp.bat
echo set "AppData=%CD%\data\AppData\Roaming\" >> quicklaunch_uwamp.bat
echo start .\bin\UwAmp\UwAmp.exe >> quicklaunch_uwamp.bat
echo exit >> quicklaunch_uwamp.bat
echo A QUICKLAUNCHER HAS BEEN WRITTEN TO: quicklaunch_uwamp.bat
pause
exit

:ERROROFFLINE
cls
set nag="YOU SEEM TO BE OFFLINE PLEASE RECONNECT TO THE INTERNET TO USE THIS FEATURE"
goto MENU