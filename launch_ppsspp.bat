@echo off
setlocal enabledelayedexpansion
Color 0A
cls
setlocal enabledelayedexpansion
set nag=BE SURE TO TURN CAPS LOCK OFF! (never said it was on just make sure)
set new_version=OFFLINE
if exist replacer.bat del replacer.bat
if "%~1" neq "" (call :%~1 & exit /b !current_version!)

:FOLDERCHECK
cls
if not exist .\bin\ppsspp\ mkdir .\bin\ppsspp\
if not exist .\data\ppsspp\ mkdir .\data\ppsspp\
if not exist .\doc\ mkdir .\doc\
if not exist .\extra\ mkdir .\extra\
call :VERSION
goto CREDITS

:VERSION
cls
echo 7 > .\doc\version.txt
set /p current_version=<.\doc\version.txt
if exist .\doc\version.txt del .\doc\version.txt
exit /b

:CREDITS
cls
if exist .\doc\ppsspp_license.txt goto PPSSPPCHECK
echo ================================================== > .\doc\ppsspp_license.txt
echo =              Script by MarioMasta64            = >> .\doc\ppsspp_license.txt
:: REMOVE SPACE AFTER VERSION HITS DOUBLE DIGITS
echo =           Script Version: v%current_version%- release         = >> .\doc\ppsspp_license.txt
echo ================================================== >> .\doc\ppsspp_license.txt
echo =You may Modify this WITH consent of the original= >> .\doc\ppsspp_license.txt
echo = creator, as long as you include a copy of this = >> .\doc\ppsspp_license.txt
echo =      as you include a copy of the License      = >> .\doc\ppsspp_license.txt
echo ================================================== >> .\doc\ppsspp_license.txt
echo =    You may also modify this script without     = >> .\doc\ppsspp_license.txt
echo =         consent for PERSONAL USE ONLY          = >> .\doc\ppsspp_license.txt
echo ================================================== >> .\doc\ppsspp_license.txt

:CREDITSREAD
cls
title PORTABLE PPSSPP LAUNCHER - ABOUT
for /f "DELIMS=" %%i in (.\doc\ppsspp_license.txt) do (echo %%i)
pause

:PPSSPPCHECK
cls
if not exist .\bin\ppsspp\PPSSPPWindows.exe set nag="please choose 6 to install ppsspp"
if not exist .\bin\ppsspp\PPSSPPWindows64.exe set nag="please choose 6 to install ppsspp"
:: goto WGETUPDATE

:: :FILECHECK
:: if not exist .\extra\ppsspp_win.zip goto DOWNLOADPPSSPP
:: call :EXTRACTPPSSPP
:: goto PPSSPPCHECK

:: :DOWNLOADPPSSPP
:: cls
:: title PORTABLE PPSSPP LAUNCHER - DOWNLOAD PPSSPP
:: if exist ppsspp_win.zip goto MOVEPPSSPP
:: if not exist .\bin\wget.exe call :DOWNLOADWGET
:: .\bin\wget.exe -q --show-progress https://ppsspp.org/files/1_5_4/ppsspp_win.zip

:: :MOVEPPSSPP
:: cls
:: move ppsspp_win.zip .\extra\ppsspp_win.zip
:: goto PPSSPPCHECK

:: :WGETUPDATE
:: cls
:: title PORTABLE PPSSPP LAUNCHER - UPDATE WGET
:: wget https://eternallybored.org/misc/wget/current/wget.exe
:: move wget.exe .\bin\
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
title PORTABLE PPSSPP LAUNCHER - DOWNLOAD WGET
cscript.exe .\bin\downloadwget.vbs
move wget.exe .\bin\
exit /b

