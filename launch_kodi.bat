:: this space fixes a problem somehow dont remove
@echo off
Color 0A
cls
title Portable Kodi Launcher - Experimental Edition
set nag=EXPIREMENTS :D
set new_version=OFFLINE
if "%~1" neq "" (call :%~1 & exit /b !current_version!)

call :Folder-Check
call :Check-Scripts
call :Set-Arch
call :Version
call :Credits
call :MoTD

if not exist .\bin\kodi\kodi.exe set nag=KODI IS NOT INSTALLED CHOOSE "E"

:Menu
cls
title Portable Kodi Launcher - Experimental Edition - Main Menu
echo %NAG%
set nag="Selection Time!"
echo 1. reinstall kodi [will remove kodi entirely]
echo 2. launch kodi [launches kodi]
echo 3. reset kodi [will remove everything kodi except the binary]
echo 4. uninstall kodi [Did Exodus Shutdown Get To You? :^^)]
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
echo e. check for new kodi version [automatically check for a new version]
echo.
set /p choice="enter a number and press enter to confirm: "
:: sets errorlevel to 0 (?)
ver > nul
:: an incorrect call throws an errorlevel of 1
:: replace all goto Main with exit /b 2 (if they are called by the main menu)
call :%choice%
if "%ERRORLEVEL%" NEQ "2" set nag="PLEASE Select A CHOICE 1-7 or a/b/c/e"
goto Menu

:Null
cls
set nag="NOT A FEATURE YET!"
(goto) 2>nul

:1
:Reinstall-Kodi
cls
rmdir /s /q .\bin\kodi\
call :Kodi-Check
exit /b 2

:2
:Launch-Kodi
set "path=%path%;%CD%\dll\32\;"
set "appdata=%CD%\data\AppData\Roaming\"
start .\bin\kodi\kodi.exe -p
exit

:3
:Reset-Kodi
cls
for %%i in (.\bin\kodi\*) do if not "%%i" == ".\bin\kodi\Kodi.exe" del %%i
for /d %%d in (.\bin\kodi\*) do rmdir /s /q "%%d"
exit /b 2

:4
:Uninstall-Kodi
cls
rmdir /s /q .\bin\kodi\
exit

:5
:Update-Check
if exist version.txt del version.txt
if not exist .\bin\wget.exe call :Download-Wget
cls
title Portable Kodi Launcher - Experimental Edition - Checking For Update
.\bin\wget.exe -q --show-progress --continue https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/version.txt
set Counter=0 & for /f "DELIMS=" %%i in ('type version.txt') do (set /a Counter+=1 & set "Line_!Counter!=%%i")
if exist version.txt del version.txt
set new_version=%Line_26%
if "%new_version%"=="OFFLINE" call :Error-Offline & exit /b 2
if %current_version% EQU %new_version% call :Latest-Build & exit /b 2
if %current_version% LSS %new_version% call :New-Update & exit /b 2
if %current_version% GTR %new_version% call :Preview-Build & exit /b 2
call :Error-Offline & exit /b 2

:6
:About
cls
del .\doc\kodi_license.txt
start launch_kodi.bat
exit

:7
exit

:a
:DLL-Downloader-Check
cls & title Portable Kodi Launcher - Experimental Edition - Download Dll Downloader
cls & if not exist .\bin\wget.exe call :Download-Wget
cls & .\bin\wget.exe -q --show-progress --continue https://raw.githubusercontent.com/MarioMasta64/DLLDownloaderPortable/master/launch_dlldownloader.bat
cls & if exist launch_dlldownloader.bat.1 del launch_dlldownloader.bat & rename launch_dlldownloader.bat.1 launch_dlldownloader.bat
cls & start launch_dlldownloader.bat
exit /b 2

:b
:Portable-Everything
cls & title Portable Kodi Launcher - Experimental Edition - Download Suite
cls & if not exist .\bin\wget.exe call :Download-Wget
cls & .\bin\wget.exe -q --show-progress --continue https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/launch_everything.bat
cls & if exist launch_everything.bat.1 del launch_everything.bat & rename launch_everything.bat.1 launch_everything.bat
cls & start launch_everything.bat
exit /b 2

