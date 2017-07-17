:: this space fixes a problem somehow dont remove
@echo off
Color 0A
cls
title Portable Discord Canary Launcher - Experimental Edition
:: no more need to check if caps is on or off
set nag=EXPERIMENTS :D
set new_version=OFFLINE
if "%~1" neq "" (call :%~1 & exit /b !current_version!)
if exist launch_discord_canary_poc.bat del launch_discord_canary_poc.bat

:: allows letters to be set as numbers
setlocal enabledelayedexpansion
call :Alpha-To-Number

:: no version check needed.

call :Folder-Check
call :Credits
call :Check-Scripts
call :Discord-Canary-Check

:Menu
cls
title Portable Discord Canary Launcher - Experimental Edition - Main Menu
echo %NAG%
set nag="Selection Time!"
echo 1. reinstall discord canary [will remove discord canary entirely]
echo 2. launch discord canary [launches discord canary]
echo 3. reset discord canary [will remove everything discord canary except the binary]
echo 4. uninstall discord canary [Maybe Canary Is Too Unstable...]
echo 5. update program [check for updates]
echo 6. about [shoulda named this credits]
echo 7. exit [EXIT]
echo 8. changelog.txt [what changed?]
echo.
echo b. download other projects [check out my other stuff]
echo.
echo c. write a quicklauncher [MAKE IT EVEN FASTER]
echo.
set /p choice="enter a number and press enter to confirm: "
:: sets errorlevel to 0 (?)
ver > nul
:: an incorrect call throws an errorlevel of 1
:: replace all goto Main with exit /b 2 (if they are called by the main menu)
call :%choice%
if "%ERRORLEVEL%" NEQ "2" set nag="PLEASE Select A CHOICE 1-8 or b/c"
goto Menu

:Null
cls
set nag="NOT A FEATURE YET!"
(goto) 2>nul

:1
:Reinstall-Discord-Canary
cls
rmdir /s /q .\bin\discord_canary\
call :Discord-Canary-Check
exit /b 2

:2
:Launch-Discord-Canary
cls
set "UserProfile=%CD%\data"
start .\bin\discord_canary\DiscordCanary.exe
exit

:3
:Reset-Discord-Canary
call :Null
exit /b 2

:4
:Uninstall-Discord-Canary
cls
rmdir /s /q .\bin\discord_canary\
exit

:5
:Update-Check
if exist version.txt del version.txt
if not exist .\bin\wget.exe call :Download-Wget
cls
title Portable Discord Canary Launcher - Experimental Edition - Checking For Update
.\bin\wget.exe -q --show-progress https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/version.txt
set Counter=0 & for /f "DELIMS=" %%i in ('type version.txt') do (set /a Counter+=1 & set "Line_!Counter!=%%i")
if exist version.txt del version.txt
set new_version=%Line_30%
if "%new_version%"=="OFFLINE" call :Error-Offline & exit /b 2
if %current_version% EQU %new_version% call :Latest-Build & exit /b 2
if %current_version% LSS %new_version% call :New-Update & exit /b 2
if %current_version% GTR %new_version% call :Preview-Build & exit /b 2
call :Error-Offline & exit /b 2

:6
:About
cls
del .\doc\discord_canary_license.txt
start launch_discord_canary.bat
exit

:7
:Exit
exit