:: :EXTRACTPPSSPP
:: cls
:: title PORTABLE PPSSPP LAUNCHER - EXTRACT PPSSPP
:: set folder=%CD%
:: if %CD%==%~d0\ set folder=%CD:~0,2%
:: cls
:: echo. > .\bin\extractppsspp.vbs
:: echo 'The location of the zip file. >> .\bin\extractppsspp.vbs
:: echo ZipFile="%folder%\extra\ppsspp_win.zip" >> .\bin\extractppsspp.vbs
:: echo 'The folder the contents should be extracted to. >> .\bin\extractppsspp.vbs
:: echo ExtractTo="%folder%\bin\ppsspp\" >> .\bin\extractppsspp.vbs
:: echo. >> .\bin\extractppsspp.vbs
:: echo 'If the extraction location does not exist create it. >> .\bin\extractppsspp.vbs
:: echo Set fso = CreateObject("Scripting.FileSystemObject") >> .\bin\extractppsspp.vbs
:: echo If NOT fso.FolderExists(ExtractTo) Then >> .\bin\extractppsspp.vbs
:: echo    fso.CreateFolder(ExtractTo) >> .\bin\extractppsspp.vbs
:: echo End If >> .\bin\extractppsspp.vbs
:: echo. >> .\bin\extractppsspp.vbs
:: echo 'Extract the contants of the zip file. >> .\bin\extractppsspp.vbs
:: echo set objShell = CreateObject("Shell.Application") >> .\bin\extractppsspp.vbs
:: echo set FilesInZip=objShell.NameSpace(ZipFile).items >> .\bin\extractppsspp.vbs
:: echo objShell.NameSpace(ExtractTo).CopyHere(FilesInZip) >> .\bin\extractppsspp.vbs
:: echo Set fso = Nothing >> .\bin\extractppsspp.vbs
:: echo Set objShell = Nothing >> .\bin\extractppsspp.vbs
:: echo. >> .\bin\extractppsspp.vbs
:: title PORTABLE PPSSPP LAUNCHER - EXTRACT ZIP
:: cscript.exe .\bin\extractppsspp.vbs
:: exit /b

:MENU
cls
title PORTABLE PPSSPP LAUNCHER - MAIN MENU
echo %NAG%
set nag="SELECTION TIME!"
echo 1. reinstall ppsspp [ppsspp install corrupted but dont want to redownload?]
echo 2. launch ppsspp
echo 3. reset ppsspp [not a feature yet]
echo 4. uninstall ppsspp [not a feature yet]
echo 5. update program
echo 6. upgrade ppsspp [experimental upgrader]
echo 7. about
echo 8. exit
echo.
echo b. download other projects
echo.
echo c. write a quicklauncher
echo.
set /p choice="enter a number and press enter to confirm: "
if "%choice%"=="1" goto NEW
if "%choice%"=="2" goto MEMSTICKCHECK
if "%choice%"=="3" goto SELECT
if "%choice%"=="4" goto DELETE
if "%choice%"=="5" goto UPDATECHECK
:: if "%choice%"=="6" goto UPGRADE
if "%choice%"=="6" goto EXPERIMENTALUPGRADE
if "%choice%"=="7" goto ABOUT
if "%choice%"=="8" goto EXIT
if "%CHOICE%"=="b" goto PORTABLEEVERYTHING
if "%CHOICE%"=="c" goto QUICKLAUNCHERCHECK
set nag="PLEASE SELECT A CHOICE 1-8 or b/c"
goto MENU

:LIST_DRIVES
cls
set Counter=0
for /f "DELIMS=" %%i in ('type .\temp\memsticks.txt') do (
    set /a Counter+=1
    set "Line_!Counter!=%%i"
)
if exist .\temp\memsticks.txt del .\temp\memsticks.txt
exit /b

:NULL
cls
set nag="NOT A FEATURE YET!"
goto MENU

:NEW
rmdir /s /q .\bin\ppsspp\
call :EXTRACTPPSSPP
goto MENU

:MEMSTICKCHECK
if not exist .\temp\ mkdir .\temp\
if exist .\temp\memsticks.txt del .\temp\memsticks.txt
for /F "tokens=1*" %%a in ('fsutil fsinfo drives') do (
   for %%c in (%%b) do (
      for /F "tokens=3" %%d in ('fsutil fsinfo drivetype %%c') do (
         if %%d equ Removable (
            if exist "%%c\pspemu\PSP\" echo %%cpspemu\>> .\temp\memsticks.txt
            if exist "%%c\PSP\" echo %%c>> .\temp\memsticks.txt
         )
      )
   )
)
if exist .\temp\memsticks.txt goto :memstick

