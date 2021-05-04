@echo off
setlocal enabledelayedexpansion
setlocal enableextensions
Color 0A
cls
title Portable Everything Launcher - Helper Edition
set nag=BE SURE TO TURN CAPS LOCK OFF! (never said it was on just make sure)
set new_version=OFFLINE_OR_NO_UPDATES

set "name=%~n0"
set "name=!name:launch_=!"
set "license=.\doc\!name!_license.txt"
set "main_launcher=%~n0.bat"
set "poc_launcher=%~n0_poc.bat"
set "quick_launcher=quick%~n0.bat"

if exist replacer.bat del replacer.bat >nul:




REM
set folder=%CD%
if %CD%==%~d0\ set folder=%CD:~0,2%
REM




if "%~1" neq "" (call :%~1 & exit /b !current_version!)

:FolderCheck
cls
if not exist .\bin\ mkdir .\bin\
if not exist .\doc\ mkdir .\doc\
if not exist .\helpers\ mkdir .\helpers\
call :Version
call :HelperCheck
goto Credits

:Version
cls
echo 21 > .\doc\version.txt
set /p current_version=<.\doc\version.txt
if exist .\doc\version.txt del .\doc\version.txt >nul:
exit /b

:Credits
cls
if exist !license! goto FileCheck
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

:CreditsRead
cls
title Portable Everything Launcher - Helper Edition - About
for /f "DELIMS=" %%i in (!license!) do (echo %%i)
pause

:FILECHECK
cls

:Menu
cls
title Portable Everything Launcher - Helper Edition - Main Menu
echo %NAG%
echo dont worry bugs will be fixed soon !
set nag=Selection Time!
echo 1. download a program
echo 2. launch a program
echo 3. update a launcher
echo 4. delete a program
echo 5. about
echo 6. exit
echo 7. DOWNLOAD EVERYTHING
echo 8. DELETE EVERYTHING
echo 9. UPDATE EVERYTHING [ Broken Use Option 3 Instead ]
echo 10. TROUBLESHOOTING
REM echo 11. GET HELPER MANAGER
echo.
set /p choice="enter a number and press enter to confirm: "
if "%CHOICE%"=="1" goto Download
if "%CHOICE%"=="2" goto Launch
if "%CHOICE%"=="3" goto Update
if "%CHOICE%"=="4" goto Delete
if "%CHOICE%"=="5" goto About
if "%CHOICE%"=="6" exit
if "%CHOICE%"=="7" goto GetAllTheStuff
if "%CHOICE%"=="8" goto DeleteAllTheStuff
if "%CHOICE%"=="9" goto UpdateAllTheStuff
if "%CHOICE%"=="10" goto Troubleshooting
REM if "%CHOICE%"=="10" goto GetHelperManager
set nag="PLEASE SELECT A CHOICE 1-10"
goto Menu

:Troubleshooting
cls
echo if nothing appears in the menu
echo or a download keeps looping or
echo a file is not extracting right
echo press exit the on the launcher
echo then delete the installer from
echo .\extra\ and delete the folder
echo that has the name of the thing
echo you were attempting to use out
echo .\bin\ and try again if it did
echo the same thing again remove -q
echo --show-progress from the place
echo in the launcher, all of them .
echo otherwise leave an issue on my
echo github github.com/mariomasta64
pause
goto Menu

:UpdateAllTheStuff
echo https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/version.txt > .\helpers\download.txt
echo launch_!launcher!.bat > .\helpers\file.txt
call launch_helpers.bat Download
cls
set "num=1"
for /f "DELIMS=" %%i in (version.txt) do (
    set /a num+=1
	if "!num!"=="1" (
		set "new_version=%%i"
		if !new_version! NEQ 0 (
			if !launcher! NEQ everything (
				if exist launch_!launcher!.bat (
					call launch_!launcher!.bat Version
					set current_version=!errorlevel!
					if !current_version! LSS !new_version! (
:: this returns OFFLINE sometimes and im unsure why, it only seems to happen after a certain amount of launchers that are updated to the current version
						if "!new_version!" NEQ "OFFLINE" (
							echo update detected for !launcher!
							echo current: !current_version!
							echo new: !new_version!
							echo https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/launch_!launcher!.bat > .\helpers\download.txt
							echo launch_!launcher!.bat > .\helpers\file.txt
							call launch_helpers.bat Download
							if exist launch_!launcher!.bat.1 (
								del launch_!launcher!.bat >nul:
								rename launch_!launcher!.bat.1 launch_!launcher!.bat
							)
						)
					)
				)
			)
		)
		if !new_version! EQU 0 (
			echo no version, not checking.
		)
	)
    if "!num!"=="2" (
		set /a "num=0"
			set "launcher=%%i"
			echo !launcher!
	)
)
if exist version.txt del version.txt >nul:
set nag="if it wasnt for http://stackoverflow.com/users/5269570/sam-denty this wouldnt work"
pause
goto Menu

