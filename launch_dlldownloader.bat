@echo off
setlocal enabledelayedexpansion
Color 0A
cls
title PORTABLE DLLDOWNLOADER LAUNCHER
set nag=BE SURE TO TURN CAPS LOCK OFF! (never said it was on just make sure)
set new_version=OFFLINE
if exist replacer.bat del replacer.bat
if exist checkupdate.txt goto version

:FOLDERCHECK
cls
if not exist .\bin\ mkdir .\bin\
if not exist .\dll\ mkdir .\dll\
if not exist .\doc\ mkdir .\doc\
call :VERSION
goto CREDITS

:VERSION
cls
echo 3 > .\doc\version.txt
set /p current_version=<.\doc\version.txt
if exist .\doc\version.txt del .\doc\version.txt
exit /b

:CREDITS
cls
if exist .\doc\dlldownloader_license.txt goto MENU
echo ================================================== > .\doc\dlldownloader_license.txt
echo =              Script by MarioMasta64            = >> .\doc\dlldownloader_license.txt
:: remove space when version reaches 2 digits
echo =           Script Version: v%current_version%- release         = >> .\doc\dlldownloader_license.txt
echo ================================================== >> .\doc\dlldownloader_license.txt
echo =You may Modify this WITH consent of the original= >> .\doc\dlldownloader_license.txt
echo = creator, as long as you include a copy of this = >> .\doc\dlldownloader_license.txt
echo =      as you include a copy of the License      = >> .\doc\dlldownloader_license.txt
echo ================================================== >> .\doc\dlldownloader_license.txt
echo =    You may also modify this script without     = >> .\doc\dlldownloader_license.txt
echo =         consent for PERSONAL USE ONLY          = >> .\doc\dlldownloader_license.txt
echo ================================================== >> .\doc\dlldownloader_license.txt

:CREDITSREAD
cls
title PORTABLE DLLDOWNLOADER LAUNCHER - ABOUT
for /f "DELIMS=" %%i in (.\doc\dlldownloader_license.txt) do (echo %%i)
pause

:WGETUPDATE
cls
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
title PORTABLE DLLDOWNLOADER LAUNCHER - DOWNLOAD WGET
cscript.exe .\bin\downloadwget.vbs
move wget.exe .\bin\
exit /b

:MENU
cls
title PORTABLE DLLDOWNLOADER LAUNCHER - MAIN MENU
echo %NAG%
set nag=SELECTION TIME!
echo 1. 
echo 2. download dll's
echo 3. 
echo 4. delete dll folder
echo 5. update downloader
echo 6. about downloader
echo 7. exit
echo.
echo b. download other projects
echo.
set /p choice="enter a number and press enter to confirm: "
if "%choice%"=="1" goto NEW
if "%choice%"=="2" goto DEFAULT
if "%choice%"=="3" goto SELECT
if "%choice%"=="4" goto DELETE
if "%choice%"=="5" goto UPDATECHECK
if "%choice%"=="6" goto ABOUT
if "%choice%"=="7" exit
if "%CHOICE%"=="b" goto PORTABLEEVERYTHING
set nag="PLEASE SELECT A CHOICE 1-6"
goto MENU

:GET_DLLS
set Counter=0
for /f "DELIMS=" %%i in ('type dll.txt') do (
	if not exist %%i .\bin\wget.exe https://raw.githubusercontent.com/MarioMasta64/DLLDownloaderPortable/master/dll/%%i
    if exist %%i move %%i .\dll\%%i
)
if exist dll.txt del dll.txt
exit /b

:NULL
cls
set nag="NOT A FEATURE YET!"
goto MENU

:NEW
goto NULL

:DEFAULT
cls
call :DOWNLOADDLL
set nag="DLL'S Downloaded?"
goto MENU

:DOWNLOADDLL
cls
if exist dll.txt del dll.txt
if not exist .\bin\wget.exe call :DOWNLOADWGET
.\bin\wget.exe https://raw.githubusercontent.com/MarioMasta64/DLLDownloaderPortable/master/dll.txt
if not exist dll.txt goto ERROROFFLINE
call :GET_DLLS
exit /b

:SELECT
goto NULL

:DELETE
cls
title PORTABLE DLLDOWNLOADER LAUNCHER - DELETE DLL
rmdir /s .\dll\
goto MENU

:UPDATECHECK
cls
if exist version.txt del version.txt
if not exist .\bin\wget.exe call :DOWNLOADWGET
.\bin\wget.exe https://raw.githubusercontent.com/MarioMasta64/DLLDownloaderPortable/master/version.txt
set /p new_version=<.\version.txt
if exist version.txt del version.txt
if %new_version%==OFFLINE goto ERROROFFLINE
if %current_version% EQU %new_version% goto LATEST
if %current_version% LSS %new_version% goto NEWUPDATE
if %current_version% GTR %new_version% goto NEWEST
goto ERROROFFLINE

:LATEST
cls
title PORTABLE DLLDOWNLOADER LAUNCHER - LATEST BUILD :D
echo you are using the latest version!!
echo Current Version: v%current_version%
echo New Version: v%new_version%
echo ENTER TO CONTINUE
pause
goto MENU

:NEWUPDATE
cls
title PORTABLE DLLDOWNLOADER LAUNCHER - OLD BUILD D:
echo %NAG%
set nag=SELECTION TIME!
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
.\bin\wget.exe https://raw.githubusercontent.com/MarioMasta64/DLLDownloaderPortable/master/launch_dlldownloader.bat
if exist launch_dlldownloader.bat.1 goto REPLACERCREATE
goto ERROROFFLINE

:REPLACERCREATE
cls
echo del launch_dlldownloader.bat >> replacer.bat
echo rename launch_dlldownloader.bat.1 launch_dlldownloader.bat >> replacer.bat
echo start launch_dlldownloader.bat >> replacer.bat
echo exit >> replacer.bat
start replacer.bat
exit

:NEWEST
cls
title PORTABLE dlldownloader LAUNCHER - TEST BUILD :0
echo YOURE USING A TEST BUILD MEANING YOURE EITHER
echo CLOSE TO ME OR YOURE SOME SORT OF PIRATE
echo Current Version: v%current_version%
echo New Version: v%new_version%
echo ENTER TO CONTINUE
pause
start launch_dlldownloader.bat
exit

:ABOUT
cls
del .\doc\dlldownloader_license.txt
start launch_dlldownloader.bat
exit

:PORTABLEEVERYTHING
cls
if not exist .\bin\wget.exe call :DOWNLOADWGET
if not exist launch_everything.bat .\bin\wget.exe https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/launch_everything.bat
start launch_everything.bat
exit

:ERROROFFLINE
cls
set nag="YOU SEEM TO BE OFFLINE PLEASE RECONNECT TO THE INTERNET TO USE THIS FEATURE"
goto MENU

:ERROR
cls
echo ERROR OCCURED
pause
exit
