@echo off
setlocal enabledelayedexpansion
setlocal enableextensions
Color 0A
cls
title Portable Tor Launcher - Helper Edition
set nag=BE SURE TO TURN CAPS LOCK OFF! (never said it was on just make sure)
set new_version=OFFLINE_OR_NO_UPDATES
if exist replacer.bat del replacer.bat
if exist "%~n0_poc.bat" del "%~n0_poc.bat"
set "folder=%CD%"
if "%CD%"=="%~d0\" set "folder=%CD:~0,2%"

call :Alpha-To-Number
call :SetArch
call :FolderCheck
call :Version
call :Credits
call :HelperCheck

:Menu
cls
title Portable Tor Launcher - Helper Edition - Main Menu
echo %NAG%
set nag="Selection Time!"
echo 1. reinstall tor [will remove tor entirely]
echo 2. launch tor [launches tor]
echo 3. reset tor [will remove everything tor except the binary]
echo 4. uninstall tor [none of your friends on tor?]
echo 5. update script [check for updates]
echo 6. credits [credits]
echo 7. exit [EXIT]
echo.
echo a. download dll's [dll errors anyone?]
echo.
echo b. download other projects [check out my other stuff]
echo.
echo c. write a quicklauncher [MAKE IT EVEN FASTER]
echo.
echo d. check for new tor version [automatically check for a new version]
echo.
echo e. install text-reader [update if had]
echo.
set /p choice="enter a number and press enter to confirm: "
:: sets errorlevel to 0 (?)
ver > nul
:: an incorrect call throws an errorlevel of 1
:: replace all goto Main with (goto) 2>nul (if they are called by the main menu)
call :%choice%
REM if "%ERRORLEVEL%" NEQ "2" set nag="PLEASE Select A CHOICE 1-7 or a/b/c/d/e"
goto Menu

:Null
cls
set nag="NOT A FEATURE YET!"
(goto) 2>nul

:1
:ReinstallTor
cls
call :UninstallTor
call :UpgradeTor
(goto) 2>nul

:2
:LaunchTor
if not exist ".\bin\tor\firefox.exe" set "nag=PLEASE INSTALL TOR FIRST" && (goto) 2>nul
title DO NOT CLOSE
cls
echo TOR IS RUNNING
start .\bin\tor\firefox.exe "https://github.com/MarioMasta64/EverythingPortable/releases/latest/"
exit

:3
:ResetTor
taskkill /f /im firefox.exe
rmdir /s /q .\bin\data\tor\
(goto) 2>nul

:4
:UninstallTor
taskkill /f /im firefox.exe
rmdir /s /q .\bin\tor\
del .\extra\*tor*.exe
(goto) 2>nul

:5
:UpdateCheck
if exist version.txt del version.txt
cls
title Portable Tor Launcher - Helper Edition - Checking For Update
call :HelperDownload "https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/version.txt" "version.txt"
set Counter=0 & for /f "DELIMS=" %%i in ('type version.txt') do (set /a Counter+=1 & set "Line_!Counter!=%%i")
if exist version.txt del version.txt
set new_version=%Line_18%
if "%new_version%"=="OFFLINE" call :ErrorOffline & (goto) 2>nul
if %current_version% EQU %new_version% call :LatestBuild & (goto) 2>nul
if %current_version% LSS %new_version% call :NewUpdate & (goto) 2>nul
if %current_version% GTR %new_version% call :PreviewBuild & (goto) 2>nul
call :ErrorOffline & (goto) 2>nul
(goto) 2>nul

:6
:About
cls
del .\doc\tor_license.txt
start launch_tor.bat
exit

:7
exit

:a
:DLLDownloaderCheck
cls & title Portable Tor Launcher - Helper Edition - Download Dll Downloader
call :HelperDownload "https://raw.githubusercontent.com/MarioMasta64/DLLDownloaderPortable/master/launch_dlldownloader.bat" "launch_dlldownloader.bat.1"
cls & if exist launch_dlldownloader.bat.1 del launch_dlldownloader.bat & rename launch_dlldownloader.bat.1 launch_dlldownloader.bat
cls & start launch_dlldownloader.bat
(goto) 2>nul

