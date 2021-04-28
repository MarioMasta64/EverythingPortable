@echo off
setlocal enabledelayedexpansion
setlocal enableextensions
Color 0A
cls
title Portable Cemu Launcher - Helper Edition
set nag=BE SURE TO TURN CAPS LOCK OFF! (never said it was on just make sure)
set new_version=OFFLINE_OR_NO_UPDATES
if exist replacer.bat del replacer.bat
set "folder=%CD%"
if "%CD%"=="%~d0\" set "folder=%CD:~0,2%"

call :FolderCheck
call :SetArch
call :Version
call :Credits
call :HelperCheck
call :v19UpgradeCheck

:Menu
cls
title Portable Cemu Launcher - Helper Edition - Main Menu
echo %NAG%
set nag="Selection Time!"
echo 1. reinstall cemu [will remove cemu entirely]
echo 2. launch cemu [launches cemu]
echo 3. reset cemu [will remove everything cemu except the binary]
echo 4. uninstall cemu [Maybe Buy A WiiU :^^)]
echo 5. update script [check for updates]
echo 6. about [shoulda named this credits]
echo 7. exit [EXIT]
echo.
echo a. download dll's [dll errors anyone?]
echo.
echo b. download other projects [check out my other stuff]
echo.
echo c. write a quicklauncher [MAKE IT EVEN FASTER]
echo.
echo d. check for new cemu version [automatically check for a new version]
echo.
echo e. install text-reader [update if had]
echo.
echo f. download mod's [want cemu hook or something?]
echo.
set /p choice="enter a number and press enter to confirm: "
:: sets errorlevel to 0 (?)
ver > nul
:: an incorrect call throws an errorlevel of 1
:: replace all goto Main with exit /b 2 (if they are called by the main menu)
call :%choice%
REM if "%ERRORLEVEL%" NEQ "2" set nag="PLEASE Select A CHOICE 1-7 or a/b/c/d/e"
goto Menu

:Null
cls
set nag="NOT A FEATURE YET!"
(goto) 2>nul

:1
:ReinstallCemu
cls
call :UninstallCemu
call :UpgradeCemu
(goto) 2>nul

:2
:LaunchCemu
title DO NOT CLOSE
set "folder=%CD%"
if "%CD%"=="%~d0\" set "folder=%CD:~0,2%"
set "UserProfile=!folder!\data\"
set "AppData=!folder!\data\AppData\Roaming\"
set "LocalAppData=!folder!\data\AppData\Local\"
set "path=!PATH!;!folder!\dll\64\;"
cls
echo CEMU IS RUNNING
cd bin\cemu*
start Cemu.exe
exit

:3
:ResetCemu
cls
rmdir /s /q ".\data\AppData\Local\Cemu\"
(goto) 2>nul

:4
:UninstallCemu
cls
taskkill /f /im "Cemu.exe"
rmdir /s /q .\bin\cemu\
del .\extra\cemu* >nul
(goto) 2>nul

:5
:UpdateCheck
if exist version.txt del version.txt
cls
title Portable Cemu Launcher - Helper Edition - Checking For Update
call :HelperDownload "https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/version.txt" "version.txt"
set Counter=0 & for /f "DELIMS=" %%i in ('type version.txt') do (set /a Counter+=1 & set "Line_!Counter!=%%i")
if exist version.txt del version.txt
set new_version=%Line_12%
if "%new_version%"=="OFFLINE" call :ErrorOffline & exit /b 2
if %current_version% EQU %new_version% call :LatestBuild & exit /b 2
if %current_version% LSS %new_version% call :NewUpdate & exit /b 2
if %current_version% GTR %new_version% call :PreviewBuild & exit /b 2
call :ErrorOffline & exit /b 2
(goto) 2>nul

:6
:About
cls
del .\doc\cemu_license.txt
start launch_cemu.bat
exit

:7
exit

:a
:DLLDownloaderCheck
cls & title Portable Cemu Launcher - Helper Edition - Download Dll Downloader
call :HelperDownload "https://raw.githubusercontent.com/MarioMasta64/DLLDownloaderPortable/master/launch_dlldownloader.bat" "launch_dlldownloader.bat.1"
cls & if exist launch_dlldownloader.bat.1 del launch_dlldownloader.bat & rename launch_dlldownloader.bat.1 launch_dlldownloader.bat
cls & start launch_dlldownloader.bat
(goto) 2>nul

:b
:PortableEverything
cls & title Portable Cemu Launcher - Helper Edition - Download Suite
call :HelperDownload "https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/launch_everything.bat" "launch_everything.bat.1"
cls & if exist launch_everything.bat.1 del launch_everything.bat & rename launch_everything.bat.1 launch_everything.bat
cls & start launch_everything.bat
(goto) 2>nul

