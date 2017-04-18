@echo off
setlocal enabledelayedexpansion
Color 0A
cls
title PORTABLE MINECRAFT LAUNCHER
set nag=BE SURE TO TURN CAPS LOCK OFF! (never said it was on just make sure)
set new_version=OFFLINE
if exist replacer.bat del replacer.bat
if "%~1" neq "" (call :%~1 & exit /b !current_version!)

:FOLDERCHECK
cls
if not exist .\bin\ mkdir .\bin\
if not exist .\doc\ mkdir .\doc\
if not exist .\extra\ mkdir .\extra\
if not exist .\data\minecraft\profiles\ mkdir .\data\minecraft\profiles\
call :VERSION
goto CREDITS

:VERSION
cls
echo 6 > .\doc\version.txt
set /p current_version=<.\doc\version.txt
if exist .\doc\version.txt del .\doc\version.txt
exit /b

:CREDITS
cls
if exist .\doc\minecraft_license.txt goto FILECHECK
echo ================================================== > .\doc\minecraft_license.txt
echo =              Script by MarioMasta64            = >> .\doc\minecraft_license.txt
:: remove space when version reaches 2 digits
echo =           Script Version: v%current_version%- release         = >> .\doc\minecraft_license.txt
echo ================================================== >> .\doc\minecraft_license.txt
echo =You may Modify this WITH consent of the original= >> .\doc\minecraft_license.txt
echo = creator, as long as you include a copy of this = >> .\doc\minecraft_license.txt
echo =      as you include a copy of the License      = >> .\doc\minecraft_license.txt
echo ================================================== >> .\doc\minecraft_license.txt
echo =    You may also modify this script without     = >> .\doc\minecraft_license.txt
echo =         consent for PERSONAL USE ONLY          = >> .\doc\minecraft_license.txt
echo ================================================== >> .\doc\minecraft_license.txt

:CREDITSREAD
cls
title PORTABLE MINECRAFT LAUNCHER - ABOUT
for /f "DELIMS=" %%i in (.\doc\minecraft_license.txt) do (echo %%i)
pause

:FILECHECK
cls
if not exist .\bin\minecraft.jar goto DOWNLOADMINECRAFT
if not exist .\data\minecraft\.minecraft\launcher.pack.lzma set nag=COPY "%APPDATA%\.minecraft" TO "%CD%\data\minecraft" IF YOU HAVE EXISTING SAVEDATA AND THEN LAUNCH DEFAULT PROFILE

:WGETUPDATE
cls
wget https://eternallybored.org/misc/wget/current/wget.exe
move wget.exe .\bin\
goto MENU

:DOWNLOADMINECRAFT
cls
if not exist .\bin\wget.exe call :DOWNLOADWGET
.\bin\wget.exe http://s3.amazonaws.com/Minecraft.Download/launcher/Minecraft.jar
cls
move Minecraft.jar .\bin\
goto FILECHECK

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

:MENU
cls
title PORTABLE MINECRAFT LAUNCHER - MAIN MENU
echo %NAG%
set nag=SELECTION TIME!
echo 1. new profile
echo 2. default profile
echo 3. launch profile
echo 4. delete profile
echo 5. update
echo 6. about
echo 7. exit
echo.
echo b. download other projects
echo.
echo c. write a quicklauncher
echo.
set /p choice="enter a number and press enter to confirm: "
if "%CHOICE%"=="1" goto NEW
if "%CHOICE%"=="2" goto DEFAULT
if "%CHOICE%"=="3" goto SELECT
if "%CHOICE%"=="4" goto DELETE
if "%CHOICE%"=="5" goto UPDATECHECK
if "%CHOICE%"=="6" goto ABOUT
if "%CHOICE%"=="7" exit
if "%CHOICE%"=="b" goto PORTABLEEVERYTHING
if "%CHOICE%"=="c" goto QUICKLAUNCHERCHECK
set nag="PLEASE SELECT A CHOICE 1-6 or b/c"
goto MENU

:GET_PROFILES
dir /ad /b .\data\minecraft\profiles\* > .\doc\profiles.txt
set Counter=0
for /f "DELIMS=" %%i in ('type .\doc\profiles.txt') do (
    set /a Counter+=1
    set "Line_!Counter!=%%i"
)
if exist .\doc\profiles.txt del .\doc\profiles.txt
exit /b

:NEW
cls
title PORTABLE MINECRAFT LAUNCHER - NEW PROFILE
echo %NAG%
set nag=SELECTION TIME!
echo type the name of the profile
echo only use letters and numbers
echo type menu to return to the main menu
set /p profile="enter a name for the new profile: "
if "%PROFILE%"=="menu" goto MENU
if exist ".\data\minecraft\%PROFILE%\" then goto EXIST
goto CREATE