:b
:PortableEverything
cls & title Portable Tor Launcher - Helper Edition - Download Suite
call :HelperDownload "https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/launch_everything.bat" "launch_everything.bat.1"
cls & if exist launch_everything.bat.1 del launch_everything.bat & rename launch_everything.bat.1 launch_everything.bat
cls & start launch_everything.bat
(goto) 2>nul

:c
:QuicklauncherCheck
cls
title Portable Tor Launcher - Helper Edition - Quicklauncher Writer
echo @echo off > quicklaunch_tor.bat
echo Color 0A >> quicklaunch_tor.bat
echo cls >> quicklaunch_tor.bat
echo set "folder=%%CD%%" >> quicklaunch_tor.bat
echo if "%%CD%%"=="%%~d0\" set "folder=%%CD:~0,2%%" >> quicklaunch_tor.bat
echo set "UserProfile=%%folder%%\data\" >> quicklaunch_tor.bat
echo set "AppData=%%folder%%\data\AppData\Roaming\" >> quicklaunch_tor.bat
echo set "LocalAppData=%%folder%%\data\AppData\Local\" >> quicklaunch_tor.bat
echo cls >> quicklaunch_tor.bat
echo start .\bin\tor\firefox.exe "https://github.com/MarioMasta64/EverythingPortable/releases/latest/" >> quicklaunch_tor.bat
echo exit >> quicklaunch_tor.bat
echo A QUICKLAUNCHER HAS BEEN WRITTEN TO: quicklaunch_tor.bat
echo ENTER TO CONTINUE & pause>nul:
(goto) 2>nul

:d
:UpgradeTor
title Portable Tor Launcher - Helper Edition - Tor Update Checkif exist index.html del index.html
call :HelperDownload "https://www.torproject.org/download/" "index.html"
for /f tokens^=4delims^=^" %%A in (
  'findstr /i /c:".exe" index.html'
) Do > .\doc\tor_link.txt Echo:%%A
set /p tor_link=<.\doc\tor_link.txt
REM no x64 yet
REM no x64 yet
REM no x64 yet
REM no x64 yet
set "tor_link=!tor_link:-win64=!"
REM no x64 yet
REM no x64 yet
REM no x64 yet
REM no x64 yet
echo !tor_link!
set "tor_link=https://www.torproject.org!tor_link:.asc=!"
set "tor_exe=!tor_link!"
REM listen, it works, im lazy, let it be, can handle a depth of 6 directories and helps future proof if they change the paths.
for /f "delims=/" %%A in ("!tor_exe!") do set tor_exe=!tor_exe:%%~nxA/=!
for /f "delims=/" %%A in ("!tor_exe!") do set tor_exe=!tor_exe:%%~nxA/=!
for /f "delims=/" %%A in ("!tor_exe!") do set tor_exe=!tor_exe:%%~nxA/=!
for /f "delims=/" %%A in ("!tor_exe!") do set tor_exe=!tor_exe:%%~nxA/=!
for /f "delims=/" %%A in ("!tor_exe!") do set tor_exe=!tor_exe:%%~nxA/=!
for /f "delims=/" %%A in ("!tor_exe!") do set tor_exe=!tor_exe:%%~nxA/=!
set tor_exe=!tor_exe:/=!
if exist index.html del index.html
cls
if exist .\extra\!tor_exe! (
  echo vivaldi is updated.
  pause
  exit /b
)
echo !tor_link!
echo !tor_exe!
if exist "!tor_exe!" del "!tor_exe!"
call :HelperDownload "!tor_link!" "!tor_exe!"
:MoveTor
move "!tor_exe!" ".\extra\!tor_exe!"
:ExtractTor
call :HelperExtract7Zip "!folder!\extra\!tor_exe!" "!folder!\bin\tor\"
rmdir /s /q .\bin\tor\$PLUGINSDIR\
xcopy /q .\bin\tor\Browser\* .\bin\tor\ /e /i /y
rmdir /s /q .\bin\tor\Browser\
(goto) 2>nul

:e
title Portable Tor Launcher - Helper Edition - Text-Reader Update Check
cls
call :HelperDownload "https://mariomasta64.me/batch/text-reader/update-text-reader.bat" "update-text-reader.bat"
start "" "update-text-reader.bat"
(goto) 2>nul

REM PROGRAM SPECIFIC STUFF THAT CAN BE EASILY CHANGED BELOW
REM STUFF THAT IS ALMOST IDENTICAL BETWEEN STUFF