:8
:Write-Discord-Canary-Change-Log
cls
title Portable Discord Canary Launcher - Expiremental Edition - Change Log
:: https://ss64.com/nt/chcp.html
chcp 65001 >nul:
echo =========================================================================== > .\doc\discord_canary_changelog.txt 
echo =                         Discord Canary Launcher - v1                  = >> .\doc\discord_canary_changelog.txt
echo =                          Experimental Code Edition                      = >> .\doc\discord_canary_changelog.txt
echo =========================================================================== >> .\doc\discord_canary_changelog.txt
echo = (ﾉ◕ヮ◕)ﾉ Type Any Labels Name To Goto It (Useful For Debugging)          = >> .\doc\discord_canary_changelog.txt
echo = (ﾉ◕ヮ◕)ﾉ Updater Now Hides Itself And Deletes Itself On Completion       = >> .\doc\discord_canary_changelog.txt
echo = (ﾉ◕ヮ◕)ﾉ (goto) 2^>nul                                                    = >> .\doc\discord_canary_changelog.txt
echo = (ﾉ◕ヮ◕)ﾉ Made Code Slightly Cleaner But Kinda Not                        = >> .\doc\discord_canary_changelog.txt
echo = (ﾉ◕ヮ◕)ﾉ Maybe Other Stuff I Forgot To Mention                           = >> .\doc\discord_canary_changelog.txt
echo =========================================================================== >> .\doc\discord_canary_changelog.txt
echo = (ﾉ◕ヮ◕)ﾉ Further improvements to overall system stability and other      = >> .\doc\discord_canary_changelog.txt
echo = (ﾉ◕ヮ◕)ﾉ minor adjustments have been made to enhance the user experience = >> .\doc\discord_canary_changelog.txt
echo =========================================================================== >> .\doc\discord_canary_changelog.txt
echo. >> .\doc\discord_canary_changelog.txt
echo =========================================================================== > .\doc\discord_canary_changelog.txt 
echo =                         Discord Canary Launcher - v2                  = >> .\doc\discord_canary_changelog.txt
echo =                          Experimental Code Edition                      = >> .\doc\discord_canary_changelog.txt
echo =========================================================================== >> .\doc\discord_canary_changelog.txt
echo = (ﾉ◕ヮ◕)ﾉ Further improvements to overall system stability and other      = >> .\doc\discord_canary_changelog.txt
echo = (ﾉ◕ヮ◕)ﾉ minor adjustments have been made to enhance the user experience = >> .\doc\discord_canary_changelog.txt
echo =========================================================================== >> .\doc\discord_canary_changelog.txt
echo. >> .\doc\discord_canary_changelog.txt
echo =========================================================================== > .\doc\discord_canary_changelog.txt 
echo =                         Discord Canary Launcher - v3                  = >> .\doc\discord_canary_changelog.txt
echo =                          Experimental Code Edition                      = >> .\doc\discord_canary_changelog.txt
echo =========================================================================== >> .\doc\discord_canary_changelog.txt
echo = (ﾉ◕ヮ◕)ﾉ Further improvements to overall system stability and other      = >> .\doc\discord_canary_changelog.txt
echo = (ﾉ◕ヮ◕)ﾉ minor adjustments have been made to enhance the user experience = >> .\doc\discord_canary_changelog.txt
echo =========================================================================== >> .\doc\discord_canary_changelog.txt
chcp 437 >nul:
notepad.exe .\doc\discord_canary_changelog.txt
exit /b 2

:a
:DLL-Downloader-Check
cls & title Portable Discord Canary Launcher - Experimental Edition - Download Dll Downloader
cls & if not exist .\bin\wget.exe call :Download-Wget
cls & .\bin\wget.exe -q --show-progress https://raw.githubusercontent.com/MarioMasta64/DLLDownloaderPortable/master/launch_dlldownloader.bat
cls & if exist launch_dlldownloader.bat.1 del launch_dlldownloader.bat & rename launch_dlldownloader.bat.1 launch_dlldownloader.bat
cls & start launch_dlldownloader.bat
exit /b 2

:b
:Portable-Everything
cls & title Portable Discord Canary Launcher - Experimental Edition - Download Suite
cls & if not exist .\bin\wget.exe call :Download-Wget
cls & .\bin\wget.exe -q --show-progress https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/launch_everything.bat
cls & if exist launch_everything.bat.1 del launch_everything.bat & rename launch_everything.bat.1 launch_everything.bat
cls & start launch_everything.bat
exit /b 2

:c
:Quicklauncher-Check
cls
title Portable Discord Canary Launcher - Experimental Edition - Quicklauncher Writer
echo @echo off > quicklaunch_discord_canary.bat
echo Color 0A >> quicklaunch_discord_canary.bat
echo cls >> quicklaunch_discord_canary.bat >> quicklaunch_discord_canary.bat
echo set "UserProfile=%%CD%%\data" >> quicklaunch_discord_canary.bat
echo start .\bin\discord_canary\DiscordCanary.exe >> quicklaunch_discord_canary.bat
echo exit >> quicklaunch_discord_canary.bat
pause>nul:
exit /b 2

