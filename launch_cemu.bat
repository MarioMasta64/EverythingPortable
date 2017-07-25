:: this space fixes a problem somehow dont remove
@echo off
Color 0A
cls
title Portable Cemu Launcher - Experimental Edition
set nag=EXPIREMENTS :D
set new_version=OFFLINE
if "%~1" neq "" (call :%~1 & exit /b !current_version!)

:: allows letters to be set as numbers
setlocal enabledelayedexpansion
call :Alpha-To-Number

:: change this to change cemu versions
:: makes for extremely easy version changes without changing a whole bunch of code
set "cemu-ver-first-digit=1"
set "cemu-ver-second-digit=8"
set "cemu-ver-third-digit=2"
set "cemu-ver-letter=b"
set cemu-ver-fourth-digit=!%cemu-ver-letter%!

:: use this to easily set what the zip file is called
set cemu-ver=cemu_%cemu-ver-first-digit%.%cemu-ver-second-digit%.%cemu-ver-third-digit%.zip

call :Folder-Check
call :Version
call :Credits
call :Check-Scripts
call :Cemu-Upgrade-Check
call :Cemu-Check

:Menu
cls
title Portable Cemu Launcher - Experimental Edition - Main Menu
echo %NAG%
set nag="Selection Time!"
echo 1. reinstall cemu [will remove cemu entirely]
echo 2. launch cemu [launches cemu]
echo 3. reset cemu [will remove everything cemu except the binary]
echo 4. uninstall cemu [Maybe Buy A WiiU :^^)]
echo 5. update program [check for updates]
echo 6. about [shoulda named this credits]
echo 7. exit [EXIT]
echo 8. changelog.txt [what changed?]
echo.
echo a. download dll's [dll errors anyone?]
echo.
echo b. download other projects [check out my other stuff]
echo.
echo c. write a quicklauncher [MAKE IT EVEN FASTER]
echo.
echo d. download mod's [want cemu hook or something?]
echo.
set /p choice="enter a number and press enter to confirm: "
:: sets errorlevel to 0 (?)
ver > nul
:: an incorrect call throws an errorlevel of 1
:: replace all goto Main with exit /b 2 (if they are called by the main menu)
call :%choice%
if "%ERRORLEVEL%" NEQ "2" set nag="PLEASE Select A CHOICE 1-8 or a/b/c/d"
goto Menu

:Null
cls
set nag="NOT A FEATURE YET!"
(goto) 2>nul

:1
:Reinstall-Cemu
cls
rmdir /s /q .\bin\cemu\
call :Cemu-Check
exit /b 2

:2
:Launch-Cemu
title DO NOT CLOSE
set "path=%PATH%;%CD%\dll\64\;"
cls
echo CEMU IS RUNNING
cd bin\cemu*
start Cemu.exe
exit

:3
:Reset-Cemu
cls
for %%i in (.\bin\cemu\*) do if not "%%i" == ".\bin\cemu\Cemu.exe" del %%i
for /d %%d in (.\bin\cemu\*) do rmdir /s /q "%%d"
exit /b 2

:4
:Uninstall-Cemu
cls
rmdir /s /q .\bin\cemu\
exit

:5
:Update-Check
if exist version.txt del version.txt
if not exist .\bin\wget.exe call :Download-Wget
cls
title Portable Cemu Launcher - Experimental Edition - Checking For Update
.\bin\wget.exe -q --show-progress https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/version.txt
set Counter=0 & for /f "DELIMS=" %%i in ('type version.txt') do (set /a Counter+=1 & set "Line_!Counter!=%%i")
if exist version.txt del version.txt
set new_version=%Line_12%
if "%new_version%"=="OFFLINE" call :Error-Offline & exit /b 2
if %current_version% EQU %new_version% call :Latest-Build & exit /b 2
if %current_version% LSS %new_version% call :New-Update & exit /b 2
if %current_version% GTR %new_version% call :Preview-Build & exit /b 2
call :Error-Offline & exit /b 2

:6
:About
cls
del .\doc\cemu_license.txt
start launch_cemu.bat
exit

:7
exit