:FolderCheck
cls
set "UserProfile=!folder!\data\"
set "AppData=!folder!\data\AppData\Roaming\"
set "LocalAppData=!folder!\data\AppData\Local\"
if not exist .\bin\ mkdir .\bin\
if not exist .\data\ mkdir .\data\
if not exist .\doc\ mkdir .\doc\
if not exist .\extra\ mkdir .\extra\
if not exist .\helpers\ mkdir .\helpers\
if not exist .\note\ mkdir .\note\
if not exist .\data\AppData\Local\ mkdir .\data\AppData\Local\
if not exist .\data\AppData\Roaming\ mkdir .\data\AppData\Roaming\
if not exist ".\bin\tor\firefox.exe" set nag=TOR IS NOT INSTALLED CHOOSE "D"
(goto) 2>nul

:Version
cls
echo 9 > .\doc\version.txt
set /p current_version=<.\doc\version.txt
if exist .\doc\version.txt del .\doc\version.txt
:: REPLACE ALL exit /b that dont need an error code (a value after it) with "exit"
(goto) 2>nul

:Credits
cls
if exist .\doc\tor_license.txt (goto) 2>nul
echo ================================================== > .\doc\tor_license.txt
echo =              Script by MarioMasta64            = >> .\doc\tor_license.txt
echo =           Script Version: v%current_version%- release        = >> .\doc\tor_license.txt
echo ================================================== >> .\doc\tor_license.txt
echo =You may Modify this WITH consent of the original= >> .\doc\tor_license.txt
echo = creator, as long as you include a copy of this = >> .\doc\tor_license.txt
echo =      as you include a copy of the License      = >> .\doc\tor_license.txt
echo ================================================== >> .\doc\tor_license.txt
echo =    You may also modify this script without     = >> .\doc\tor_license.txt
echo =         consent for PERSONAL USE ONLY          = >> .\doc\tor_license.txt
echo ================================================== >> .\doc\tor_license.txt
cls
title Portable Tor Launcher - Helper Edition - About
for /f "DELIMS=" %%i in (.\doc\tor_license.txt) do (echo %%i)
pause
call :PingInstall
(goto) 2>nul

REM if a script can be used between files then it can be put here and re-written only if it doesnt exist
REM stuff here will not be changed between programs

:SetArch
set arch=
if exist "%PROGRAMFILES(X86)%" set "arch=64"
(goto) 2>nul

:HelperCheck
if not exist launch_helpers.bat call :DownloadHelpers
(goto) 2>nul
:DownloadHelpers
if not exist .\helpers\download.vbs call :CreateDownloadVBS
cscript .\helpers\download.vbs https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/launch_helpers.bat launch_helpers.bat > nul
(goto) 2>nul
:CreateDownloadVBS
echo Dim Arg, download, file > .\helpers\download.vbs
echo Set Arg = WScript.Arguments >> .\helpers\download.vbs
echo. >> .\helpers\download.vbs
echo download = Arg(0) >> .\helpers\download.vbs
echo file = Arg(1) >> .\helpers\download.vbs
echo. >> .\helpers\download.vbs
echo dim xHttp: Set xHttp = CreateObject("MSXML2.ServerXMLHTTP")>> .\helpers\download.vbs
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
(goto) 2>nul

:HelperDownload
REM v1+ Required
echo 1 > .\helpers\version.txt
echo %1 > .\helpers\download.txt
echo %2 > .\helpers\file.txt
call launch_helpers.bat Download
(goto) 2>nul

:HelperDownloadWget
REM v3+ Required
echo 3 > .\helpers\version.txt
call launch_helpers.bat DownloadWget
(goto) 2>nul

:HelperExtract
REM v1+ Required
echo 1 > .\helpers\version.txt
echo %1 > .\helpers\file.txt
echo %2 > .\helpers\folder.txt
call launch_helpers.bat Extract
(goto) 2>nul

:HelperExtract7Zip
REM v3+ Required
echo 3 > .\helpers\version.txt
echo %1 > .\helpers\file.txt
echo %2 > .\helpers\folder.txt
call launch_helpers.bat Extract7Zip
(goto) 2>nul

:HelperHide
REM v4+ Required
echo 4 > .\helpers\version.txt
echo %1 > .\helpers\file.txt
call launch_helpers.bat Hide
(goto) 2>nul