:default
echo %CD%\data\ppsspp> .\bin\ppsspp\installed.txt
goto launch

:list_drives
cls
set Counter=0
for /f "DELIMS=" %%i in ('type .\temp\memsticks.txt') do (
    set /a Counter+=1
    set "Line_!Counter!=%%i"
)
if exist .\temp\memsticks.txt del .\temp\memsticks.txt
exit /b

:memstick
cls
call :list_drives
For /L %%C in (1,1,%Counter%) Do (echo %%C. !Line_%%C!)
set /p choice="use memstick in drive: "
set drive=!Line_%CHOICE%!
echo %drive%> .\bin\ppsspp\installed.txt
if "%CHOICE%"=="default" goto DEFAULT

:launch
rmdir /s /q .\temp\
start .\bin\ppsspp\PPSSPPWindows64.exe
exit

:SELECT
goto NULL

:DELETE
goto NULL

:: :UPGRADE
:: cls
:: rmdir /s /q .\bin\ppsspp\
:: del /q .\extra\ppsspp_win.zip
:: goto PPSSPPCHECK

:EXPERIMENTALUPGRADE
rmdir /s /q .\bin\ppsspp\
del /q .\extra\ppsspp_win.zip

if exist index.html del index.html
.\bin\wget.exe -q --show-progress https://www.ppsspp.org/
if not exist index.html pause
for /f tokens^=4delims^=^> %%A in (
  'findstr /i /c:"Download PPSSPP " /c:"Download PPSSPP " index.html'
) Do > .\doc\ppsspp_link.txt Echo:"%%A"
if exist index.html del index.html

set /p ppsspp_link=<.\doc\ppsspp_link.txt
set "ppsspp_ver=%ppsspp_link:~18,5%"
echo do you wish to upgrade to "%ppsspp_ver%"? enter to continue
pause
set "ppsspp_url=https://www.ppsspp.org/files/%ppsspp_ver:~0,1%_%ppsspp_ver:~2,1%_%ppsspp_ver:~4,1%/ppsspp_win.zip"

:: to-do add a check to see if its newer or not
:: ideas: save as ppsspp_win_<ver>.zip and see if it exists

.\bin\wget.exe -q --show-progress "%ppsspp_url%"
move ppsspp_win.zip .\extra\ppsspp_win.zip
call :extract-zip "bin\ppsspp" "extra\ppsspp_win.zip"
goto MENU

:extract-zip
set "dir=%1"
set "file=%2"
set "folder=%CD%"
if "%CD%==%~d0\" set "folder=%CD:~0,2%"
cscript extractzip.vbs "%folder%\%file%" "%folder%\%dir%"
(goto) 2>nul

:UPDATECHECK
cls
if exist version.txt del version.txt
if not exist .\bin\wget.exe call :DOWNLOADWGET
.\bin\wget.exe -q --show-progress https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/version.txt
cls
set Counter=0 & for /f "DELIMS=" %%i in ('type version.txt') do (set /a Counter+=1 & set "Line_!Counter!=%%i")
if exist version.txt del version.txt
set new_version=%Line_28%
if "%new_version%"=="OFFLINE" goto ERROROFFLINE
if %current_version% EQU %new_version% goto LATEST
if %current_version% LSS %new_version% goto NEWUPDATE
if %current_version% GTR %new_version% goto NEWEST
goto ERROROFFLINE

:LATEST
cls
title PORTABLE PPSSPP LAUNCHER - LATEST BUILD :D
echo you are using the latest version!!
echo Current Version: v%current_version%
echo New Version: v%new_version%
pause
start launch_ppsspp.bat
exit