:c
:Quicklauncher-Check
cls
title Portable Kodi Launcher - Experimental Edition - Quicklauncher Writer
echo @echo off > quicklaunch_kodi.bat
echo Color 0A >> quicklaunch_kodi.bat
echo cls >> quicklaunch_kodi.bat
echo set "path=%path%;%CD%\dll\32\;" >> quicklaunch_kodi.bat
echo set "appdata=%CD%\data\AppData\Roaming\" >> quicklaunch_kodi.bat
echo start .\bin\kodi\kodi.exe -p >> quicklaunch_kodi.bat
echo exit >> quicklaunch_kodi.bat
echo A QUICKLAUNCHER HAS BEEN WRITTEN TO: quicklaunch_kodi.bat
echo ENTER TO CONTINUE & pause>nul:
exit /b 2

:d
:: other mod stuff
call :Null
exit /b 2

:e
:Upgrade-Kodi
title Portable Kodi Launcher - Expiremental Edition - Kodi Update Check
if not exist .\bin\wget.exe call :Download-Wget
if exist index.html del index.html
.\bin\wget.exe -q --show-progress --continue http://mirrors.kodi.tv/releases/win32/
for /f tokens^=2delims^=^" %%A in (
  'findstr /i /c:"kodi-" /c:"kodi-" index.html'
) Do > .\doc\kodi_link.txt Echo:%%A
set /p kodi_exe=<.\doc\kodi_link.txt
if exist index.html del index.html
if not exist .\bin\wget.exe call :Download-Wget
cls
echo %kodi_exe% & pause
set broke=0
if exist .\extra\%kodi_exe% (
  echo kodi is updated.
  pause
  exit /b
)
cls
echo upgrading to kodi v%kodi_exe:~5,4% & call :Upgrade-Build
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
if not exist .\data\AppData\Roaming\ mkdir .\data\AppData\Roaming\
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
if exist .\doc\kodi_license.txt (goto) 2>nul
echo ================================================== > .\doc\kodi_license.txt
echo =              Script by MarioMasta64            = >> .\doc\kodi_license.txt
echo =           Script Version: v%current_version%- release        = >> .\doc\kodi_license.txt
echo ================================================== >> .\doc\kodi_license.txt
echo =You may Modify this WITH consent of the original= >> .\doc\kodi_license.txt
echo = creator, as long as you include a copy of this = >> .\doc\kodi_license.txt
echo =      as you include a copy of the License      = >> .\doc\kodi_license.txt
echo ================================================== >> .\doc\kodi_license.txt
echo =    You may also modify this script without     = >> .\doc\kodi_license.txt
echo =         consent for PERSONAL USE ONLY          = >> .\doc\kodi_license.txt
echo ================================================== >> .\doc\kodi_license.txt
cls
title Portable Kodi Launcher - Experimental Edition - About
for /f "DELIMS=" %%i in (.\doc\kodi_license.txt) do (echo %%i)
pause
call :Ping-Install
(goto) 2>nul

########################################################################

:: if a script can be used between files then it can be put here and re-written only if it doesnt exist
:: stuff here will not be changed between programs

########################################################################

:Set-Arch
set arch=32
if exist "%PROGRAMFILES(X86)%" set "arch=64"
(goto) 2>nul

########################################################################

:Check-Scripts
if not exist .\bin\downloadwget.vbs call :Create-Wget-Downloader
if not exist .\bin\hide.vbs call :Create-Hide
if not exist .\bin\extractzip.vbs call :Create-Zip-Extractor
if not exist .\bin\replacetext.vbs call :Create-Text-Replacer
(goto) 2>nul

########################################################################

:Create-Wget-Downloader
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

:Create-Hide
echo CreateObject("Wscript.Shell").Run """" ^& WScript.Arguments(0) ^& """", 0, False > .\bin\hide.vbs
(goto) 2>nul

########################################################################

