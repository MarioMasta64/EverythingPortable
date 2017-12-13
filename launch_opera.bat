:: this space fixes a problem somehow dont remove
@echo off
Color 0A
cls
title Portable Opera Launcher - Experimental Edition
:: no more need to check if caps is on or off
set nag=EXPERIMENTS :D
set new_version=OFFLINE
if "%~1" neq "" (call :%~1 & exit /b !current_version!)
if exist launch_opera_poc.bat del launch_opera_poc.bat

:: allows letters to be set as numbers
setlocal enabledelayedexpansion
call :Alpha-To-Number

:: no version check needed.

call :Folder-Check
call :Version
call :Credits
call :Check-Scripts
call :Opera-Check

:Menu
cls
title Portable Opera Launcher - Experimental Edition - Main Menu
echo %NAG%
set nag="Selection Time!"
echo 1. reinstall opera [will remove opera entirely]
echo 2. launch opera [launches opera]
echo 3. reset opera [not a feature yet]
echo 4. uninstall opera [THEY GOT BOUGHT OUT BY WHO?!?]
echo 5. update program [check for updates]
echo 6. about [shoulda named this credits]
echo 7. exit [EXIT]
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
:Reinstall-Opera
cls
rmdir /s /q .\bin\opera\
call :Opera-Check
exit /b 2

:2
:Launch-Opera
set "AppData=%CD%\data\AppData\Roaming\"
set "LocalAppData=%CD%\data\AppData\Local\"
start .\bin\opera\launcher.exe https://github.com/MarioMasta64/EverythingPortable/releases/latest/
exit

:3
:Reset-Opera
call :Null
exit /b 2

:4
:Uninstall-Opera
cls
rmdir /s /q .\bin\opera\
rmdir /s /q .\data\AppData\Local\temp\
rmdir /s /q .\data\AppData\Roaming\opera\
exit

:5
:Update-Check
if exist version.txt del version.txt
if not exist .\bin\wget.exe call :Download-Wget
cls
title Portable Opera Launcher - Experimental Edition - Checking For Update
.\bin\wget.exe -q --show-progress https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/version.txt
set Counter=0 & for /f "DELIMS=" %%i in ('type version.txt') do (set /a Counter+=1 & set "Line_!Counter!=%%i")
if exist version.txt del version.txt
set new_version=%Line_34%
if "%new_version%"=="OFFLINE" call :Error-Offline & exit /b 2
if %current_version% EQU %new_version% call :Latest-Build & exit /b 2
if %current_version% LSS %new_version% call :New-Update & exit /b 2
if %current_version% GTR %new_version% call :Preview-Build & exit /b 2
call :Error-Offline & exit /b 2

:6
:About
cls
del .\doc\opera_license.txt
start launch_opera.bat
exit

:7
:Exit
exit

:a
:DLL-Downloader-Check
cls & title Portable Opera Launcher - Experimental Edition - Download Dll Downloader
cls & if not exist .\bin\wget.exe call :Download-Wget
cls & .\bin\wget.exe -q --show-progress https://raw.githubusercontent.com/MarioMasta64/DLLDownloaderPortable/master/launch_dlldownloader.bat
cls & if exist launch_dlldownloader.bat.1 del launch_dlldownloader.bat & rename launch_dlldownloader.bat.1 launch_dlldownloader.bat
cls & start launch_dlldownloader.bat
exit /b 2

:b
:Portable-Everything
cls & title Portable Opera Launcher - Experimental Edition - Download Suite
cls & if not exist .\bin\wget.exe call :Download-Wget
cls & .\bin\wget.exe -q --show-progress https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/launch_everything.bat
cls & if exist launch_everything.bat.1 del launch_everything.bat & rename launch_everything.bat.1 launch_everything.bat
cls & start launch_everything.bat
exit /b 2

:c
:Quicklauncher-Check
cls
title Portable Opera Launcher - Experimental Edition - Quicklauncher Writer
echo @echo off > quicklaunch_opera.bat
echo Color 0A >> quicklaunch_opera.bat
echo cls >> quicklaunch_opera.bat >> quicklaunch_opera.bat
echo set "AppData=%%CD%%\data\AppData\Roaming\" >> quicklaunch_opera.bat
echo set "LocalAppData=%%CD%%\data\AppData\Local\" >> quicklaunch_opera.bat
echo start .\bin\opera\launcher.exe https://github.com/MarioMasta64/EverythingPortable/releases/latest/ >> quicklaunch_opera.bat
echo exit >> quicklaunch_opera.bat
echo ENTER TO CONTINUE & pause>nul:
exit /b 2

########################################################################

:: program specific stuff that can easily be changed below
:: stuff that is almost identical betwwen stuff

########################################################################

:Folder-Check
cls
if not exist .\bin\opera\ mkdir .\bin\opera\
if not exist .\data\AppData\Local\ mkdir .\data\AppData\Local\
if not exist .\data\AppData\Roaming\ mkdir .\data\AppData\Roaming\
:: dll folder check removed because dll downloader creates it
if not exist .\doc\ mkdir .\doc\
if not exist .\extra\ mkdir .\extra\
(goto) 2>nul

########################################################################

:Version
cls
echo 1 > .\doc\version.txt
set /p current_version=<.\doc\version.txt
if exist .\doc\version.txt del .\doc\version.txt
:: REPLACE ALL exit /b that dont need an error code (a value after it) with "exit"
(goto) 2>nul

########################################################################