:NEWUPDATE
cls
title PORTABLE PPSSPP LAUNCHER - OLD BUILD D:
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
.\bin\wget.exe -q --show-progress https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/launch_ppsspp.bat
cls
if exist launch_ppsspp.bat.1 goto REPLACERCREATE
goto ERROROFFLINE

:REPLACERCREATE
cls
echo @echo off > replacer.bat
echo Color 0A >> replacer.bat
echo del launch_ppsspp.bat >> replacer.bat
echo rename launch_ppsspp.bat.1 launch_ppsspp.bat >> replacer.bat
echo start launch_ppsspp.bat >> replacer.bat
echo exit >> replacer.bat
start replacer.bat
exit

:NEWEST
cls
title PORTABLE PPSSPP LAUNCHER - TEST BUILD :0
echo YOURE USING A TEST BUILD MEANING YOURE EITHER
echo CLOSE TO ME OR YOURE SOME SORT OF PIRATE
echo Current Version: v%current_version%
echo New Version: v%new_version%
echo ENTER TO CONTINUE
pause
start launch_ppsspp.bat
exit

:ABOUT
cls
del .\doc\ppsspp_license.txt
start launch_ppsspp.bat
exit

:ERROROFFLINE
cls
set nag="YOU SEEM TO BE OFFLINE PLEASE RECONNECT TO THE INTERNET TO USE THIS FEATURE"
goto MENU

:PORTABLEEVERYTHING
cls
title PORTABLE PPSSPP LAUNCHER - DOWNLOAD SUITE
if not exist .\bin\wget.exe call :DOWNLOADWGET
if not exist launch_everything.bat .\bin\wget.exe -q --show-progress https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/launch_everything.bat
cls
start launch_everything.bat
exit

:QUICKLAUNCHERCHECK
cls
title PORTABLE PPSSPP LAUNCHER - QUICKLAUNCHER WRITER

echo @echo off> quicklaunch_ppsspp.bat
echo cls>> quicklaunch_ppsspp.bat
echo Color 0A>> quicklaunch_ppsspp.bat
echo setlocal enabledelayedexpansion>> quicklaunch_ppsspp.bat
echo if exist .\bin\ppsspp\installed.txt del .\bin\ppsspp\installed.txt>> quicklaunch_ppsspp.bat
echo for /F "tokens=1*" %%%%a in ('fsutil fsinfo drives') do (>> quicklaunch_ppsspp.bat
echo    for %%%%c in (%%%%b) do (>> quicklaunch_ppsspp.bat
echo       for /F "tokens=3" %%%%d in ('fsutil fsinfo drivetype %%%%c') do (>> quicklaunch_ppsspp.bat
echo          if %%%%d equ Removable (>> quicklaunch_ppsspp.bat
echo            if exist "%%%%c\pspemu\PSP\" echo %%%%cpspemu\^> .\bin\ppsspp\installed.txt>> quicklaunch_ppsspp.bat
echo             if exist "%%%%c\PSP\" echo %%%%c^> .\bin\ppsspp\installed.txt>> quicklaunch_ppsspp.bat
echo          )>> quicklaunch_ppsspp.bat
echo       )>> quicklaunch_ppsspp.bat
echo    )>> quicklaunch_ppsspp.bat
echo )>> quicklaunch_ppsspp.bat
echo if exist .\bin\ppsspp\installed.txt goto :launch>> quicklaunch_ppsspp.bat
echo.>> quicklaunch_ppsspp.bat
echo :default>> quicklaunch_ppsspp.bat
echo echo %CD%\data\ppsspp^> .\bin\ppsspp\installed.txt>> quicklaunch_ppsspp.bat
echo goto launch>> quicklaunch_ppsspp.bat
echo.>> quicklaunch_ppsspp.bat
echo :launch>> quicklaunch_ppsspp.bat
echo start .\bin\ppsspp\PPSSPPWindows64.exe>> quicklaunch_ppsspp.bat
echo exit>> quicklaunch_ppsspp.bat

echo A QUICKLAUNCHER HAS BEEN WRITTEN TO: quicklaunch_ppsspp.bat
pause
exit