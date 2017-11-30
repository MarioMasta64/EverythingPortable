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

:mn
echo "d" download
echo "i" install
echo "l" launch
echo "why" why doesnt it sync passwords and extensions?!?!?!?!
set /p goto="choice: "
goto %goto%

:why
cls
echo see: https://www.ghacks.net/2017/07/06/how-to-sync-vivaldi-user-data/
echo for the most part this is due to vivaldi using google chromes core,
echo all you can do is hope for a sync option
echo (extension data stays i.e. reinstalling lastpass will load the old lastpass login)
pause
goto mn

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
.\bin\wget.exe http://downloads.sourceforge.net/portableapps/7-ZipPortable_16.04.paf.exe
move 7-ZipPortable_16.04.paf.exe .\extra\7-ZipPortable_16.04.paf.exe
.\extra\7-ZipPortable_16.04.paf.exe /destination="%folder%\bin\"

:u
if exist .\bin\vivaldi\ (
    taskkill /f /im update_notifier.exe
    rmdir /s /q .\bin\vivaldi\
)
.\bin\wget.exe https://downloads.vivaldi.com/stable/Vivaldi.1.13.1008.32.exe
move Vivaldi.1.13.1008.32.exe .\extra\Vivaldi.1.13.1008.32.exe
if not exist .\temp\ mkdir .\temp\
.\bin\7-ZipPortable\App\7-Zip%arch%\7z.exe x .\extra\Vivaldi.1.13.1008.32.exe * -o.\temp\
.\bin\7-ZipPortable\App\7-Zip%arch%\7z.exe x .\temp\vivaldi.7z * -o.\temp\
:c
xcopy .\temp\Vivaldi-bin\*.* .\bin\vivaldi\ /e /i /y
:: insert check
pause
rmdir /s /q .\temp\
pause

:I
:: of all things. it was tmp -> %userprofile%\AppData\Local\temp\
:: of all things. it was tmp -> %localappdata%\temp\
:: of all things. it was tmp -> %tmp%
:: %temp% is usually C:\Windows\Temp\
:: %tmp% is usually C:\Users\<username>\AppData\Local\temp\
:: like wow

:L
set "AppData=%folder%\data\AppData\Roaming\"
set "LocalAppData=%folder%\data\AppData\Local\"
set "UserProfile=%folder%\data\"
start .\bin\vivaldi\vivaldi.exe "--user-data-dir=%folder%\data\vivaldi" https://github.com/MarioMasta64/EverythingPortable/releases/latest/
exit

http://www.intowindows.com/vivaldi-browser-portable-version/
https://forum.vivaldi.net/topic/1363/portable-version/30?page=2
https://help.vivaldi.com/article/standalone-version-of-vivaldi/
https://www.oxhow.com/generate-portable-version-of-vivaldi-browser/
https://www.ghacks.net/2017/07/06/how-to-sync-vivaldi-user-data/
http://portableappz.blogspot.co.uk/