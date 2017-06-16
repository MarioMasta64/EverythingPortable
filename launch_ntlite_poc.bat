@echo off
cls
Color 0A

if not exist .\bin\ mkdir .\bin\
if not exist .\data\AppData\Roaming\ mkdir .\data\AppData\Roaming\
if not exist .\extra\ mkdir .\extra\

echo "l" to launch ntlite
echo "d" to download ntlite (first time)
echo "e" to extract ntlite
echo "u" to update ntlite
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
:u
.\bin\wget.exe https://sourceforge.net/projects/innounp/files/latest/download?source=typ_redirect
rename "download@source=typ_redirect" innounp.rar
move innounp.rar .\extra\innounp.rar
:: is not required to be set. will be set in release
.\bin\7-ZipPortable\App\7-Zip%arch%\7z.exe x .\extra\innounp.rar * -o.\bin\innounp\
.\bin\wget.exe http://downloads.ntlite.com/files/NTLite_setup_x64.exe
.\bin\wget.exe http://downloads.ntlite.com/files/NTLite_setup_x86.exe
move NTLite_setup_x64.exe .\extra\NTLite_setup_x64.exe
move NTLite_setup_x86.exe .\extra\NTLite_setup_x86.exe
:e
.\bin\innounp\innounp.exe -q -x -y -dtemp\64 .\extra\NTLite_setup_x64.exe
.\bin\innounp\innounp.exe -q -x -y -dtemp\86 .\extra\NTLite_setup_x86.exe
xcopy .\temp\64\{app}\* .\bin\ntlite\x64\ /e /i /y
xcopy .\temp\86\{app}\* .\bin\ntlite\x86\ /e /i /y
rmdir /s /q .\temp\
:l
echo you require admin btw & pause
set "appdata=%CD%\data\appdata\roaming\"
start .\bin\ntlite\x64\ntlite.exe
exit