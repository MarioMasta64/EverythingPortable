@echo off
setlocal enabledelayedexpansion
Color 0A
cls
title PORTABLE KAERUSETUP LAUNCHER
set nag=BE SURE TO TURN CAPS LOCK OFF! (never said it was on just make sure)
set new_version=OFFLINE
if exist replacer.bat del replacer.bat

:FOLDERCHECK
cls
if not exist .\bin\ mkdir .\bin\
if not exist .\doc\ mkdir .\doc\
if not exist .\data\sd\ mkdir .\data\sd\
if not exist .\extra\ mkdir .\extra\

:VERSION
cls
echo 3 > .\doc\version.txt
set /p current_version=<.\doc\version.txt
if exist .\doc\version.txt del .\doc\version.txt

:CREDITS
cls
if exist .\doc\kaerusetup_license.txt goto FILECHECK
echo ================================================== > .\doc\kaerusetup_license.txt
echo =              Script by MarioMasta64            = >> .\doc\kaerusetup_license.txt
echo =         Most of the code by MikeModder007      = >> .\doc\kaerusetup_license.txt
:: REMOVE SPACE AFTER VERSION HITS DOUBLE DIGITS
echo =            Script Version: v%current_version%- beta          = >> .\doc\kaerusetup_license.txt
echo ================================================== >> .\doc\kaerusetup_license.txt
echo =You may Modify this WITH consent of the original= >> .\doc\kaerusetup_license.txt
echo = creator, as long as you include a copy of this = >> .\doc\kaerusetup_license.txt
echo =      as you include a copy of the License      = >> .\doc\kaerusetup_license.txt
echo ================================================== >> .\doc\kaerusetup_license.txt
echo =    You may also modify this script without     = >> .\doc\kaerusetup_license.txt
echo =         consent for PERSONAL USE ONLY          = >> .\doc\kaerusetup_license.txt
echo ================================================== >> .\doc\kaerusetup_license.txt

:CREDITSREAD
cls
title PORTABLE KAERUSETUP LAUNCHER - ABOUT
for /f "DELIMS=" %%i in (.\doc\kaerusetup_license.txt) do (echo %%i)
pause

:FILECHECK
cls

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
title PORTABLE KAERU SETUP LAUNCHER - DOWNLOAD WGET
cscript.exe .\bin\downloadwget.vbs
move wget.exe .\bin\
exit /b

:MENU
cls
title PORTABLE KAERU SETUP - JOIN TYPE
echo %NAG%
set nag=SELECTION TIME!
echo 1. CIA (choose this if you have cfw installed)
echo 2. HANS (choose this if you dont have cfw or are unsure)
echo 3. NTR (choose this if you have cfw but dont wish to modify the original)
echo 4. IPS (for luma v7 users the better patch :^) )
echo 5. exit
echo.
echo a. write the original work and launch it
echo.
set /p choice="enter a number and press enter to confirm: "
if "%choice%"=="1" goto KAERUCIA
if "%choice%"=="2" goto KAERUHANS
if "%choice%"=="3" goto KAERUNTR
if "%choice%"=="4" goto KAERUIPS
if "%choice%"=="5" exit

if "%choice%"=="a" goto original

set nag="PLEASE SELECT A CHOICE 1-3"
goto MENU

:NULL
cls
set nag="NOT A FEATURE YET!"
exit /b

:HOWEVEN
cls
set nag="I DONT KNOW HOW YOU GOT HERE... BUT WELL... YEA... HEY"
exit /b

:KAERUCIA
cls
set type=CIA
set nag="PLEASE CHOOSE YOUR REGION"
goto KAERUMENU

:KAERUHANS
cls
set type=HANS
set nag="PLEASE CHOOSE YOUR REGION"
goto KAERUMENU

:KAERUNTR
cls
set type=NTR
set nag="PLEASE CHOOSE YOUR REGION"
goto KAERUMENU

:KAERUIPS
cls
:: intercepted bitch :^)
goto KAERUIPSCHECK
:: end intercept
set type=IPS
set nag="PLEASE CHOOSE YOUR REGION"
goto KAERUMENU

:KAERUMENU
cls
title PORTABLE KAERU SETUP - %type% SETUP
echo %NAG%
set nag=SELECTION TIME!
echo USA (for all USA versions)
echo EUR (for all EURope versions)
echo JPN (for all JaPaNese versions)
echo type menu to return to the kaeru setup menu
set /p region="type your region and press enter to confirm: "
if "%region%"=="USA" goto KAERU%type%CHECK
if "%region%"=="EUR" goto KAERU%type%CHECK
if "%region%"=="JPN" goto KAERU%type%CHECK
if "%region%"=="menu" goto MENU
set nag="PLEASE SELECT A CHOICE FROM THE LIST TYPE IN UPPERCASE"
goto KAERUMENU

