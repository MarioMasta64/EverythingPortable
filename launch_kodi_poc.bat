@echo off
cls
Color 0A

if not exist .\bin\ mkdir .\bin\
if not exist .\dll\32\ mkdir .\dll\32\
if not exist .\data\AppData\Roaming\ mkdir .\data\AppData\Roaming\
if not exist .\extra\ mkdir .\extra\

echo "l" to launch kodi
echo "d" to download wget and 7zip
echo "e" to download and extract kodi
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
.\extra\7-ZipPortable_16.04.paf.exe /destination="%CD%\bin\"
:e
.\bin\wget.exe http://mirrors.kodi.tv/releases/win32/kodi-17.3-Krypton.exe
move kodi-17.3-Krypton.exe .\extra\kodi-17.3-Krypton.exe
:: is not required to be set. will be set in release
.\bin\7-ZipPortable\App\7-Zip%arch%\7z.exe x .\extra\kodi-17.3-Krypton.exe * -o.\bin\kodi\
rmdir /s /q .\bin\kodi\$PLUGINSDIR\
rmdir /s /q .\bin\kodi\$TEMP\
del .\bin\kodi\AppxManifest.xml
del .\bin\kodi\Uninstall.exe
.\bin\wget.exe https://raw.githubusercontent.com/MarioMasta64/DLLDownloaderPortable/master/dll32.txt
set Counter=0
for /f "DELIMS=" %%i in ('type dll32.txt') do (
	if not exist %%i .\bin\wget.exe https://raw.githubusercontent.com/MarioMasta64/DLLDownloaderPortable/master/dll/32/%%i
    if exist %%i move %%i .\dll\32\%%i
)
if exist dll32.txt del dll32.txt
:l
set "path=%path%;%CD%\dll\32\;"
set "appdata=%CD%\data\AppData\Roaming\"
start .\bin\kodi\kodi.exe -p
exit