:c
:QuicklauncherCheck
cls
title Portable Cemu Launcher - Helper Edition - Quicklauncher Writer
echo @echo off > quicklaunch_cemu.bat
echo Color 0A >> quicklaunch_cemu.bat
echo cls >> quicklaunch_cemu.bat
echo set "folder=%%CD%%" >> quicklaunch_cemu.bat
echo if "%%CD%%"=="%%~d0\" set "folder=%%CD:~0,2%%" >> quicklaunch_cemu.bat
echo set path="%%PATH%%;%%folder%%\dll\64\;" >> quicklaunch_cemu.bat
echo cls >> quicklaunch_cemu.bat
echo start .\bin\cemu\Cemu.exe >> quicklaunch_cemu.bat
echo exit >> quicklaunch_cemu.bat
echo A QUICKLAUNCHER HAS BEEN WRITTEN TO: quicklaunch_cemu.bat
echo ENTER TO CONTINUE & pause>nul:
exit /b 2

:d
:UpgradeCemu
title Portable Cemu Launcher - Expiremental Edition - Cemu Update Check
if exist index.html del index.html
call :HelperDownload "https://cemu.info/#Download" "index.html"
for /f tokens^=2delims^=^" %%A in (
  'findstr /i /c:"https://cemu.info/releases/" /c:"http://cemu.info/releases/" index.html'
) Do > .\doc\cemu_link.txt Echo:%%A
set /p cemu_link=<.\doc\cemu_link.txt
set "cemu_zip=!cemu_link:~27,20!"
if exist index.html del index.html
cls
set broke=0
if exist .\extra\!cemu_zip! (
  echo cemu is updated.
  pause
  exit /b
)
cls
set "cemu_txt=!cemu_zip:~0,-4!"
set "cemu_txt=!cemu_txt:.=_!"
set "cemu_txt=http://cemu.info/changelog/!cemu_txt!.txt"
echo "!cemu_zip!"
echo "!cemu_txt!"
echo "!cemu_txt:~27!"
if not exist ".\doc\!cemu_txt:~27!" call :HelperDownload "!cemu_txt!" "!cemu_txt:~27!" & move "!cemu_txt:~27!" ".\doc\!cemu_txt:~27!"
if exist batch-read.bat pause & call batch-read ".\doc\!cemu_txt:~27!" 10 1
echo upgrading to cemu v!cemu_zip:~5,-4!
del /q cemu*.zip>nul:
call :HelperDownload "!cemu_link!" "!cemu_zip!"
if not exist !cemu_zip! call :ErrorOffline & (goto) 2>nul
if exist !cemu_zip! move !cemu_zip! .\extra\!cemu_zip!
call :HelperExtract "!folder!\extra\!cemu_zip!" "!folder!\bin\cemu\"
cd bin
if exist cemu cd cemu
if exist "!cemu_zip:~0,-4!" cd "!cemu_zip:~0,-4!"
if exist "!cemu_zip:~0,4!!cemu_zip:~5,-4!" cd "!cemu_zip:~0,4!!cemu_zip:~5,-4!"
if not exist ..\wget.exe (
  if not exist ..\cemu_always_updated.bat (
    xcopy * ..\ /e /i /y
    cd ..
  )
  for /D %%A IN ("cemu*") DO echo rmdir /s /q "%%A"
  if exist "!cemu_zip:~0,-4!" rmdir /s /q "!cemu_zip:~0,-4!"
  if exist "!cemu_zip:~0,4!!cemu_zip:~5,-4!" rmdir /s /q "!cemu_zip:~0,4!!cemu_zip:~5,-4!"
)
if exist ..\wget.exe cd ..
if exist ..\launch_cemu.bat cd ..
(goto) 2>nul

:e
title Portable Cemu Launcher - Helper Edition - Text-Reader Update Check
cls
REM IMPLEMENT THIS LATER
set nag="NOT A FEATURE YET!"
(goto) 2>nul

:f
:ModDownloaderCheck
cls & title Portable Cemu Launcher - Helper Edition - Download Suite
call :HelperDownload "https://github.com/MarioMasta64/ModDownloaderPortable/raw/master/launch_cemu_moddownloader.bat" "launch_cemu_moddownloader.bat.1"
cls & if exist launch_cemu_moddownloader.bat.1 del launch_cemu_moddownloader.bat
cls & start launch_cemu_moddownloader.bat
(goto) 2>nul

REM PROGRAM SPECIFIC STUFF THAT CAN BE EASILY CHANGED BELOW
REM STUFF THAT IS ALMOST IDENTICAL BETWEEN STUFF

:FolderCheck
cls
if not exist .\bin\ mkdir .\bin\
if not exist .\data\ mkdir .\data\
:: dll folder check removed because dll downloader creates it
if not exist .\doc\ mkdir .\doc\
if not exist .\extra\ mkdir .\extra\
if not exist .\helpers\ mkdir .\helpers\
if not exist .\note\ mkdir .\note\
(goto) 2>nul

:Version
cls
echo 34 > .\doc\version.txt
set /p current_version=<.\doc\version.txt
if exist .\doc\version.txt del .\doc\version.txt
:: REPLACE ALL exit /b that dont need an error code (a value after it) with "exit"
(goto) 2>nul