:KAERUCIACHECK
cls
if not exist .\data\sd\cia\%region%.cia goto DOWNLOADKAERUCIA
goto KAERUSDSET

:DOWNLOADKAERUCIA
cls
if "%region%"=="JPN" call :NULL & goto KAERUMENU
if exist %region%.cia goto MOVEKAERUCIA
if not exist .\bin\wget.exe call :DOWNLOADWGET
.\bin\wget.exe http://dl.projectkaeru.xyz/cia/%region%.cia

:MOVEKAERUCIA
cls
if not exist .\data\sd\cia\ mkdir .\data\sd\cia\
move %region%.cia .\data\sd\cia\%region%.cia
goto KAERUCIACHECK

:KAERUHANSREGIONCHECK
if "%region%"=="USA" set titleid="000c6600"
if "%region%"=="EUR" set titleid="000c6700"
exit /b

:KAERUHANSCHECK
call :KAERUHANSREGIONCHECK
if "%region%"=="JPN" call :NULL
if "%region%"=="JPN" goto KAERUMENU
cls
if not exist .\data\sd\hans\%titleid%.code goto DOWNLOADKAERUHANS
if not exist .\data\sd\hans\%titleid%.romfs goto DOWNLOADKAERUHANS
goto KAERUSDSET

:DOWNLOADKAERUHANS
cls
if exist %titleid%.code goto MOVEKAERUHANS
if not exist .\bin\wget.exe call :DOWNLOADWGET
.\bin\wget.exe http://dl.projectkaeru.xyz/hans/hans/%titleid%.code
.\bin\wget.exe http://dl.projectkaeru.xyz/hans/hans/%titleid%.romfs

:MOVEKAERUHANS
cls
if not exist .\data\sd\hans\ mkdir .\data\sd\hans\
move %titleid%.code .\data\sd\hans\%titleid%.code
move %titleid%.romfs .\data\sd\hans\%titleid%.romfs
goto KAERUHANSCHECK

:KAERUNTRREGIONCHECK
if "%region%"=="USA" set titleid="00040000000c6600"
if "%region%"=="USA" set shortcode=US
if "%region%"=="EUR" set titleid="00040000000c6700"
if "%region%"=="EUR" set shortcode=EU
exit /b

:KAERUNTRCHECK
call :KAERUNTRREGIONCHECK
if "%region%"=="JPN" call :NULL
if "%region%"=="JPN" goto KAERUMENU
cls
if not exist .\data\sd\plugin\%titleid%\ mkdir .\data\sd\plugin\%titleid%\
if not exist .\data\sd\%titleid%\messageData\%shortcode%_English\ mkdir .\data\sd\%titleid%\messageData\%shortcode%_English\
if not exist .\data\sd\%titleid%\messageData\%shortcode%_English\LayoutMessage.blz goto DOWNLOADKAERUNTR
if not exist .\data\sd\%titleid%\messageData\%shortcode%_English\SystemMessage.blz goto DOWNLOADKAERUNTR
if not exist .\data\sd\plugin\%titleid%\layeredfs.plg goto DOWNLOADKAERUNTR
goto KAERUSDSET

:DOWNLOADKAERUNTR
cls
if exist %titleid%.code goto MOVEKAERUNTR
if not exist .\bin\wget.exe call :DOWNLOADWGET
.\bin\wget.exe http://dl.projectkaeru.xyz/ntr/%region%/%titleid%/messageData/%shortcode%_English/LayoutMessage.blz
.\bin\wget.exe http://dl.projectkaeru.xyz/ntr/%region%/%titleid%/messageData/%shortcode%_English/SystemMessage.blz
.\bin\wget.exe http://dl.projectkaeru.xyz/ntr/%region%/plugin/%titleid%/layeredfs.plg

:MOVEKAERUNTR
cls
move LayoutMessage.blz .\data\sd\%titleid%\messageData\%shortcode%_English\
move SystemMessage.blz .\data\sd\%titleid%\messageData\%shortcode%_English\
move layeredfs.plg .\data\sd\plugin\%titleid%\
goto KAERUNTRCHECK

:KAERUIPSCHECK
REM call :KAERUIPSREGION
REM if "%region%"=="JPN" call :NULL
REM if "%region%"=="JPN" goto KAERUMENU
cls
if not exist .\extra\ips.zip goto DOWNLOADKAERUIPS
goto EXTRACTKAERUIPS

:DOWNLOADKAERUIPS
cls
if exist  ips.zip goto MOVEKAERUIPS
if not exist .\bin\wget.exe call :DOWNLOADWGET
.\bin\wget.exe http://dl.projectkaeru.xyz/ips.zip

