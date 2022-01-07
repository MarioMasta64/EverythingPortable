if "%~1" neq "" (call :%~1 & exit /b !current_version!)
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
if exist .\doc\everything_quicklaunch.txt del .\doc\everything_quicklaunch.txt >nul
set "folder=%~dp0"
set "folder=!folder:~0,-1!"
pushd "!folder!"
call :AlphaToNumber
call :SetArch
call :FolderCheck
call :Version
call :Credits
call :HelperCheck
call :DataUpgrade
call :SettingsCheck

:Menu
cls
title Portable itch.io Launcher - Helper Edition - Main Menu
echo %NAG%
set nag="Selection Time!"
echo 1. reinstall itch.io [will remove itch.io entirely]
echo 2. launch itch.io [launches itch.io]
echo 3. reset itch.io [will remove everything itch.io except the binary]
echo 4. uninstall itch.io [tired of seeing all the porn games?]
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
echo d. check for new itch.io version [automatically check for a new version]
echo.
echo e. install text-reader [update if had]
echo.
echo z. purge current install [ reset, uninstall, and delete launcher]
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
:Reinstallitchio
cls
call :Uninstallitchio
call :Upgradeitchio
exit /b 2

:2
:Launchitchio
if not exist ".\bin\itchio\!arch!\itch.exe" set "nag=PLEASE INSTALL ITCH.IO FIRST" & exit /b 2
title DO NOT CLOSE
cls
echo ITCH.IO IS RUNNING
start "" "!folder!\bin\itchio\!arch!\itch.exe"
exit

:3
if "!NoPrompt!" NEQ "1" (
  cls
  echo %NAG%
  set nag=SELECTION TIME!
  echo DO YOU REALLY WANT TO RESET?
  echo type yes if you want this
  set /p choice="choice: "
  if "%CHOICE%" NEQ "yes" exit /b 2
)
:Resetitchio
cls
taskkill /f /im itch.exe
if exist .\data\Users\MarioMasta64\AppData\Roaming\itch rmdir /s /q .\data\Users\MarioMasta64\AppData\Roaming\itch
exit /b 2

:4
if "!NoPrompt!" NEQ "1" (
  echo %NAG%
  set nag=SELECTION TIME!
  echo DO YOU REALLY WANT TO UNINSTALL?
  echo type yes if you want this
  set /p choice="choice: "
  if "%CHOICE%" NEQ "yes" exit /b 2
)
:Uninstallitchio
cls
taskkill /f /im itch.exe
if exist .\data\Users\MarioMasta64\AppData\Local\itch\ rmdir /s /q .\data\Users\MarioMasta64\AppData\Local\itch\
exit /b 2

:5
:UpdateCheck
if exist version.txt del version.txt >nul
cls
title Portable itch.io Launcher - Helper Edition - Checking For Update
call :HelperDownload "https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/version.txt" "version.txt"
set Counter=0 & for /f "DELIMS=" %%i in ('type version.txt') do (set /a Counter+=1 & set "Line_!Counter!=%%i")
if exist version.txt del version.txt >nul
set new_version=%Line_92%
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
cls & title Portable itch.io Launcher - Helper Edition - Download Dll Downloader
call :HelperDownload "https://raw.githubusercontent.com/MarioMasta64/DLLDownloaderPortable/master/launch_dlldownloader.bat" "launch_dlldownloader.bat.1"
cls & if exist launch_dlldownloader.bat.1 del launch_dlldownloader.bat >nul & rename launch_dlldownloader.bat.1 launch_dlldownloader.bat
cls & start launch_dlldownloader.bat
exit /b 2

:b
:PortableEverything
cls & title Portable itch.io Launcher - Helper Edition - Download Suite
call :HelperDownload "https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/launch_everything.bat" "launch_everything.bat.1"
cls & if exist launch_everything.bat.1 del launch_everything.bat >nul & rename launch_everything.bat.1 launch_everything.bat
cls & start launch_everything.bat
exit /b 2