:CREATE
cls
title PORTABLE MINECRAFT LAUNCHER - CREATE PROFILE
echo %NAG%
set nag=SELECTION TIME!
echo create profile "%PROFILE%"?
echo type yes or no and press enter
set /p choice="choice: "
if "%CHOICE%"=="no" goto NEWTITLE
if "%CHOICE%"=="yes" goto NOWCREATING
set nag="please enter YES or NO"
goto CREATE

:NOWCREATING
cls
if exist ".\data\minecraft\profiles\%PROFILE%\" goto EXISTS
mkdir ".\data\minecraft\profiles\%PROFILE%\"
if exist ".\data\minecraft\profiles\%PROFILE%\" goto LAUNCH
set LEGITCHECK="INVALID NAME"
goto NEW

:EXISTS
cls
title PORTABLE MINECRAFT LAUNCHER - LAUNCH PROFILE
echo %NAG%
set nag=SELECTION TIME!
echo PROFILE "%PROFILE%" EXISTS
echo launch it?
echo type yes or no and press enter
set /p choice="choice: "
if "%CHOICE%"=="no" goto NEWTITLE
if "%CHOICE%"=="yes" goto LAUNCH
set nag="please enter YES or NO"
goto EXISTS

:NEWTITLE
cls
set nag="ENTER A DIFFERENT TITLE THEN"
goto NEW

:SELECT
cls
title PORTABLE MINECRAFT LAUNCHER - SELECT PROFILE
echo %NAG%
set nag=SELECTION TIME!
echo type default for default profile
call :get_profiles
For /L %%C in (1,1,%Counter%) Do (echo %%C. !Line_%%C!)
echo type menu to return to the main menu
set /p choice="profile to launch: "
set profile=!Line_%CHOICE%!
if "%CHOICE%"=="menu" goto MENU
if "%CHOICE%"=="default" goto DEFAULT
if ".\data\minecraft\profiles\%PROFILE%\"==".\data\minecraft\profiles\" goto set_create
if exist ".\data\minecraft\profiles\%PROFILE%\" goto LAUNCH

:set_create
cls
set "profile=%CHOICE%"
if exist ".\data\minecraft\profiles\%PROFILE%\" goto LAUNCH
set nag=PROFILE "%PROFILE%" DOES NOT EXIST
goto CREATE

:LAUNCH
cls
set "APPDATA=.\data\minecraft\profiles\%PROFILE%\"
goto OSCHECK

:DEFAULT
cls
set APPDATA=.\data\minecraft
goto OSCHECK

:DELETE
cls
title PORTABLE MINECRAFT LAUNCHER - DELETE PROFILE
echo %NAG%
set nag=SELECTION TIME!
echo type default for default profile
call :get_profiles
For /L %%C in (1,1,%Counter%) Do (echo %%C. !Line_%%C!)
echo type menu to return to the main menu
set /p choice="profile to delete: "
set profile=!Line_%CHOICE%!
if "%CHOICE%"=="menu" goto MENU
if "%CHOICE%"=="default" goto DELETEMAIN
if ".\data\minecraft\profiles\%PROFILE%\"==".\data\minecraft\profiles\" goto set_delete
if exist ".\data\minecraft\profiles\%PROFILE%\" goto NOWDELETING

:set_delete
cls
set "profile=%CHOICE%"
if exist ".\data\minecraft\profiles\%PROFILE%\" goto NOWDELETING
set nag=PROFILE "%PROFILE%" DOES NOT EXIST
goto DELETE

:NOWDELETING
cls
rmdir /s ".\data\minecraft\profiles\%PROFILE%\"
goto DELETE

:DELETEMAIN
cls
rmdir /s .\data\minecraft\.minecraft\
rmdir /s /q .\data\minecraft\java\
goto DELETE

:OSCHECK
cls
title PORTABLE MINECRAFT LAUNCHER - JAVA
echo type y for system or anything else for portable java
echo press enter afterwards
set /p choice="choice: "
if "%CHOICE%"=="y" goto JAVALAUNCH
goto ARCHCHECK

:JAVALAUNCH
cls
start .\bin\Minecraft.jar
exit

:ARCHCHECK
cls
set arch=
if exist "%PROGRAMFILES(X86)%" set arch=64

:JAVACHECK
cls
if not exist .\bin\commonfiles\java%arch%\bin\javaw.exe goto JAVAINSTALLERCHECK
start "" .\bin\commonfiles\java%arch%\bin\javaw.exe -jar .\bin\Minecraft.jar
exit