:Credits
cls
if exist .\doc\cemu_license.txt (goto) 2>nul
echo ================================================== > .\doc\cemu_license.txt
echo =              Script by MarioMasta64            = >> .\doc\cemu_license.txt
echo =           Script Version: v%current_version%- release        = >> .\doc\cemu_license.txt
echo ================================================== >> .\doc\cemu_license.txt
echo =You may Modify this WITH consent of the original= >> .\doc\cemu_license.txt
echo = creator, as long as you include a copy of this = >> .\doc\cemu_license.txt
echo =      as you include a copy of the License      = >> .\doc\cemu_license.txt
echo ================================================== >> .\doc\cemu_license.txt
echo =    You may also modify this script without     = >> .\doc\cemu_license.txt
echo =         consent for PERSONAL USE ONLY          = >> .\doc\cemu_license.txt
echo ================================================== >> .\doc\cemu_license.txt
cls
title Portable Cemu Launcher - Helper Edition - About
for /f "DELIMS=" %%i in (.\doc\cemu_license.txt) do (echo %%i)
pause
call :PingInstall
(goto) 2>nul

REM if a script can be used between files then it can be put here and re-written only if it doesnt exist
REM stuff here will not be changed between programs

:SetArch
set arch=32
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
echo %1 > .\helpers\oldtext.txt
echo %1 > .\helpers\newtext.txt
call launch_helpers.bat ReplaceText
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
title Portable Cemu Launcher - Helper Edition - Latest Build :D
echo you are using the latest version!!
echo Current Version: v%current_version%
echo New Version: v%new_version%
echo ENTER TO CONTINUE & pause>nul:
start launch_cemu.bat
exit

:NewUpdate
cls
title Portable Cemu Launcher - Helper Edition - Old Build D:
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
cls & if not exist .\bin\wget.exe call :Download-Wget
cls & title Portable Cemu Launcher - Helper Edition - Updating Launcher
call :HelperDownload "https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/launch_cemu.bat" "launch_cemu.bat.1"
cls & if exist launch_cemu.bat.1 goto ReplacerCreate
cls & call :ErrorOffline
(goto) 2>nul

:ReplacerCreate
cls
echo @echo off > replacer.bat
echo Color 0A >> replacer.bat
echo del launch_cemu.bat >> replacer.bat
echo rename launch_cemu.bat.1 launch_cemu.bat >> replacer.bat
echo start launch_cemu.bat >> replacer.bat
:: launcher exits, deletes itself, and then exits again. yes. its magic.
echo (goto) 2^>nul ^& del "%%~f0" ^& exit >> replacer.bat
call :HelperHide "replacer.bat"
exit

:PreviewBuild
cls
title Portable Cemu Launcher - Helper Edition - Test Build :0
echo YOURE USING A TEST BUILD MEANING YOURE EITHER
echo CLOSE TO ME OR YOURE SOME SORT OF PIRATE
echo Current Version: v%current_version%
echo New Version: v%new_version%
echo ENTER TO CONTINUE & pause>nul:
start launch_cemu.bat
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
title Portable Cemu Launcher - Helper Edition - Command Prompt - By MarioMasta64
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
echo cls >> relauncher.bat
echo Color 0A >> relaunch.bat
echo start %~f0 >> relaunch.bat
:: launcher exits, deletes itself, and then exits again. yes. its magic.
echo (goto) 2^>nul ^& del "%%~f0" ^& exit >> relaunch.bat
call :HelperHide "relaunch.bat"
exit

:: scripts that are made to cleanup or move directories and files between releases are below

:v19UpgradeCheck
if exist .\bin\temp.txt del .\bin\temp.txt
for /D %%A IN (".\bin\cemu*") DO echo "%%A">.\bin\temp.txt
if exist .\bin\temp.txt set /p dir=<.\bin\temp.txt
if "%dir%"=="".\bin\cemu"" goto Skip-Upgrade
if exist .\bin\temp.txt xcopy %dir%\* .\bin\cemu\ /e /i /y
if exist .\bin\temp.txt rmdir /s /q %dir%
:Skip-Upgrade
if exist .\bin\temp.txt del .\bin\temp.txt
(goto) 2>nul


REM LEFTOVER STUFF, REMOVE EVENTUALLY

:MoTD
if not exist .\bin\wget.exe call :Download-Wget
title checking for message of the day
set program=%~n0>nul:
.\bin\wget.exe -q --show-progress https://github.com/MarioMasta64/EverythingPortable/raw/master/note/motd.txt>nul:
if exist motd.txt del .\note\motd.txt>nul:
if exist motd.txt (
  del /q .\note\motd.txt>nul:
  copy motd.txt .\note\motd.txt
)
if exist .\note\motd.txt for /f "DELIMS=" %%i in ('type .\note\motd.txt') do (set nag=%%i)
del /q motd.txt*>nul:
(goto) 2>nul

REM replace launch_cemu.bat with %~f0
REM because i use the call command. you can edit the file add a label and goto the label by typing it in the menu without even having to close the program cause youre worried about it glitching (put your code on the bottom)
REM add raw before raw/master in everything
REM maybe add option to open mod folder?
REM add new launchers to update check in everything portable
REM the better link: https://raw.githubusercontent.com/MarioMasta64/ModDownloaderPortable/master/mod_list.txt
REM apparently raw is bad before master but only sometimes?
REM raw is perfect for text links tho
