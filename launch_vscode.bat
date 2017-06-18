@echo off
setlocal enabledelayedexpansion
Color 0A
cls
title PORTABLE VSCODE LAUNCHER
set nag=BE SURE TO TURN CAPS LOCK OFF! (never said it was on just make sure)
set new_version=OFFLINE
if exist replacer.bat del replacer.bat
if "%~1" neq "" (call :%~1 & exit /b !current_version!)

:FOLDERCHECK
cls
if not exist .\bin\vscode\ mkdir .\bin\vscode\
if not exist .\doc\ mkdir .\doc\
if not exist .\data\ mkdir .\data\
if not exist .\data\.vscode\ mkdir .\data\.vscode\
if not exist .\data\AppData\Roaming\ mkdir .\data\AppData\Roaming\
if not exist .\extra\ mkdir .\extra\
call :VERSION
goto CREDITS

:VERSION
cls
echo 1 > .\doc\version.txt
set /p current_version=<.\doc\version.txt
if exist .\doc\version.txt del .\doc\version.txt
exit /b

:CREDITS
cls
if exist .\doc\vscode_license.txt goto VSCODECHECK
echo ================================================== > .\doc\vscode_license.txt
echo =              Script by MarioMasta64            = >> .\doc\vscode_license.txt
:: remove space when version reaches 2 digits
echo =           Script Version: v%current_version%- release         = >> .\doc\vscode_license.txt
echo ================================================== >> .\doc\vscode_license.txt
echo =You may Modify this WITH consent of the original= >> .\doc\vscode_license.txt
echo = creator, as long as you include a copy of this = >> .\doc\vscode_license.txt
echo =      as you include a copy of the License      = >> .\doc\vscode_license.txt
echo ================================================== >> .\doc\vscode_license.txt
echo =    You may also modify this script without     = >> .\doc\vscode_license.txt
echo =         consent for PERSONAL USE ONLY          = >> .\doc\vscode_license.txt
echo ================================================== >> .\doc\vscode_license.txt

:CREDITSREAD
cls
title PORTABLE VSCODE LAUNCHER - ABOUT
for /f "DELIMS=" %%i in (.\doc\vscode_license.txt) do (echo %%i)
pause

:VSCODECHECK
cls
if exist .\temp\ goto MOVEVSCODEFILES
if exist .\bin\Code.exe call :PoCv1Upgrade
if exist .\data\AppData\Local\Code\ call :PoCv2Upgrade
if not exist .\bin\vscode\Code.exe goto FILECHECK
goto WGETUPDATE

:FILECHECK
if not exist .\extra\vscode.zip goto DOWNLOADVSCODE
call :EXTRACTVSCODE
goto VSCODECHECK

:DOWNLOADVSCODE
cls
title PORTABLE VSCODE LAUNCHER - DOWNLOAD VSCODE
if exist "index.html@LinkID=623231" goto RENAMEVSCODE
if exist vscode.zip goto MOVEVSCODE
if not exist .\bin\wget.exe call :DOWNLOADWGET
.\bin\wget.exe -q --show-progress "https://go.microsoft.com/fwlink/?LinkID=623231"

:RENAMEVSCODE
cls
rename "index.html@LinkID=623231" "vscode.zip"

:MOVEVSCODE
cls
move vscode.zip .\extra\vscode.zip
goto VSCODECHECK

:MOVEVSCODEFILES
cls
set "root=%CD%"
cd .\temp\VSCode*
xcopy * "%root%\bin\vscode\" /e /i /y
cd "%root%"
rmdir /s /q .\temp\
goto VSCODECHECK

:WGETUPDATE
cls
title PORTABLE VSCODE LAUNCHER - UPDATE WGET
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
title PORTABLE VSCODE LAUNCHER - DOWNLOAD WGET
cscript.exe .\bin\downloadwget.vbs
move wget.exe .\bin\
exit /b