:Create-Zip-Extractor
echo 'The location of the zip file. > .\bin\extractzip.vbs
echo ZipFile = Wscript.Arguments(0) >> .\bin\extractzip.vbs
echo 'The folder the contents should be extracted to. >> .\bin\extractzip.vbs
echo ExtractTo = Wscript.Arguments(1) >> .\bin\extractzip.vbs
echo. >> .\bin\extractzip.vbs
echo 'If the extraction location does not exist create it. >> .\bin\extractzip.vbs
echo Set fso = CreateObject("Scripting.FileSystemObject") >> .\bin\extractzip.vbs
echo If NOT fso.FolderExists(ExtractTo) Then >> .\bin\extractzip.vbs
echo fso.CreateFolder(ExtractTo) >> .\bin\extractzip.vbs
echo End If >> .\bin\extractzip.vbs
echo. >> .\bin\extractzip.vbs
echo 'Extract the contants of the zip file. >> .\bin\extractzip.vbs
echo set objShell = CreateObject("Shell.Application") >> .\bin\extractzip.vbs
echo set FilesInZip=objShell.NameSpace(ZipFile).items >> .\bin\extractzip.vbs
echo objShell.NameSpace(ExtractTo).CopyHere(FilesInZip) >> .\bin\extractzip.vbs
echo Set fso = Nothing >> .\bin\extractzip.vbs
echo Set objShell = Nothing >> .\bin\extractzip.vbs
(goto) 2>nul

########################################################################

:Create-Text-Replacer
echo Const ForReading = 1 > .\bin\replacetext.vbs
echo Const ForWriting = 2 >> .\bin\replacetext.vbs
echo. >> .\bin\replacetext.vbs
echo strFileName = Wscript.Arguments(0) >> .\bin\replacetext.vbs
echo strOldText = Wscript.Arguments(1) >> .\bin\replacetext.vbs
echo strNewText = Wscript.Arguments(2) >> .\bin\replacetext.vbs
echo. >> .\bin\replacetext.vbs
echo Set objFSO = CreateObject("Scripting.FileSystemObject") >> .\bin\replacetext.vbs
echo Set objFile = objFSO.OpenTextFile(strFileName, ForReading) >> .\bin\replacetext.vbs
echo strText = objFile.ReadAll >> .\bin\replacetext.vbs
echo objFile.Close >> .\bin\replacetext.vbs
echo. >> .\bin\replacetext.vbs
echo strNewText = Replace(strText, strOldText, strNewText) >> .\bin\replacetext.vbs
echo Set objFile = objFSO.OpenTextFile(strFileName, ForWriting) >> .\bin\replacetext.vbs
echo objFile.Write strNewText  'WriteLine adds extra CR/LF >> .\bin\replacetext.vbs
echo objFile.Close >> .\bin\replacetext.vbs
(goto) 2>nul

########################################################################

:Ping-Install
setlocal enabledelayedexpansion
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
echo https://hackinformer.com/NintendoGuide/test/test.php?program=%program:~7%^&serial=%sha1%
.\bin\wget -q --show-progress --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.115 Safari/537.36" https://hackinformer.com/NintendoGuide/test/test.php?program=%program:~7%^&serial=%sha1%
endlocal
del test.php*
del serial.txt
(goto) 2>nul

########################################################################

:MoTD
if not exist .\bin\wget.exe call :Download-Wget
title checking for message of the day
set program=%~n0>nul:
.\bin\wget.exe -q --show-progress https://github.com/MarioMasta64/EverythingPortable/raw/master/note/motd.txt>nul:
if exist motd.txt del .\note\motd.txt>nul:
if exist motd.txt (
  del /s /q .\note\motd.txt>nul:
  copy motd.txt .\note\motd.txt
)
if exist .\note\motd.txt for /f "DELIMS=" %%i in ('type .\note\motd.txt') do (set nag=%%i)
del /s /q motd.txt*>nul:
(goto) 2>nul

########################################################################

End Of Scripts

########################################################################

:Extract-Zip
cls
set dir=%1
set file=%2
set folder=%CD%
if "%CD%"=="%~d0\" "set folder=%CD:~0,2%"
cscript .\bin\extractzip.vbs "%folder%\%file%" "%folder%\%dir%"
(goto) 2>nul

########################################################################

:Extract-7Zip
if not exist .\bin\7-ZipPortable\7-ZipPortable.exe call :Download-7zip
cls
set dir=%1
set file=%2
set folder=%CD%
if "%CD%"=="%~d0\" "set folder=%CD:~0,2%"
.\bin\7-ZipPortable\App\7-Zip%arch%\7z.exe x "%folder%\%file%" * -o"%folder%\%dir%"
(goto) 2>nul

########################################################################

:Download-Wget
cls
title Portable Kodi Launcher - Experimental Edition - Download Wget
cscript.exe .\bin\downloadwget.vbs
move wget.exe .\bin\
(goto) 2>nul