:HelperReplaceText
REM v5+ Required
echo 5 > .\helpers\version.txt
echo %1 > .\helpers\file.txt
echo %2 > .\helpers\oldtext.txt
echo %3 > .\helpers\newtext.txt
call launch_helpers.bat ReplaceText
(goto) 2>nul

:HelperExtractInno
REM v8+ Required
echo 8 > .\helpers\version.txt
echo %1 > .\helpers\file.txt
echo %2 > .\helpers\folder.txt
call launch_helpers.bat ExtractInno
(goto) 2>nul

:PingInstall
for /F "skip=1 tokens=5" %%a in ('vol %~D0') do echo %%a>serial.txt
set /a count=1 
for /f "skip=1 delims=:" %%a in ('CertUtil -hashfile "serial.txt" sha1') do (
  if !count! equ 1 set "sha1=%%a"
  set/a count+=1
)
set "sha1=%sha1: =%
echo %sha1%
set program=%~n0
echo %program:~7%
echo "https://mariomasta64.me/install/new_install.php?program=%program:~7%^&serial=%sha1%"
REM call :HelperDownload "https://mariomasta64.me/install/new_install.php?program=%program:~7%^&serial=%sha1%" "new_install.php"
del new_install.php*
del serial.txt
(goto) 2>nul

:UpdateWget
cls
call launch_helpers.bat DownloadWget
(goto) 2>nul

:LatestBuild
cls
title Portable Tor Launcher - Helper Edition - Latest Build :D
echo you are using the latest version!!
echo Current Version: v%current_version%
echo New Version: v%new_version%
echo ENTER TO CONTINUE & pause>nul:
start launch_tor.bat
exit

:NewUpdate
cls
title Portable Tor Launcher - Helper Edition - Old Build D:
echo %NAG%
set nag="Selection Time!"
echo you are using an older version
echo enter yes or no
echo Current Version: v%current_version%
echo New Version: v%new_version%
set /p choice="Update?: "
if "%choice%"=="yes" call :Update-Now & (goto) 2>nul
if "%choice%"=="no" (goto) 2>nul
set nag="please enter YES or NO"
goto NewUpdate

:UpdateNow
cls & title Portable Tor Launcher - Helper Edition - Updating Launcher
call :HelperDownload "https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/launch_tor.bat" "launch_tor.bat.1"
cls & if exist launch_tor.bat.1 goto ReplacerCreate
cls & call :ErrorOffline
(goto) 2>nul

:ReplacerCreate
cls
echo @echo off > replacer.bat
echo Color 0A >> replacer.bat
echo del launch_tor.bat >> replacer.bat
echo rename launch_tor.bat.1 launch_tor.bat >> replacer.bat
echo start launch_tor.bat >> replacer.bat
:: launcher exits, deletes itself, and then exits again. yes. its magic.
echo (goto) 2^>nul ^& del "%%~f0" ^& exit >> replacer.bat
call :HelperHide "replacer.bat"
exit

:PreviewBuild
cls
title Portable Tor Launcher - Helper Edition - Test Build :0
echo YOURE USING A TEST BUILD MEANING YOURE EITHER
echo CLOSE TO ME OR YOURE SOME SORT OF PIRATE
echo Current Version: v%current_version%
echo New Version: v%new_version%
echo ENTER TO CONTINUE & pause>nul:
start launch_tor.bat
exit

:ErrorOffline
cls
set nag="YOU SEEM TO BE OFFLINE PLEASE RECONNECT TO THE INTERNET TO USE THIS FEATURE"
(goto) 2>nul

REM GENERAL PURPOSE SCRIPTS BELOW

:AlphaToNumber
set a=1
set b=2
set c=3
set d=4
set e=5
set f=6
set g=7
set h=8
set i=9
set j=10
set k=11
set l=12
set m=13
set n=14
set o=15
set p=16
set q=17
set r=18
set s=19
set t=20
set u=21
set v=22
set w=23
set x=24
set y=25
set z=26
(goto) 2>nul

:ViewCode
start notepad.exe "%~f0"
(goto) 2>nul

:MakeCopy
:SaveCopy
del "%~f0.bak"
copy "%~f0" "%~f0.bak"
(goto) 2>nul