:EXTRACTVSCODE
cls
title PORTABLE VSCODE LAUNCHER - EXTRACT VSCODE
set folder=%CD%
if %CD%==%~d0\ set folder=%CD:~0,2%
cls
echo. > .\bin\extractvscode.vbs
echo 'The location of the zip file. >> .\bin\extractvscode.vbs
echo ZipFile="%folder%\extra\vscode.zip" >> .\bin\extractvscode.vbs
echo 'The folder the contents should be extracted to. >> .\bin\extractvscode.vbs
:: change to %folder%\bin\ on regular builds (ones that dont have a folder inside the zip)
echo ExtractTo="%folder%\temp\" >> .\bin\extractvscode.vbs
echo. >> .\bin\extractvscode.vbs
echo 'If the extraction location does not exist create it. >> .\bin\extractvscode.vbs
echo Set fso = CreateObject("Scripting.FileSystemObject") >> .\bin\extractvscode.vbs
echo If NOT fso.FolderExists(ExtractTo) Then >> .\bin\extractvscode.vbs
echo    fso.CreateFolder(ExtractTo) >> .\bin\extractvscode.vbs
echo End If >> .\bin\extractvscode.vbs
echo. >> .\bin\extractvscode.vbs
echo 'Extract the contants of the zip file. >> .\bin\extractvscode.vbs
echo set objShell = CreateObject("Shell.Application") >> .\bin\extractvscode.vbs
echo set FilesInZip=objShell.NameSpace(ZipFile).items >> .\bin\extractvscode.vbs
echo objShell.NameSpace(ExtractTo).CopyHere(FilesInZip) >> .\bin\extractvscode.vbs
echo Set fso = Nothing >> .\bin\extractvscode.vbs
echo Set objShell = Nothing >> .\bin\extractvscode.vbs
echo. >> .\bin\extractvscode.vbs
title PORTABLE VSCODE LAUNCHER - EXTRACT ZIP
if not exist .\temp\ mkdir .\temp\
cscript.exe .\bin\extractvscode.vbs
exit /b

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
del .\bin\*.pak
del .\bin\*.dll
del .\bin\*.dat
del .\bin\*.bin
del .\bin\Code.exe
rmdir /s /q .\bin\bin\
rmdir /s /q .\bin\locales\
rmdir /s /q .\bin\resources\
exit /b

:PoCv2Upgrade
taskkill /f /im Code.exe
xcopy .\data\AppData\Local\Code\* .\data\AppData\Roaming\Code\ /e /i /y
rmdir /s /q .\data\AppData\Local\Code\
pause
exit /b

:MENU
cls
title PORTABLE VSCODE LAUNCHER - MAIN MENU
echo %NAG%
set nag="SELECTION TIME!"
echo 1. reinstall vscode [not a feature yet]
echo 2. launch vscode
echo 3. reset vscode [not a feature yet]
echo 4. uninstall vscode [not a feature yet]
echo 5. update program
echo 6. about
echo 7. exit
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
if "%choice%"=="6" goto ABOUT
if "%choice%"=="7" goto EXIT
if "%CHOICE%"=="b" goto PORTABLEEVERYTHING
if "%CHOICE%"=="c" goto QUICKLAUNCHERCHECK
set nag="PLEASE SELECT A CHOICE 1-7 or b/c"
goto MENU

:NULL
cls
set nag="NOT A FEATURE YET!"
goto MENU

:NEW
goto NULL

:DEFAULT
cls
title DO NOT CLOSE
rmdir /s /q .\data\.vscode\
set "AppData=%CD%\data\AppData\Roaming\"
cls
echo VSCODE IS RUNNING
.\bin\vscode\Code.exe
goto EXIT

:SELECT
goto NULL

:DELETE
goto NULL

