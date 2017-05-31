@echo off
color 0A
if not exist .\bin\ mkdir .\bin\
if not exist .\extra\ mkdir .\extra\
if not exist .\data\ mkdir .\data\
if not exist .\data\appdata\local\ mkdir .\data\appdata\local\
if not exist .\data\.vscode\ mkdir .\data\.vscode\

echo "l" to launch vscode
echo "d" to download vscode
set /p goto="choice: "
goto %goto%

:D
echo WARNING DO NOT RUN ME IN A DIRECTORY THAT HAS AN index.html* File
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
.\bin\wget "https://go.microsoft.com/fwlink/?LinkID=623231"
rename "index.html@LinkID=623231" "vscode.zip"
move vscode.zip .\extra\vscode.zip
set folder=%CD%
if %CD%==%~d0\ set folder=%CD:~0,2%
cls
echo. > .\bin\extractvscode.vbs
echo 'The location of the zip file. >> .\bin\extractvscode.vbs
echo ZipFile="%folder%\extra\vscode.zip" >> .\bin\extractvscode.vbs
echo 'The folder the contents should be extracted to. >> .\bin\extractvscode.vbs
echo ExtractTo="%folder%\bin\" >> .\bin\extractvscode.vbs
echo. >> .\bin\extractvscode.vbs
echo 'If the extraction location does not exist create it. >> .\bin\extractvscode.vbs
echo Set fso = CreateObject("Scripting.FileSystemObject") >> .\bin\extractvscode.vbs
echo If NOT fso.FolderExists(ExtractTo) Then >> .\bin\extractvscode.vbs
echo fso.CreateFolder(ExtractTo) >> .\bin\extractvscode.vbs
echo End If >> .\bin\extractvscode.vbs
echo. >> .\bin\extractvscode.vbs
echo 'Extract the contants of the zip file. >> .\bin\extractvscode.vbs
echo set objShell = CreateObject("Shell.Application") >> .\bin\extractvscode.vbs
echo set FilesInZip=objShell.NameSpace(ZipFile).items >> .\bin\extractvscode.vbs
echo objShell.NameSpace(ExtractTo).CopyHere(FilesInZip) >> .\bin\extractvscode.vbs
echo Set fso = Nothing >> .\bin\extractvscode.vbs
echo Set objShell = Nothing >> .\bin\extractvscode.vbs
echo. >> .\bin\extractvscode.vbs
title PORTABLE VSCODE LAUNCHER - EXTRACT ZIP
cscript.exe .\bin\extractvscode.vbs
set userprofile=%CD%\data\userprofile
:L
title DO NOT CLOSE VSCODE IS RUNNING
xcopy .\data\.vscode\* "%userprofile%\.vscode\" /e /i /y
rmdir /s /q .\data\.vscode\
set appdata=%CD%\data\appdata\local\
cls
echo DO NOT CLOSE VSCODE IS RUNNING
.\bin\Code.exe
xcopy "%userprofile%\.vscode\*" .\data\.vscode\ /e /i /y
rmdir /s /q "%userprofile%\.vscode\"
exit