:8
:Write-Cemu-Change-Log
cls
title Portable Cemu Launcher - Expiremental Edition - Change Log
:: https://ss64.com/nt/chcp.html
chcp 65001 >nul:
echo =========================================================================== > .\doc\cemu_changelog.txt 
echo =                             Cemu Launcher - v19                         = >> .\doc\cemu_changelog.txt
echo =                          Experimental Code Edition                      = >> .\doc\cemu_changelog.txt
echo =========================================================================== >> .\doc\cemu_changelog.txt
echo = (ﾉ◕ヮ◕)ﾉ Upgraded To Cemu v1.8.1                                         = >> .\doc\cemu_changelog.txt
echo = (ﾉ◕ヮ◕)ﾉ Automaticly Upgrade Cemu No More Need For Manual Upgrade        = >> .\doc\cemu_changelog.txt
echo = (ﾉ◕ヮ◕)ﾉ Type Any Labels Name To Goto It (Useful For Debugging)          = >> .\doc\cemu_changelog.txt
echo = (ﾉ◕ヮ◕)ﾉ Updater Now Hides Itself And Deletes Itself On Completion       = >> .\doc\cemu_changelog.txt
echo = (ﾉ◕ヮ◕)ﾉ (goto) 2^>nul                                                    = >> .\doc\cemu_changelog.txt
echo = (ﾉ◕ヮ◕)ﾉ Made It Easier To Set Cemu Versions For Faster Deployement      = >> .\doc\cemu_changelog.txt
echo = (ﾉ◕ヮ◕)ﾉ Made Code Slightly Cleaner But Kinda Not                        = >> .\doc\cemu_changelog.txt
echo = (ﾉ◕ヮ◕)ﾉ Maybe Other Stuff I Forgot To Mention                           = >> .\doc\cemu_changelog.txt
echo =========================================================================== >> .\doc\cemu_changelog.txt
echo = (ﾉ◕ヮ◕)ﾉ Further improvements to overall system stability and other      = >> .\doc\cemu_changelog.txt
echo = (ﾉ◕ヮ◕)ﾉ minor adjustments have been made to enhance the user experience = >> .\doc\cemu_changelog.txt
echo =========================================================================== >> .\doc\cemu_changelog.txt
echo. >> .\doc\cemu_changelog.txt
echo =========================================================================== >> .\doc\cemu_changelog.txt 
echo =                             Cemu Launcher - v20                         = >> .\doc\cemu_changelog.txt
echo =                          Experimental Code Edition                      = >> .\doc\cemu_changelog.txt
echo =========================================================================== >> .\doc\cemu_changelog.txt
echo = (ﾉ◕ヮ◕)ﾉ Further improvements to overall system stability and other      = >> .\doc\cemu_changelog.txt
echo = (ﾉ◕ヮ◕)ﾉ minor adjustments have been made to enhance the user experience = >> .\doc\cemu_changelog.txt
echo =========================================================================== >> .\doc\cemu_changelog.txt
echo. >> .\doc\cemu_changelog.txt
echo =========================================================================== >> .\doc\cemu_changelog.txt 
echo =                             Cemu Launcher - v21                         = >> .\doc\cemu_changelog.txt
echo =                          Experimental Code Edition                      = >> .\doc\cemu_changelog.txt
echo =========================================================================== >> .\doc\cemu_changelog.txt
echo = (ﾉ◕ヮ◕)ﾉ Fixed Changelog Somehow                                         = >> .\doc\cemu_changelog.txt
echo =========================================================================== >> .\doc\cemu_changelog.txt
echo = (ﾉ◕ヮ◕)ﾉ Further improvements to overall system stability and other      = >> .\doc\cemu_changelog.txt
echo = (ﾉ◕ヮ◕)ﾉ minor adjustments have been made to enhance the user experience = >> .\doc\cemu_changelog.txt
echo =========================================================================== >> .\doc\cemu_changelog.txt
chcp 437 >nul:
notepad.exe .\doc\cemu_changelog.txt
exit /b 2

:a
:DLL-Downloader-Check
cls & title Portable Cemu Launcher - Experimental Edition - Download Dll Downloader
cls & if not exist .\bin\wget.exe call :Download-Wget
cls & .\bin\wget.exe -q --show-progress https://raw.githubusercontent.com/MarioMasta64/DLLDownloaderPortable/master/launch_dlldownloader.bat
cls & if exist launch_dlldownloader.bat.1 del launch_dlldownloader.bat & rename launch_dlldownloader.bat.1 launch_dlldownloader.bat
cls & start launch_dlldownloader.bat
exit /b 2

:b
:Portable-Everything
cls & title Portable Cemu Launcher - Experimental Edition - Download Suite
cls & if not exist .\bin\wget.exe call :Download-Wget
cls & .\bin\wget.exe -q --show-progress https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/launch_everything.bat
cls & if exist launch_everything.bat.1 del launch_everything.bat & rename launch_everything.bat.1 launch_everything.bat
cls & start launch_everything.bat
exit /b 2

