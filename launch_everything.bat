@echo off
setlocal enabledelayedexpansion
Color 0A
cls
title PORTABLE EVERYTHING LAUNCHER
set nag=BE SURE TO TURN CAPS LOCK OFF! (never said it was on just make sure)
set new_version=OFFLINE_OR_NO_UPDATES
if exist replacer.bat del replacer.bat
if "%~1" neq "" (call :%~1 & exit /b !current_version!)

:FOLDERCHECK
cls
if not exist .\bin\ mkdir .\bin\
if not exist .\doc\ mkdir .\doc\
call :VERSION
goto CREDITS

:VERSION
cls
echo 16 > .\doc\version.txt
set /p current_version=<.\doc\version.txt
if exist .\doc\version.txt del .\doc\version.txt
exit /b

:CREDITS
cls
if exist .\doc\everything_license.txt goto FILECHECK
echo ================================================== > .\doc\everything_license.txt
echo =              Script by MarioMasta64            = >> .\doc\everything_license.txt
echo =           Script Version: v%current_version%- release        = >> .\doc\everything_license.txt
echo ================================================== >> .\doc\everything_license.txt
echo =You may Modify this WITH consent of the original= >> .\doc\everything_license.txt
echo = creator, as long as you include a copy of this = >> .\doc\everything_license.txt
echo =      as you include a copy of the License      = >> .\doc\everything_license.txt
echo ================================================== >> .\doc\everything_license.txt
echo =    You may also modify this script without     = >> .\doc\everything_license.txt
echo =         consent for PERSONAL USE ONLY          = >> .\doc\everything_license.txt
echo ================================================== >> .\doc\everything_license.txt

:CREDITSREAD
cls
title PORTABLE EVERYTHING LAUNCHER - ABOUT
for /f "DELIMS=" %%i in (.\doc\everything_license.txt) do (echo %%i)
pause

:FILECHECK
cls

:WGETUPDATE
cls
title PORTABLE EVERYTHING LAUNCHER - UPDATE WGET
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
title PORTABLE EVERYTHING LAUNCHER - DOWNLOAD WGET
cscript.exe .\bin\downloadwget.vbs
move wget.exe .\bin\
exit /b

:MENU
cls
title PORTABLE EVERYTHING LAUNCHER - MAIN MENU
echo %NAG%
echo dont worry bugs will be fixed soon !
set nag=SELECTION TIME!
echo 1. download a program
echo 2. launch a program
echo 3. update a launcher
echo 4. delete a program
echo 5. about
echo 6. exit
echo 7. DOWNLOAD EVERYTHING
echo 8. DELETE EVERYTHING
echo.
set /p choice="enter a number and press enter to confirm: "
if "%CHOICE%"=="1" goto DOWNLOAD
if "%CHOICE%"=="2" goto LAUNCH
if "%CHOICE%"=="3" goto UPDATE
if "%CHOICE%"=="4" goto DELETE
if "%CHOICE%"=="5" goto ABOUT
if "%CHOICE%"=="6" exit
if "%CHOICE%"=="7" goto GETALLTHESTUFF
if "%CHOICE%"=="8" goto DELETEALLTHESTUFF
set nag="PLEASE SELECT A CHOICE 1-8"
goto MENU

:GET_LAUNCHERS
dir /b /a-d launch_*.bat > .\doc\launchers.txt
set Counter=0
for /f "DELIMS=" %%i in ('type .\doc\launchers.txt') do (
	if "%%i" NEQ "launch_dlldownloader.bat" (
		set /a Counter+=1
		set Line_!Counter!=%%i
	)
)
if exist .\doc\launchers.txt del .\doc\launchers.txt
exit /b

:GET_INFO
if not exist .\bin\wget.exe call :DOWNLOADWGET
if exist %launchername%.txt del %launchername%.txt
.\bin\wget.exe -q --show-progress https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/info/%launchername%.txt
cls
for /f "DELIMS=" %%i in ('type %launchername%.txt') do (
    echo %%i
)
if not exist %launchername%.txt cls & echo you seem to be offline or there is a problem with the github
if exist %launchername%.txt del %launchername%.txt
exit /b

:GET_DOWNLOADS
if not exist .\bin\wget.exe call :DOWNLOADWGET
.\bin\wget.exe -q --show-progress https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/version.txt
cls
set "num=1"
set "counter=0"
for /f "DELIMS=" %%i in (version.txt) do (
    set /a num+=1
:: this line says if num is equal to blah execute this. basically it counts by this many lines it also resets the counter on completion
    if "!num!"=="2" (
		set /a counter+=1&set "line_!counter!=%%i"&set num=0
		if "%launcher%"=="launch_%%i.bat" (set /a new_line=!counter!*2)
	)
)
if exist version.txt del version.txt
set nag="if it wasnt for http://stackoverflow.com/users/5269570/sam-denty this wouldnt work"
exit /b