:Credits
cls
if exist .\doc\opera_license.txt (goto) 2>nul
echo ================================================== > .\doc\opera_license.txt
echo =              Script by MarioMasta64            = >> .\doc\opera_license.txt
echo =           Script Version: v%current_version%- release        = >> .\doc\opera_license.txt
echo ================================================== >> .\doc\opera_license.txt
echo =You may Modify this WITH consent of the original= >> .\doc\opera_license.txt
echo = creator, as long as you include a copy of this = >> .\doc\opera_license.txt
echo =      as you include a copy of the License      = >> .\doc\opera_license.txt
echo ================================================== >> .\doc\opera_license.txt
echo =    You may also modify this script without     = >> .\doc\opera_license.txt
echo =         consent for PERSONAL USE ONLY          = >> .\doc\opera_license.txt
echo ================================================== >> .\doc\opera_license.txt
cls
title Portable Opera Launcher - Experimental Edition - About
for /f "DELIMS=" %%i in (.\doc\opera_license.txt) do (echo %%i)
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
title Portable Opera Launcher - Experimental Edition - Download Wget
cscript.exe .\bin\downloadwget.vbs
move wget.exe .\bin\
(goto) 2>nul

########################################################################

:Download-7zip
cls
title Portable Opera Launcher - Experimental Edition - Download 7zip
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

:Opera-Check
cls
if not exist .\bin\opera\launcher.exe call :File-Check & goto Opera-Check
(goto) 2>nul

:File-Check
if not exist .\extra\Opera_PortableSetup.exe call :Download-Opera
if exist .\extra\Opera_PortableSetup.exe call :Install-Opera
(goto) 2>nul

:Download-Opera
if exist "windows*" del /q "windows*"
if exist Opera_PortableSetup.exe call :Move-Opera & (goto) 2>nul
if not exist .\bin\wget.exe call :Download-Wget
cls
title Portable Opera Launcher - Experimental Edition - Download Opera
.\bin\wget.exe -q --show-progress "http://net.geo.opera.com/opera_portable/stable/windows?http_referrer=missing_via_opera_com&utm_source=(direct)_via_opera_com&utm_medium=doc&utm_campaign=(direct)_via_opera_com&dl_token=39379966"

:Rename-Opera
if exist "windows*" rename "windows*" "Opera_PortableSetup.exe"

:Move-Opera
cls
if not exist Opera_PortableSetup.exe (goto) 2>nul
move Opera_PortableSetup.exe .\extra\Opera_PortableSetup.exe
(goto) 2>nul

########################################################################

:Install-Opera
cls
title Portable Opera Launcher - Experimental Edition - Install Opera
echo Please Wait, Opera Is Installing...
set "TMP=%CD%\data\AppData\Local\temp\"
.\extra\Opera_PortableSetup.exe /silent /installfolder=%CD%\bin\opera\ /allusers=0 /copyonly=1 /singleprofile=1 /setdefaultbrowser=0 /desktopshortcut=0 /startmenushortcut=0 /quicklaunchshortcut=0 /pintotaskbar=0 /import-browser-data=0 /enable-stats=0 /enable-installer-stats=0 /launchbrowser=0
rmdir /s /q .\data\AppData\Local\temp\
del .\extra\debug.log
(goto) 2>nul

########################################################################

:: scripts that are used for updating things are below

########################################################################

:Update-Wget
cls
title Portable Opera Launcher - Experimental Edition - Update Wget
.\bin\wget.exe -q --show-progress https://eternallybored.org/misc/wget/current/wget.exe
move wget.exe .\bin\
(goto) 2>nul

########################################################################

:Latest-Build
cls
title Portable Opera Launcher - Experimental Edition - Latest Build :D
echo you are using the latest version!!
echo Current Version: v%current_version%
echo New Version: v%new_version%
echo ENTER TO CONTINUE & pause>nul:
start launch_opera.bat
exit

:New-Update
cls
title Portable Opera Launcher - Experimental Edition - Old Build D:
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
cls & title Portable Opera Launcher - Experimental Edition - Updating Launcher
cls & .\bin\wget.exe -q --show-progress https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/launch_opera.bat
cls & if exist launch_opera.bat.1 goto Replacer-Create
cls & call :Error-Offline
(goto) 2>nul

:Replacer-Create
cls
echo @echo off > replacer.bat
echo Color 0A >> replacer.bat
echo del launch_opera.bat >> replacer.bat
echo rename launch_opera.bat.1 launch_opera.bat >> replacer.bat
echo start launch_opera.bat >> replacer.bat
:: launcher exits, deletes itself, and then exits again. yes. its magic.
echo (goto) 2^>nul ^& del "%%~f0" ^& exit >> replacer.bat
wscript "%CD%\bin\hide.vbs" "replacer.bat"
exit

:Preview-Build
cls
title Portable Opera Launcher - Experimental Edition - Test Build :0
echo YOURE USING A TEST BUILD MEANING YOURE EITHER
echo CLOSE TO ME OR YOURE SOME SORT OF PIRATE
echo Current Version: v%current_version%
echo New Version: v%new_version%
echo ENTER TO CONTINUE
echo ENTER TO CONTINUE & pause>nul:
start launch_opera.bat
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
title Portable Opera Launcher - Experimental Edition - Command Prompt - By MarioMasta64
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

because i use the call command. you can edit the file add a label and goto the label by typing it in the menu without even having to close the program cause youre worried about it glitching (put your code on the bottom)
add raw before raw/master in everything
apparently raw is bad before master but only sometimes?
raw is perfect for text links tho

########################################################################