:c
:Quicklauncher-Check
cls
title Portable Cemu Launcher - Experimental Edition - Quicklauncher Writer
echo @echo off > quicklaunch_cemu.bat
echo Color 0A >> quicklaunch_cemu.bat
echo cls >> quicklaunch_cemu.bat
echo set path="%%PATH%%;%%CD%%\dll\64\;" >> quicklaunch_cemu.bat
echo cls >> quicklaunch_cemu.bat
echo start .\bin\cemu\Cemu.exe >> quicklaunch_cemu.bat
echo exit >> quicklaunch_cemu.bat
echo A QUICKLAUNCHER HAS BEEN WRITTEN TO: quicklaunch_cemu.bat
pause>nul:
exit /b 2

:d
:Mod-Downloader-Check
cls & title Portable Cemu Launcher - Experimental Edition - Download Mod Downloader
cls & if not exist .\bin\wget.exe call :Download-Wget
cls & .\bin\wget.exe -q --show-progress https://github.com/MarioMasta64/ModDownloaderPortable/raw/master/launch_cemu_moddownloader.bat
cls & if exist launch_cemu_moddownloader.bat.1 del launch_cemu_moddownloader.bat & rename launch_cemu_moddownloader.bat.1 launch_cemu_moddownloader.bat
cls & start launch_cemu_moddownloader.bat
exit /b 2

########################################################################

:: program specific stuff that can easily be changed below
:: stuff that is almost identical betwwen stuff

########################################################################

:Folder-Check
cls
if not exist .\bin\ mkdir .\bin\
:: dll folder check removed because dll downloader creates it
if not exist .\doc\ mkdir .\doc\
if not exist .\extra\ mkdir .\extra\
(goto) 2>nul

########################################################################

:Version
cls
echo 22 > .\doc\version.txt
set /p current_version=<.\doc\version.txt
if exist .\doc\version.txt del .\doc\version.txt
:: REPLACE ALL exit /b that dont need an error code (a value after it) with "exit"
(goto) 2>nul

########################################################################

:Credits
cls
if not exist .\doc\cemu_changelog.txt call :Write-Cemu-Change-Log
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
title Portable Cemu Launcher - Experimental Edition - About
for /f "DELIMS=" %%i in (.\doc\cemu_license.txt) do (echo %%i)
pause
(goto) 2>nul

########################################################################

:: if a script can be used between files then it can be put here and re-written only if it doesnt exist
:: stuff here will not be changed between programs

########################################################################

:Check-Scripts
if not exist .\bin\downloadwget.vbs call :Create-Wget-Downloader
if not exist .\bin\hide.vbs call :Create-Hide
(goto) 2>nul

########################################################################

:Create-Wget-Downloader
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
(goto) 2>nul

########################################################################

:Download-Wget
cls
title Portable Cemu Launcher - Experimental Edition - Download Wget
cscript.exe .\bin\downloadwget.vbs
move wget.exe .\bin\
(goto) 2>nul

########################################################################

:Create-Hide
echo CreateObject("Wscript.Shell").Run """" ^& WScript.Arguments(0) ^& """", 0, False > .\bin\hide.vbs
(goto) 2>nul

########################################################################

:: scripts that are program specific are below

########################################################################

:Cemu-Check
cls
call :v19-Upgrade-Check
if not exist .\bin\cemu\Cemu.exe call :File-Check & goto Cemu-Check
(goto) 2>nul

:File-Check
if not exist .\extra\%cemu-ver% call :Download-Cemu
if exist .\extra\%cemu-ver% call :Extract-Cemu
(goto) 2>nul

:Download-Cemu
if exist %cemu-ver% call :Move-Cemu & (goto) 2>nul
if not exist .\bin\wget.exe call :Download-Wget
cls
title Portable Cemu Launcher - Experimental Edition - Download Cemu
.\bin\wget.exe -q --show-progress "http://cemu.info/releases/%cemu-ver%"

:Move-Cemu
cls
if not exist %cemu-ver% (goto) 2>nul
move %cemu-ver% .\extra\%cemu-ver%
(goto) 2>nul

########################################################################