:c
:QuicklauncherCheck
if not exist .\doc\everything_quicklaunch.txt cls
title Portable itch.io Launcher - Helper Edition - Quicklauncher Writer
echo @echo off>!quick_launcher!
echo Color 0A>>!quick_launcher!
echo cls>>!quick_launcher!
echo set arch=32>>!quick_launcher!
echo if exist "%%PROGRAMFILES(X86)%%" set "arch=64">>!quick_launcher!
echo set "folder=%%CD%%">>!quick_launcher!
echo set "folder=%%folder:~0,-1%%">>!quick_launcher!
echo set "UserProfile=%%folder%%\data\Users\MarioMasta64">>!quick_launcher!
echo set "AppData=%%folder%%\data\Users\MarioMasta64\AppData\Roaming">>!quick_launcher!
echo set "LocalAppData=%%folder%%\data\Users\MarioMasta64\AppData\Local">>!quick_launcher!
echo set "ProgramData=%%folder%%\data\ProgramData">>!quick_launcher!
echo cls>>!quick_launcher!
echo start "" "!folder!\bin\itchio\%%arch%%\itch.exe">>!quick_launcher!
echo exit>>!quick_launcher!
echo A QUICKLAUNCHER HAS BEEN WRITTEN TO:!quick_launcher!
if not exist .\doc\everything_quicklaunch.txt echo ENTER TO CONTINUE & pause >nul
exit /b 2

:d
cls
:Upgradeitchio
title Portable itch.io Launcher - Helper Edition - itch.io Update Check
if exist windows-386 del windows-386 >nul
if exist windows-amd64 del windows-amd64 >nul
call :HelperDownload "https://broth.itch.ovh/itch/windows-386" "windows-386"
call :HelperDownload "https://broth.itch.ovh/itch/windows-amd64" "windows-amd64"
set counter=0
:UpgradeSearchLoop32
set /a counter+=1
for /f tokens^=%counter%delims^=^" %%A in (
  'findstr /i /c:"/itch/windows-386/" windows-386'
) Do > .\doc\itchio_link32.txt Echo:%%A
:ContinueSearch32
set /p itchio_link32=<.\doc\itchio_link32.txt
if "!Debug!" EQU "1" (
  echo !itchio_link32!
  echo !counter!
)
if "!itchio_link32:~0,18!"=="/itch/windows-386/" ( if "!Debug!" EQU "1" ( echo hit ) ) & goto ExitUpgradeSearchLoop32
goto UpgradeSearchLoop32
:ExitUpgradeSearchLoop32
if exist windows-386 del windows-386 >nul
cls
set counter=0
:UpgradeSearchLoop64
set /a counter+=1
for /f tokens^=%counter%delims^=^" %%A in (
  'findstr /i /c:"/itch/windows-amd64/" windows-amd64'
) Do > .\doc\itchio_link64.txt Echo:%%A
:ContinueSearch32
set /p itchio_link64=<.\doc\itchio_link64.txt
if "!Debug!" EQU "1" (
  echo !itchio_link64!
  echo !counter!
)
if "!itchio_link64:~0,20!"=="/itch/windows-amd64/" ( if "!Debug!" EQU "1" ( echo hit ) ) & goto ExitUpgradeSearchLoop64
goto UpgradeSearchLoop64
:ExitUpgradeSearchLoop64
if exist windows-amd64 del windows-amd64 >nul
cls
set "tempstr=!itchio_link32!"
set "result=%tempstr:/=" & set "result=%"
set "itchio_version32=!result!"
set "itchio_link32=https://broth.itch.ovh!itchio_link32!/archive/default"
set "tempstr=!itchio_link64!"
set "result=%tempstr:/=" & set "result=%"
set "itchio_version64=!result!"
set "itchio_link64=https://broth.itch.ovh!itchio_link64!/archive/default"
if "!Debug!" EQU "1" (
  cls
  echo "!itchio_link32!"
  echo "!itchio_version32!"
  echo "!itchio_link64!"
  echo "!itchio_version64!"
  echo PRESS ENTER TO CONTINUE & pause >nul
)
set broke=0
if exist ".\extra\itch-windows-386-!itchio_version32!.zip" (
  if exist ".\extra\itch-windows-amd64-!itchio_version64!.zip" (
    echo itchio is updated.
    pause
    exit /b 2
  )
)
cls
if exist default del default >nul
:Downloaditchio32
echo upgrading to itchio v!itchio_version32! (32-Bit)
call :HelperDownload "!itchio_link32!" "itch-windows-386-!itchio_version32!.zip"
:Moveitchio32
move "default" ".\extra\itch-windows-386-!itchio_version32!.zip"
:Downloaditchio64
echo upgrading to itchio v!itchio_version64! (64-Bit)
call :HelperDownload "!itchio_link64!" "itch-windows-amd64-!itchio_version64!.zip"
:Moveitchio32
move "default" ".\extra\itch-windows-amd64-!itchio_version64!.zip"
:Extractitchio
if not exist .\bin\itchio\ mkdir .\bin\itchio\
call :HelperExtract "!folder!\extra\itch-windows-386-!itchio_version32!.zip" "!folder!\bin\itchio\32\"
call :HelperExtract "!folder!\extra\itch-windows-amd64-!itchio_version64!.zip" "!folder!\bin\itchio\64\"
REM if exist "download@platform=windows" del "download@platform=windows" >nul
REM call :HelperDownload "https://itch.io/app/download?platform=windows" "download@platform=windows"
REM :Moveitchio
REM move "download@platform=windows" ".\extra\itch-setup.exe"
REM :Installitchio
REM .\extra\itch-setup.exe
REM taskkill /f /im itch.exe
REM :Cleanupitchio
REM echo y | reg delete HKEY_USERS\S-1-5-21-1589965034-2326289270-2253047584-1001\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\itch\
:Extractitchio
:NullExtra
if "!NullExtra!" EQU "1" ( echo.>".\extra\itch-windows-386-!itchio_version32!.zip" & echo.>".\extra\itch-windows-amd64-!itchio_version64!.zip")
exit /b 2

