if "%~1" neq "" (call :%~1 & exit /b %current_version%)
@echo off
setlocal enabledelayedexpansion
setlocal enableextensions
Color 0A
cls
set nag=Finally Getting Updates After 4 Years (Helper Update)
set new_version=OFFLINE_OR_NO_UPDATES
set "name=%~n0"
set "name=!name:launch_=!"
set "license=.\doc\!name!_license.txt"
set "main_launcher=%~n0.bat"
set "poc_launcher=%~n0_poc.bat"
set "quick_launcher=quick%~n0.bat"
if exist replacer.bat del replacer.bat >nul
if exist !poc_launcher! del !poc_launcher! >nul
set "folder=%CD%"
if "%CD%"=="%~d0\" set "folder=%CD:~0,2%"
call :AlphaToNumber
call :SetArch
call :FolderCheck
call :Version
call :Credits
call :HelperCheck

:Menu
cls
title Portable Vscode Launcher - Helper Edition - Main Menu
echo %NAG%
set nag="Selection Time!"
echo 1. reinstall vscode [will remove vscode entirely]
echo 2. launch vscode [launches vscode]
echo 3. reset vscode [will remove everything vscode except the binary]
echo 4. uninstall vscode [switching your ide?]
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
echo d. check for new vscode version [automatically check for a new version]
echo.
echo e. install text-reader [update if had]
echo.
echo f. backup vscode folder [just in case]
echo g. restore vscode folder [fucked up(?)]
echo.
set /p choice="enter your choice and press enter to confirm: "
:: sets errorlevel to 0 (?)
ver >nul
:: an incorrect call throws an errorlevel of 1
call :%choice%
REM if "%ERRORLEVEL%" NEQ "2" set nag="PLEASE Select A CHOICE 1-7 or a/b/c/d/e"
goto Menu

:Null
cls
set nag="NOT A FEATURE YET!"
exit /b 2

:1
:ReinstallVscode
cls
call :UninstallVscode
call :UpgradeVscode
exit /b 2

:2
:LaunchVscode
if not exist ".\bin\vscode!arch!\Code.exe" set "nag=PLEASE INSTALL VSCODE FIRST" & exit /b 2
title DO NOT CLOSE
cls
echo VSCODE IS RUNNING
start "" ".\bin\vscode!arch!\Code.exe"
exit

:3
:ResetVscode
taskkill /f /im Code.exe
if exist .\data\.vscode\ rmdir /s /q .\data\.vscode\
if exist .\data\AppData\Roaming\Code\ rmdir /s /q .\data\AppData\Roaming\Code\
exit /b 2

:4
:UninstallVscode
taskkill /f /im Code.exe
if exist .\bin\vscode* rmdir /s /q .\bin\vscode*
exit /b 2

:5
:UpdateCheck
if exist version.txt del version.txt >nul
cls
title Portable Vscode Launcher - Helper Edition - Checking For Update
call :HelperDownload "https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/version.txt" "version.txt"
set Counter=0 & for /f "DELIMS=" %%i in ('type version.txt') do (set /a Counter+=1 & set "Line_!Counter!=%%i")
if exist version.txt del version.txt >nul
set new_version=%Line_24%
if "%new_version%"=="OFFLINE" call :ErrorOffline & exit /b 2
if %current_version% EQU %new_version% call :LatestBuild & exit /b 2
if %current_version% LSS %new_version% call :NewUpdate & exit /b 2
if %current_version% GTR %new_version% call :PreviewBuild & exit /b 2
call :ErrorOffline & exit /b 2
exit /b 2

:6
:About
cls
if exist !license! del !license! >nul
start "" "!main_launcher!"
exit

:7
exit