:Create-Cemu-Extractor
cls
title Portable Cemu Launcher - Experimental Edition - Extract Cemu
set folder=%CD%
if %CD%==%~d0\ set folder=%CD:~0,2%
echo. > .\bin\extractcemu.vbs
echo 'The location of the zip file. >> .\bin\extractcemu.vbs
echo ZipFile="%folder%\extra\%cemu-ver%" >> .\bin\extractcemu.vbs
echo 'The folder the contents should be extracted to. >> .\bin\extractcemu.vbs
echo ExtractTo="%folder%\bin\cemu\" >> .\bin\extractcemu.vbs
echo. >> .\bin\extractcemu.vbs
echo 'If the extraction location does not exist create it. >> .\bin\extractcemu.vbs
echo Set fso = CreateObject("Scripting.FileSystemObject") >> .\bin\extractcemu.vbs
echo If NOT fso.FolderExists(ExtractTo) Then >> .\bin\extractcemu.vbs
echo    fso.CreateFolder(ExtractTo) >> .\bin\extractcemu.vbs
echo End If >> .\bin\extractcemu.vbs
echo. >> .\bin\extractcemu.vbs
echo 'Extract the contants of the zip file. >> .\bin\extractcemu.vbs
echo set objShell = CreateObject("Shell.Application") >> .\bin\extractcemu.vbs
echo set FilesInZip=objShell.NameSpace(ZipFile).items >> .\bin\extractcemu.vbs
echo objShell.NameSpace(ExtractTo).CopyHere(FilesInZip) >> .\bin\extractcemu.vbs
echo Set fso = Nothing >> .\bin\extractcemu.vbs
echo Set objShell = Nothing >> .\bin\extractcemu.vbs
echo. >> .\bin\extractcemu.vbs
(goto) 2>nul

########################################################################

:Extract-Cemu
cls
title Portable Cemu Launcher - Experimental Edition - Extract Cemu
:: if a script has to point to a relative object then it needs to be re-written so its best not to put it in :Check-Scripts
call :Create-Cemu-Extractor
cscript.exe .\bin\extractcemu.vbs
cd bin
if exist cemu cd cemu
if exist cemu* cd cemu*
if not exist ..\wget.exe xcopy * ..\ /e /i /y
if not exist ..\wget.exe cd ..
if exist temp.txt del temp.txt
for /D %%A IN ("cemu*") DO echo "%%A">temp.txt
if exist temp.txt set /p dir=<temp.txt
if exist temp.txt rmdir /s /q %dir%
if exist temp.txt del temp.txt
if exist ..\wget.exe cd ..
if exist ..\launch_cemu.bat cd ..
(goto) 2>nul

#######################################################################

:: scripts that are made to cleanup or move directories and files between releases are below

#######################################################################

:v19-Upgrade-Check
if exist .\bin\temp.txt del .\bin\temp.txt
for /D %%A IN (".\bin\cemu*") DO echo "%%A">.\bin\temp.txt
if exist .\bin\temp.txt set /p dir=<.\bin\temp.txt
if "%dir%"=="".\bin\cemu"" goto Skip-Upgrade
if exist .\bin\temp.txt xcopy %dir%\* .\bin\cemu\ /e /i /y
if exist .\bin\temp.txt rmdir /s /q %dir%
:Skip-Upgrade
if exist .\bin\temp.txt del .\bin\temp.txt
(goto) 2>nul

########################################################################

:Cemu-Upgrade-Check
cls
if not exist cemu-ver.txt (goto) 2>nul
set Counter=0 & for /f "DELIMS=" %%i in ('type cemu-ver.txt') do (set /a Counter+=1 & set "Line_!Counter!=%%i")
del cemu-ver.txt
set old-ver-first-digit=%Line_1%
set old-ver-second-digit=%Line_2%
set old-ver-third-digit=%Line_3%
set old-ver-fourth-digit=%Line_4%
if %old-ver-first-digit% LSS %cemu-ver-first-digit% call :Upgrade-Cemu
if %old-ver-second-digit% LSS %cemu-ver-second-digit% call :Upgrade-Cemu
if %old-ver-third-digit% LSS %cemu-ver-third-digit% call :Upgrade-Cemu
if %old-ver-fourth-digit% LSS %cemu-ver-fourth-digit% call :Upgrade-Cemu
(goto) 2>nul

########################################################################

:Upgrade-Cemu
cls
del .\bin\cemu\Cemu.exe
(goto) 2>nul

########################################################################

:: scripts that are used for updating things are below

########################################################################