:MOVEKAERUIPS
cls
move ips.zip .\extra\ips.zip
goto KAERUIPSCHECK

:EXTRACTKAERUIPS
cls
set folder=%CD%
if %CD%==%~d0\ set folder=%CD:~0,2%
cls
echo. > .\bin\extractkaeruzip.vbs
echo 'The location of the zip file. >> .\bin\extractkaeruzip.vbs
echo ZipFile="%folder%\extra\ips.zip" >> .\bin\extractkaeruzip.vbs
echo 'The folder the contents should be extracted to. >> .\bin\extractkaeruzip.vbs
echo ExtractTo="%folder%\data\sd\" >> .\bin\extractkaeruzip.vbs
echo. >> .\bin\extractkaeruzip.vbs
echo 'If the extraction location does not exist create it. >> .\bin\extractkaeruzip.vbs
echo Set fso = CreateObject("Scripting.FileSystemObject") >> .\bin\extractkaeruzip.vbs
echo If NOT fso.FolderExists(ExtractTo) Then >> .\bin\extractkaeruzip.vbs
echo    fso.CreateFolder(ExtractTo) >> .\bin\extractkaeruzip.vbs
echo End If >> .\bin\extractkaeruzip.vbs
echo. >> .\bin\extractkaeruzip.vbs
echo 'Extract the contants of the zip file. >> .\bin\extractkaeruzip.vbs
echo set objShell = CreateObject("Shell.Application") >> .\bin\extractkaeruzip.vbs
echo set FilesInZip=objShell.NameSpace(ZipFile).items >> .\bin\extractkaeruzip.vbs
echo objShell.NameSpace(ExtractTo).CopyHere(FilesInZip) >> .\bin\extractkaeruzip.vbs
echo Set fso = Nothing >> .\bin\extractkaeruzip.vbs
echo Set objShell = Nothing >> .\bin\extractkaeruzip.vbs
echo. >> .\bin\extractkaeruzip.vbs
title PORTABLE KAERU SETUP LAUNCHER - EXTRACT ZIP
cscript.exe .\bin\extractkaeruzip.vbs
goto KAERUSDSET

:KAERUSDSET
cls
title PORTABLE KAERU SETUP - %type% SETUP - MOVE2SD
echo ================================================
echo =Instert your 3DS SDCARD into the computer now =
echo ================================================
echo =Please instert you 3DS SDCARD into your       =
echo =computer now. When it has been mounted, type  =
echo =the drive letter at the prompt, them press    =
echo =enter. Ensure that the drive letter is in     =
echo =UPPERCASE and thet you don't include the ":"  =
echo ================================================
echo setup sd card for homebrew coming soon(tm)
set /P driveletter="What is the drive letter:"
echo Are you sure this is the right drive: %driveletter%:
set /P choice="Is this the right drive (y/n):"
if %choice%==y goto MOVEFILES
if %choice%==n goto KAERUSDSET
goto KAERUSDSET

:MOVEFILES
xcopy ".\data\sd\%type%\*" "%driveletter%:\%type%\" /e /i /y
goto SETUPCOMPLETE

:SETUPCOMPLETE
cls
title PORTABLE KAERU SETUP - %type% SETUP - ALMOST DONE!
echo Almost done!
echo Remove your SDCARD from the PC and re-insert it in your 3DS
echo.
echo For CIA:
echo Turn on your 3DS and open FBI
echo Click SD
echo Using the arrow keys and the A button navigate to the cia folder
echo When you are in this folder hit A while <current directory> is highlighted
echo Then hit Install all CIAs and say yes to any prompts.
echo Now exit FBI, and Flipnote Studio 3D should appear on your homemenu
echo.
echo For HANS:
echo im to lazy and have never used hans...
echo.
echo For NTR:
echo im to lazy and have never used ntr...
echo.
echo To access Project Kaeru open Flipnote Studio 3D and hit the right arrow
echo Then click the box that says Project Kaeru.
echo Congrats, you have now joined Project Kaeru!
echo.
echo For IPS:
echo if you have Luma v7 you dont need to do anything ! just launch Flipnote Studio 3D
pause
exit