:a
:DLLDownloaderCheck
cls & title Portable Vscode Launcher - Helper Edition - Download Dll Downloader
call :HelperDownload "https://raw.githubusercontent.com/MarioMasta64/DLLDownloaderPortable/master/launch_dlldownloader.bat" "launch_dlldownloader.bat.1"
cls & if exist launch_dlldownloader.bat.1 del launch_dlldownloader.bat >nul & rename launch_dlldownloader.bat.1 launch_dlldownloader.bat
cls & start launch_dlldownloader.bat
exit /b 2

:b
:PortableEverything
cls & title Portable Vscode Launcher - Helper Edition - Download Suite
call :HelperDownload "https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/launch_everything.bat" "launch_everything.bat.1"
cls & if exist launch_everything.bat.1 del launch_everything.bat >nul & rename launch_everything.bat.1 launch_everything.bat
cls & start launch_everything.bat
exit /b 2

:c
:QuicklauncherCheck
cls
title Portable Vscode Launcher - Helper Edition - QuickLauncher Writer
echo @echo off>!quick_launcher!
echo Color 0A>>!quick_launcher!
echo cls>>!quick_launcher!
echo set arch=32>>!quick_launcher!
echo if exist "%%PROGRAMFILES(X86)%%" set "arch=64">>!quick_launcher!
echo title DO NOT CLOSE>>!quick_launcher!
echo set "folder=%%CD%%">>!quick_launcher!
echo if "%%CD%%"=="%%~d0\" set "folder=%%CD:~0,2%%">>!quick_launcher!
echo set "UserProfile=%%folder%%\data">>!quick_launcher!
echo set "AppData=%%folder%%\data\AppData\Roaming">>!quick_launcher!
echo set "LocalAppData=%%folder%%\data\AppData\Local">>!quick_launcher!
echo set "ProgramData=%%folder%%\data\ProgramData">>!quick_launcher!
echo cls>>!quick_launcher!
echo echo VSCODE IS RUNNING>>!quick_launcher!
echo start .\bin\vscode%%arch%%\Code.exe>>!quick_launcher!
echo exit>>!quick_launcher!
echo A QUICKLAUNCHER HAS BEEN WRITTEN TO:!quick_launcher!
echo ENTER TO CONTINUE & pause >nul
exit

:d
:UpgradeVscode
REM if "!arch!"=="32" set "LinkID=623231"
REM if "!arch!"=="64" set "LinkID=852157"
set ArchAdd=
if "!arch!"=="64" set "ArchAdd=-x64"
REM Backwards Compatibility Fix For vscode.zip (Only 32-Bit At That Time)
if exist "vscode.zip" del "vscode.zip" >nul
if exist "index.html@LinkID=!LinkID!" del "index.html@LinkID=!LinkID!" >nul
if exist "vscode!arch!.zip" del "vscode!arch!.zip" >nul
REM if exist "vscode!arch!.exe" del "vscode!arch!.zip" >nul
REM call :HelperDownload "https://go.microsoft.com/fwlink/?LinkID=!LinkID!" "index.ht2ml@LinkID=!LinkID!"
call :HelperDownload "https://code.visualstudio.com/sha/download?build=stable&os=win32!ArchAdd!-archive" "vscode!arch!.zip"
:MoveVscode
REM move "index.html@LinkID=!LinkID!" ".\extra\vscode!arch!.exe"
move "download@build=stable&os=win32!ArchAdd!-archive" ".\extra\vscode!arch!.zip"
:ExtractVscode
REM call :HelperExtract7Zip "!folder!\extra\vscode!arch!.exe" "!folder!\bin\vscode!arch!\"
call :HelperExtract "!folder!\extra\vscode!arch!.zip" "!folder!\bin\vscode!arch!\"
exit /b 2

:e
title Portable Vscode Launcher - Helper Edition - Text-Reader Update Check
cls
call :HelperDownload "https://mariomasta64.me/batch/text-reader/update-text-reader.bat" "update-text-reader.bat"
start "" "update-text-reader.bat"
exit /b 2

