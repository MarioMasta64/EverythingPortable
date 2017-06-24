@echo off
setlocal enabledelayedexpansion
Color 0A
cls
title PORTABLE OBS LAUNCHER
set nag=BE SURE TO TURN CAPS LOCK OFF! (never said it was on just make sure)
set new_version=OFFLINE
if exist replacer.bat del replacer.bat
if "%~1" neq "" (call :%~1 & exit /b !current_version!)

:FOLDERCHECK
cls
if not exist .\bin\obs\ mkdir .\bin\obs\
if not exist .\dll\32\ mkdir .\dll\32\
if not exist .\dll\64\ mkdir .\dll\64\
if not exist .\doc\ mkdir .\doc\
if not exist .\extra\ mkdir .\extra\
if not exist .\data\obs\ mkdir .\data\obs\
call :VERSION
goto CREDITS

:VERSION
cls
echo 13 > .\doc\version.txt
set /p current_version=<.\doc\version.txt
if exist .\doc\version.txt del .\doc\version.txt
exit /b

:CREDITS
cls
if exist .\doc\obs_license.txt goto ARCHCHECK
echo ================================================== > .\doc\obs_license.txt
echo =              Script by MarioMasta64            = >> .\doc\obs_license.txt
echo =           Script Version: v%current_version%- release        = >> .\doc\obs_license.txt
echo ================================================== >> .\doc\obs_license.txt
echo =You may Modify this WITH consent of the original= >> .\doc\obs_license.txt
echo = creator, as long as you include a copy of this = >> .\doc\obs_license.txt
echo =      as you include a copy of the License      = >> .\doc\obs_license.txt
echo ================================================== >> .\doc\obs_license.txt
echo =    You may also modify this script without     = >> .\doc\obs_license.txt
echo =         consent for PERSONAL USE ONLY          = >> .\doc\obs_license.txt
echo ================================================== >> .\doc\obs_license.txt

:CREDITSREAD
cls
title PORTABLE OBS LAUNCHER - ABOUT
for /f "DELIMS=" %%i in (.\doc\obs_license.txt) do (echo %%i)
pause

:ARCHCHECK
cls
if exist "%PROGRAMFILES(X86)%" set "arch=64" & goto OBSCHECK
set arch=32

:OBSCHECK
cls
if not exist .\bin\obs\bin\%arch%bit\obs%arch%.exe goto FILECHECK
goto WGETUPDATE

:FILECHECK
cls
if not exist .\extra\OBS-Studio-19.0.3-Full.zip goto DOWNLOADOBS
call :EXTRACTOBS
goto OBSCHECK

:DOWNLOADOBS
cls
title PORTABLE OBS LAUNCHER - DOWNLOAD OBS
if exist OBS-Studio-19.0.3-Full.zip goto MOVEOBS
if not exist .\bin\wget.exe call :DOWNLOADWGET
.\bin\wget.exe -q --show-progress https://github.com/jp9000/obs-studio/releases/download/19.0.2/OBS-Studio-19.0.3-Full.zip

:MOVEOBS
cls
move OBS-Studio-19.0.3-Full.zip .\extra\OBS-Studio-19.0.3-Full.zip
goto FILECHECK

:WGETUPDATE
cls
title PORTABLE OBS LAUNCHER - UPDATE WGET
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
title PORTABLE OBS LAUNCHER - DOWNLOAD WGET
cscript.exe .\bin\downloadwget.vbs
move wget.exe .\bin\
exit /b