:Cmd
cls
title Portable Tor Launcher - Helper Edition - Command Prompt - By MarioMasta64
ver
echo (C) Copyright Microsoft Corporation. All rights reserved
echo.
echo nice job finding me. have fun with my little cmd prompt.
echo upon error (more likely than not) i will return to the menu.
echo type "(goto) 2^>nul" or make me error to return.
echo.
:CmdLoop
set /p "cmd=%cd%>"
if "%cmd%"=="reset-cmd" call :Cmd
%cmd%
echo.
goto CmdLoop

:Relaunch
echo @echo off > relaunch.bat
echo cls >> relaunch.bat
echo Color 0A >> relaunch.bat
echo start %~f0 >> relaunch.bat
:: launcher exits, deletes itself, and then exits again. yes. its magic.
echo (goto) 2^>nul ^& del "%%~f0" ^& exit >> relaunch.bat
call :HelperHide "relaunch.bat"
exit






































@echo off
setlocal enabledelayedexpansion
Color 0A
cls
title PORTABLE TOR LAUNCHER
set nag=BE SURE TO TURN CAPS LOCK OFF! (never said it was on just make sure)
set new_version=OFFLINE
if exist replacer.bat del replacer.bat
if "%~1" neq "" (call :%~1 & exit /b !current_version!)

:FOLDERCHECK
cls
if not exist .\bin\tor\ mkdir .\bin\tor\
if not exist .\doc\ mkdir .\doc\
if not exist .\extra\ mkdir .\extra\
call :VERSION
goto CREDITS

:VERSION
cls
echo 8 > .\doc\version.txt
set /p current_version=<.\doc\version.txt
if exist .\doc\version.txt del .\doc\version.txt
exit /b

:CREDITS
cls
if exist .\doc\tor_license.txt goto TORCHECK
echo ================================================== > .\doc\tor_license.txt
echo =              Script by MarioMasta64            = >> .\doc\tor_license.txt
:: REMOVE SPACE AFTER VERSION HITS DOUBLE DIGITS
echo =           Script Version: v%current_version%- release         = >> .\doc\tor_license.txt
echo ================================================== >> .\doc\tor_license.txt
echo =You may Modify this WITH consent of the original= >> .\doc\tor_license.txt
echo = creator, as long as you include a copy of this = >> .\doc\tor_license.txt
echo =      as you include a copy of the License      = >> .\doc\tor_license.txt
echo ================================================== >> .\doc\tor_license.txt
echo =    You may also modify this script without     = >> .\doc\tor_license.txt
echo =         consent for PERSONAL USE ONLY          = >> .\doc\tor_license.txt
echo ================================================== >> .\doc\tor_license.txt

:CREDITSREAD
cls
title PORTABLE TOR LAUNCHER - ABOUT
for /f "DELIMS=" %%i in (.\doc\tor_license.txt) do (echo %%i)
pause

:TORCHECK
cls
if not exist .\bin\tor\firefox.exe goto FILECHECK
goto WGETUPDATE

:FILECHECK
cls
if not exist .\extra\torbrowser-install-6.5.1_en-US.exe goto DOWNLOADTOR
if not exist .\bin\7-ZipPortable\7-ZipPortable.exe goto 7ZIPINSTALLERCHECK
.\bin\7-ZipPortable\App\7-Zip%arch%\7z.exe x .\extra\torbrowser-install-6.5.1_en-US.exe * -o.\bin\tor\
rmdir /s /q .\bin\tor\$PLUGINSDIR\
cd bin\tor\Browser
xcopy /q .\* .. /e /i /y
cd ..
cd ..
cd ..
goto TORCHECK

:DOWNLOADTOR
cls
title PORTABLE TOR LAUNCHER - DOWNLOAD TOR
if exist torbrowser-install-6.5.1_en-US.exe goto MOVETOR
if not exist .\bin\wget.exe call :DOWNLOADWGET
.\bin\wget.exe -q --show-progress https://github.com/TheTorProject/gettorbrowser/releases/download/v6.5.1/torbrowser-install-6.5.1_en-US.exe

:MOVETOR
cls
move torbrowser-install-6.5.1_en-US.exe .\extra\torbrowser-install-6.5.1_en-US.exe
goto FILECHECK

