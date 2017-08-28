@echo off
cls
Color 0A
title INSTALLING OPERA
echo RUNNING INSTALLER DO NOT CLOSE

set "folder=%CD%"
if "%CD%"=="%~d0\" set "folder=%CD:~0,2%"

if not exist .\bin\opera\ mkdir .\bin\opera\
if not exist .\extra\ mkdir .\extra\
if not exist .\data\AppData\Local\ mkdir .\data\AppData\Local\
if not exist .\data\AppData\Roaming\ mkdir .\data\AppData\Roaming\

echo "d" download
echo "i" install
echo "l" launch
set /p goto="choice: "
goto %goto%

:D
echo ANY FILES THAT START WITH "windows" WILL BE RENAMED
pause
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
.\bin\wget.exe http://net.geo.opera.com/opera_portable/stable/windows?http_referrer=missing_via_opera_com&utm_source=(direct)_via_opera_com&utm_medium=doc&utm_campaign=(direct)_via_opera_com&dl_token=39379966
rename "windows*" "Opera_PortableSetup.exe"
move Opera_PortableSetup.exe .\extra\Opera_PortableSetup.exe

:I
:: of all things. it was tmp -> %userprofile%\AppData\Local\temp\
:: of all things. it was tmp -> %localappdata%\temp\
:: of all things. it was tmp -> %tmp%
:: %temp% is usually C:\Windows\Temp\
:: %tmp% is usually C:\Users\<username>\AppData\Local\temp\
:: like wow

set "TMP=%folder%\data\AppData\Local\temp\"
.\extra\Opera_PortableSetup.exe /silent /installfolder=%folder%\bin\opera\ /allusers=0 /copyonly=1 /singleprofile=1 /setdefaultbrowser=0 /desktopshortcut=0 /startmenushortcut=0 /quicklaunchshortcut=0 /pintotaskbar=0 /import-browser-data=0 /enable-stats=0 /enable-installer-stats=0 /launchbrowser=0
rmdir /s /q .\data\AppData\Local\temp\
del .\extra\debug.log

cls
if not exist .\bin\opera\*.exe echo INSTALLATION FAILED & pause & goto I
if exist .\bin\opera\*.exe echo INSTALLATION SUCCESS & pause & exit
pause

:L
set "AppData=%folder%\data\AppData\Roaming\"
set "LocalAppData=%folder%\data\AppData\Local\"
start .\bin\opera\launcher.exe https://github.com/MarioMasta64/EverythingPortable/releases/latest/
exit