:EXTRACTOBS
cls
title PORTABLE OBS LAUNCHER - EXTRACT OBS
set folder=%CD%
if %CD%==%~d0\ set folder=%CD:~0,2%
cls
echo. > .\bin\extractobs.vbs
echo 'The location of the zip file. >> .\bin\extractobs.vbs
echo ZipFile="%folder%\extra\OBS-Studio-19.0.3-Full.zip" >> .\bin\extractobs.vbs
echo 'The folder the contents should be extracted to. >> .\bin\extractobs.vbs
echo ExtractTo="%folder%\bin\obs\" >> .\bin\extractobs.vbs
echo. >> .\bin\extractobs.vbs
echo 'If the extraction location does not exist create it. >> .\bin\extractobs.vbs
echo Set fso = CreateObject("Scripting.FileSystemObject") >> .\bin\extractobs.vbs
echo If NOT fso.FolderExists(ExtractTo) Then >> .\bin\extractobs.vbs
echo    fso.CreateFolder(ExtractTo) >> .\bin\extractobs.vbs
echo End If >> .\bin\extractobs.vbs
echo. >> .\bin\extractobs.vbs
echo 'Extract the contants of the zip file. >> .\bin\extractobs.vbs
echo set objShell = CreateObject("Shell.Application") >> .\bin\extractobs.vbs
echo set FilesInZip=objShell.NameSpace(ZipFile).items >> .\bin\extractobs.vbs
echo objShell.NameSpace(ExtractTo).CopyHere(FilesInZip) >> .\bin\extractobs.vbs
echo Set fso = Nothing >> .\bin\extractobs.vbs
echo Set objShell = Nothing >> .\bin\extractobs.vbs
echo. >> .\bin\extractobs.vbs
title PORTABLE OBS LAUNCHER - EXTRACT ZIP
cscript.exe .\bin\extractobs.vbs
exit /b

:MENU
cls
title PORTABLE OBS LAUNCHER - MAIN MENU
echo %NAG%
set nag="SELECTION TIME!"
echo 1. reinstall obs [not a feature yet]
echo 2. launch obs
echo 3. reset obs [not a feature yet]
echo 4. uninstall obs [not a feature yet]
echo 5. update program
echo 6. upgrade [use after update]
echo 7. about
echo 8. exit
echo.
echo a. download dll's
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
if "%choice%"=="6" goto UPGRADE
if "%choice%"=="7" goto ABOUT
if "%choice%"=="8" goto EXIT
if "%choice%"=="a" goto DLLDOWNLOADERCHECK
if "%CHOICE%"=="b" goto PORTABLEEVERYTHING
if "%CHOICE%"=="c" goto QUICKLAUNCHERCHECK
set nag="PLEASE SELECT A CHOICE 1-8 or a/b/c"
goto MENU

:DLLDOWNLOADERCHECK
if not exist launch_dlldownloader.bat goto DOWNLOADDLLDOWNLOADER
start launch_dlldownloader.bat
goto MENU

:DOWNLOADDLLDOWNLOADER
cls
title PORTABLE OBS LAUNCHER - DOWNLOAD DLL DOWNLOADER
if not exist .\bin\wget.exe call :DOWNLOADWGET
.\bin\wget.exe -q --show-progress https://raw.githubusercontent.com/MarioMasta64/DLLDownloaderPortable/master/launch_dlldownloader.bat
cls
goto DLLDOWNLOADERCHECK

:NULL
cls
set nag="NOT A FEATURE YET!"
goto MENU

:NEW
goto NULL

:DEFAULT
cls
title DO NOT CLOSE
set "arch=32"
if exist "%PROGRAMFILES(X86)%" set "arch=64"
set "path=%PATH%;%CD%\dll\%arch%\;"
xcopy .\data\obs\* "%appdata%\obs-studio\" /e /i /y
rmdir /s /q .\data\obs\
cls
echo OBS IS RUNNING
cd .\bin\obs\bin\64bit\
obs64.exe -portable
goto EXIT

:SELECT
goto NULL

:DELETE
goto NULL

:UPGRADE
cls
rmdir /s /q .\bin\obs\
goto OBSCHECK

:UPDATECHECK
cls
if exist version.txt del version.txt
if not exist .\bin\wget.exe call :DOWNLOADWGET
.\bin\wget.exe -q --show-progress https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/version.txt
cls
set Counter=0 & for /f "DELIMS=" %%i in ('type version.txt') do (set /a Counter+=1 & set "Line_!Counter!=%%i")
if exist version.txt del version.txt
set new_version=%Line_8%
if "%new_version%"=="OFFLINE" goto ERROROFFLINE
if %current_version% EQU %new_version% goto LATEST
if %current_version% LSS %new_version% goto NEWUPDATE
if %current_version% GTR %new_version% goto NEWEST
goto ERROROFFLINE