:f
:BackupVscodeFolder
:: title PORTABLE VSCODE LAUNCHER - BACKING UP VSCODE FOLDER...
echo make sure
echo "!folder!\data\.vscode\"
echo contains your data before pressing enter
pause >nul
cls
echo BACKING UP VSCODE
if exist .\backup\.vscode\ rmdir /s /q .\backup\.vscode\
mkdir .\backup\.vscode\
xcopy .\data\.vscode\* .\backup\.vscode\ /e /i /y
exit /b 2

:g
:RestoreVscodeFolder
:: title PORTABLE VSCODE LAUNCHER - RESTORING VSCODE FOLDER...
echo make sure
echo "!folder!\backup\.vscode\"
echo contains your data before pressing enter
pause >nul
cls
echo RESTORING VSCODE
if exist .\data\.vscode\ rmdir /s /q .\data\.vscode\
mkdir .\data\.vscode\
xcopy .\backup\.vscode\* .\data\.vscode\ /e /i /y
exit /b 2

REM PROGRAM SPECIFIC STUFF THAT CAN BE EASILY CHANGED BELOW
REM STUFF THAT IS ALMOST IDENTICAL BETWEEN STUFF

:FolderCheck
cls
set "UserProfile=!folder!\data"
set "AppData=!folder!\data\AppData\Roaming"
set "LocalAppData=!folder!\data\AppData\Local"
set "ProgramData=!folder!\data\ProgramData"
if not exist .\bin\ mkdir .\bin\
if not exist .\data\ mkdir .\data\
if not exist .\doc\ mkdir .\doc\
if not exist .\extra\ mkdir .\extra\
if not exist .\helpers\ mkdir .\helpers\
if not exist .\ini\ mkdir .\ini\
if not exist .\note\ mkdir .\note\
if not exist .\data\AppData\Local\ mkdir .\data\AppData\Local\
if not exist .\data\AppData\Roaming\ mkdir .\data\AppData\Roaming\
if not exist .\data\ProgramData\ mkdir .\data\ProgramData\
if not exist ".\data\3D Objects\" mkdir ".\data\3D Objects\"
if not exist ".\data\Contacts\" mkdir ".\data\Contacts\"
if not exist ".\data\Desktop\" mkdir ".\data\Desktop\"
if not exist ".\data\Documents\" mkdir ".\data\Documents\"
if not exist ".\data\Downloads\" mkdir ".\data\Downloads\"
if not exist ".\data\Favorites\" mkdir ".\data\Favorites\"
if not exist ".\data\Links\" mkdir ".\data\Links\"
if not exist ".\data\Music\" mkdir ".\data\Music\"
if not exist ".\data\OneDrive\" mkdir ".\data\OneDrive\"
if not exist ".\data\Pictures\" mkdir ".\data\Pictures\"
if not exist ".\data\Saved Games\" mkdir ".\data\Saved Games\"
if not exist ".\data\Searches\" mkdir ".\data\Searches\"
if not exist ".\data\Videos\" mkdir ".\data\Videos\"
if exist .\bin\Code.exe call :PoCv1Upgrade
if exist .\data\AppData\Local\Code\ call :PoCv2Upgrade
if exist .\bin\vscode\ call :Releasev6Upgrade
if not exist ".\bin\vscode!arch!\Code.exe" set nag=VSCODE IS NOT INSTALLED CHOOSE "D"
exit /b 2

:Version
echo 14 > .\doc\version.txt
set /p current_version=<.\doc\version.txt
if exist .\doc\version.txt del .\doc\version.txt >nul
exit /b 2