:GetLaunchers
dir /b /a-d launch_*.bat > .\doc\launchers.txt
set Counter=0
for /f "DELIMS=" %%i in ('type .\doc\launchers.txt') do (
	if "%%i" NEQ "launch_dlldownloader.bat" (
		set /a Counter+=1
		set Line_!Counter!=%%i
	)
)
if exist .\doc\launchers.txt del .\doc\launchers.txt >nul:
exit /b

:GetInfo
if exist %launchername%.txt del %launchername%.txt >nul:
echo https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/info/%launchername%.txt > .\helpers\download.txt
echo %launchername%.txt > .\helpers\file.txt
call launch_helpers.bat Download
cls
for /f "DELIMS=" %%i in ('type %launchername%.txt') do (
    echo %%i
)
if not exist %launchername%.txt cls & echo you seem to be offline or there is a problem with the github
if exist %launchername%.txt del %launchername%.txt >nul:
exit /b

:GetDownloads
echo https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/version.txt > .\helpers\download.txt
echo version.txt > .\helpers\file.txt
call launch_helpers.bat Download
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
if exist version.txt del version.txt >nul:
set nag="if it wasnt for http://stackoverflow.com/users/5269570/sam-denty this wouldnt work"
exit /b

:GetNewDownloads
echo https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/version.txt > .\helpers\download.txt
echo version.txt > .\helpers\file.txt
call launch_helpers.bat Download
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
if exist version.txt del version.txt >nul:
set nag="if it wasnt for http://stackoverflow.com/users/5269570/sam-denty this wouldnt work"
exit /b

:Download
call :GetNewDownloads
cls
title Portable Everything Launcher - Helper Edition - Download Launcher
echo %NAG%
set nag=Selection Time!
:: first number is which line to start second number is how many lines to count by
For /L %%C in (1,1,%Counter%) Do (echo %%C. !Line_%%C!)
echo type menu to return to the main menu
set /p choice="launcher to download: "
set launchername=!Line_%CHOICE%!
set launcher=launch_%launchername%.bat
if "%CHOICE%"=="menu" goto Menu
:: cap output somehow
goto Info

:LauncherCheck
cls
title Portable Everything Launcher - Helper Edition - Check Launcher
set /a verline = %CHOICE% * 2
if not exist launch_%launchername%.bat goto UpdateNow
set nag="You Shouldn't Be Able To Trigger This. If You Do Let Me Know. Launcher %launcher% Exists"
goto UpdateCheck
goto Menu

:Launch
cls
title Portable Everything Launcher - Helper Edition - SelectLauncher
echo %NAG%
set nag=Selection Time!
call :GetLaunchers
For /L %%C in (1,1,%Counter%) Do (echo %%C. !Line_%%C!)
echo type menu to return to the main menu
:: typing "]" here opens cmd prompt. spoopy.
set /p choice="launcher to launch: "
set launcher=!Line_%CHOICE%!
if "%CHOICE%"=="menu" goto Menu
start %launcher%
exit

:Delete
cls
title Portable Everything Launcher - Helper Edition - DeleteLauncher
echo %NAG%
set nag=Selection Time!
call :GetLaunchers
For /L %%C in (1,1,%Counter%) Do (echo %%C. !Line_%%C!)
echo type menu to return to the main menu
set /p choice="launcher to delete: "
set launcher=!Line_%CHOICE%!
if "%CHOICE%"=="menu" goto Menu
del %launcher% >nul:
goto Menu

:Update
cls
title Portable Everything Launcher - Helper EditionUPDATE LAUNCHER
echo %NAG%
set nag=Selection Time!
call :GetLaunchers
For /L %%C in (1,1,%Counter%) Do (echo %%C. !Line_%%C!)
echo type menu to return to the main menu
set /p choice="launcher to update: "
set launcher=!Line_%CHOICE%!
if "%CHOICE%"=="menu" goto Menu
call :GetDownloads

