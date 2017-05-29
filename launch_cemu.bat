@echo off
setlocal enabledelayedexpansion
Color 0A
cls
title PORTABLE CEMU LAUNCHER
set nag=BE SURE TO TURN CAPS LOCK OFF! (never said it was on just make sure)
set new_version=OFFLINE
if exist replacer.bat del replacer.bat
if "%~1" neq "" (call :%~1 & exit /b !current_version!)
set upgrade=0

:FOLDERCHECK
cls
if not exist .\bin\ mkdir .\bin\
if not exist .\data\cemu\ mkdir .\data\cemu\
if not exist .\dll\ mkdir .\dll\
if not exist .\doc\ mkdir .\doc\
if not exist .\extra\ mkdir .\extra\
call :VERSION
goto CREDITS

:VERSION
cls
echo 15 > .\doc\version.txt
set /p current_version=<.\doc\version.txt
if exist .\doc\version.txt del .\doc\version.txt
exit /b

:CREDITS
cls
if exist .\doc\cemu_license.txt goto CEMUCHECK
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

:CREDITSREAD
cls
title PORTABLE CEMU LAUNCHER - ABOUT
for /f "DELIMS=" %%i in (.\doc\cemu_license.txt) do (echo %%i)
pause

:CEMUCHECK
cls
if not exist .\bin\cemu_1.7.5\Cemu.exe goto FILECHECK
goto WGETUPDATE

:FILECHECK
if not exist .\extra\cemu_1.7.5.zip goto DOWNLOADCEMU
call :EXTRACTCEMU
goto CEMUCHECK

:DOWNLOADCEMU
cls
title PORTABLE CEMU LAUNCHER - DOWNLOAD CEMU
if exist cemu_1.7.5.zip goto MOVECEMU
if not exist .\bin\wget.exe call :DOWNLOADWGET
.\bin\wget.exe -q --show-progress http://cemu.info/releases/cemu_1.7.5.zip

:MOVECEMU
cls
move cemu_1.7.5.zip .\extra\cemu_1.7.5.zip
goto CEMUCHECK

:WGETUPDATE
cls
title PORTABLE CEMU LAUNCHER - UPDATE WGET
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
title PORTABLE CEMU LAUNCHER - DOWNLOAD WGET
cscript.exe .\bin\downloadwget.vbs
move wget.exe .\bin\
exit /b

:EXTRACTCEMU
cls
title PORTABLE CEMU LAUNCHER - EXTRACT CEMU
set folder=%CD%
if %CD%==%~d0\ set folder=%CD:~0,2%
cls
echo. > .\bin\extractcemu.vbs
echo 'The location of the zip file. >> .\bin\extractcemu.vbs
echo ZipFile="%folder%\extra\cemu_1.7.5.zip" >> .\bin\extractcemu.vbs
echo 'The folder the contents should be extracted to. >> .\bin\extractcemu.vbs
:: change to %folder%\bin\ on regular builds (ones that dont have a folder inside the zip)
echo ExtractTo="%folder%\bin\" >> .\bin\extractcemu.vbs
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
title PORTABLE CEMU LAUNCHER - EXTRACT ZIP
cscript.exe .\bin\extractcemu.vbs

set "root=%CD%"
cd bin\cemu*
if exist "%root%\temp\mlc01\" xcopy "%root%\temp\mlc01\*" "%CD%\mlc01\" /e /i /y
if exist "%root%\temp\hfiomlc01\" xcopy "%root%\temp\hfiomlc01\*" "%CD%\hfiomlc01\" /e /i /y
cd %root%
rmdir /s /q .\temp\
exit /b

:MENU
cls
title PORTABLE CEMU LAUNCHER - MAIN MENU
echo %NAG%
set nag="SELECTION TIME!"
echo 1. reinstall cemu [not a feature yet]
echo 2. launch cemu
echo 3. reset cemu [not a feature yet]
echo 4. uninstall cemu [not a feature yet]
echo 5. update program
echo 6. upgrade cemu
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
title PORTABLE CEMU LAUNCHER - DOWNLOAD DLL DOWNLOADER
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
set path=%PATH%;%CD%\dll\;
cls
echo CEMU IS RUNNING
cd bin\cemu*
start Cemu.exe
exit

:SELECT
goto NULL

:DELETE
goto NULL

