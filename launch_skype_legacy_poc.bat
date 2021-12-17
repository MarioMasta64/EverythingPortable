@echo off
cls
Color 0A

set "folder=%~dp0"
set "folder=!folder:~0,-1!"
pushd "!folder!"

set "rm=yes"
set "dp=yes"
set "datapath=%folder%\data\skype\"
set "us=no"
set "login="
set "ps=no"
set "password="
set "ns=no"
set "mn=no"
set "sc=no"
set "cl=no"
set "contact="
if not exist .\bin\skype\ mkdir .\bin\skype\
if not exist .\data\skype\ mkdir .\data\skype\
if not exist .\extra\ mkdir .\extra\

:main
cls
echo rm: Set Removable
echo dp: Set Data Path
echo us: Set Username
echo ps: Set Password
echo ns: Set No Splash
echo mn: Set Minimized
echo sc: Set Secondary Skype
echo cl: Set Call Someone
echo.
echo st: Start Skype
echo sd: Shutdown Skype
echo.
echo dl: Download Skype
echo.
echo ini: Write Current Settings To .\extra\skype.ini
echo.
set /p choice="choice: "
call :%choice%
goto main

:ini
cls
echo inicl: Clear Ini
echo inist: Set Ini
set /p choice="choice: "
call :%choice%
goto rm

:inist
echo xxxxxx Removable xxxxxx> .\ini\skype.ini
echo "rm:%rm%">> .\ini\skype.ini
echo xxxxxx Datapath xxxxxx >> .\ini\skype.ini
echo "dp:%dp%">> .\ini\skype.ini
echo xxxxxx Datapath !CD! for current directory xxxxxx >> .\ini\skype.ini
echo "data:%datapath%">> .\ini\skype.ini
echo xxxxxx Username xxxxxx>> .\ini\skype.ini
echo "us:%us%">> .\ini\skype.ini
echo xxxxxx Enter Username xxxxxx>> .\ini\skype.ini
echo "user:%login%">> .\ini\skype.ini
echo xxxxxx Password xxxxxx>> .\ini\skype.ini
echo "ps:%ps%">> .\ini\skype.ini
echo xxxxxx Enter Password xxxxxx>> .\ini\skype.ini
echo "pass:%password%">> .\ini\skype.ini
echo xxxxxx No Splash xxxxxx>> .\ini\skype.ini
echo "ns:%ns%">> .\ini\skype.ini
echo xxxxxx Minimize xxxxxx>> .\ini\skype.ini
echo "mn:%mn%">> .\ini\skype.ini
echo xxxxxx Contact Someone xxxxxx>> .\ini\skype.ini
echo "cl:no">> .\ini\skype.ini
echo xxxxxx Contact Number xxxxxx>> .\ini\skype.ini
echo "contact:">> .\ini\skype.ini
echo .\ini\skype.ini has been written
pause
goto main

:inicl
if exist .\ini\skype.ini del .\ini\skype.ini >nul
echo .\ini\skype.ini has been removed
pause
goto main

:sd
cls
"%folder%\bin\Skype\Skype.exe" /shutdown
goto main

:st
cls

if exist .\ini\skype.ini (
  setlocal enabledelayedexpansion
  set "start=%folder%\bin\Skype\Skype.exe"
  for /f "delims=" %%a in (.\ini\skype.ini) do ( 
    set "a=%%a"
    if "!a:~1,3!"=="rm:" set "rm=!a:~4,-1!"
    if "!a:~1,3!"=="dp:" set "dp=!a:~4,-1!"
    if "!a:~1,3!"=="us:" set "us=!a:~4,-1!"
    if "!a:~1,3!"=="ps:" set "ps=!a:~4,-1!"
    if "!a:~1,3!"=="ns:" set "ns=!a:~4,-1!"
    if "!a:~1,3!"=="mn:" set "mn=!a:~4,-1!"
    if "!a:~1,3!"=="sc:" set "sc=!a:~4,-1!"
    if "!a:~1,3!"=="cl:" set "cl=!a:~4,-1!"
    if "!a:~1,5!"=="user:" set "login=!a:~6,-1!"
    if "!a:~1,5!"=="pass:" set "password=!a:~6,-1!"
    if "!a:~1,5!"=="data:" set "datapath=!a:~6,-1!"
    if "!a:~1,8!"=="contact:" set "contact=!a:~9,-1!"
  )
  if "!rm!"=="yes" set "start=!start! /removable"
  if "!dp!"=="yes" set "start=!start! /datapath:!datapath!"
  if "!us!"=="yes" set "start=!start! /username:!login!"
  if "!ps!"=="yes" set "start=!start! /password:!password!"
  if "!ns!"=="yes" set "start=!start! /nosplash"
  if "!mn!"=="yes" set "start=!start! /minimized"
  if "!sc!"=="yes" set "start=!start! /secondary"
  if "!cl!"=="yes" set "start=!start! /callto:!contact!"

  echo !start!
  pause
  start !start!
  exit
  endlocal
)

