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
call :v30UpgradeCheck

:Menu
cls
title Portable Steam Launcher - Helper Edition - Main Menu
echo !NAG!
set nag="Selection Time!"
echo 1. reinstall steam [will remove steam entirely]
echo 2. launch steam [launches steam]
echo 3. reset steam [will remove everything steam except the binary]
echo 4. uninstall steam [tired of 200GB games?]
echo 5. update script [check for updates]
echo 6. credits [credits]
echo 7. exit [EXIT]
echo.
echo a. download dll's [dll errors anyone?]
echo b. download other projects [check out my other stuff]
echo c. write a quicklauncher [MAKE IT EVEN FASTER]
echo d. check for new steam version [automatically check for a new version]
echo e. install text-reader [update if had]
echo.
echo f. type your steam login [to automatically login between pc]
echo g. remove steam login [to not login automatically]
echo.
echo y. open explorer [open windows explorer to user directory]
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
:ReinstallSteam
cls
call :UninstallSteam
call :UpgradeSteam
exit /b 2

:2
:LaunchSteam
if not exist ".\bin\steam\steam.exe" set "nag=PLEASE INSTALL STEAM FIRST" & exit /b 2
:: title DO NOT CLOSE - Steam is Running
:: xcopy /q ".\data\Users\MarioMasta64\AppData\LocalLow\*" "%UserProfile%\data\AppData\LocalLow" /e /i /y
title DO NOT CLOSE
set "Path=!PATH!;!folder!\dll\32\;"
cls
echo STEAM IS RUNNING
if exist .\ini\steam.ini ( 
  for /f "delims=" %%a in (.\ini\steam.ini) do ( 
    set "a=%%a" 
    if "!a:~1,5!"=="User:" set "user=!a:~6,-1!" 
    if "!a:~1,5!"=="Pass:" set "pass=!a:~6,-1!" 
  ) 
  pushd .\bin\steam\
  start steam.exe -login "!user!" "!pass!"
  popd
)
if not exist .\ini\steam.ini (
  pushd .\bin\steam\
  start steam.exe
  popd
)
REM xcopy /q "%UserProfile%\data\AppData\LocalLow\*" .\data\AppData\LocalLow /e /i /y
REM if exist "%UserProfile%\data\AppData\LocalLow" rmdir /s /q "%UserProfile%\data\AppData\LocalLow"
exit

:3
if "!NoPrompt!" NEQ "1" (
  cls
  echo !NAG!
  set nag=SELECTION TIME!
  echo DO YOU REALLY WANT TO RESET?
  echo type yes if you want this
  set /p choice="choice: "
  if "!CHOICE!" NEQ "yes" exit /b 2
)
:ResetSteam
cls
call :Null
exit /b 2

:4
if "!NoPrompt!" NEQ "1" (
  cls
  echo !NAG!
  set nag=SELECTION TIME!
  echo DO YOU REALLY WANT TO UNINSTALL?
  echo type yes if you want this
  set /p choice="choice: "
  if "!CHOICE!" NEQ "yes" exit /b 2
)
:UninstallSteam
cls
taskkill /f /im steam.exe
if exist .\bin\steam\ rmdir /s /q .\bin\steam\
if exist .\extra\SteamSetup.exe del .\extra\SteamSetup.exe >nul
exit /b 2

:5
:UpdateCheck
if exist version.txt del version.txt >nul
cls
title Portable Steam Launcher - Helper Edition - Checking For Update
call :HelperDownload "https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/version.txt" "version.txt"
set Counter=0 & for /f "DELIMS=" %%i in ('type version.txt') do (set /a Counter+=1 & set "Line_!Counter!=%%i")
if exist version.txt del version.txt >nul
set new_version=%Line_6%
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
cls & title Portable Steam Launcher - Helper Edition - Download Dll Downloader
call :HelperDownload "https://raw.githubusercontent.com/MarioMasta64/DLLDownloaderPortable/master/launch_dlldownloader.bat" "launch_dlldownloader.bat.1"
cls & if exist launch_dlldownloader.bat.1 del launch_dlldownloader.bat >nul & rename launch_dlldownloader.bat.1 launch_dlldownloader.bat
cls & start launch_dlldownloader.bat
exit /b 2

:b
:PortableEverything
cls & title Portable Steam Launcher - Helper Edition - Download Suite
call :HelperDownload "https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/launch_everything.bat" "launch_everything.bat.1"
cls & if exist launch_everything.bat.1 del launch_everything.bat >nul & rename launch_everything.bat.1 launch_everything.bat
cls & start launch_everything.bat
exit /b 2