:GET_NEW_DOWNLOADS
if not exist .\bin\wget.exe call :DOWNLOADWGET
.\bin\wget.exe -q --show-progress https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/version.txt
cls
set "num=1"
set "counter=0"
for /f "DELIMS=" %%i in (version.txt) do (
    set /a num+=1
:: this line says if num is equal to blah execute this. basically it counts by this many lines it also resets the counter on completion
    if "!num!"=="2" (
		if not exist launch_%%i.bat (set /a counter+=1&set "line_!counter!=%%i")
		set num=0
	)
)
if exist version.txt del version.txt
set nag="if it wasnt for http://stackoverflow.com/users/5269570/sam-denty this wouldnt work"
exit /b

:DOWNLOAD
call :GET_NEW_DOWNLOADS
cls
title PORTABLE EVERYTHING LAUNCHER - DOWNLOAD LAUNCHER
echo %NAG%
set nag=SELECTION TIME!
:: first number is which line to start second number is how many lines to count by
For /L %%C in (1,1,%Counter%) Do (echo %%C. !Line_%%C!)
echo type menu to return to the main menu
set /p choice="launcher to download: "
set launchername=!Line_%CHOICE%!
set launcher=launch_%launchername%.bat
if "%CHOICE%"=="menu" goto MENU
:: cap output somehow
goto INFO

:LAUNCHERCHECK
cls
title PORTABLE EVERYTHING LAUNCHER - CHECK LAUNCHER
set /a verline = %CHOICE% * 2
if not exist launch_%launchername%.bat goto UPDATENOW
set nag="You Shouldn't Be Able To Trigger This. If You Do Let Me Know. Launcher %launcher% Exists"
goto UPDATECHECK
goto MENU

:LAUNCH
cls
title PORTABLE EVERYTHING LAUNCHER - SELECT LAUNCHER
echo %NAG%
set nag=SELECTION TIME!
call :GET_LAUNCHERS
For /L %%C in (1,1,%Counter%) Do (echo %%C. !Line_%%C!)
echo type menu to return to the main menu
:: typing "]" here opens cmd prompt. spoopy.
set /p choice="launcher to launch: "
set launcher=!Line_%CHOICE%!
if "%CHOICE%"=="menu" goto MENU
start %launcher%
exit

:DELETE
cls
title PORTABLE EVERYTHING LAUNCHER - DELETE LAUNCHER
echo %NAG%
set nag=SELECTION TIME!
call :GET_LAUNCHERS
For /L %%C in (1,1,%Counter%) Do (echo %%C. !Line_%%C!)
echo type menu to return to the main menu
set /p choice="launcher to delete: "
set launcher=!Line_%CHOICE%!
if "%CHOICE%"=="menu" goto MENU
del %launcher%
goto MENU

:UPDATE
cls
title PORTABLE EVERYTHING LAUNCHER - UPDATE LAUNCHER
echo %NAG%
set nag=SELECTION TIME!
call :GET_LAUNCHERS
For /L %%C in (1,1,%Counter%) Do (echo %%C. !Line_%%C!)
echo type menu to return to the main menu
set /p choice="launcher to update: "
set launcher=!Line_%CHOICE%!
if "%CHOICE%"=="menu" goto MENU
call :GET_DOWNLOADS

:UPDATECHECK
cls
call %launcher% VERSION
set current_version=!errorlevel!
if exist version.txt del version.txt
if not exist .\bin\wget.exe call :DOWNLOADWGET
.\bin\wget.exe -q --show-progress https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/version.txt
set Counter=0 & for /f "DELIMS=" %%i in ('type version.txt') do (set /a Counter+=1 & set "Line_!Counter!=%%i")
if exist version.txt del version.txt
set new_version=!line_%new_line%!
if "%new_version%"=="OFFLINE" goto ERROROFFLINE
if %current_version% EQU %new_version% goto LATEST
if %current_version% LSS %new_version% goto NEWUPDATE
if %current_version% GTR %new_version% goto NEWEST
goto ERROROFFLINE

:LATEST
cls
title PORTABLE EVERYTHING LAUNCHER - LATEST BUILD :D
echo %NAG%
set nag=SELECTION TIME!
echo you are using the latest version!!
echo Current Version: v%current_version%
echo New Version: v%new_version%
echo ENTER TO CONTINUE
pause
goto MENU

