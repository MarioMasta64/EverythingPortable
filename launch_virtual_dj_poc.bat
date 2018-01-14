@echo off
cls
Color 0A
title Virtual DJ 8 - PoC - By MarioMasta64

if not exist .\bin\winscp\ mkdir .\bin\winscp\
if not exist .\data\AppData\Roaming\ mkdir .\data\AppData\Roaming\
if not exist .\extra\ mkdir .\extra\

set "folder=%CD%"
if "%CD%"=="%~d0\" set "folder=%CD:~0,2%"

:mn
echo "l" to launch virtual dj
echo "d" to download virtual dj
echo "u" to update virtual dj
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
.\bin\wget.exe -q --show-progress http://downloads.sourceforge.net/portableapps/7-ZipPortable_16.04.paf.exe
move 7-ZipPortable_16.04.paf.exe .\extra\7-ZipPortable_16.04.paf.exe
.\extra\7-ZipPortable_16.04.paf.exe /destination="%CD%\bin\"

:u
cls
echo you will need to save the .msi as "%folder%\extra\virtualdj.msi"
pause
echo once you are done press enter
start https://www.virtualdj.com/download/
pause
.\bin\7-ZipPortable\App\7-Zip%arch%\7z.exe x .\extra\virtualdj.msi * -o.\bin\virtual_dj\
pause

goto mn

:l
cls
set "UserProfile=%folder%\data"
set "AppData=%folder%\data\AppData\Roaming"
set "LocalAppData=%folder%\data\AppData\Local"
start .\bin\virtual_dj\virtualdj8.exe
goto mn