:UpdateCheck
cls
call %launcher% Version
set current_version=!errorlevel!
if exist version.txt del version.txt >nul:
echo https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/version.txt > .\helpers\download.txt
echo version.txt > .\helpers\file.txt
call launch_helpers.bat Download
set Counter=0 & for /f "DELIMS=" %%i in ('type version.txt') do (set /a Counter+=1 & set "Line_!Counter!=%%i")
if exist version.txt del version.txt >nul:
set new_version=!line_%new_line%!
if "%new_version%"=="OFFLINE" goto ErrorOffline
if %current_version% EQU %new_version% goto Latest
if %current_version% LSS %new_version% goto NewUpdate
if %current_version% GTR %new_version% goto Newest
goto ErrorOffline

:Latest
cls
title Portable Everything Launcher - Helper Edition - Latest Build :D
echo %NAG%
set nag=Selection Time!
echo you are using the latest version!!
echo Current Version: v%current_version%
echo New Version: v%new_version%
echo Press Enter To Continue
pause
goto Menu

:NewUpdate
cls
title Portable Everything Launcher - Helper Edition - Old Build D:
echo %NAG%
set nag=Selection Time!
echo you are using an older version
echo enter yes or no
echo Current Version: v%current_version%
echo New Version: v%new_version%
set /p choice="Update?: "
if "%CHOICE%"=="yes" goto UpdateNow
if "%CHOICE%"=="no" goto Menu
set nag="please enter YES or NO"
goto NewUpdate

:Info
cls
title Portable Everything Launcher - Helper Edition - "%launchername%" Menu
echo %NAG%
set nag=Selection Time!
echo what would you like to do?
echo 1. Download Launcher
echo 2. View More Info
echo back to go back or menu to go back to the menu
set /p choice="action: "
if "%CHOICE%"=="1" goto LauncherCheck
if "%CHOICE%"=="2" goto MoreInfo
if "%CHOICE%"=="back" goto Download
if "%CHOICE%"=="menu" goto Menu
set nag="please enter 1 or 2"
goto Info

:MoreInfo
cls
call :GetInfo
title Portable "%launchername%" Launcher - More Info
pause
goto Info

:UpdateNow
cls
echo https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/%launcher% > .\helpers\download.txt
echo %launcher% > .\helpers\file.txt
call launch_helpers.bat Download
cls
if exist %launcher%.1 goto ReplacerCreate
if exist %launcher% goto Menu
goto ErrorOffline

:ReplacerCreate
cls
echo @echo off > replacer.bat
echo Color 0A >> replacer.bat
echo del %launcher% >> replacer.bat
echo rename %launcher%.1 %launcher% >> replacer.bat
echo start %~n0 >> replacer.bat
echo exit >> replacer.bat
start replacer.bat
exit

:Newest
cls
title Portable Everything Launcher - Helper Edition - Test Build :0
echo YOURE USING A TEST BUILD MEANING YOURE EITHER
echo CLOSE TO ME OR YOURE SOME SORT OF BETA TESTER
echo Current Version: v%current_version%
echo New Version: v%new_version%
echo Press Enter To Continue
pause
start %~n0
exit

:About
cls
if exist !license! del !license! >nul:
start %~n0
exit

:ErrorOffline
cls
echo an error occured
pause
goto Menu

:GetAllTheStuff
echo https://github.com/MarioMasta64/EverythingPortable/archive/master.zip > .\helpers\download.txt
echo master.zip > .\helpers\file.txt
call launch_helpers.bat Download
if not exist .\bin\wget.exe call :DownloadWget
echo "%folder%\master.zip" > .\helpers\file.txt
echo "%folder%" > .\helpers\folder.txt
call launch_helpers.bat Extract
for %%i in (.\EverythingPortable-master\launch_*.bat) do if not "%%i" == ".\EverythingPortable-master\%~n0" xcopy %%i .\ /e /i /y
if exist .\EverythingPortable-master\ rmdir /s /q .\EverythingPortable-master\
if exist .\.vs\ rmdir /s /q .\.vs\
if exist .\info\ rmdir /s /q .\info\
if exist .\note\ rmdir /s /q .\note\
if exist master.zip del master.zip >nul:
goto Menu

:DeleteAllTheStuff
for %%i in (*) do (
	if not "%%i" == "%~n0" (
		if not "%%i" == "launch_helpers.bat" del %%i >nul:
	)
)
goto Menu

:DownloadWget
if not exist .\helpers\download.vbs call :CreateDownloadVBS
cscript .\helpers\download.vbs https://eternallybored.org/misc/wget/current/wget.exe .\bin\wget.exe
exit /b








REM
:HelperCheck
if not exist launch_helpers.bat call :DownloadHelpers
exit /b
:DownloadHelpers
if not exist .\helpers\download.vbs call :CreateDownloadVBS
cscript .\helpers\download.vbs https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/launch_helpers.bat launch_helpers.bat >nul:
exit /b
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
exit /b
REM