:NEWUPDATE
cls
title PORTABLE EVERYTHING LAUNCHER - OLD BUILD D:
echo %NAG%
set nag=SELECTION TIME!
echo you are using an older version
echo enter yes or no
echo Current Version: v%current_version%
echo New Version: v%new_version%
set /p choice="Update?: "
if "%CHOICE%"=="yes" goto UPDATENOW
if "%CHOICE%"=="no" goto MENU
set nag="please enter YES or NO"
goto NEWUPDATE

:INFO
cls
title PORTABLE EVERYTHING LAUNCHER - "%launchername%" MENU
echo %NAG%
set nag=SELECTION TIME!
echo what would you like to do?
echo 1. Download Launcher
echo 2. View More Info
echo back to go back or menu to go back to the menu
set /p choice="action: "
if "%CHOICE%"=="1" goto LAUNCHERCHECK
if "%CHOICE%"=="2" goto MOREINFO
if "%CHOICE%"=="back" goto DOWNLOAD
if "%CHOICE%"=="menu" goto MENU
set nag="please enter 1 or 2"
goto INFO

:MOREINFO
cls
call :GET_INFO
title PORTABLE "%launchername%" LAUNCHER - MORE INFO
pause
goto INFO

:UPDATENOW
cls
if not exist .\bin\wget.exe call :DOWNLOADWGET
.\bin\wget.exe -q --show-progress https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/%launcher%
cls
if exist %launcher%.1 goto REPLACERCREATE
if exist %launcher% goto MENU
goto ERROROFFLINE

:REPLACERCREATE
cls
echo @echo off > replacer.bat
echo Color 0A >> replacer.bat
echo del %launcher% >> replacer.bat
echo rename %launcher%.1 %launcher% >> replacer.bat
echo start launch_everything.bat >> replacer.bat
echo exit >> replacer.bat
start replacer.bat
exit

:NEWEST
cls
title PORTABLE EVERYTHING LAUNCHER - TEST BUILD :0
echo YOURE USING A TEST BUILD MEANING YOURE EITHER
echo CLOSE TO ME OR YOURE SOME SORT OF PIRATE
echo Current Version: v%current_version%
echo New Version: v%new_version%
echo ENTER TO CONTINUE
pause
start launch_everything.bat
exit

:ABOUT
cls
del .\doc\everything_license.txt
start launch_everything.bat
exit

:ERROROFFLINE
cls
echo an error occured
pause
goto MENU

:GETALLTHESTUFF
if not exist .\bin\wget.exe call :DOWNLOADWGET
.\bin\wget.exe -q --show-progress https://github.com/MarioMasta64/EverythingPortable/archive/master.zip
set folder=%CD%
if %CD%==%~d0\ set folder=%CD:~0,2%
echo. > .\bin\extracteverything.vbs
echo 'The location of the zip file. >> .\bin\extracteverything.vbs
echo ZipFile="%folder%\master.zip" >> .\bin\extracteverything.vbs
echo 'The folder the contents should be extracted to. >> .\bin\extracteverything.vbs
echo ExtractTo="%folder%\" >> .\bin\extracteverything.vbs
echo. >> .\bin\extracteverything.vbs
echo 'If the extraction location does not exist create it. >> .\bin\extracteverything.vbs
echo Set fso = CreateObject("Scripting.FileSystemObject") >> .\bin\extracteverything.vbs
echo If NOT fso.FolderExists(ExtractTo) Then >> .\bin\extracteverything.vbs
echo    fso.CreateFolder(ExtractTo) >> .\bin\extracteverything.vbs
echo End If >> .\bin\extracteverything.vbs
echo. >> .\bin\extracteverything.vbs
echo 'Extract the contants of the zip file. >> .\bin\extracteverything.vbs
echo set objShell = CreateObject("Shell.Application") >> .\bin\extracteverything.vbs
echo set FilesInZip=objShell.NameSpace(ZipFile).items >> .\bin\extracteverything.vbs
echo objShell.NameSpace(ExtractTo).CopyHere(FilesInZip) >> .\bin\extracteverything.vbs
echo Set fso = Nothing >> .\bin\extracteverything.vbs
echo Set objShell = Nothing >> .\bin\extracteverything.vbs
echo. >> .\bin\extracteverything.vbs
cscript .\bin\extracteverything.vbs
for %%i in (.\EverythingPortable-master\launch_*.bat) do if not "%%i" == ".\EverythingPortable-master\launch_everything.bat" xcopy %%i .\ /e /i /y
rmdir /s /q .\EverythingPortable-master\
del /s /q  master.zip
goto MENU

:DELETEALLTHESTUFF
for %%i in (*) do if not "%%i" == "launch_everything.bat" del %%i
goto MENU