:JAVAINSTALLERCHECK
cls
if not exist .\extra\jPortable%arch%_8_Update_121.paf.exe goto DOWNLOADJAVA
start .\extra\jPortable%arch%_8_Update_121.paf.exe /destination="%CD%\bin\"
title READMEREADMEREADMEREADMEREADMEREADMEREADMEREADMEREADMEREADMEREADMEREADMEREADMEREADMEREADME
echo go through the install directions as it says then press enter to continue
pause
goto JAVACHECK

:DOWNLOADJAVA
cls
if exist jPortable%arch%_8_Update_121.paf.exe goto MOVEJAVA
if not exist .\bin\wget.exe call :DOWNLOADWGET
.\bin\wget.exe http://downloads.sourceforge.net/portableapps/jPortable%arch%_8_Update_121.paf.exe

:MOVEJAVA
cls
move jPortable%arch%_8_Update_121.paf.exe .\extra\jPortable%arch%_8_Update_121.paf.exe
goto JAVAINSTALLERCHECK

:UPDATECHECK
cls
if exist version.txt del version.txt
if not exist .\bin\wget.exe call :DOWNLOADWGET
.\bin\wget.exe https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/version.txt
cls
set Counter=0 & for /f "DELIMS=" %%i in ('type version.txt') do (set /a Counter+=1 & set "Line_!Counter!=%%i")
if exist version.txt del version.txt
set new_version=%Line_4%
if %new_version%==OFFLINE goto ERROROFFLINE
if %current_version% EQU %new_version% goto LATEST
if %current_version% LSS %new_version% goto NEWUPDATE
if %current_version% GTR %new_version% goto NEWEST
goto ERROROFFLINE

:LATEST
cls
title PORTABLE MINECRAFT LAUNCHER - LATEST BUILD :D
echo you are using the latest version!!
echo Current Version: v%current_version%
echo New Version: v%new_version%
echo ENTER TO CONTINUE
pause
goto MENU

:NEWUPDATE
cls
title PORTABLE MINECRAFT LAUNCHER - OLD BUILD D:
echo %NAG%
set nag=SELECTION TIME!
echo you are using an older version
echo enter yes or no
echo Current Version: v%current_version%
echo New Version: v%new_version%
set /p choice="Update?: "
if "%CHOICE%"=="yes" goto UPDATE
if "%CHOICE%"=="no" goto MENU
set nag="please enter YES or NO"
goto NEWUPDATE

:UPDATE
cls
if not exist .\bin\wget.exe call :DOWNLOADWGET
.\bin\wget.exe https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/launch_minecraft.bat
cls
if exist launch_minecraft.bat.1 goto REPLACERCREATE
goto ERROROFFLINE

:REPLACERCREATE
cls
echo @echo off > replacer.bat
echo Color 0A >> replacer.bat
echo del launch_minecraft.bat >> replacer.bat
echo rename launch_minecraft.bat.1 launch_minecraft.bat >> replacer.bat
echo start launch_minecraft.bat >> replacer.bat
echo exit >> replacer.bat
start replacer.bat
exit

:NEWEST
cls
title PORTABLE MINECRAFT LAUNCHER - TEST BUILD :0
echo YOURE USING A TEST BUILD MEANING YOURE EITHER
echo CLOSE TO ME OR YOURE SOME SORT OF PIRATE
echo Current Version: v%current_version%
echo New Version: v%new_version%
echo ENTER TO CONTINUE
pause
start launch_minecraft.bat
exit

:ABOUT
cls
del .\doc\minecraft_license.txt
start launch_minecraft.bat
exit

:PORTABLEEVERYTHING
cls
if not exist .\bin\wget.exe call :DOWNLOADWGET
if not exist launch_everything.bat .\bin\wget.exe https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/launch_everything.bat
cls
start launch_everything.bat
exit

:QUICKLAUNCHERCHECK
cls
title PORTABLE MINECRAFT LAUNCHER - QUICKLAUNCHER WRITER
echo @echo off > quicklaunch_minecraft.bat
echo Color 0A >> quicklaunch_minecraft.bat
echo cls >> quicklaunch_minecraft.bat
echo set APPDATA=.\data\minecraft >> quicklaunch_minecraft.bat
echo start "" .\bin\commonfiles\java64\bin\javaw.exe -jar .\bin\Minecraft.jar >> quicklaunch_minecraft.bat
echo exit >> quicklaunch_minecraft.bat
echo A QUICKLAUNCHER HAS BEEN WRITTEN TO: quicklaunch_minecraft.bat
pause
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