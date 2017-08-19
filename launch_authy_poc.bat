@echo off
cls
Color 0A

if not exist .\bin\authy\ mkdir .\bin\authy\
if not exist .\data\AppData\Roaming\ mkdir .\data\AppData\Roaming\
if not exist .\extra\ mkdir .\extra\

echo "l" to launch authy
echo "d" to download authy
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

set /a cycle1=1
set /a cycle2=0
set /a cycle3=0

:loop
set /a cycle3+=1
if %cycle3%==99 set /a cycle3=0 & set /a cycle2+=1
if %cycle2%==9 set /a cycle2=0 & set /a cycle1+=1
if %cycle1%==9 set /a cycle1=0 & echo nothing found?
title checking v%cycle1%.%cycle2%.%cycle3%
.\bin\wget.exe -q --show-progress --tries=1 https://s3.amazonaws.com/authy-electron-repository-production/stable/%cycle1%.%cycle2%.%cycle3%/win32/x64/authy-installer.exe
if exist authy-installer.exe goto extract
goto loop

:extract
move 7-ZipPortable_16.04.paf.exe .\extra\7-ZipPortable_16.04.paf.exe
move authy-installer.exe .\extra\authy-installer.exe
.\extra\7-ZipPortable_16.04.paf.exe /destination="%CD%\bin\"
if not exist .\temp\ mkdir .\temp\
:: is not required to be set. will be set in release

.\bin\7-ZipPortable\App\7-Zip%arch%\7z.exe x .\extra\authy-installer.exe * -o.\temp\
del .\temp\background.gif
del .\temp\Update.exe

for %%d in (.\temp\authy*.nupkg) do set authy=%%d
.\bin\7-ZipPortable\App\7-Zip\7z.exe x %authy% * -o.\temp\
del %authy%
xcopy .\temp\lib\net45\* .\bin\authy\ /e /i /y
rmdir /s /q .\temp\

pause
:l
set "UserProfile=%CD%\data\"
start .\bin\authy\Authy%%20Desktop.exe
exit

https://s3.amazonaws.com/authy-electron-repository-production/stable/1.0.13/win32/x64/authy-installer.exe