########################################################################

:: program specific stuff that can easily be changed below
:: stuff that is almost identical betwwen stuff

########################################################################

:Folder-Check
cls
if not exist .\bin\discord_canary\ mkdir .\bin\discord_canary\
if not exist .\data\AppData\Roaming\ mkdir .\data\AppData\Roaming\
:: dll folder check removed because dll downloader creates it
if not exist .\doc\ mkdir .\doc\
if not exist .\extra\ mkdir .\extra\
(goto) 2>nul

########################################################################

:Version
cls
echo 2 > .\doc\version.txt
set /p current_version=<.\doc\version.txt
if exist .\doc\version.txt del .\doc\version.txt
:: REPLACE ALL exit /b that dont need an error code (a value after it) with "exit"
(goto) 2>nul

########################################################################

:Credits
cls
if not exist .\doc\discord_canary_changelog.txt call :Write-Discord-Canary-Change-Log
if exist .\doc\discord_canary_license.txt (goto) 2>nul
echo ================================================== > .\doc\discord_canary_license.txt
echo =              Script by MarioMasta64            = >> .\doc\discord_canary_license.txt
echo =           Script Version: v%current_version%- release        = >> .\doc\discord_canary_license.txt
echo ================================================== >> .\doc\discord_canary_license.txt
echo =You may Modify this WITH consent of the original= >> .\doc\discord_canary_license.txt
echo = creator, as long as you include a copy of this = >> .\doc\discord_canary_license.txt
echo =      as you include a copy of the License      = >> .\doc\discord_canary_license.txt
echo ================================================== >> .\doc\discord_canary_license.txt
echo =    You may also modify this script without     = >> .\doc\discord_canary_license.txt
echo =         consent for PERSONAL USE ONLY          = >> .\doc\discord_canary_license.txt
echo ================================================== >> .\doc\discord_canary_license.txt
cls
title Portable Discord Canary Launcher - Experimental Edition - About
for /f "DELIMS=" %%i in (.\doc\discord_canary_license.txt) do (echo %%i)
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
title Portable Discord Canary Launcher - Experimental Edition - Download Wget
cscript.exe .\bin\downloadwget.vbs
move wget.exe .\bin\
(goto) 2>nul

########################################################################

:Download-7zip
cls
title Portable Discord Canary Launcher - Experimental Edition - Download 7zip
if not exist .\bin\wget.exe call :Download-Wget
.\bin\wget.exe -q --show-progress http://downloads.sourceforge.net/portableapps/7-ZipPortable_16.04.paf.exe
if not exist 7-ZipPortable_16.04.paf.exe goto :Download-7zip
move 7-ZipPortable_16.04.paf.exe .\extra\7-ZipPortable_16.04.paf.exe
.\extra\7-ZipPortable_16.04.paf.exe /destination="%CD%\bin\"
(goto) 2>nul

########################################################################

:Create-Hide
echo CreateObject("Wscript.Shell").Run """" ^& WScript.Arguments(0) ^& """", 0, False > .\bin\hide.vbs
(goto) 2>nul

########################################################################

:: scripts that are program specific are below

########################################################################

:Discord-Canary-Check
cls
if not exist .\bin\discord_canary\DiscordCanary.exe call :File-Check & goto Discord-Canary-Check
(goto) 2>nul

:File-Check
if not exist .\extra\discord_canary.exe call :Download-Discord-Canary
if exist .\extra\discord_canary.exe call :Extract-Discord-Canary
(goto) 2>nul

:Download-Discord-Canary
if exist "canary@platform=win" rename "canary@platform=win" discord_canary.exe
if exist discord_canary.exe call :Move-Discord-Canary & (goto) 2>nul
if not exist .\bin\wget.exe call :Download-Wget
cls
title Portable Discord Canary Launcher - Experimental Edition - Download Discord-Canary
.\bin\wget.exe -q --show-progress "https://discordapp.com/api/download/canary?platform=win"