:UPDATECHECK
cls
if exist version.txt del version.txt
if not exist .\bin\wget.exe call :DOWNLOADWGET
.\bin\wget.exe -q --show-progress https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/version.txt
cls
set Counter=0 & for /f "DELIMS=" %%i in ('type version.txt') do (set /a Counter+=1 & set "Line_!Counter!=%%i")
if exist version.txt del version.txt
set new_version=%Line_24%
if "%new_version%"=="OFFLINE" goto ERROROFFLINE
if %current_version% EQU %new_version% goto LATEST
if %current_version% LSS %new_version% goto NEWUPDATE
if %current_version% GTR %new_version% goto NEWEST
goto ERROROFFLINE

:LATEST
cls
title PORTABLE VSCODE LAUNCHER - LATEST BUILD :D
echo you are using the latest version!!
echo Current Version: v%current_version%
echo New Version: v%new_version%
pause
start launch_vscode.bat
exit

:NEWUPDATE
cls
title PORTABLE VSCODE LAUNCHER - OLD BUILD D:
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
.\bin\wget.exe -q --show-progress https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/launch_vscode.bat
cls
if exist launch_vscode.bat.1 goto REPLACERCREATE
goto ERROROFFLINE

:REPLACERCREATE
cls
echo @echo off > replacer.bat
echo Color 0A >> replacer.bat
echo del launch_vscode.bat >> replacer.bat
echo rename launch_vscode.bat.1 launch_vscode.bat >> replacer.bat
echo start launch_vscode.bat >> replacer.bat
echo exit >> replacer.bat
start replacer.bat
exit

:NEWEST
cls
title PORTABLE VSCODE LAUNCHER - TEST BUILD :0
echo YOURE USING A TEST BUILD MEANING YOURE EITHER
echo CLOSE TO ME OR YOURE SOME SORT OF PIRATE
echo Current Version: v%current_version%
echo New Version: v%new_version%
echo ENTER TO CONTINUE
pause
start launch_vscode.bat
exit

:ABOUT
cls
del .\doc\vscode_license.txt
start launch_vscode.bat
exit

:ERROROFFLINE
cls
set nag="YOU SEEM TO BE OFFLINE PLEASE RECONNECT TO THE INTERNET TO USE THIS FEATURE"
goto MENU

:PORTABLEEVERYTHING
cls
title PORTABLE VSCODE LAUNCHER - DOWNLOAD SUITE
if not exist .\bin\wget.exe call :DOWNLOADWGET
if not exist launch_everything.bat .\bin\wget.exe -q --show-progress https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/launch_everything.bat
cls
start launch_everything.bat
exit

:QUICKLAUNCHERCHECK
cls
title PORTABLE VSCODE LAUNCHER - QUICKLAUNCHER WRITER
echo @echo off > quicklaunch_vscode.bat >> quicklaunch_vscode.bat
echo Color 0A >> quicklaunch_vscode.bat >> quicklaunch_vscode.bat
echo cls >> quicklaunch_vscode.bat
echo title DO NOT CLOSE >> quicklaunch_vscode.bat
echo rmdir /s /q .\data\.vscode\ >> quicklaunch_vscode.bat
echo set "AppData=%CD%\data\AppData\Roaming\" >> quicklaunch_vscode.bat
echo cls >> quicklaunch_vscode.bat
echo echo VSCODE IS RUNNING >> quicklaunch_vscode.bat
echo .\bin\vscode\Code.exe >> quicklaunch_vscode.bat
echo xcopy "%userprofile%\.vscode\*" .\data\.vscode\ /e /i /y >> quicklaunch_vscode.bat
echo rmdir /s /q "%userprofile%\.vscode\" >> quicklaunch_vscode.bat
echo exit >> quicklaunch_vscode.bat
echo A QUICKLAUNCHER HAS BEEN WRITTEN TO: quicklaunch_vscode.bat
pause
exit

:EXIT
xcopy "%userprofile%\.vscode\*" .\data\.vscode\ /e /i /y
rmdir /s /q "%userprofile%\.vscode\"
exit