:7ZIPINSTALLERCHECK
if not exist .\extra\7-ZipPortable_16.04.paf.exe goto DOWNLOAD7ZIP
title PORTABLE TOR LAUNCHER - RUNNING 7ZIP INSTALLER
.\extra\7-ZipPortable_16.04.paf.exe /destination="%CD%\bin\"
goto FILECHECK

:DOWNLOAD7ZIP
cls
title PORTABLE TOR LAUNCHER - DOWNLOAD 7ZIP
if exist 7-ZipPortable_16.04.paf.exe goto MOVE7ZIP
if not exist .\bin\wget.exe call :DOWNLOADWGET
.\bin\wget.exe -q --show-progress http://downloads.sourceforge.net/portableapps/7-ZipPortable_16.04.paf.exe

:MOVE7ZIP
cls
move 7-ZipPortable_16.04.paf.exe .\extra\7-ZipPortable_16.04.paf.exe
goto FILECHECK

:WGETUPDATE
cls
title PORTABLE TOR LAUNCHER - UPDATE WGET
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
title PORTABLE TOR LAUNCHER - DOWNLOAD WGET
cscript.exe .\bin\downloadwget.vbs
move wget.exe .\bin\
exit /b

:MENU
cls
title PORTABLE TOR LAUNCHER - MAIN MENU
echo %NAG%
set nag=SELECTION TIME!
echo 1. reinstall tor [not a feature yet]
echo 2. launch tor
echo 3. reset tor [not a feature yet]
echo 4. uninstall tor [not a feature yet]
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
start .\bin\tor\firefox.exe
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
set new_version=%Line_18%
if "%new_version%"=="OFFLINE" goto ERROROFFLINE
if %current_version% EQU %new_version% goto LATEST
if %current_version% LSS %new_version% goto NEWUPDATE
if %current_version% GTR %new_version% goto NEWEST
goto ERROROFFLINE

:LATEST
cls
title PORTABLE TOR LAUNCHER - LATEST BUILD :D
echo you are using the latest version!!
echo Current Version: v%current_version%
echo New Version: v%new_version%
echo ENTER TO CONTINUE
pause
goto MENU

:NEWUPDATE
cls
title PORTABLE TOR LAUNCHER - OLD BUILD D:
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
.\bin\wget.exe -q --show-progress https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/launch_tor.bat
cls
if exist launch_tor.bat.1 goto REPLACERCREATE
goto ERROROFFLINE

:REPLACERCREATE
cls
echo @echo off > replacer.bat
echo Color 0A >> replacer.bat
echo del launch_tor.bat >> replacer.bat
echo rename launch_tor.bat.1 launch_tor.bat >> replacer.bat
echo start launch_tor.bat >> replacer.bat
echo exit >> replacer.bat
start replacer.bat
exit

:NEWEST
cls
title PORTABLE TOR LAUNCHER - TEST BUILD :0
echo YOURE USING A TEST BUILD MEANING YOURE EITHER
echo CLOSE TO ME OR YOURE SOME SORT OF PIRATE
echo Current Version: v%current_version%
echo New Version: v%new_version%
echo ENTER TO CONTINUE
pause
start launch_tor.bat
exit

:ABOUT
cls
del .\doc\tor_license.txt
start launch_tor.bat
exit

:PORTABLEEVERYTHING
cls
title PORTABLE TOR LAUNCHER - DOWNLOAD SUITE
if not exist .\bin\wget.exe call :DOWNLOADWGET
if not exist launch_everything.bat .\bin\wget.exe -q --show-progress https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/launch_everything.bat
cls
start launch_everything.bat
exit

:QUICKLAUNCHERCHECK
cls
title PORTABLE TOR LAUNCHER - QUICKLAUNCHER WRITER
echo @echo off > quicklaunch_tor.bat
echo Color 0A >> quicklaunch_tor.bat
echo cls >> quicklaunch_tor.bat
echo start .\bin\tor\firefox.exe >> quicklaunch_tor.bat
echo exit >> quicklaunch_tor.bat
echo A QUICKLAUNCHER HAS BEEN WRITTEN TO: quicklaunch_steam.bat
pause
exit

:ERROROFFLINE
cls
set nag="YOU SEEM TO BE OFFLINE PLEASE RECONNECT TO THE INTERNET TO USE THIS FEATURE"
goto MENU