:LATEST
cls
title PORTABLE OBS LAUNCHER - LATEST BUILD :D
echo you are using the latest version!!
echo Current Version: v%current_version%
echo New Version: v%new_version%
pause
start launch_obs.bat
exit

:NEWUPDATE
cls
title PORTABLE OBS LAUNCHER - OLD BUILD D:
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
.\bin\wget.exe -q --show-progress https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/launch_obs.bat
cls
if exist launch_obs.bat.1 goto REPLACERCREATE
goto ERROROFFLINE

:REPLACERCREATE
cls
echo @echo off > replacer.bat
echo Color 0A >> replacer.bat
echo del launch_obs.bat >> replacer.bat
echo rename launch_obs.bat.1 launch_obs.bat >> replacer.bat
echo start launch_obs.bat >> replacer.bat
echo exit >> replacer.bat
start replacer.bat
exit

:NEWEST
cls
title PORTABLE OBS LAUNCHER - TEST BUILD :0
echo YOURE USING A TEST BUILD MEANING YOURE EITHER
echo CLOSE TO ME OR YOURE SOME SORT OF PIRATE
echo Current Version: v%current_version%
echo New Version: v%new_version%
echo ENTER TO CONTINUE
pause
start launch_obs.bat
exit

:ABOUT
cls
del .\doc\obs_license.txt
start launch_obs.bat
exit

:ERROROFFLINE
cls
set nag="YOU SEEM TO BE OFFLINE PLEASE RECONNECT TO THE INTERNET TO USE THIS FEATURE"
goto MENU

:PORTABLEEVERYTHING
cls
title PORTABLE OBS LAUNCHER - DOWNLOAD SUITE
if not exist .\bin\wget.exe call :DOWNLOADWGET
if not exist launch_everything.bat .\bin\wget.exe -q --show-progress https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/launch_everything.bat
cls
start launch_everything.bat
exit

:QUICKLAUNCHERCHECK
cls
title PORTABLE OBS LAUNCHER - QUICKLAUNCHER WRITER
echo @echo off > quicklaunch_obs.bat
echo Color 0A >> quicklaunch_obs.bat
echo cls >> quicklaunch_obs.bat
echo title DO NOT CLOSE >> quicklaunch_obs.bat
echo set path="%%PATH%%";"%%CD%%\dll\64\;"; >> quicklaunch_obs.bat
echo xcopy .\data\obs\* "%%appdata%%\obs-studio\" /e /i /y >> quicklaunch_obs.bat
echo rmdir /s /q .\data\obs\ >> quicklaunch_obs.bat
echo cls >> quicklaunch_obs.bat
echo echo OBS IS RUNNING >> quicklaunch_obs.bat
echo cd .\bin\obs\bin\64bit\ >> quicklaunch_obs.bat
echo obs64.exe -portable >> quicklaunch_obs.bat
echo cd .. >> quicklaunch_obs.bat
echo cd .. >> quicklaunch_obs.bat
echo cd .. >> quicklaunch_obs.bat
echo cd .. >> quicklaunch_obs.bat
echo xcopy "%%appdata%%\obs-studio\*" .\data\obs\ /e /i /y >> quicklaunch_obs.bat
echo rmdir /s /q "%%appdata%%\obs-studio" >> quicklaunch_obs.bat
echo exit >> quicklaunch_obs.bat
echo A QUICKLAUNCHER HAS BEEN WRITTEN TO: quicklaunch_obs.bat
pause
exit

:EXIT
cd ..
cd ..
cd ..
cd ..
xcopy "%appdata%\obs-studio\*" .\data\obs\ /e /i /y
rmdir /s /q "%appdata%\obs-studio"
exit