:e
title Portable itch.io Launcher - Helper Edition - Text-Reader Update Check
cls
call :HelperDownload "https://mariomasta64.me/batch/text-reader/update-text-reader.bat" "update-text-reader.bat"
start "" "update-text-reader.bat"
exit /b 2

:z
if "!NoPrompt!" NEQ "1" (
  cls
  echo %NAG%
  set nag=SELECTION TIME!
  echo DO YOU REALLY WANT TO PURGE?
  echo type yes if you want this
  set /p choice="choice: "
  if "%CHOICE%" NEQ "yes" exit /b 2
)
:Purgeitchio
call :Resetitchio
call :Uninstallitchio
start /b "" cmd /c del "%~f0"&exit /b
exit /b 2

REM PROGRAM SPECIFIC STUFF THAT CAN BE EASILY CHANGED BELOW
REM STUFF THAT IS ALMOST IDENTICAL BETWEEN STUFF

:FolderCheck
cls
set "AllUsersProfile=!folder!\data\ProgramData"
set "AppData=!folder!\data\Users\MarioMasta64\AppData\Roaming"
set "CommonProgramFiles=!folder!\data\Program Files\Common Files"
set "CommonProgramFiles(x86)=!folder!\data\Program Files (x86)\Common Files"
set "HomeDrive=!folder!\data"
set "HomePath=!folder!\data\Users\MarioMasta64"
set "LocalAppData=!folder!\data\Users\MarioMasta64\AppData\Local"
set "ProgramData=!folder!\data\ProgramData"
set "ProgramFiles=!folder!\data\Program Files"
set "ProgramFiles(x86)=!folder!\data\Program Files (x86)"
set "ProgramW6432=!folder!\data\ProgramData"
REM set "SystemDrive=!folder!\data"
REM set "SystemRoot=!folder!\Windows"
set "UserName=MarioMasta64"
if "!UserProfile!" neq "!folder!\data\Users\MarioMasta64" set "RealUserProfile=!UserProfile!"
set "UserProfile=!folder!\data\Users\MarioMasta64"
if not exist .\bin\ mkdir .\bin\
if not exist .\data\ mkdir .\data\
if not exist .\doc\ mkdir .\doc\
if not exist .\extra\ mkdir .\extra\
if not exist .\helpers\ mkdir .\helpers\
if not exist .\ini\ mkdir .\ini\
if not exist .\note\ mkdir .\note\
if not exist ".\data\Program Files\Common Files\" mkdir ".\data\Program Files\Common Files\"
if not exist ".\data\Program Files (x86)\Common Files\" mkdir ".\data\Program Files (x86)\Common Files\"
if not exist ".\data\ProgramData\" mkdir ".\data\ProgramData\"
if not exist ".\data\Users\MarioMasta64\" mkdir ".\data\Users\MarioMasta64\"
if not exist ".\data\Users\MarioMasta64\AppData\Local\" mkdir ".\data\Users\MarioMasta64\AppData\Local\"
if not exist ".\data\Users\MarioMasta64\AppData\Roaming\" mkdir ".\data\Users\MarioMasta64\AppData\Roaming\"
if not exist ".\data\Users\MarioMasta64\3D Objects\" mkdir ".\data\Users\MarioMasta64\3D Objects\"
if not exist ".\data\Users\MarioMasta64\Contacts\" mkdir ".\data\Users\MarioMasta64\Contacts\"
if not exist ".\data\Users\MarioMasta64\Desktop\" mkdir ".\data\Users\MarioMasta64\Desktop\"
if not exist ".\data\Users\MarioMasta64\Documents\" mkdir ".\data\Users\MarioMasta64\Documents\"
if not exist ".\data\Users\MarioMasta64\Downloads\" mkdir ".\data\Users\MarioMasta64\Downloads\"
if not exist ".\data\Users\MarioMasta64\Favorites\" mkdir ".\data\Users\MarioMasta64\Favorites\"
if not exist ".\data\Users\MarioMasta64\Links\" mkdir ".\data\Users\MarioMasta64\Links\"
if not exist ".\data\Users\MarioMasta64\Music\" mkdir ".\data\Users\MarioMasta64\Music\"
if not exist ".\data\Users\MarioMasta64\OneDrive\" mkdir ".\data\Users\MarioMasta64\OneDrive\"
if not exist ".\data\Users\MarioMasta64\Pictures\" mkdir ".\data\Users\MarioMasta64\Pictures\"
if not exist ".\data\Users\MarioMasta64\Saved Games\" mkdir ".\data\Users\MarioMasta64\Saved Games\"
if not exist ".\data\Users\MarioMasta64\Searches\" mkdir ".\data\Users\MarioMasta64\Searches\"
if not exist ".\data\Users\MarioMasta64\Videos\" mkdir ".\data\Users\MarioMasta64\Videos\"
if not exist ".\bin\itchio\!arch!\itch.exe" set nag=ITCH.IO IS NOT INSTALLED CHOOSE "D"
if exist ".\data\Users\MarioMasta64\AppData\Local\itch\" rmdir /s /q ".\data\Users\MarioMasta64\AppData\Local\itch\"
exit /b 2

