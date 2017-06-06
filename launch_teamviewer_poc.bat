@echo off
cls
Color 0A

if not exist .\bin\teamviewer\ mkdir .\bin\teamviewer\
if not exist .\data\AppData\Roaming\ mkdir .\data\AppData\Roaming\
if not exist .\extra\ mkdir .\extra\

echo "l" to launch teamviewer host
echo "d" to download teamviewer host
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
.\bin\wget.exe https://download.teamviewer.com/download/TeamViewerPortable.zip
move TeamViewerPortable.zip .\extra\TeamViewerPortable.zip
cls
title PORTABLE CEMU LAUNCHER - EXTRACT TEAMVIEWER
set folder=%CD%
if %CD%==%~d0\ set folder=%CD:~0,2%
cls
echo. > .\bin\extractteamviewer.vbs
echo 'The location of the zip file. >> .\bin\extractteamviewer.vbs
echo ZipFile="%folder%\extra\TeamViewerPortable.zip" >> .\bin\extractteamviewer.vbs
echo 'The folder the contents should be extracted to. >> .\bin\extractteamviewer.vbs
:: change to %folder%\bin\ on regular builds (ones that dont have a folder inside the zip)
echo ExtractTo="%folder%\bin\teamviewer\" >> .\bin\extractteamviewer.vbs
echo. >> .\bin\extractteamviewer.vbs
echo 'If the extraction location does not exist create it. >> .\bin\extractteamviewer.vbs
echo Set fso = CreateObject("Scripting.FileSystemObject") >> .\bin\extractteamviewer.vbs
echo If NOT fso.FolderExists(ExtractTo) Then >> .\bin\extractteamviewer.vbs
echo    fso.CreateFolder(ExtractTo) >> .\bin\extractteamviewer.vbs
echo End If >> .\bin\extractteamviewer.vbs
echo. >> .\bin\extractteamviewer.vbs
echo 'Extract the contants of the zip file. >> .\bin\extractteamviewer.vbs
echo set objShell = CreateObject("Shell.Application") >> .\bin\extractteamviewer.vbs
echo set FilesInZip=objShell.NameSpace(ZipFile).items >> .\bin\extractteamviewer.vbs
echo objShell.NameSpace(ExtractTo).CopyHere(FilesInZip) >> .\bin\extractteamviewer.vbs
echo Set fso = Nothing >> .\bin\extractteamviewer.vbs
echo Set objShell = Nothing >> .\bin\extractteamviewer.vbs
echo. >> .\bin\extractteamviewer.vbs
title PORTABLE CEMU LAUNCHER - EXTRACT ZIP
cscript.exe .\bin\extractteamviewer.vbs

:l
cls
echo on exit it will ask to make changes to the hard drive select no.
set "AppData=%CD%\data\AppData\Roaming"
start .\bin\teamviewer\TeamViewer.exe
exit