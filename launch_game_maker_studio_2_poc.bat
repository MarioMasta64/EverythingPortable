@echo off
cls
Color 0A

set "folder=%CD%"
if "%CD%"=="%~d0\" set "folder=%CD:~0,2%"
set path="%PATH%;%CD%\dll\64\;" 
set "AppData=%CD%\data\AppData\Roaming\"
set "LocalAppData=%CD%\data\AppData\Local\"

if not exist .\bin\ mkdir .\bin\
if not exist .\data\AppData\Roaming\ mkdir .\data\AppData\Roaming\
if not exist .\extra\ mkdir .\extra\

echo "l" to launch game
echo "d" to download project64 (first time)
echo "u" to download/upgrade project64
set /p goto="choice: "
goto %goto%

:d
cls
echo ' Set your settings > .\bin\downloadwget.vbs
echo strFileURL = "https://eternallybored.org/misc/wget/current/wget.exe" >> .\bin\downloadwget.vbs
echo strHDLocation = "wget.exe" >> .\bin\downloadwget.vbs
echo. >> .\bin\downloadwget.vbs
echo ' Fetch the file >> .\bin\downloadwget.vbs
echo Set objXMLHTTP = CreateObject("MSXML2.XMLHTTP") >> .\bin\downloadwget.vbs
echo. >> .\bin\downloadwget.vbs
echo objXMLHTTP.open "GET", strFileURL, false >> .\bin\downloadwget.vbs
echo objXMLHTTP.send() >> .\bin\downloadwget.vbs
echo. >> .\bin\downloadwget.vbs
echo If objXMLHTTP.Status = 200 Then >> .\bin\downloadwget.vbs
echo Set objADOStream = CreateObject("ADODB.Stream") >> .\bin\downloadwget.vbs
echo objADOStream.Open >> .\bin\downloadwget.vbs
echo objADOStream.Type = 1 'adTypeBinary >> .\bin\downloadwget.vbs
echo. >> .\bin\downloadwget.vbs
echo objADOStream.Write objXMLHTTP.ResponseBody >> .\bin\downloadwget.vbs
echo objADOStream.Position = 0'Set the stream position to the start >> .\bin\downloadwget.vbs
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
.\bin\wget.exe https://sourceforge.net/projects/innounp/files/latest/download?
:: is not required to be set. will be set in release
.\bin\7-ZipPortable\App\7-Zip%arch%\7z.exe x .\extra\innounp.rar * -o.\bin\innounp\
.\bin\wget.exe https://raw.githubusercontent.com/MarioMasta64/DLLDownloaderPortable/master/dll64.txt
set Counter=0
for /f "DELIMS=" %%i in ('type dll64.txt') do (
	if not exist %%i .\bin\wget.exe https://raw.githubusercontent.com/MarioMasta64/DLLDownloaderPortable/master/dll/64/%%i
    if exist %%i move %%i .\dll\64\%%i
)
if exist dll64.txt del dll64.txt

:u
echo please download game maker studio 2 and save it as "%CD%\extra\gms2.exe"
echo press enter to continue
pause >nul:
if exist .\bin\opera\launcher.exe (
	start .\bin\opera\launcher.exe https://account.yoyogames.com/downloads
)
if not exist .\bin\opera\launcher.exe (
	start https://account.yoyogames.com/downloads
)
pause
if not exist .\extra\gms2.exe goto u
.\bin\7-ZipPortable\App\7-Zip%arch%\7z.exe x .\extra\gms2.exe * -o.\bin\game_maker_studio_2\
rmdir .\bin\game_maker_studio_2\$PLUGINSDIR\
rmdir .\bin\game_maker_studio_2\$TEMP\

:l
start .\bin\game_maker_studio_2\GameMakerStudio.exe
exit