:Move-Discord-Canary
cls
if not exist discord_canary.exe (goto) 2>nul
move discord_canary.exe .\extra\discord_canary.exe
(goto) 2>nul

########################################################################

:Extract-Discord-Canary
cls
title Portable Discord Canary Launcher - Experimental Edition - Extract Discord Canary
if not exist .\temp\Discord*.nupkg call :Extract-Discord-Canary-Binary
if exist .\temp\Discord*.nupkg call :Extract-Discord-Canary-Nupkg
(goto) 2>nul

########################################################################

:Extract-Discord-Canary-Binary
cls
title Portable Discord Canary Launcher - Experimental Edition - Extract Discord Canary Binary
if not exist .\bin\7-ZipPortable\App\7-Zip\7z.exe call :Download-7zip
.\bin\7-ZipPortable\App\7-Zip\7z.exe x .\extra\discord_canary.exe * -o.\temp\
del .\temp\RELEASES
del .\temp\Update.exe
del .\extra\discord_canary.exe
(goto) 2>nul

########################################################################

:Extract-Discord-Canary-Nupkg
cls
title Portable Discord Canary Launcher - Experimental Edition - Extract Discord Canary Nupkg
for %%d in (.\temp\DiscordCanary*.nupkg) do set discord=%%d
if not exist .\bin\7-ZipPortable\App\7-Zip\7z.exe call :Download-7zip
.\bin\7-ZipPortable\App\7-Zip\7z.exe x %discord% * -o.\temp\
del %discord%
xcopy .\temp\lib\net45\* .\bin\discord_canary\ /e /i /y
rmdir /s /q .\temp\
del .\bin\discord_canary\Squirrel.exe
(goto) 2>nul

#######################################################################

:: scripts that are used for updating things are below

########################################################################

:Update-Wget
cls
title Portable Discord Canary Launcher - Experimental Edition - Update Wget
.\bin\wget.exe -q --show-progress https://eternallybored.org/misc/wget/current/wget.exe
move wget.exe .\bin\
(goto) 2>nul

########################################################################

:Latest-Build
cls
title Portable Discord Canary Launcher - Experimental Edition - Latest Build :D
echo you are using the latest version!!
echo Current Version: v%current_version%
echo New Version: v%new_version%
pause>nul:
start launch_discord_canary.bat
exit

:New-Update
cls
title Portable Discord Canary Launcher - Experimental Edition - Old Build D:
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
cls & title Portable Discord Canary Launcher - Experimental Edition - Updating Launcher
cls & .\bin\wget.exe -q --show-progress https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/raw/master/launch_discord_canary.bat
cls & if exist launch_discord_canary.bat.1 goto Replacer-Create
cls & call :Error-Offline
(goto) 2>nul

:Replacer-Create
cls
echo @echo off > replacer.bat
echo Color 0A >> replacer.bat
echo del launch_discord_canary.bat >> replacer.bat
echo rename launch_discord_canary.bat.1 launch_discord_canary.bat >> replacer.bat
echo start launch_discord_canary.bat >> replacer.bat
:: launcher exits, deletes itself, and then exits again. yes. its magic.
echo (goto) 2^>nul ^& del "%%~f0" ^& exit >> replacer.bat
wscript "%CD%\bin\hide.vbs" "replacer.bat"
if exist .\doc\discord_canary_changelog.txt del .\doc\discord_canary_changelog.txt
exit

:Preview-Build
cls
title Portable Discord Canary Launcher - Experimental Edition - Test Build :0
echo YOURE USING A TEST BUILD MEANING YOURE EITHER
echo CLOSE TO ME OR YOURE SOME SORT OF PIRATE
echo Current Version: v%current_version%
echo New Version: v%new_version%
echo ENTER TO CONTINUE
pause>nul:
start launch_discord_canary.bat
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
title Portable Discord Canary Launcher - Experimental Edition - Command Prompt - By MarioMasta64
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

make a way to flip through pages in changelog
because i use the call command. you can edit the file add a label and goto the label by typing it in the menu without even having to close the program cause youre worried about it glitching (put your code on the bottom)
add raw before raw/master in everything
apparently raw is bad before master but only sometimes?
raw is perfect for text links tho

########################################################################