:UPGRADE
cls
set "root=%CD%"
mkdir .\temp\
cd bin\cemu*
:: maybe check the 6-10 digits and compare them as a value? using first digit the second then third?
:: copy directories stupid code!!! D:<
:: i fixed it btw
xcopy /q .\mlc01\* "%root%\temp\mlc01\" /e /i /y
xcopy /q .\hfiomlc01\* "%root%\temp\hfiomlc01\" /e /i /y
cd ..
rmdir /s /q cemu_1.7.3d
rmdir /s /q cemu_1.7.4d
rmdir /s /q cemu_1.7.5
cd "%root%"
goto CEMUCHECK

:COPYBACK
cls
cd bin\cemu*
xcopy /q "%root%\temp\*" .\ /e /i /y
xcopy /q "%root%\temp\*" .\ /e /i /y
exit /b

:UPDATECHECK
cls
if exist version.txt del version.txt
if not exist .\bin\wget.exe call :DOWNLOADWGET
.\bin\wget.exe -q --show-progress https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/version.txt
cls
set Counter=0 & for /f "DELIMS=" %%i in ('type version.txt') do (set /a Counter+=1 & set "Line_!Counter!=%%i")
if exist version.txt del version.txt
set new_version=%Line_12%
if %new_version%==OFFLINE goto ERROROFFLINE
if %current_version% EQU %new_version% goto LATEST
if %current_version% LSS %new_version% goto NEWUPDATE
if %current_version% GTR %new_version% goto NEWEST
goto ERROROFFLINE

:LATEST
cls
title PORTABLE CEMU LAUNCHER - LATEST BUILD :D
echo you are using the latest version!!
echo Current Version: v%current_version%
echo New Version: v%new_version%
pause
start launch_cemu.bat
exit

:NEWUPDATE
cls
title PORTABLE CEMU LAUNCHER - OLD BUILD D:
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
.\bin\wget.exe -q --show-progress https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/launch_cemu.bat
cls
if exist launch_cemu.bat.1 goto REPLACERCREATE
goto ERROROFFLINE

:REPLACERCREATE
cls
echo @echo off > replacer.bat
echo Color 0A >> replacer.bat
echo del launch_cemu.bat >> replacer.bat
echo rename launch_cemu.bat.1 launch_cemu.bat >> replacer.bat
echo start launch_cemu.bat >> replacer.bat
echo exit >> replacer.bat
start replacer.bat
exit

:NEWEST
cls
title PORTABLE CEMU LAUNCHER - TEST BUILD :0
echo YOURE USING A TEST BUILD MEANING YOURE EITHER
echo CLOSE TO ME OR YOURE SOME SORT OF PIRATE
echo Current Version: v%current_version%
echo New Version: v%new_version%
echo ENTER TO CONTINUE
pause
start launch_cemu.bat
exit

:ABOUT
cls
del .\doc\cemu_license.txt
start launch_cemu.bat
exit

:ERROROFFLINE
cls
set nag="YOU SEEM TO BE OFFLINE PLEASE RECONNECT TO THE INTERNET TO USE THIS FEATURE"
goto MENU

:PORTABLEEVERYTHING
cls
title PORTABLE CEMU LAUNCHER - DOWNLOAD SUITE
if not exist .\bin\wget.exe call :DOWNLOADWGET
if not exist launch_everything.bat .\bin\wget.exe -q --show-progress https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/launch_everything.bat
cls
start launch_everything.bat
exit

:QUICKLAUNCHERCHECK
cls
title PORTABLE CEMU LAUNCHER - QUICKLAUNCHER WRITER
echo @echo off > quicklaunch_cemu.bat
echo Color 0A >> quicklaunch_cemu.bat
echo cls >> quicklaunch_cemu.bat
echo title DO NOT CLOSE >> quicklaunch_cemu.bat
echo set path="%%PATH%%;%%CD%%\dll\;" >> quicklaunch_cemu.bat
echo cls >> quicklaunch_cemu.bat
echo echo CEMU IS RUNNING >> quicklaunch_cemu.bat
echo cd bin\cemu* >> quicklaunch_cemu.bat
echo start Cemu.exe >> quicklaunch_cemu.bat
echo exit >> quicklaunch_cemu.bat
echo A QUICKLAUNCHER HAS BEEN WRITTEN TO: quicklaunch_cemu.bat
pause
exit