:Update-Wget
cls
title Portable Cemu Launcher - Experimental Edition - Update Wget
.\bin\wget.exe -q --show-progress https://eternallybored.org/misc/wget/current/wget.exe
move wget.exe .\bin\
(goto) 2>nul

########################################################################

:Latest-Build
cls
title Portable Cemu Launcher - Experimental Edition - Latest Build :D
echo you are using the latest version!!
echo Current Version: v%current_version%
echo New Version: v%new_version%
pause>nul:
start launch_cemu.bat
exit

:New-Update
cls
title Portable Cemu Launcher - Experimental Edition - Old Build D:
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
goto New-Update

:Update-Now
cls & if not exist .\bin\wget.exe call :Download-Wget
cls & title Portable Cemu Launcher - Experimental Edition - Updating Launcher
cls & .\bin\wget.exe -q --show-progress https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/raw/master/launch_cemu.bat
cls & if exist launch_cemu.bat.1 goto Replacer-Create
cls & call :Error-Offline
(goto) 2>nul

:Replacer-Create
cls
echo @echo off > replacer.bat
echo Color 0A >> replacer.bat
echo del launch_cemu.bat >> replacer.bat
echo rename launch_cemu.bat.1 launch_cemu.bat >> replacer.bat
echo start launch_cemu.bat >> replacer.bat
:: launcher exits, deletes itself, and then exits again. yes. its magic.
echo (goto) 2^>nul ^& del "%%~f0" ^& exit >> replacer.bat
wscript "%CD%\bin\hide.vbs" "replacer.bat"
if exist cemu-ver.txt del cemu-ver.txt
if exist .\doc\cemu_changelog.txt del .\doc\cemu_changelog.txt
echo %cemu-ver-first-digit% > cemu-ver.txt
echo %cemu-ver-second-digit% >> cemu-ver.txt
echo %cemu-ver-third-digit% >> cemu-ver.txt
echo %cemu-ver-fourth-digit% >> cemu-ver.txt
exit

:Preview-Build
cls
title Portable Cemu Launcher - Experimental Edition - Test Build :0
echo YOURE USING A TEST BUILD MEANING YOURE EITHER
echo CLOSE TO ME OR YOURE SOME SORT OF PIRATE
echo Current Version: v%current_version%
echo New Version: v%new_version%
echo ENTER TO CONTINUE
pause>nul:
start launch_cemu.bat
exit

########################################################################

:Error-Offline
cls
set nag="YOU SEEM TO BE OFFLINE PLEASE RECONNECT TO THE INTERNET TO USE THIS FEATURE"
(goto) 2>nul

########################################################################

:: General Purpose Scripts Are Below

########################################################################

:Alpha-To-Number
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

########################################################################

:View-Code
start notepad.exe "%~f0"
(goto) 2>nul

########################################################################

:Make-Copy
:Save-Copy
del "%~f0.bak"
copy "%~f0" "%~f0.bak"
(goto) 2>nul

########################################################################

:cmd
cls
title Portable Cemu Launcher - Experimental Edition - Command Prompt - By MarioMasta64
ver
echo (C) Copyright Microsoft Corporation. All rights reserved
echo.
echo nice job finding me. have fun with my little cmd prompt.
echo upon error (more likely than not) i will return to the menu.
echo type "(goto) 2^>nul" or make me error to return.
echo.
:cmd-loop
set /p "cmd=%cd%>"
if "%cmd%"=="reset-cmd" call :cmd
%cmd%
echo.
goto cmd-loop

########################################################################

:Relaunch
echo @echo off > relaunch.bat
echo cls >> relauncher.bat
echo Color 0A >> relaunch.bat
echo start %~f0 >> relaunch.bat
:: launcher exits, deletes itself, and then exits again. yes. its magic.
echo (goto) 2^>nul ^& del "%%~f0" ^& exit >> relaunch.bat
wscript "%CD%\bin\hide.vbs" "relaunch.bat"
exit

########################################################################

:: notes i guess

########################################################################

replace launch_cemu.bat with %~f0
make a way to flip through pages in changelog
because i use the call command. you can edit the file add a label and goto the label by typing it in the menu without even having to close the program cause youre worried about it glitching (put your code on the bottom)
add raw before raw/master in everything
maybe add option to open mod folder?
add new launchers to update check in everything portable
the better link: https://raw.githubusercontent.com/MarioMasta64/ModDownloaderPortable/master/mod_list.txt
apparently raw is bad before master but only sometimes?
raw is perfect for text links tho

########################################################################