set "start=%folder%\bin\Skype\Skype.exe"
:: removable logic
if "%rm%"=="yes" set "start=%start% /removable"
if "%dp%"=="yes" set "start=%start% /datapath:%datapath%"
if "%us%"=="yes" set "start=%start% /username:%login%"
if "%ps%"=="yes" set "start=%start% /password:%password%"
if "%ns%"=="yes" set "start=%start% /nosplash"
if "%mn%"=="yes" set "start=%start% /minimized"
if "%sc%"=="yes" set "start=%start% /secondary"
if "%cl%"=="yes" set "start=%start% /callto:%contact%"
echo "%start%"
pause
start %start%
goto main

:rm
cls
echo rmcl: Clear Removable
echo rmst: Set Removable
set /p choice="choice: "
call :%choice%
goto rm

:rmcl
cls
set "rm=no"

cls
echo removable set: "%rm%"
pause

goto main

:rmst
cls
set "rm=yes"

cls
echo removable set: "%rm%"
pause

goto main

:dp
cls
echo dpcl: Datapath Set Default
echo dpdf: Datapath Set Default
echo dpst: Datapath Set Data Path
set /p choice="choice: "
call :%choice%
goto rmst

:dpcl
cls
set "dp=no"
set "datapath="

cls
echo datapath set: "%dp%"
echo datapath: "%datapath%"
pause

goto main

:dpdf
cls
set "dp=yes"
set "datapath=%folder%\data\skype\"

cls
echo datapath set: "%dp%"
echo datapath: "%datapath%"
pause

goto main

:dpst
cls
echo enter the datapath below
set /p datapath="datapath: "

cls
echo datapath set: "%dp%"
echo datapath: "%datapath%"
pause

goto main

:us
cls
echo uscl: Clear Username
echo usst: Set Username
set /p choice="choice: "
call :%choice%
goto us

:uscl
cls
set "us=no"
set "login="

cls
echo username set: "%us%"
echo login: "%login%"
pause

goto main

:usst
cls
echo enter your username below
set /p login="login: "
set "us=yes"

cls
echo username set: "%us%"
echo login: "%login%"
pause

goto main

:ps
cls
echo pscl: Clear Password
echo psst: Set Password
set /p choice="choice: "
call :%choice%
goto ps

:pscl
cls
set "ps=no"
set "password="

cls
echo password set: "%ps%"
echo password: "%password%"
pause

goto main

:psst
cls
echo enter your password below
set /p password="password: "
set "ps=yes"

cls
echo password set: "%ps%"
echo password: "%password%"
pause

goto main

:ns
cls
echo nscl: Set No Splash
echo nsst: Set Splash
set /p choice="choice: "
call :%choice%
goto ns

:nscl
cls
set "ns=no"

cls
echo no splash set: "%ns%"
pause

goto main

:nsst
cls
set "ns=yes"

cls
echo no splash set: "%ns%"
pause

goto main

:mn
cls
echo mncl: Set Not Start Minimized
echo mnst: Set Start Minimized
set /p choice="choice: "
call :%choice%
goto ns

:mncl
cls
set "mn=no"

cls
echo start minimized set: "%mn%"
pause

goto main

:mnst
cls
set "mn=yes"

cls
echo start minimized set: "%mn%"
pause

goto main

:sc
cls
echo sccl: Set Not Start Secondary
echo scst: Set Start Secondary
set /p choice="choice: "
call :%choice%
goto sc

:sccl
cls
set "sc=no"

cls
echo start secondary set: "%sc%"
pause

goto main

:scst
cls
set "sc=yes"

cls
echo start secondary set: "%sc%"
pause

goto main

:cl
cls
echo clcl: Clear CallTo
echo clst: Set CallTo
set /p choice="choice: "
call :%choice%
goto us

:clcl
cls
set "cl=no"
set "contact="

cls
echo callto set: "%cl%"
echo contact: "%contact%"
pause

goto main

:clst
cls
echo enter your username below
set /p contact="contact: "
set "cl=yes"

cls
echo callto set: "%cl%"
echo contact: "%contact%"
pause

goto main

:dl
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
cscript.exe .\bin\downloadwget.vbs
move wget.exe .\bin\wget.exe

.\bin\wget.exe http://downloads.sourceforge.net/portableapps/7-ZipPortable_16.04.paf.exe
move 7-ZipPortable_16.04.paf.exe .\extra\7-ZipPortable_16.04.paf.exe
.\extra\7-ZipPortable_16.04.paf.exe /destination="%folder%\bin\"