:SettingsCheck
if exist .\ini\settings.ini (
  for /f %%C in ('Find /v /c "" ^< .\ini\settings.ini') do set Count=%%C
  for /F "delims=" %%i in (.\ini\settings.ini) do set "lastline=%%i"
) else (
  set Count=0
)
:Setting1
if "!Count!" LSS "2" (
>.\ini\settings.ini (echo // Nulls Future Items Put In .\extra\ To Save Space)
>>.\ini\settings.ini (echo "NullExtra", 0)
)
set "NullExtra=" & for /F "skip=1 delims=" %%k in (.\ini\settings.ini) do ( set "NullExtra=%%k" & set "NullExtra=!NullExtra:~-1!" & goto :Setting2 )
:Setting2
if "!Count!" LSS "4" (
>>.\ini\settings.ini (echo // Debug)
>>.\ini\settings.ini (echo "Debug", 0)
)
set "Debug=" & for /F "skip=3 delims=" %%k in (.\ini\settings.ini) do ( set "Debug=%%k" & set "Debug=!Debug:~-1!" & goto :Setting3 )
:Setting3
if "!Count!" LSS "6" (
>>.\ini\settings.ini (echo // Do Not Prompt For Confirmation [DANGEROUS])
>>.\ini\settings.ini (echo "NoPrompt", 0)
)
set "NoPrompt=" & for /F "skip=5 delims=" %%l in (.\ini\settings.ini) do ( set "NoPrompt=%%l" & set "NoPrompt=!NoPrompt:~-1!" & goto :Setting4 )
:Setting4
exit /b 2

:Version
echo 7 > .\doc\version.txt
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
title Portable itch.io Launcher - Helper Edition - About
for /f "DELIMS=" %%i in (!license!) do (echo %%i)
pause
call :PingInstall
exit /b 2

REM if a script can be used between files then it can be put here and re-written only if it doesnt exist
REM stuff here will not be changed between programs

:SetArch
set arch=
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
echo 1> .\helpers\version.txt
echo %1> .\helpers\download.txt
echo %2> .\helpers\file.txt
call "!folder!\launch_helpers.bat" Download
exit /b 2

:HelperDownloadWget
REM v3+ Required
echo 3> .\helpers\version.txt
call "!folder!\launch_helpers.bat" DownloadWget
exit /b 2

:HelperExtract
REM v1+ Required
echo 1> .\helpers\version.txt
echo %1> .\helpers\file.txt
echo %2> .\helpers\folder.txt
call "!folder!\launch_helpers.bat" Extract
exit /b 2

:HelperExtract7Zip
REM v3+ Required
echo 3> .\helpers\version.txt
echo %1> .\helpers\file.txt
echo %2> .\helpers\folder.txt
call "!folder!\launch_helpers.bat" Extract7Zip
exit /b 2

:HelperHide
REM v4+ Required
echo 4> .\helpers\version.txt
echo %1> .\helpers\file.txt
call "!folder!\launch_helpers.bat" Hide
exit /b 2

:HelperReplaceText
REM v5+ Required
echo 5> .\helpers\version.txt
echo %1> .\helpers\file.txt
echo %2> .\helpers\oldtext.txt
echo %3> .\helpers\newtext.txt
call "!folder!\launch_helpers.bat" ReplaceText
exit /b 2

:HelperExtractInno
REM v8+ Required
echo 8> .\helpers\version.txt
echo %1> .\helpers\file.txt
echo %2> .\helpers\folder.txt
call "!folder!\launch_helpers.bat" ExtractInno
exit /b 2

:HelperDownloadJava
REM v10+ Required But Always Updated Anyways
echo 9999> .\helpers\version.txt
call "!folder!\launch_helpers.bat" DownloadJava
exit /b 2

:HelperExtractDirectX
REM v11+ Required
echo 11> .\helpers\version.txt
echo %1> .\helpers\file.txt
echo %2> .\helpers\folder.txt
call "!folder!\launch_helpers.bat" ExtractDirectX
exit /b 2

:HelperExtractMSI
REM v11+ Required
echo 11> .\helpers\version.txt
echo %1> .\helpers\file.txt
echo %2> .\helpers\folder.txt
call "!folder!\launch_helpers.bat" ExtractMSI
exit /b 2

:HelperExtractWix
REM v11+ Required
echo 11> .\helpers\version.txt
echo %1> .\helpers\file.txt
echo %2> .\helpers\folder.txt
call "!folder!\launch_helpers.bat" ExtractWix
exit /b 2

:Test
REM call :HelperRunAsAdmin "cmd" "/c !systemroot!\notepad.exe !folder!\helpers\runasadmin.vbs" "0"
call :HelperRunAsAdmin "!systemroot!\notepad.exe" "!folder!\helpers\runasadmin.vbs" "0"
pause
exit /b 2

:HelperRunAsAdmin
REM v17+ Required
echo 17> .\helpers\version.txt
echo %1> .\helpers\command.txt
echo %2> .\helpers\params.txt
echo "!folder!"> .\helpers\folder.txt
echo %3> .\helpers\mode.txt
call "!folder!\launch_helpers.bat" RunAsAdmin
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
call "!folder!\launch_helpers.bat" DownloadWget
exit /b 2

:LatestBuild
cls
title Portable itch.io Launcher - Helper Edition - Latest Build :D
echo you are using the latest version!!
echo Current Version: v%current_version%
echo New Version: v%new_version%
echo ENTER TO CONTINUE & pause >nul
start "" "!main_launcher!"
exit

:NewUpdate
cls
title Portable itch.io Launcher - Helper Edition - Old Build D:
if "!NoPrompt!" NEQ "1" (
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
)

:UpdateNow
cls & title Portable itch.io Launcher - Helper Edition - Updating Launcher
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
title Portable itch.io Launcher - Helper Edition - Test Build :0
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
title Portable itch.io Launcher - Helper Edition - Command Prompt - By MarioMasta64
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

:DataUpgrade
cls
echo PLEASE WAIT.. UPGRADING DATA FOLDER
REM if move failed (which it does do sometimes for MANY dumb reasons) continue with xcopy
if exist ".\data\.vscode\" move ".\data\.vscode" ".\data\Users\MarioMasta64"
if exist ".\data\.vscode\" xcopy ".\data\.vscode\" ".\data\Users\MarioMasta64\.vscode\" /e /i /y & rmdir /s /q ".\data\.vscode\"
if exist ".\data\3D Objects\" move ".\data\3D Objects" ".\data\Users\MarioMasta64"
if exist ".\data\3D Objects\" xcopy ".\data\3D Objects\" ".\data\Users\MarioMasta64\3D Objects\" /e /i /y & rmdir /s /q ".\data\3D Objects\"
if exist ".\data\AppData\" move ".\data\AppData" ".\data\Users\MarioMasta64"
if exist ".\data\AppData\" xcopy ".\data\AppData\" ".\data\Users\MarioMasta64\AppData\" /e /i /y & rmdir /s /q ".\data\AppData\"
if exist ".\data\Contacts\" move ".\data\Contacts" ".\data\Users\MarioMasta64"
if exist ".\data\Contacts\" xcopy ".\data\Contacts\" ".\data\Users\MarioMasta64\Contacts\" /e /i /y & rmdir /s /q ".\data\Contacts\"
if exist ".\data\Cookies\" move ".\data\Cookies" ".\data\Users\MarioMasta64"
if exist ".\data\Cookies\" xcopy ".\data\Cookies\" ".\data\Users\MarioMasta64\Cookies\" /e /i /y & rmdir /s /q ".\data\Cookies\"
if exist ".\data\Desktop\" move ".\data\Desktop" ".\data\Users\MarioMasta64"
if exist ".\data\Desktop\" xcopy ".\data\Desktop\" ".\data\Users\MarioMasta64\Desktop\" /e /i /y & rmdir /s /q ".\data\Desktop\"
if exist ".\data\Documents\" move ".\data\Documents" ".\data\Users\MarioMasta64"
if exist ".\data\Documents\" xcopy ".\data\Documents\" ".\data\Users\MarioMasta64\Documents\" /e /i /y & rmdir /s /q ".\data\Documents\"
if exist ".\data\Downloads\" move ".\data\Downloads" ".\data\Users\MarioMasta64"
if exist ".\data\Downloads\" xcopy ".\data\Downloads\" ".\data\Users\MarioMasta64\Downloads\" /e /i /y & rmdir /s /q ".\data\Downloads\"
if exist ".\data\Favorites\" move ".\data\Favorites" ".\data\Users\MarioMasta64"
if exist ".\data\Favorites\" xcopy ".\data\Favorites\" ".\data\Users\MarioMasta64\Favorites\" /e /i /y & rmdir /s /q ".\data\Favorites\"
if exist ".\data\Links\" move ".\data\Links" ".\data\Users\MarioMasta64"
if exist ".\data\Links\" xcopy ".\data\Links\" ".\data\Users\MarioMasta64\Links\" /e /i /y & rmdir /s /q ".\data\Links\"
if exist ".\data\Local Settings\" move ".\data\Local Settings" ".\data\Users\MarioMasta64"
if exist ".\data\Local Settings\" xcopy ".\data\Local Settings\" ".\data\Users\MarioMasta64\Local Settings\" /e /i /y & rmdir /s /q ".\data\Local Settings\"
if exist ".\data\Music\" move ".\data\Music" ".\data\Users\MarioMasta64"
if exist ".\data\Music\" xcopy ".\data\Music\" ".\data\Users\MarioMasta64\Music\" /e /i /y & rmdir /s /q ".\data\Music\"
if exist ".\data\OneDrive\" move ".\data\OneDrive" ".\data\Users\MarioMasta64"
if exist ".\data\OneDrive\" xcopy ".\data\OneDrive\" ".\data\Users\MarioMasta64\OneDrive\" /e /i /y & rmdir /s /q ".\data\OneDrive\"
if exist ".\data\Pictures\" move ".\data\Pictures" ".\data\Users\MarioMasta64"
if exist ".\data\Pictures\" xcopy ".\data\Pictures\" ".\data\Users\MarioMasta64\Pictures\" /e /i /y & rmdir /s /q ".\data\Pictures\"
if exist ".\data\Saved Games\" move ".\data\Saved Games" ".\data\Users\MarioMasta64"
if exist ".\data\Saved Games\" xcopy ".\data\Saved Games\" ".\data\Users\MarioMasta64\Saved Games\" /e /i /y & rmdir /s /q ".\data\Saved Games\"
if exist ".\data\Searches\" move ".\data\Searches" ".\data\Users\MarioMasta64"
if exist ".\data\Searches\" xcopy ".\data\Searches\" ".\data\Users\MarioMasta64\Searches\" /e /i /y & rmdir /s /q ".\data\Searches\"
if exist ".\data\Videos\" move ".\data\Videos" ".\data\Users\MarioMasta64"
if exist ".\data\Videos\" xcopy ".\data\Videos\" ".\data\Users\MarioMasta64\Videos\" /e /i /y & rmdir /s /q ".\data\Videos\"
if exist ".\Users\" move ".\Users" ".\data"
if exist ".\Users\" xcopy ".\Users\" ".\data\Users\" /e /i /y & rmdir /s /q ".\Users\"
exit /b 2