:c
:QuicklauncherCheck
if not exist .\doc\everything_quicklaunch.txt cls
title Portable Steam Launcher - Helper Edition - Quicklauncher Writer
echo @echo off>!quick_launcher!
echo Color 0A>>!quick_launcher!
echo cls>>!quick_launcher!
echo set "arch=32">>!quick_launcher!
echo if exist "%%PROGRAMFILES(X86)%%" set "arch=64">>!quick_launcher!
REM echo title DO NOT CLOSE - Steam is Running>>!quick_launcher!
REM echo xcopy /q ".\data\Users\MarioMasta64\AppData\LocalLow\*" "%%sUserProfile%%\data\AppData\LocalLow" /e /i /y>>!quick_launcher!
echo set "folder=%%CD%%">>!quick_launcher!
echo set "folder=%%folder:~0,-1%%">>!quick_launcher!
echo set "path=%%PATH%%;%%folder%%\dll\%%arch%%\;">>!quick_launcher!
echo set "UserProfile=%%folder%%\data\Users\MarioMasta64">>!quick_launcher!
echo set "LocalAppData=%%folder%%\data\Users\MarioMasta64\AppData\Local">>!quick_launcher!
echo set "AppData=%%folder%%\data\Users\MarioMasta64\AppData\Roaming">>!quick_launcher!
echo set "ProgramData=%%folder%%\data\ProgramData">>!quick_launcher!
echo setlocal enabledelayedexpansion>>!quick_launcher!
echo if exist .\ini\steam.ini (>>!quick_launcher!
echo   for /f "delims=" %%%%a in (.\ini\steam.ini) do (>>!quick_launcher!
echo     set "a=%%%%a">>!quick_launcher!
echo     if "^!a:~1,5^!"=="User:" set "user=^!a:~6,-1^!">>!quick_launcher!
echo     if "^!a:~1,5^!"=="Pass:" set "pass=^!a:~6,-1^!">>!quick_launcher!
echo   )>>!quick_launcher!
echo   pushd .\bin\steam\>>!quick_launcher!
echo   start steam.exe -login "^!user^!" "^!pass^!">>!quick_launcher!
echo   popd>>!quick_launcher!
echo )>>!quick_launcher!
echo if not exist .\ini\steam.ini (>>!quick_launcher!
echo   pushd .\bin\steam\>>!quick_launcher!
echo   start steam.exe>>!quick_launcher!
echo   popd>>!quick_launcher!
echo )>>!quick_launcher!
REM echo xcopy /q "%%UserProfile%%\data\data\AppData\LocalLow\*" .\data\AppData\locallow /e /i /y>>!quick_launcher!
REM echo if exist "%%UserProfile%%\data\AppData\LocalLow" rmdir /s /q "%%UserProfile%%\data\AppData\LocalLow">>!quick_launcher!
echo exit>>!quick_launcher!
echo A QUICKLAUNCHER HAS BEEN WRITTEN TO:!quick_launcher!
if not exist .\doc\everything_quicklaunch.txt echo ENTER TO CONTINUE & pause >nul
exit /b 2

:d
cls
:UpgradeSteam
title Portable Steam Launcher - Helper Edition - Steam Update Check
if exist SteamSetup.exe del SteamSetup.exe >nul
call :HelperDownload "https://steamcdn-a.akamaihd.net/client/installer/SteamSetup.exe" "SteamSetup.exe"
:MoveSteam
move SteamSetup.exe .\extra\SteamSetup.exe
:ExtractSteam
call :HelperExtract7Zip "!folder!\extra\SteamSetup.exe" "!folder!\bin\steam\"
:NullExtra
if "!NullExtra!" EQU "1" ( echo.>".\extra\SteamSetup.exe")
exit /b 2

:e
title Portable Steam Launcher - Helper Edition - Text-Reader Update Check
cls
call :HelperDownload "https://mariomasta64.me/batch/text-reader/update-text-reader.bat" "update-text-reader.bat"
start "" "update-text-reader.bat"
exit /b 2

:f
cls
title Portable Steam Launcher - Helper Edition - Create steam.ini
set /p username="username: "
set /p password="password: "
echo "User:%username%"> .\ini\steam.ini
echo "Pass:%password%">> .\ini\steam.ini
echo steam login saved to .\ini\steam.ini
echo PRESS ENTER TO CONTINUE & pause >nul
exit /b 2

:g
if exist .\ini\steam.ini del .\ini\steam.ini >nul
exit /b 2

:y
cls
pushd "!Folder!\data\Users\MarioMasta64\"
start cmd /c "explorer.exe !CD!"
popd
exit /b 2

:z
if "!NoPrompt!" NEQ "1" (
  cls
  echo !NAG!
  set nag=SELECTION TIME!
  echo DO YOU REALLY WANT TO PURGE?
  echo type yes if you want this
  set /p choice="choice: "
  if "!CHOICE!" NEQ "yes" exit /b 2
)
:PurgeSteam
call :ResetSteam
call :UninstallSteam
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
if not exist ".\data\Users\MarioMasta64\AppData\Roaming\Microsoft\Windows\Recent\" mkdir ".\data\Users\MarioMasta64\AppData\Roaming\Microsoft\Windows\Recent\"
if not exist ".\bin\steam\steam.exe" set nag=STEAM IS NOT INSTALLED CHOOSE "D"
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
echo 34 > .\doc\version.txt
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
title Portable Steam Launcher - Helper Edition - About
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
title Portable Steam Launcher - Helper Edition - Latest Build :D
echo you are using the latest version!!
echo Current Version: v%current_version%
echo New Version: v%new_version%
echo ENTER TO CONTINUE & pause >nul
start "" "!main_launcher!"
exit

