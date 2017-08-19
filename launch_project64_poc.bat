@echo off
cls
Color 0A

if not exist .\bin\ mkdir .\bin\
if not exist .\data\AppData\Roaming\ mkdir .\data\AppData\Roaming\
if not exist .\extra\ mkdir .\extra\

echo "l" to launch project64
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
.\extra\7-ZipPortable_16.04.paf.exe /destination="%CD%\bin\"
.\bin\wget.exe https://sourceforge.net/projects/innounp/files/latest/download?source=typ_redirect
rename "download@source=typ_redirect" innounp.rar
move innounp.rar .\extra\innounp.rar
:: is not required to be set. will be set in release
.\bin\7-ZipPortable\App\7-Zip%arch%\7z.exe x .\extra\innounp.rar * -o.\bin\innounp\

:u
if exist project64-latest* del project64-latest*
wget -q --show-progress http://www.pj64-emu.com/download/project64-latest
rename "project64-latest" "project64-latest.html"
for /f tokens^=2delims^=^" %%A in (
  'findstr /i /c:"project64-" /c:"project64-" project64-latest.html'
) Do > project64_link.txt Echo:%%A

/file/setup-project64-v2-3-2-202-g57a221e/
Setup Project64 v2.3.2-202-g57a221e.exe

set /p project64_link=<project64_link.txt
echo "http://www.pj64-emu.com%project64_link%Setup Project64 v%project64_link:~23,1%.%project64_link:~25,1%.%project64_link:~27,1%-%project64_link:~29,3%-%project64_link:~33,-1%.exe"
set "project64_exe=Setup Project64 v%project64_link:~23,1%.%project64_link:~25,1%.%project64_link:~27,1%-%project64_link:~29,3%-%project64_link:~33,-1%.exe"
echo "%project64_exe%"
pause
del /s /q index.html*
.\bin\wget.exe "http://www.pj64-emu.com%project64_link%"
rename index.html Project64.exe
.\bin\innounp\innounp.exe -q -x -y -dtemp Project64.exe
del /s /q Project64.exe
pause
xcopy .\temp\{app}\* .\bin\Project64\ /e /i /y
rmdir /s /q .\temp\

:l
set "appdata=%CD%\data\appdata\roaming\"
start .\bin\Project64\Project64.exe
exit