########################################################################

:Download-7zip
cls
if not exist .\bin\wget.exe call :Download-Wget
title Portable Kodi Launcher - Experimental Edition - Download 7zip
if not exist .\extra\7-ZipPortable_16.04.paf.exe .\bin\wget.exe -q --show-progress --continue http://downloads.sourceforge.net/portableapps/7-ZipPortable_16.04.paf.exe & move 7-ZipPortable_16.04.paf.exe .\extra\7-ZipPortable_16.04.paf.exe
.\extra\7-ZipPortable_16.04.paf.exe /destination="%CD%\bin\"
(goto) 2>nul

########################################################################

:: scripts that are program specific are below

########################################################################

:: scripts that are used for updating things are below

########################################################################

:Upgrade-Kodi
cls
del .\bin\kodi\Kodi.exe
(goto) 2>nul

########################################################################

:Update-Wget
cls
title Portable Kodi Launcher - Experimental Edition - Update Wget
.\bin\wget.exe -q --show-progress --continue https://eternallybored.org/misc/wget/current/wget.exe
move wget.exe .\bin\
(goto) 2>nul

########################################################################

:Latest-Build
cls
title Portable Kodi Launcher - Experimental Edition - Latest Build :D
echo you are using the latest version!!
echo Current Version: v%current_version%
echo New Version: v%new_version%
echo ENTER TO CONTINUE & pause>nul:
start launch_kodi.bat
exit

:New-Update
cls
title Portable Kodi Launcher - Experimental Edition - Old Build D:
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
cls & title Portable Kodi Launcher - Experimental Edition - Updating Launcher
cls & .\bin\wget.exe -q --show-progress --continue https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/launch_kodi.bat
cls & if exist launch_kodi.bat.1 goto Replacer-Create
cls & call :Error-Offline
(goto) 2>nul

:Replacer-Create
cls
echo @echo off > replacer.bat
echo Color 0A >> replacer.bat
echo del launch_kodi.bat >> replacer.bat
echo rename launch_kodi.bat.1 launch_kodi.bat >> replacer.bat
echo start launch_kodi.bat >> replacer.bat
:: launcher exits, deletes itself, and then exits again. yes. its magic.
echo (goto) 2^>nul ^& del "%%~f0" ^& exit >> replacer.bat
wscript "%CD%\bin\hide.vbs" "replacer.bat"
exit

:Preview-Build
cls
title Portable Kodi Launcher - Experimental Edition - Test Build :0
echo YOURE USING A TEST BUILD MEANING YOURE EITHER
echo CLOSE TO ME OR YOURE SOME SORT OF PIRATE
echo Current Version: v%current_version%
echo New Version: v%new_version%
echo ENTER TO CONTINUE
echo ENTER TO CONTINUE & pause>nul:
start launch_kodi.bat
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
title Portable Kodi Launcher - Experimental Edition - Command Prompt - By MarioMasta64
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

replace launch_kodi.bat with %~f0
because i use the call command. you can edit the file add a label and goto the label by typing it in the menu without even having to close the program cause youre worried about it glitching (put your code on the bottom)
add raw before raw/master in everything
maybe add option to open mod folder?
add new launchers to update check in everything portable
the better link: https://raw.githubusercontent.com/MarioMasta64/ModDownloaderPortable/master/mod_list.txt
apparently raw is bad before master but only sometimes?
raw is perfect for text links tho

########################################################################

:Upgrade-Build
call :Download-Kodi
call :Extract-Kodi
(goto) 2>nul

:Download-Kodi
if not exist .\bin\wget.exe call :Download-Wget
del /s /q kodi*.exe>nul:
.\bin\wget.exe -q --show-progress --continue http://mirrors.kodi.tv/releases/win32/%kodi_exe%
if not exist %kodi_exe% call :Error-Offline & (goto) 2>nul
if exist %kodi_exe% move %kodi_exe% .\extra\%kodi_exe%
(goto) 2>nul

:Extract-Kodi
call :Extract-7Zip bin\kodi\ extra\%kodi_exe%
rmdir /s /q .\bin\kodi\$PLUGINSDIR\
rmdir /s /q .\bin\kodi\$TEMP\
del .\bin\kodi\AppxManifest.xml
del .\bin\kodi\Uninstall.exe
exit /b 2

########################################################################