.\bin\wget.exe https://web.archive.org/web/20171001183831/http://download.skype.com/msi/SkypeSetup_7.39.0.102.msi
move SkypeSetup_7.39.0.102.msi .\extra\SkypeSetup_7.39.0.102.msi

goto SKIP

:: this code could be useful for extracting with different folder names (specificly with cemu) i left it in cause why not

.\bin\wget.exe https://github.com/upx/upx/releases/download/v3.94/upx394w.zip
move upx394w.zip .\extra\upx394w.zip

echo. > .\bin\extractupx.vbs
echo 'The location of the zip file. >> .\bin\extractupx.vbs
echo ZipFile="%folder%\extra\upx394w.zip" >> .\bin\extractupx.vbs
echo 'The folder the contents should be extracted to. >> .\bin\extractupx.vbs
:: change to %folder%\bin\ on regular builds (ones that dont have a folder inside the zip)
echo ExtractTo="%folder%\bin\upx\" >> .\bin\extractupx.vbs
echo. >> .\bin\extractupx.vbs
echo 'If the extraction location does not exist create it. >> .\bin\extractupx.vbs
echo Set fso = CreateObject("Scripting.FileSystemObject") >> .\bin\extractupx.vbs
echo If NOT fso.FolderExists(ExtractTo) Then >> .\bin\extractupx.vbs
echo    fso.CreateFolder(ExtractTo) >> .\bin\extractupx.vbs
echo End If >> .\bin\extractupx.vbs
echo. >> .\bin\extractupx.vbs
echo 'Extract the contants of the zip file. >> .\bin\extractupx.vbs
echo set objShell = CreateObject("Shell.Application") >> .\bin\extractupx.vbs
echo set FilesInZip=objShell.NameSpace(ZipFile).items >> .\bin\extractupx.vbs
echo objShell.NameSpace(ExtractTo).CopyHere(FilesInZip) >> .\bin\extractupx.vbs
echo Set fso = Nothing >> .\bin\extractupx.vbs
echo Set objShell = Nothing >> .\bin\extractupx.vbs
echo. >> .\bin\extractupx.vbs
cscript.exe .\bin\extractupx.vbs

cd bin
if exist upx cd upx
if exist upx* cd upx*
if not exist ..\wget.exe xcopy *.* ..\ /e /i /y
if not exist ..\wget.exe cd ..
if exist temp.txt del temp.txt >nul
for /D %%A IN ("upx*") DO echo "%%A">temp.txt
if exist temp.txt set /p dir=<temp.txt
if exist temp.txt rmdir /s /q %dir%
if exist temp.txt del temp.txt >nul
if exist ..\wget.exe cd ..
if exist ..\launch_skype_poc.bat cd ..

:SKIP

:: is not required to be set. will be set in release
.\bin\7-ZipPortable\App\7-Zip%arch%\7z.exe x .\extra\SkypeSetup_7.39.0.102.msi Product.CAB -o.\temp\

expand -r .\temp\Product.CAB -F:* .\bin\skype\

if exist .\temp\ rmdir /s /q .\temp\

rename .\bin\skype\Skype4COM.dll.65B9650E_D4EA_458D_AE52_454823D78F93 Skype4COM.dll
rename .\bin\skype\SkypeThirdPartyAttributions third-party_attributions.txt

rename .\bin\skype\api_ms_win_core_console_l1_1_0.dll api-ms-win-core-console-l1-1-0.dll
rename .\bin\skype\api_ms_win_core_datetime_l1_1_0.dll api-ms-win-core-datetime-l1-1-0.dll
rename .\bin\skype\api_ms_win_core_debug_l1_1_0.dll api-ms-win-core-debug-l1-1-0.dll

if exist .\bin\skype\api_ms_win_core_errorhandling_l1_1_0.dll del .\bin\skype\api_ms_win_core_errorhandling_l1_1_0.dll >nul
if exist .\bin\skype\SkypeDesktopIni del .\bin\skype\SkypeDesktopIni >nul
if exist .\bin\skype\Updater.exe del .\bin\skype\Updater.exe >nul
if exist .\bin\skype\Updater.dll del .\bin\skype\Updater.dll >nul
if exist .\bin\skype\SkypeBrowserHost.exe.8BC8B74C_C7CF_4DDC_9B88_774D97DA1209 del .\bin\skype\SkypeBrowserHost.exe.8BC8B74C_C7CF_4DDC_9B88_774D97DA1209 >nul

Setlocal enabledelayedexpansion

Set "source=_"
Set "target=-"

For %%# in (".\bin\skype\*.dll") Do (
    Set "File=%%~nx#"
    Ren "%%#" "!File:%source%=%target%!"
)
EndLocal

goto main