:ORIGINAL
echo @echo off > ProjectKaeruSetup.bat
echo del *.cia >> ProjectKaeruSetup.bat
echo :disclaimer >> ProjectKaeruSetup.bat
echo title Project Kaeru Guided Setup >> ProjectKaeruSetup.bat
echo cls >> ProjectKaeruSetup.bat
echo echo ============================================================= >> ProjectKaeruSetup.bat
echo echo =Project Kaeru is a free alternitave to the Japan Exclusive = >> ProjectKaeruSetup.bat
echo echo =Flipnote Gallery World. This service allows users of the   = >> ProjectKaeruSetup.bat
echo echo =Flipnote Studio 3D application to upload their creations   = >> ProjectKaeruSetup.bat
echo echo =for other users of Project Kaeru to see.                   = >> ProjectKaeruSetup.bat
echo echo ============================================================= >> ProjectKaeruSetup.bat
echo echo =The author of this program (MikeModder007) does not claim  = >> ProjectKaeruSetup.bat
echo echo =any rights to the Project Kaeru name or any of its assets. = >> ProjectKaeruSetup.bat
echo echo ============================================================= >> ProjectKaeruSetup.bat
echo echo =This program is provided as-is. The author of this program = >> ProjectKaeruSetup.bat
echo echo =will not be held responsible for any damanges cause to any = >> ProjectKaeruSetup.bat
echo echo =system. Should something not work correctly, submit a      = >> ProjectKaeruSetup.bat
echo echo =issue on GitHub.                                           = >> ProjectKaeruSetup.bat
echo echo ============================================================= >> ProjectKaeruSetup.bat
echo echo =Press any key to continue...                               = >> ProjectKaeruSetup.bat
echo echo ============================================================= >> ProjectKaeruSetup.bat
echo echo =You are using a pre-release version of this software!      = >> ProjectKaeruSetup.bat
echo echo =It's most likely buggy as all hell, and doesn't support    = >> ProjectKaeruSetup.bat
echo echo =NTR yet. If you look at the sourcecode, you can            = >> ProjectKaeruSetup.bat
echo echo =see the code for those options is commented out.           = >> ProjectKaeruSetup.bat
echo echo ============================================================= >> ProjectKaeruSetup.bat
echo echo =PRERELEASE VERSION 2                                       = >> ProjectKaeruSetup.bat
echo echo ============================================================= >> ProjectKaeruSetup.bat
echo pause ^> null >> ProjectKaeruSetup.bat
echo. >> ProjectKaeruSetup.bat
echo :jointype >> ProjectKaeruSetup.bat
echo cls >> ProjectKaeruSetup.bat
echo. >> ProjectKaeruSetup.bat
echo echo ============================================================== >> ProjectKaeruSetup.bat
echo echo =How will you be accessing Project Kaeru?                    = >> ProjectKaeruSetup.bat
echo echo ============================================================== >> ProjectKaeruSetup.bat
echo echo =1)CIA (Use only if you have a CFW)                          = >> ProjectKaeruSetup.bat
echo echo =2)HANS (Can be used without CFW via Homebrew)               = >> ProjectKaeruSetup.bat
echo ::echo =3)NTR (CFW only, but leaves original install intact)        = >> ProjectKaeruSetup.bat
echo echo ============================================================== >> ProjectKaeruSetup.bat
echo echo =Enter the number of your choice then press enter            = >> ProjectKaeruSetup.bat
echo echo ============================================================== >> ProjectKaeruSetup.bat
echo.  >> ProjectKaeruSetup.bat
echo set /P joinsel="Your Selection:" >> ProjectKaeruSetup.bat
echo.  >> ProjectKaeruSetup.bat
echo if %%joinsel%%==1 goto cia >> ProjectKaeruSetup.bat
echo if %%joinsel%%==2 goto hansregion >> ProjectKaeruSetup.bat
echo ::if %%joinsel%%==3 goto ntr >> ProjectKaeruSetup.bat
echo. >> ProjectKaeruSetup.bat
echo echo ERROR: Invalid choice! Press any key to retry... >> ProjectKaeruSetup.bat
echo pause ^> null >> ProjectKaeruSetup.bat
echo goto jointype >> ProjectKaeruSetup.bat
echo. >> ProjectKaeruSetup.bat
echo :cia >> ProjectKaeruSetup.bat
echo if not exist wget.exe goto nowget >> ProjectKaeruSetup.bat
echo cls >> ProjectKaeruSetup.bat
echo echo ================================== >> ProjectKaeruSetup.bat
echo echo =What region is your 3DS system? =  >> ProjectKaeruSetup.bat
echo echo ================================== >> ProjectKaeruSetup.bat
echo echo =To check, open System settings  = >> ProjectKaeruSetup.bat
echo echo =and look in the bottom right.   = >> ProjectKaeruSetup.bat
echo echo =If you 3DS doesn't show any of  = >> ProjectKaeruSetup.bat
echo echo =the listed below, go with the   = >> ProjectKaeruSetup.bat
echo echo =one closest to your region.     = >> ProjectKaeruSetup.bat
echo echo ================================== >> ProjectKaeruSetup.bat
echo echo =(U)SA - America and Canada      = >> ProjectKaeruSetup.bat
echo echo =(E)urope - European Countries   = >> ProjectKaeruSetup.bat
echo echo ================================== >> ProjectKaeruSetup.bat
echo echo =Type your choice then hit enter = >> ProjectKaeruSetup.bat
echo echo ================================== >> ProjectKaeruSetup.bat
echo set /P region="Your choice:" >> ProjectKaeruSetup.bat
echo. >> ProjectKaeruSetup.bat
echo if %%region%%==U goto usacia >> ProjectKaeruSetup.bat
echo if %%region%%==u goto usacia >> ProjectKaeruSetup.bat
echo if %%region%%==E goto eurcia >> ProjectKaeruSetup.bat
echo if %%region%%==e goto eurcia >> ProjectKaeruSetup.bat
echo. >> ProjectKaeruSetup.bat
echo echo Invalid selection! Press any key to retry... >> ProjectKaeruSetup.bat
echo pause ^> null >> ProjectKaeruSetup.bat
echo goto cia >> ProjectKaeruSetup.bat
echo. >> ProjectKaeruSetup.bat
echo :usacia >> ProjectKaeruSetup.bat
echo cls >> ProjectKaeruSetup.bat
echo echo Downlaoding USA cia... >> ProjectKaeruSetup.bat
echo wget http://dl.projectkaeru.xyz/cia/USA.cia >> ProjectKaeruSetup.bat
echo if not exist usa.cia goto ciadlfail >> ProjectKaeruSetup.bat
echo echo Downloaded USA cia! >> ProjectKaeruSetup.bat
echo rename usa.cia ProjectKaeru.cia >> ProjectKaeruSetup.bat
echo echo Press any key to move on to the next step... >> ProjectKaeruSetup.bat
echo pause ^> null >> ProjectKaeruSetup.bat
echo goto getsd >> ProjectKaeruSetup.bat
echo. >> ProjectKaeruSetup.bat
echo :eurcia >> ProjectKaeruSetup.bat
echo cls >> ProjectKaeruSetup.bat
echo echo Downloading EUR cia... >> ProjectKaeruSetup.bat
echo wget http://dl.projectkaeru.xyz/cia/EUR.cia >> ProjectKaeruSetup.bat
echo if not exist eur.cia goto ciadlfail >> ProjectKaeruSetup.bat
echo echo Downloaded EUR CIA! >> ProjectKaeruSetup.bat
echo rename eur.cia ProjectKaeru.cia >> ProjectKaeruSetup.bat
echo echo Press any key to move on to the next step... >> ProjectKaeruSetup.bat
echo pause ^> null >> ProjectKaeruSetup.bat
echo goto getsd >> ProjectKaeruSetup.bat
echo. >> ProjectKaeruSetup.bat
echo :ciadlfail >> ProjectKaeruSetup.bat
echo echo ERROR: CIA Failed to download. >> ProjectKaeruSetup.bat
echo echo Press any key to return the the region selection menu... >> ProjectKaeruSetup.bat
echo pause ^> null >> ProjectKaeruSetup.bat
echo goto cia >> ProjectKaeruSetup.bat
echo. >> ProjectKaeruSetup.bat
echo :getsd >> ProjectKaeruSetup.bat
echo cls >> ProjectKaeruSetup.bat
echo echo ================================================ >> ProjectKaeruSetup.bat
echo echo =Instert your 3DS SDCARD into the computer now = >> ProjectKaeruSetup.bat
echo echo ================================================ >> ProjectKaeruSetup.bat
echo echo =Please instert you 3DS SDCARD into your       = >> ProjectKaeruSetup.bat
echo echo =computer now. When it has been mounted, type  = >> ProjectKaeruSetup.bat
echo echo =the drive letter at the prompt, them press    = >> ProjectKaeruSetup.bat
echo echo =enter. Ensure that the drive letter is in     = >> ProjectKaeruSetup.bat
echo echo =UPPERCASE and thet you don't include the colon= >> ProjectKaeruSetup.bat
echo echo ================================================ >> ProjectKaeruSetup.bat
echo set /P driveletter="What is the drive letter:" >> ProjectKaeruSetup.bat
echo. >> ProjectKaeruSetup.bat
echo echo Are you sure this is the right drive: %%driveletter%%: >> ProjectKaeruSetup.bat
echo set /P rightdrive="Is this the right drive (Y/N):" >> ProjectKaeruSetup.bat
echo. >> ProjectKaeruSetup.bat
echo if %%rightdrive%%==y goto movecia >> ProjectKaeruSetup.bat
echo if %%rightdrive%%==Y goto movecia >> ProjectKaeruSetup.bat
echo if %%rightdrive%%==n goto getsd >> ProjectKaeruSetup.bat
echo if %%rightdrive%%==N goto getsd >> ProjectKaeruSetup.bat
echo. >> ProjectKaeruSetup.bat
echo echo Invalid choice. Press any key to return... >> ProjectKaeruSetup.bat
echo pause ^> null >> ProjectKaeruSetup.bat
echo goto getsd >> ProjectKaeruSetup.bat
echo. >> ProjectKaeruSetup.bat
echo :movecia >> ProjectKaeruSetup.bat
echo cls >> ProjectKaeruSetup.bat
echo mkdir %%driveletter%%:\ProjectKaeru\ >> ProjectKaeruSetup.bat
echo del %%driveletter%%:\ProjectKaeru\*.cia >> ProjectKaeruSetup.bat
echo echo Moving ProjectKaeru.cia to %%driveletter%%:\ProjectKaeru\ >> ProjectKaeruSetup.bat
echo copy *.cia %%driveletter%%:\ProjectKaeru\ >> ProjectKaeruSetup.bat
echo if not exist %%driveletter%%:\ProjectKaeru\ProjectKaeru.cia goto ciamovefail >> ProjectKaeruSetup.bat
echo echo Press any key to continue... >> ProjectKaeruSetup.bat
echo pause ^> null >> ProjectKaeruSetup.bat
echo goto ciaon3ds >> ProjectKaeruSetup.bat
echo. >> ProjectKaeruSetup.bat
echo :ciamovefail >> ProjectKaeruSetup.bat
echo echo ERROR: Failed to move files to SDCARD. Are you sure you entred the right driver letter? >> ProjectKaeruSetup.bat
echo echo Press any key to return to the SDCARD menu... >> ProjectKaeruSetup.bat
echo pause ^> null >> ProjectKaeruSetup.bat
echo goto getsd >> ProjectKaeruSetup.bat
echo. >> ProjectKaeruSetup.bat
echo :ciaon3ds >> ProjectKaeruSetup.bat
echo cls >> ProjectKaeruSetup.bat
echo echo Almost done! >> ProjectKaeruSetup.bat
echo echo Remove your SDCARD from the PC and re-insert it in your 3DS >> ProjectKaeruSetup.bat
echo echo Turn on your 3DS and open FBI >> ProjectKaeruSetup.bat
echo echo Click SD >> ProjectKaeruSetup.bat
echo echo Using the arrow keys and the A button navigate to the ProjectKaeru folder >> ProjectKaeruSetup.bat
echo echo When you are in this folder hit A while ^<current directory^> is highlighted >> ProjectKaeruSetup.bat
echo echo Then hit Install all CIAs and say yes to any prompts. >> ProjectKaeruSetup.bat
echo echo Now exit FBI, and Flipnote Studio 3D should appear on your homemenu >> ProjectKaeruSetup.bat
echo echo To acess Project Kaeru open Flipnote Studio 3D and hit the right arrow >> ProjectKaeruSetup.bat
echo echo Then click the box that says Project Kaeru. >> ProjectKaeruSetup.bat
echo echo Congrats, you have now joined Project Kaeru! >> ProjectKaeruSetup.bat
echo echo. >> ProjectKaeruSetup.bat
echo echo To exit, hit the X button on the window. >> ProjectKaeruSetup.bat
echo. >> ProjectKaeruSetup.bat
echo :inloop >> ProjectKaeruSetup.bat
echo goto inloop >> ProjectKaeruSetup.bat
echo. >> ProjectKaeruSetup.bat
echo. >> ProjectKaeruSetup.bat
echo. >> ProjectKaeruSetup.bat
echo. >> ProjectKaeruSetup.bat
echo. >> ProjectKaeruSetup.bat
echo. >> ProjectKaeruSetup.bat
echo. >> ProjectKaeruSetup.bat
echo :hans >> ProjectKaeruSetup.bat
echo if not exist wget.exe goto nowget >> ProjectKaeruSetup.bat
echo cls >> ProjectKaeruSetup.bat
echo echo ================================================= >> ProjectKaeruSetup.bat
echo echo =Do you already have HANS in your 3DS homebrew? = >> ProjectKaeruSetup.bat
echo echo ================================================= >> ProjectKaeruSetup.bat
echo echo =(Y)es - I already have HANS                    = >> ProjectKaeruSetup.bat
echo echo =(N)o - I Dont have HANS                        = >> ProjectKaeruSetup.bat
echo echo =(D)ont Know - I am unsure if I have HANS       = >> ProjectKaeruSetup.bat
echo echo ================================================= >> ProjectKaeruSetup.bat
echo echo =Enter your selection then press enter...       = >> ProjectKaeruSetup.bat
echo echo ================================================= >> ProjectKaeruSetup.bat
echo echo. >> ProjectKaeruSetup.bat
echo set /P hashans="Your choice:" >> ProjectKaeruSetup.bat
echo. >> ProjectKaeruSetup.bat
echo if %%hashans%%==Y  goto hansregion >> ProjectKaeruSetup.bat
echo if %%hashans%%==y  goto hansregion >> ProjectKaeruSetup.bat
echo if %%hashans%%==N  goto gethans >> ProjectKaeruSetup.bat
echo if %%hashans%%==n  goto gethans >> ProjectKaeruSetup.bat
echo if %%hashans%%==D  goto gethans >> ProjectKaeruSetup.bat
echo if %%hashans%%==d  goto gethans >> ProjectKaeruSetup.bat
echo. >> ProjectKaeruSetup.bat
echo echo Invalid choice. Press any key to retry... >> ProjectKaeruSetup.bat
echo pause ^> null >> ProjectKaeruSetup.bat
echo goto hans >> ProjectKaeruSetup.bat
echo. >> ProjectKaeruSetup.bat
echo :hansregion >> ProjectKaeruSetup.bat
echo echo ================================================== >> ProjectKaeruSetup.bat
echo echo =What version of Flipnote Studio 3D do you have? = >> ProjectKaeruSetup.bat
echo echo ================================================== >> ProjectKaeruSetup.bat
echo echo =Is your copy of FS3D from:                      = >> ProjectKaeruSetup.bat
echo echo =                                                = >> ProjectKaeruSetup.bat
echo echo =(U)SA - America and Canada                      = >> ProjectKaeruSetup.bat
echo echo =(E)urope - European Countries                   = >> ProjectKaeruSetup.bat
echo echo ================================================== >> ProjectKaeruSetup.bat
echo echo =Enter your selection then press enter...        = >> ProjectKaeruSetup.bat
echo echo ================================================== >> ProjectKaeruSetup.bat
echo echo. >> ProjectKaeruSetup.bat
echo. >> ProjectKaeruSetup.bat
echo set /P hregion="Your choice:" >> ProjectKaeruSetup.bat
echo. >> ProjectKaeruSetup.bat
echo if %%hregion%%==U goto hansus >> ProjectKaeruSetup.bat
echo if %%hregion%%==u goto hansus >> ProjectKaeruSetup.bat
echo if %%hregion%%==E goto hanseur >> ProjectKaeruSetup.bat
echo if %%hregion%%==e goto hanseur >> ProjectKaeruSetup.bat
echo. >> ProjectKaeruSetup.bat
echo echo Invalid selection. Press any key to retry... >> ProjectKaeruSetup.bat
echo pause ^> null >> ProjectKaeruSetup.bat
echo goto hans >> ProjectKaeruSetup.bat
echo. >> ProjectKaeruSetup.bat
echo :hansus >> ProjectKaeruSetup.bat
echo wget https://dl.projectkaeru.xyz/hans/hans/000c6600.code >> ProjectKaeruSetup.bat
echo wget https://dl.projectkaeru.xyz/hans/hans/000c6600.romfs >> ProjectKaeruSetup.bat
echo if not exist 000c6600.code goto hansdlfail >> ProjectKaeruSetup.bat
echo if not exist 000c6600.romfs goto hansdlfail >> ProjectKaeruSetup.bat
echo goto hanstosd >> ProjectKaeruSetup.bat
echo. >> ProjectKaeruSetup.bat
echo. >> ProjectKaeruSetup.bat
echo :hanseur >> ProjectKaeruSetup.bat
echo wget https://dl.projectkaeru.xyz/hans/hans/000c6700.code >> ProjectKaeruSetup.bat
echo wget https://dl.projectkaeru.xyz/hans/hans/000c6700.romfs >> ProjectKaeruSetup.bat
echo if not exist 000c6700.code goto hansdlfail >> ProjectKaeruSetup.bat
echo if not exist 000c6700.romfs goto hansdlfail >> ProjectKaeruSetup.bat
echo goto hanstosd >> ProjectKaeruSetup.bat
echo. >> ProjectKaeruSetup.bat
echo :hanstosd >> ProjectKaeruSetup.bat
echo cls >> ProjectKaeruSetup.bat
echo echo ================================================ >> ProjectKaeruSetup.bat
echo echo =Instert your 3DS SDCARD into the computer now = >> ProjectKaeruSetup.bat
echo echo ================================================ >> ProjectKaeruSetup.bat
echo echo =Please instert your 3DS SDCARD into your      = >> ProjectKaeruSetup.bat
echo echo =computer now. When it has been mounted, type  = >> ProjectKaeruSetup.bat
echo echo =the drive letter at the prompt, them press    = >> ProjectKaeruSetup.bat
echo echo =enter. Ensure that the drive letter is in     = >> ProjectKaeruSetup.bat
echo echo =UPPERCASE and thet you don't include the colon= >> ProjectKaeruSetup.bat
echo echo ================================================ >> ProjectKaeruSetup.bat
echo set /P driveletter="What is the drive letter:" >> ProjectKaeruSetup.bat
echo. >> ProjectKaeruSetup.bat
echo echo Are you sure this is the right drive: %%driveletter%%: >> ProjectKaeruSetup.bat
echo set /P rightdrive="Is this the right drive (Y/N):" >> ProjectKaeruSetup.bat
echo. >> ProjectKaeruSetup.bat
echo if %%rightdrive%%==y goto movehans >> ProjectKaeruSetup.bat
echo if %%rightdrive%%==Y goto movehans >> ProjectKaeruSetup.bat
echo if %%rightdrive%%==n goto hanstosd >> ProjectKaeruSetup.bat
echo if %%rightdrive%%==N goto hanstosd >> ProjectKaeruSetup.bat
echo. >> ProjectKaeruSetup.bat
echo echo Invalid choice. Press any key to return... >> ProjectKaeruSetup.bat
echo pause ^> null >> ProjectKaeruSetup.bat
echo goto hanstosd >> ProjectKaeruSetup.bat
echo. >> ProjectKaeruSetup.bat
echo :movehans >> ProjectKaeruSetup.bat
echo if not exist %%driveletter%%:\hans mkdir %%driveletter%%:\hans >> ProjectKaeruSetup.bat
echo copy *.code %%driveletter%%:\hans >> ProjectKaeruSetup.bat
echo copy *.romfs %%driveletter%%:\hans >> ProjectKaeruSetup.bat
echo. >> ProjectKaeruSetup.bat
echo :hansdlfail >> ProjectKaeruSetup.bat
echo cls >> ProjectKaeruSetup.bat
echo echo The download of the HANS file(s) failed. >> ProjectKaeruSetup.bat
echo echo echo Press any key to return to the HANS menu... >> ProjectKaeruSetup.bat
echo pause ^> null >> ProjectKaeruSetup.bat
echo echo echo goto hans >> ProjectKaeruSetup.bat
echo. >> ProjectKaeruSetup.bat
echo :gethans >> ProjectKaeruSetup.bat
echo cls >> ProjectKaeruSetup.bat
echo echo ================================================= >> ProjectKaeruSetup.bat
echo echo =You can get HANS and the homebrew starter kit  = >> ProjectKaeruSetup.bat
echo echo =by going to https://smealum.github.io/3ds/     = >> ProjectKaeruSetup.bat
echo echo ================================================= >> ProjectKaeruSetup.bat
echo echo =After you have HANS come back an re-run this   = >> ProjectKaeruSetup.bat
echo echo =wizard. See you soon!                          = >> ProjectKaeruSetup.bat
echo echo ================================================= >> ProjectKaeruSetup.bat
echo echo. >> ProjectKaeruSetup.bat
echo echo Press any key to terminate this application... >> ProjectKaeruSetup.bat
echo pause ^> null >> ProjectKaeruSetup.bat
echo exit >> ProjectKaeruSetup.bat
echo. >> ProjectKaeruSetup.bat
echo :ntr >> ProjectKaeruSetup.bat
echo if not exist wget.exe goto nowget >> ProjectKaeruSetup.bat
echo. >> ProjectKaeruSetup.bat
echo pause >> ProjectKaeruSetup.bat
echo exit >> ProjectKaeruSetup.bat
echo. >> ProjectKaeruSetup.bat
echo. >> ProjectKaeruSetup.bat
echo :nowget >> ProjectKaeruSetup.bat
echo cls >> ProjectKaeruSetup.bat
echo echo FATAL: wget binary not found! Try redownloading ProjectKaeruSetupWizard.exe or >> ProjectKaeruSetup.bat
echo echo manually placing wget.exe in the same directory as ProjectKaeruSetupWizard.exe! >> ProjectKaeruSetup.bat
echo pause >> ProjectKaeruSetup.bat
echo exit >> ProjectKaeruSetup.bat
echo. >> ProjectKaeruSetup.bat
echo :nounzip >> ProjectKaeruSetup.bat
echo cls >> ProjectKaeruSetup.bat
echo echo FATAL: unzip binary not found! Try redownloading ProjectKaeruSetup.exe or manually >> ProjectKaeruSetup.bat
echo echo placing unzip.exe in the same directory as ProjectKaeruSetup.exe! >> ProjectKaeruSetup.bat
cls
echo FEEL THE NOSTALGIA :D
pause
start ProjectKaeruSetup.bat
exit