:Credits
cls
if exist !license! exit /b 2
echo ================================================== > !license!
echo =              Script by MarioMasta64            = >> !license!
set "extra_space="
if %current_version% LSS 10 set "extra_space= "
echo =           Script Version: v%current_version%- release        %extra_space%= >> !license!
echo ================================================== >> !license!
echo =You may Modify this WITH consent of the original= >> !license!
echo = creator, as long as you include a copy of this = >> !license!
echo =      as you include a copy of the License      = >> !license!
echo ================================================== >> !license!
echo =    You may also modify this script without     = >> !license!
echo =         consent for PERSONAL USE ONLY          = >> !license!
echo ================================================== >> !license!
cls
title Portable Vscode Launcher - Helper Edition - About
for /f "DELIMS=" %%i in (!license!) do (echo %%i)
pause
call :PingInstall
exit /b 2

REM if a script can be used between files then it can be put here and re-written only if it doesnt exist
REM stuff here will not be changed between programs

:SetArch
set arch=32
if exist "%PROGRAMFILES(X86)%" set "arch=64"
exit /b 2

:HelperCheck
if not exist launch_helpers.bat call :DownloadHelpers
exit /b 2
:DownloadHelpers
if not exist .\helpers\download.vbs call :CreateDownloadVBS
cscript .\helpers\download.vbs https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/launch_helpers.bat launch_helpers.bat >nul
exit /b 2
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
exit /b 2

:HelperDownload
REM v1+ Required
echo 1 > .\helpers\version.txt
echo %1 > .\helpers\download.txt
echo %2 > .\helpers\file.txt
call launch_helpers.bat Download
exit /b 2

:HelperDownloadWget
REM v3+ Required
echo 3 > .\helpers\version.txt
call launch_helpers.bat DownloadWget
exit /b 2

:HelperExtract
REM v1+ Required
echo 1 > .\helpers\version.txt
echo %1 > .\helpers\file.txt
echo %2 > .\helpers\folder.txt
call launch_helpers.bat Extract
exit /b 2

:HelperExtract7Zip
REM v3+ Required
echo 3 > .\helpers\version.txt
echo %1 > .\helpers\file.txt
echo %2 > .\helpers\folder.txt
call launch_helpers.bat Extract7Zip
exit /b 2

:HelperHide
REM v4+ Required
echo 4 > .\helpers\version.txt
echo %1 > .\helpers\file.txt
call launch_helpers.bat Hide
exit /b 2

:HelperReplaceText
REM v5+ Required
echo 5 > .\helpers\version.txt
echo %1 > .\helpers\file.txt
echo %2 > .\helpers\oldtext.txt
echo %3 > .\helpers\newtext.txt
call launch_helpers.bat ReplaceText
exit /b 2

:HelperExtractInno
REM v8+ Required
echo 8 > .\helpers\version.txt
echo %1 > .\helpers\file.txt
echo %2 > .\helpers\folder.txt
call launch_helpers.bat ExtractInno
exit /b 2

:HelperDownloadJava
REM v10+ Required But Always Updated Anyways
echo 9999 > .\helpers\version.txt
call launch_helpers.bat DownloadJava
exit /b 2

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
if exist new_install.php del new_install.php >nul
if exist serial.txt del serial.txt >nul
REM call :HelperDownload "https://mariomasta64.me/install/new_install.php?program=%program:~7%^&serial=%sha1%" "new_install.php"
if exist new_install.php del new_install.php >nul
if exist serial.txt del serial.txt >nul
exit /b 2

:UpdateWget
cls
call launch_helpers.bat DownloadWget
exit /b 2

:LatestBuild
cls
title Portable Vscode Launcher - Helper Edition - Latest Build :D
echo you are using the latest version!!
echo Current Version: v%current_version%
echo New Version: v%new_version%
echo ENTER TO CONTINUE & pause >nul
start "" "!main_launcher!"
exit

:NewUpdate
cls
title Portable Vscode Launcher - Helper Edition - Old Build D:
echo %NAG%
set nag="Selection Time!"
echo you are using an older version
echo enter yes or no
echo Current Version: v%current_version%
echo New Version: v%new_version%
set /p choice="Update?: "
if "%choice%"=="yes" call :UpdateNow & exit /b 2
if "%choice%"=="no" exit /b 2
set nag="please enter YES or NO"
goto NewUpdate

