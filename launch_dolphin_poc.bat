@echo off
cls
Color 0A
title Dolphin 5.0 PoC - MarioMasta64

if not exist .\bin\ mkdir .\bin\
if not exist .\data\dolphin\ mkdir .\data\dolphin\
if not exist .\dll\64\ mkdir .\dll\64\
:: if not exist .\doc\ mkdir .\doc\
if not exist .\extra\ mkdir .\extra\
echo "l" to launch dolphin
echo "d" to download dolphin (first time)
echo "e" to extract dolphin
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
.\bin\wget.exe "https://dl-mirror.dolphin-emu.org/5.0/dolphin-x64-5.0.exe"
move dolphin-x64-5.0.exe .\extra\dolphin-x64-5.0.exe
:: is not required to be set. will be set in release
:e
.\bin\7-ZipPortable\App\7-Zip%arch%\7z.exe x .\extra\dolphin-x64-5.0.exe * -o.\bin\dolphin\
rmdir /s /q .\bin\dolphin\$PLUGINSDIR\
rmdir /s /q .\bin\dolphin\$TEMP\
del .\bin\dolphin\uninst.exe.nsis
.\bin\wget.exe https://raw.githubusercontent.com/MarioMasta64/DLLDownloaderPortable/master/dll64.txt
set Counter=0
for /f "DELIMS=" %%i in ('type dll64.txt') do (
	if not exist %%i .\bin\wget.exe https://raw.githubusercontent.com/MarioMasta64/DLLDownloaderPortable/master/dll/64/%%i
    if exist %%i move %%i .\dll\64\%%i
)
if exist dll64.txt del dll64.txt
:l
set "path=%path%;%CD%\dll\64\;"
dont pirate mmkay > .\bin\dolphin\portable.txt
start .\bin\dolphin\dolphin.exe -u "%CD%\data\dolphin\"
exit