:NewUpdate
cls
title Portable Steam Launcher - Helper Edition - Old Build D:
if "!NoPrompt!" NEQ "1" (
  cls
  echo !NAG!
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
cls & title Portable Steam Launcher - Helper Edition - Updating Launcher
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
title Portable Steam Launcher - Helper Edition - Test Build :0
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
title Portable Steam Launcher - Helper Edition - Command Prompt - By MarioMasta64
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

:: scripts that are made to cleanup or move directories and files between releases are below

:v30UpgradeCheck
if exist "crashhandler.dll" ( xcopy "crashhandler.dll" ".\bin\steam\" /e /i /y & del "crashhandler.dll" >nul )
if exist "crashhandler.dll.old" ( xcopy "crashhandler.dll.old" ".\bin\steam\" /e /i /y & del "crashhandler.dll.old" >nul )
if exist "CSERHelper.dll" ( xcopy "CSERHelper.dll" ".\bin\steam\" /e /i /y & del "CSERHelper.dll" >nul )
if exist "steam.exe.old" ( xcopy "steam.exe.old" ".\bin\steam\" /e /i /y & del "steam.exe.old" >nul )
if exist ".\appcache\" ( xcopy ".\appcache\*" ".\bin\steam\" /e /i /y & rmdir /s /q ".\appcache\" >nul )
if exist "DLLInjector.ini" ( xcopy "DLLInjector.ini" ".\bin\steam\" /e /i /y & del "DLLInjector.ini" >nul )
if exist "fossilize_engine_filters.json" ( xcopy "fossilize_engine_filters.json" ".\bin\steam\" /e /i /y & del "fossilize_engine_filters.json" >nul )
if exist "ThirdPartyLegalNotices.css" ( xcopy "ThirdPartyLegalNotices.css" ".\bin\steam\" /e /i /y & del "ThirdPartyLegalNotices.css" >nul )
if exist ".\depotcache\" ( xcopy ".\depotcache\*" ".\bin\steam\" /e /i /y & rmdir /s /q ".\depotcache\" >nul )
if exist "steamclient.dll" ( xcopy "steamclient.dll" ".\bin\steam\" /e /i /y & del "steamclient.dll" >nul )
if exist "ThirdPartyLegalNotices.doc" ( xcopy "ThirdPartyLegalNotices.doc" ".\bin\steam\" /e /i /y & del "ThirdPartyLegalNotices.doc" >nul )
if exist "vstdlib_s.dll" ( xcopy "vstdlib_s.dll" ".\bin\steam\" /e /i /y & del "vstdlib_s.dll" >nul )
if exist "SDL2_ttf.dll" ( xcopy "SDL2_ttf.dll" ".\bin\steam\" /e /i /y & del "SDL2_ttf.dll" >nul )
if exist "GreenLuma_Reborn.log" ( xcopy "GreenLuma_Reborn.log" ".\bin\steam\" /e /i /y & del "GreenLuma_Reborn.log" >nul )
if exist "GreenLuma_Reborn_x64.dll" ( xcopy "GreenLuma_Reborn_x64.dll" ".\bin\steam\" /e /i /y & del "GreenLuma_Reborn_x64.dll" >nul )
if exist "ThirdPartyLegalNotices.html" ( xcopy "ThirdPartyLegalNotices.html" ".\bin\steam\" /e /i /y & del "ThirdPartyLegalNotices.html" >nul )
if exist ".ntfs_transaction_failed" ( xcopy ".ntfs_transaction_failed" ".\bin\steam\" /e /i /y & del ".ntfs_transaction_failed" >nul )
if exist ".\package\" ( xcopy ".\package\*" ".\bin\steam\" /e /i /y & rmdir /s /q ".\package\" >nul )
if exist "ThirdPartyLegalNotices.css.old" ( xcopy "ThirdPartyLegalNotices.css.old" ".\bin\steam\" /e /i /y & del "ThirdPartyLegalNotices.css.old" >nul )
if exist "ThirdPartyLegalNotices.doc.old" ( xcopy "ThirdPartyLegalNotices.doc.old" ".\bin\steam\" /e /i /y & del "ThirdPartyLegalNotices.doc.old" >nul )
if exist "GameOverlayUI.exe.log.last" ( xcopy "GameOverlayUI.exe.log.last" ".\bin\steam\" /e /i /y & del "GameOverlayUI.exe.log.last" >nul )
if exist "ThirdPartyLegalNotices.html.old" ( xcopy "ThirdPartyLegalNotices.html.old" ".\bin\steam\" /e /i /y & del "ThirdPartyLegalNotices.html.old" >nul )
if exist "libavcodec-58.dll" ( xcopy "libavcodec-58.dll" ".\bin\steam\" /e /i /y & del "libavcodec-58.dll" >nul )
if exist "libx264-142.dll" ( xcopy "libx264-142.dll" ".\bin\steam\" /e /i /y & del "libx264-142.dll" >nul )
if exist "libavcodec-58.dll.old" ( xcopy "libavcodec-58.dll.old" ".\bin\steam\" /e /i /y & del "libavcodec-58.dll.old" >nul )
if exist "Steam2.dll.old" ( xcopy "Steam2.dll.old" ".\bin\steam\" /e /i /y & del "Steam2.dll.old" >nul )
if exist "NoHook.bin" ( xcopy "NoHook.bin" ".\bin\steam\" /e /i /y & del "NoHook.bin" >nul )
if exist "openvr_api.dll" ( xcopy "openvr_api.dll" ".\bin\steam\" /e /i /y & del "openvr_api.dll" >nul )
if exist "steamwebrtc.dll" ( xcopy "steamwebrtc.dll" ".\bin\steam\" /e /i /y & del "steamwebrtc.dll" >nul )
if exist "icui18n.dll.old" ( xcopy "icui18n.dll.old" ".\bin\steam\" /e /i /y & del "icui18n.dll.old" >nul )
if exist "ssfn32150490844543315" ( xcopy "ssfn32150490844543315" ".\bin\steam\" /e /i /y & del "ssfn32150490844543315" >nul )
if exist "icuuc.dll.old" ( xcopy "icuuc.dll.old" ".\bin\steam\" /e /i /y & del "icuuc.dll.old" >nul )
if exist "steam.exe" ( xcopy "steam.exe" ".\bin\steam\" /e /i /y & del "steam.exe" >nul )
if exist "v8.dll.old" ( xcopy "v8.dll.old" ".\bin\steam\" /e /i /y & del "v8.dll.old" >nul )
if exist "VkLayer_steam_fossilize.dll" ( xcopy "VkLayer_steam_fossilize.dll" ".\bin\steam\" /e /i /y & del "VkLayer_steam_fossilize.dll" >nul )
if exist "SteamOverlayVulkanLayer.dll" ( xcopy "SteamOverlayVulkanLayer.dll" ".\bin\steam\" /e /i /y & del "SteamOverlayVulkanLayer.dll" >nul )
if exist "libavformat-58.dll.old" ( xcopy "libavformat-58.dll.old" ".\bin\steam\" /e /i /y & del "libavformat-58.dll.old" >nul )
if exist "SteamFossilizeVulkanLayer.json" ( xcopy "SteamFossilizeVulkanLayer.json" ".\bin\steam\" /e /i /y & del "SteamFossilizeVulkanLayer.json" >nul )
if exist "zlib1.dll.old" ( xcopy "zlib1.dll.old" ".\bin\steam\" /e /i /y & del "zlib1.dll.old" >nul )
if exist "SteamOverlayVulkanLayer64.dll" ( xcopy "SteamOverlayVulkanLayer64.dll" ".\bin\steam\" /e /i /y & del "SteamOverlayVulkanLayer64.dll" >nul )
if exist "libavresample-4.dll.old" ( xcopy "libavresample-4.dll.old" ".\bin\steam\" /e /i /y & del "libavresample-4.dll.old" >nul )
if exist "SteamOverlayVulkanLayer.json" ( xcopy "SteamOverlayVulkanLayer.json" ".\bin\steam\" /e /i /y & del "SteamOverlayVulkanLayer.json" >nul )
if exist "VkLayer_steam_fossilize64.dll" ( xcopy "VkLayer_steam_fossilize64.dll" ".\bin\steam\" /e /i /y & del "VkLayer_steam_fossilize64.dll" >nul )
if exist "SteamOverlayVulkanLayer64.json" ( xcopy "SteamOverlayVulkanLayer64.json" ".\bin\steam\" /e /i /y & del "SteamOverlayVulkanLayer64.json" >nul )
if exist "libavutil-56.dll.old" ( xcopy "libavutil-56.dll.old" ".\bin\steam\" /e /i /y & del "libavutil-56.dll.old" >nul )
if exist "libswscale-5.dll.old" ( xcopy "libswscale-5.dll.old" ".\bin\steam\" /e /i /y & del "libswscale-5.dll.old" >nul )
if exist "libx264-142.dll.crypt.old" ( xcopy "libx264-142.dll.crypt.old" ".\bin\steam\" /e /i /y & del "libx264-142.dll.crypt.old" >nul )
if exist "libx264-142.dll.md5.old" ( xcopy "libx264-142.dll.md5.old" ".\bin\steam\" /e /i /y & del "libx264-142.dll.md5.old" >nul )
if exist "libavformat-58.dll" ( xcopy "libavformat-58.dll" ".\bin\steam\" /e /i /y & del "libavformat-58.dll" >nul )
if exist "streaming_client.exe.log" ( xcopy "streaming_client.exe.log" ".\bin\steam\" /e /i /y & del "streaming_client.exe.log" >nul )
if exist "streaming_client.exe.log.last" ( xcopy "streaming_client.exe.log.last" ".\bin\steam\" /e /i /y & del "streaming_client.exe.log.last" >nul )
if exist "libavresample-4.dll" ( xcopy "libavresample-4.dll" ".\bin\steam\" /e /i /y & del "libavresample-4.dll" >nul )
if exist "libavutil-56.dll" ( xcopy "libavutil-56.dll" ".\bin\steam\" /e /i /y & del "libavutil-56.dll" >nul )
if exist "tier0_s64.dll" ( xcopy "tier0_s64.dll" ".\bin\steam\" /e /i /y & del "tier0_s64.dll" >nul )
if exist "libswscale-5.dll" ( xcopy "libswscale-5.dll" ".\bin\steam\" /e /i /y & del "libswscale-5.dll" >nul )
if exist "libx264-142.dll.crypt" ( xcopy "libx264-142.dll.crypt" ".\bin\steam\" /e /i /y & del "libx264-142.dll.crypt" >nul )
if exist "update_hosts_cached.vdf" ( xcopy "update_hosts_cached.vdf" ".\bin\steam\" /e /i /y & del "update_hosts_cached.vdf" >nul )
if exist "libx264-142.dll.md5" ( xcopy "libx264-142.dll.md5" ".\bin\steam\" /e /i /y & del "libx264-142.dll.md5" >nul )
if exist "CSERHelper.dll.old" ( xcopy "CSERHelper.dll.old" ".\bin\steam\" /e /i /y & del "CSERHelper.dll.old" >nul )
if exist "GfnRuntimeSdk.dll" ( xcopy "GfnRuntimeSdk.dll" ".\bin\steam\" /e /i /y & del "GfnRuntimeSdk.dll" >nul )
if exist "vstdlib_s64.dll" ( xcopy "vstdlib_s64.dll" ".\bin\steam\" /e /i /y & del "vstdlib_s64.dll" >nul )
if exist "GfnRuntimeSdk.dll.old" ( xcopy "GfnRuntimeSdk.dll.old" ".\bin\steam\" /e /i /y & del "GfnRuntimeSdk.dll.old" >nul )
if exist "SDL2_ttf.dll.old" ( xcopy "SDL2_ttf.dll.old" ".\bin\steam\" /e /i /y & del "SDL2_ttf.dll.old" >nul )
if exist "Steam2.dll" ( xcopy "Steam2.dll" ".\bin\steam\" /e /i /y & del "Steam2.dll" >nul )
if exist "SDL2.dll.old" ( xcopy "SDL2.dll.old" ".\bin\steam\" /e /i /y & del "SDL2.dll.old" >nul )
if exist ".\AppList\" ( xcopy ".\AppList\*" ".\bin\steam\" /e /i /y & rmdir /s /q ".\AppList\" >nul )
if exist ".\bin\cef\" ( xcopy ".\bin\cef\*" ".\bin\steam\bin\" /e /i /y & rmdir /s /q ".\bin\cef\" >nul )
if exist ".\bin\panorama\" ( xcopy ".\bin\panorama\*" ".\bin\steam\bin\" /e /i /y & rmdir /s /q ".\bin\panorama\" >nul )
if exist ".\bin\shaders\" ( xcopy ".\bin\shaders\*" ".\bin\steam\bin\" /e /i /y & rmdir /s /q ".\bin\shaders\" >nul )
if exist ".\bin\audio.dll" ( xcopy ".\bin\audio.dll" ".\bin\steam\bin\" /e /i /y & del ".\bin\audio.dll" >nul )
if exist ".\bin\chromehtml.dll" ( xcopy ".\bin\chromehtml.dll" ".\bin\steam\bin\" /e /i /y & del ".\bin\chromehtml.dll" >nul )
if exist ".\bin\drivers.exe" ( xcopy ".\bin\drivers.exe" ".\bin\steam\bin\" /e /i /y & del ".\bin\drivers.exe" >nul )
if exist ".\bin\filesystem_stdio.dll" ( xcopy ".\bin\filesystem_stdio.dll" ".\bin\steam\bin\" /e /i /y & del ".\bin\filesystem_stdio.dll" >nul )
if exist ".\bin\fossilize-replay.exe" ( xcopy ".\bin\fossilize-replay.exe" ".\bin\steam\bin\" /e /i /y & del ".\bin\fossilize-replay.exe" >nul )
if exist ".\bin\fossilize-replay64.exe" ( xcopy ".\bin\fossilize-replay64.exe" ".\bin\steam\bin\" /e /i /y & del ".\bin\fossilize-replay64.exe" >nul )
if exist ".\bin\friendsui.dll" ( xcopy ".\bin\friendsui.dll" ".\bin\steam\bin\" /e /i /y & del ".\bin\friendsui.dll" >nul )
if exist ".\bin\gameoverlayui.dll" ( xcopy ".\bin\gameoverlayui.dll" ".\bin\steam\bin\" /e /i /y & del ".\bin\gameoverlayui.dll" >nul )
if exist ".\bin\gldriverquery.exe" ( xcopy ".\bin\gldriverquery.exe" ".\bin\steam\bin\" /e /i /y & del ".\bin\gldriverquery.exe" >nul )
if exist ".\bin\gldriverquery64.exe" ( xcopy ".\bin\gldriverquery64.exe" ".\bin\steam\bin\" /e /i /y & del ".\bin\gldriverquery64.exe" >nul )
if exist ".\bin\mss32.dll" ( xcopy ".\bin\mss32.dll" ".\bin\steam\bin\" /e /i /y & del ".\bin\mss32.dll" >nul )
if exist ".\bin\mssdsp.flt" ( xcopy ".\bin\mssdsp.flt" ".\bin\steam\bin\" /e /i /y & del ".\bin\mssdsp.flt" >nul )
if exist ".\bin\mssmp3.asi" ( xcopy ".\bin\mssmp3.asi" ".\bin\steam\bin\" /e /i /y & del ".\bin\mssmp3.asi" >nul )
if exist ".\bin\mssvoice.asi" ( xcopy ".\bin\mssvoice.asi" ".\bin\steam\bin\" /e /i /y & del ".\bin\mssvoice.asi" >nul )
if exist ".\bin\nattypeprobe.dll" ( xcopy ".\bin\nattypeprobe.dll" ".\bin\steam\bin\" /e /i /y & del ".\bin\nattypeprobe.dll" >nul )
if exist ".\bin\secure_desktop_capture.exe" ( xcopy ".\bin\secure_desktop_capture.exe" ".\bin\steam\bin\" /e /i /y & del ".\bin\secure_desktop_capture.exe" >nul )
if exist ".\bin\serverbrowser.dll" ( xcopy ".\bin\serverbrowser.dll" ".\bin\steam\bin\" /e /i /y & del ".\bin\serverbrowser.dll" >nul )
if exist ".\bin\service_current_versions.vdf" ( xcopy ".\bin\service_current_versions.vdf" ".\bin\steam\bin\" /e /i /y & del ".\bin\service_current_versions.vdf" >nul )
if exist ".\bin\service_log.txt" ( xcopy ".\bin\service_log.txt" ".\bin\steam\bin\" /e /i /y & del ".\bin\service_log.txt" >nul )
if exist ".\bin\service_minimum_versions.vdf" ( xcopy ".\bin\service_minimum_versions.vdf" ".\bin\steam\bin\" /e /i /y & del ".\bin\service_minimum_versions.vdf" >nul )
if exist ".\bin\steam_monitor.exe" ( xcopy ".\bin\steam_monitor.exe" ".\bin\steam\bin\" /e /i /y & del ".\bin\steam_monitor.exe" >nul )
if exist ".\bin\steamservice.dll" ( xcopy ".\bin\steamservice.dll" ".\bin\steam\bin\" /e /i /y & del ".\bin\steamservice.dll" >nul )
if exist ".\bin\steamservice.exe" ( xcopy ".\bin\steamservice.exe" ".\bin\steam\bin\" /e /i /y & del ".\bin\steamservice.exe" >nul )
if exist ".\bin\steamxboxutil.exe" ( xcopy ".\bin\steamxboxutil.exe" ".\bin\steam\bin\" /e /i /y & del ".\bin\steamxboxutil.exe" >nul )
if exist ".\bin\steamxboxutil64.exe" ( xcopy ".\bin\steamxboxutil64.exe" ".\bin\steam\bin\" /e /i /y & del ".\bin\steamxboxutil64.exe" >nul )
if exist ".\bin\vgui2_s.dll" ( xcopy ".\bin\vgui2_s.dll" ".\bin\steam\bin\" /e /i /y & del ".\bin\vgui2_s.dll" >nul )
if exist ".\bin\vulkandriverquery.exe" ( xcopy ".\bin\vulkandriverquery.exe" ".\bin\steam\bin\" /e /i /y & del ".\bin\vulkandriverquery.exe" >nul )
if exist ".\bin\vulkandriverquery64.exe" ( xcopy ".\bin\vulkandriverquery64.exe" ".\bin\steam\bin\" /e /i /y & del ".\bin\vulkandriverquery64.exe" >nul )
if exist ".\bin\x64launcher.exe" ( xcopy ".\bin\x64launcher.exe" ".\bin\steam\bin\" /e /i /y & del ".\bin\x64launcher.exe" >nul )
if exist ".\bin\x86launcher.exe" ( xcopy ".\bin\x86launcher.exe" ".\bin\steam\bin\" /e /i /y & del ".\bin\x86launcher.exe" >nul )
if exist ".\bin\xinput1_3.dll" ( xcopy ".\bin\xinput1_3.dll" ".\bin\steam\bin\" /e /i /y & del ".\bin\xinput1_3.dll" >nul )
if exist ".\bin\xpad.dll" ( xcopy ".\bin\xpad.dll" ".\bin\steam\bin\" /e /i /y & del ".\bin\xpad.dll" >nul )
if exist ".\clientui\" ( xcopy ".\clientui\*" ".\bin\steam\clientui\" /e /i /y & rmdir /s /q ".\clientui\" >nul )
if exist ".\config\" ( xcopy ".\config\*" ".\bin\steam\config\" /e /i /y & rmdir /s /q ".\config\" >nul )
if exist ".\controller_base\" ( xcopy ".\controller_base\*" ".\bin\steam\controller_base\" /e /i /y & rmdir /s /q ".\controller_base\" >nul )
if exist "Steam.dll.old" ( xcopy "Steam.dll.old" ".\bin\steam\" /e /i /y & del "Steam.dll.old" >nul )
if exist ".\dumps\" ( xcopy ".\dumps\*" ".\bin\steam\dumps\" /e /i /y & rmdir /s /q ".\dumps\" >nul )
if exist ".\friends\" ( xcopy ".\friends\*" ".\bin\steam\friends\" /e /i /y & rmdir /s /q ".\friends\" >nul )
if exist ".\GameLogs\" ( xcopy ".\GameLogs\*" ".\bin\steam\GameLogs\" /e /i /y & rmdir /s /q ".\GameLogs\" >nul )
if exist ".\graphics\" ( xcopy ".\graphics\*" ".\bin\steam\graphics\" /e /i /y & rmdir /s /q ".\graphics\" >nul )
if exist ".\logs\" ( xcopy ".\logs\*" ".\bin\steam\logs\" /e /i /y & rmdir /s /q ".\logs\" >nul )
if exist "SteamUI.dll.old" ( xcopy "SteamUI.dll.old" ".\bin\steam\" /e /i /y & del "crashhandler.dll" >nul )
if exist ".\public\" ( xcopy ".\public\*" ".\bin\steam\public\" /e /i /y & rmdir /s /q ".\public\" >nul )
if exist ".\resource\" ( xcopy ".\resource\*" ".\bin\steam\resource\" /e /i /y & rmdir /s /q ".\resource\" >nul )
if exist ".\servers\" ( xcopy ".\servers\*" ".\bin\steam\servers\" /e /i /y & rmdir /s /q ".\servers\" >nul )
if exist ".\steam\" ( xcopy ".\steam\*" ".\bin\steam\steam\" /e /i /y & rmdir /s /q ".\steam\" >nul )
if exist ".\steamapps\" ( xcopy ".\steamapps\*" ".\bin\steam\steamapps\" /e /i /y & rmdir /s /q ".\steamapps\" >nul )
if exist ".\steamchina\" ( xcopy ".\steamchina\*" ".\bin\steam\steamchina\" /e /i /y & rmdir /s /q ".\steamchina\" >nul )
if exist ".\steamui\" ( xcopy ".\steamui\*" ".\bin\steam\steamui\" /e /i /y & rmdir /s /q ".\steamui\" >nul )
if exist ".\tenfoot\" ( xcopy ".\tenfoot\*" ".\bin\steam\tenfoot\" /e /i /y & rmdir /s /q ".\tenfoot\" >nul )
if exist ".\ubuntu12_64\" ( xcopy ".\ubuntu12_64\*" ".\bin\steam\ubuntu12_64\" /e /i /y & rmdir /s /q ".\ubuntu12_64\" >nul )
if exist ".\userdata\" ( xcopy ".\userdata\*" ".\bin\steam\userdata\" /e /i /y & rmdir /s /q ".\userdata\" >nul )
if exist ".\x64ForDedicatedServers\" ( xcopy ".\x64ForDedicatedServers\*" ".\bin\steam\x64ForDedicatedServers\" /e /i /y & rmdir /s /q ".\x64ForDedicatedServers\" >nul )
if exist "SteamFossilizeVulkanLayer.json.old" ( xcopy "SteamFossilizeVulkanLayer.json.old" ".\bin\steam\" /e /i /y & del "SteamFossilizeVulkanLayer.json.old" >nul )
if exist "icui18n.dll" ( xcopy "icui18n.dll" ".\bin\steam\" /e /i /y & del "icui18n.dll" >nul )
if exist "SteamFossilizeVulkanLayer64.json.old" ( xcopy "SteamFossilizeVulkanLayer64.json.old" ".\bin\steam\" /e /i /y & del "SteamFossilizeVulkanLayer64.json.old" >nul )
if exist "d3dcompiler_46.dll.old" ( xcopy "d3dcompiler_46.dll.old" ".\bin\steam\" /e /i /y & del "d3dcompiler_46.dll.old" >nul )
if exist "SteamFossilizeVulkanLayer64.json" ( xcopy "SteamFossilizeVulkanLayer64.json" ".\bin\steam\" /e /i /y & del "SteamFossilizeVulkanLayer64.json" >nul )
if exist "WriteMiniDump.exe" ( xcopy "WriteMiniDump.exe" ".\bin\steam\" /e /i /y & del "WriteMiniDump.exe" >nul )
if exist "tier0_s.dll" ( xcopy "tier0_s.dll" ".\bin\steam\" /e /i /y & del "tier0_s.dll" >nul )
if exist "SteamOverlayVulkanLayer.json.old" ( xcopy "SteamOverlayVulkanLayer.json.old" ".\bin\steam\" /e /i /y & del "SteamOverlayVulkanLayer.json.old" >nul )
if exist "SteamOverlayVulkanLayer64.json.old" ( xcopy "SteamOverlayVulkanLayer64.json.old" ".\bin\steam\" /e /i /y & del "SteamOverlayVulkanLayer64.json.old" >nul )
if exist "icuuc.dll" ( xcopy "icuuc.dll" ".\bin\steam\" /e /i /y & del "icuuc.dll" >nul )
if exist "d3dcompiler_46_64.dll.old" ( xcopy "d3dcompiler_46_64.dll.old" ".\bin\steam\" /e /i /y & del "d3dcompiler_46_64.dll.old" >nul )
if exist "d3dcompiler_46.dll" ( xcopy "d3dcompiler_46.dll" ".\bin\steam\" /e /i /y & del "d3dcompiler_46.dll" >nul )
if exist "libfreetype-6.dll.old" ( xcopy "libfreetype-6.dll.old" ".\bin\steam\" /e /i /y & del "libfreetype-6.dll.old" >nul )
if exist "v8.dll" ( xcopy "v8.dll" ".\bin\steam\" /e /i /y & del "v8.dll" >nul )
if exist "libharfbuzz-0.dll.old" ( xcopy "libharfbuzz-0.dll.old" ".\bin\steam\" /e /i /y & del "libharfbuzz-0.dll.old" >nul )
if exist "d3dcompiler_46_64.dll" ( xcopy "d3dcompiler_46_64.dll" ".\bin\steam\" /e /i /y & del "d3dcompiler_46_64.dll" >nul )
if exist "fossilize_engine_filters.json.old" ( xcopy "fossilize_engine_filters.json.old" ".\bin\steam\" /e /i /y & del "fossilize_engine_filters.json.old" >nul )
if exist "libfreetype-6.dll" ( xcopy "libfreetype-6.dll" ".\bin\steam\" /e /i /y & del "libfreetype-6.dll" >nul )
if exist "zlib1.dll" ( xcopy "zlib1.dll" ".\bin\steam\" /e /i /y & del "zlib1.dll" >nul )
if exist "steamwebrtc64.dll.old" ( xcopy "steamwebrtc64.dll.old" ".\bin\steam\" /e /i /y & del "steamwebrtc64.dll.old" >nul )
if exist "GameOverlayRenderer.dll.old" ( xcopy "GameOverlayRenderer.dll.old" ".\bin\steam\" /e /i /y & del "GameOverlayRenderer.dll.old" >nul )
if exist "libharfbuzz-0.dll" ( xcopy "libharfbuzz-0.dll" ".\bin\steam\" /e /i /y & del "libharfbuzz-0.dll" >nul )
if exist "openvr_api.dll.old" ( xcopy "openvr_api.dll.old" ".\bin\steam\" /e /i /y & del "openvr_api.dll.old" >nul )
if exist "steamwebrtc.dll.old" ( xcopy "steamwebrtc.dll.old" ".\bin\steam\" /e /i /y & del "steamwebrtc.dll.old" >nul )
if exist "GameOverlayRenderer64.dll.old" ( xcopy "GameOverlayRenderer64.dll.old" ".\bin\steam\" /e /i /y & del "GameOverlayRenderer64.dll.old" >nul )
if exist "steamwebrtc64.dll" ( xcopy "steamwebrtc64.dll" ".\bin\steam\" /e /i /y & del "steamwebrtc64.dll" >nul )
if exist "video.dll" ( xcopy "video.dll" ".\bin\steam\" /e /i /y & del "video.dll" >nul )
if exist "GameOverlayRenderer.dll" ( xcopy "GameOverlayRenderer.dll" ".\bin\steam\" /e /i /y & del "GameOverlayRenderer.dll" >nul )
if exist "GameOverlayRenderer64.dll" ( xcopy "GameOverlayRenderer64.dll" ".\bin\steam\" /e /i /y & del "GameOverlayRenderer64.dll" >nul )
if exist "GameOverlayUI.exe" ( xcopy "GameOverlayUI.exe" ".\bin\steam\" /e /i /y & del "GameOverlayUI.exe" >nul )
if exist "SDL2.dll" ( xcopy "SDL2.dll" ".\bin\steam\" /e /i /y & del "SDL2.dll" >nul )
if exist "Steam.dll" ( xcopy "Steam.dll" ".\bin\steam\" /e /i /y & del "Steam.dll" >nul )
if exist "SteamOverlayVulkanLayer.dll.old" ( xcopy "SteamOverlayVulkanLayer.dll.old" ".\bin\steam\" /e /i /y & del "SteamOverlayVulkanLayer.dll.old" >nul )
if exist "SteamOverlayVulkanLayer64.dll.old" ( xcopy "SteamOverlayVulkanLayer64.dll.old" ".\bin\steam\" /e /i /y & del "SteamOverlayVulkanLayer64.dll.old" >nul )
if exist "SteamUI.dll" ( xcopy "SteamUI.dll" ".\bin\steam\" /e /i /y & del "SteamUI.dll" >nul )
if exist "VkLayer_steam_fossilize.dll.old" ( xcopy "VkLayer_steam_fossilize.dll.old" ".\bin\steam\" /e /i /y & del "VkLayer_steam_fossilize.dll.old" >nul )
if exist "VkLayer_steam_fossilize64.dll.old" ( xcopy "VkLayer_steam_fossilize64.dll.old" ".\bin\steam\" /e /i /y & del "VkLayer_steam_fossilize64.dll.old" >nul )
if exist "crashhandler64.dll" ( xcopy "crashhandler64.dll" ".\bin\steam\" /e /i /y & del "crashhandler64.dll" >nul )
if exist "steam.signatures" ( xcopy "steam.signatures" ".\bin\steam\" /e /i /y & del "steam.signatures" >nul )
if exist "steamclient64.dll" ( xcopy "steamclient64.dll" ".\bin\steam\" /e /i /y & del "steamclient64.dll" >nul )
if exist "steamerrorreporter.exe" ( xcopy "steamerrorreporter.exe" ".\bin\steam\" /e /i /y & del "steamerrorreporter.exe" >nul )
if exist "steamerrorreporter64.exe" ( xcopy "steamerrorreporter64.exe" ".\bin\steam\" /e /i /y & del "steamerrorreporter64.exe" >nul )
exit /b 2

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