:UpdateNow
cls & title Portable Vscode Launcher - Helper Edition - Updating Launcher
call :HelperDownload "https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/!main_launcher!" "!main_launcher!.1"
cls & if exist "!main_launcher!.1" goto ReplacerCreate
cls & call :ErrorOffline
exit /b 2

:ReplacerCreate
cls
echo @echo off > replacer.bat
echo Color 0A >> replacer.bat
echo del "!main_launcher!" >> replacer.bat
echo rename "!main_launcher!.1" "!main_launcher!" >> replacer.bat
echo start "" "!main_launcher!" >> replacer.bat
:: launcher exits, deletes itself, and then exits again. yes. its magic.
echo (goto) 2^ >nul ^& del "%%~f0" ^& exit >> replacer.bat
call :HelperHide "replacer.bat"
exit

:PreviewBuild
cls
title Portable Vscode Launcher - Helper Edition - Test Build :0
echo YOURE USING A TEST BUILD MEANING YOURE EITHER
echo CLOSE TO ME OR YOURE SOME SORT OF PIRATE
echo Current Version: v%current_version%
echo New Version: v%new_version%
echo ENTER TO CONTINUE & pause >nul
start "" "!main_launcher!"
exit

:ErrorOffline
cls
set nag="YOU SEEM TO BE OFFLINE PLEASE RECONNECT TO THE INTERNET TO USE THIS FEATURE"
exit /b 2

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
exit /b 2

:ViewCode
start notepad.exe "%~f0"
exit /b 2

:MakeCopy
:SaveCopy
del "%~f0.bak"
copy "%~f0" "%~f0.bak"
exit /b 2

:Cmd
cls
title Portable Vscode Launcher - Helper Edition - Command Prompt - By MarioMasta64
ver
echo (C) Copyright Microsoft Corporation. All rights reserved
echo.
echo nice job finding me. have fun with my little cmd prompt.
echo upon error (more likely than not) i will return to the menu.
echo type "(goto) 2^ >nul" or make me error to return.
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
echo (goto) 2^ >nul ^& del "%%~f0" ^& exit >> relaunch.bat
call :HelperHide "relaunch.bat"
exit

:PoCv1Upgrade
taskkill /f /im Code.exe
xcopy .\bin\*.pak .\bin\vscode\ /e /i /y
xcopy .\bin\*.dll .\bin\vscode\ /e /i /y
xcopy .\bin\*.dat .\bin\vscode\ /e /i /y
xcopy .\bin\*.bin .\bin\vscode\ /e /i /y
xcopy .\bin\Code.exe .\bin\vscode\ /e /i /y
xcopy .\bin\bin\* .\bin\vscode\bin\ /e /i /y
xcopy .\bin\locales\* .\bin\vscode\locales\ /e /i /y
xcopy .\bin\resources\* .\bin\vscode\resources\ /e /i /y
if exist .\bin\*.pak del .\bin\*.pak >nul
if exist .\bin\*.dll del .\bin\*.dll >nul
if exist .\bin\*.dat del .\bin\*.dat >nul
if exist .\bin\*.bin del .\bin\*.bin >nul
if exist .\bin\Code.exe del .\bin\Code.exe >nul
if exist .\bin\bin\ rmdir /s /q .\bin\bin\
if exist .\bin\locales\ rmdir /s /q .\bin\locales\
if exist .\bin\resources\ rmdir /s /q .\bin\resources\
exit /b 2

:PoCv2Upgrade
taskkill /f /im Code.exe
xcopy .\data\AppData\Local\Code\* .\data\AppData\Roaming\Code\ /e /i /y
if exist .\data\AppData\Local\Code\ rmdir /s /q .\data\AppData\Local\Code\
exit /b 2

:Releasev6Upgrade
taskkill /f /im Code.exe
move .\bin\vscode .\bin\vscode32
exit /b 2