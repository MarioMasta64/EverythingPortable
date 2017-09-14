@echo off
cls
Color 0A

if not exist .\bin\winscp\ mkdir .\bin\winscp\
if not exist .\data\AppData\Roaming\ mkdir .\data\AppData\Roaming\
if not exist .\extra\ mkdir .\extra\

set "folder=%CD%"
if "%CD%"=="%~d0\" set "folder=%CD:~0,2%"

:mn
echo "l" to launch winscp
echo "d" to download winscp
echo "u" to update winscp
echo "wl" to launch winscppwd
echo "wu" to update winscppwd
echo "pl" to launch putty
echo "pu" to update putty
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

:u
cls
if exist download.php del download.php
.\bin\wget.exe -q --show-progress https://winscp.net/eng/download.php#download2
for /f tokens^=2delims^=^" %%A in (
  'findstr /i /c:"https://winscp.net/download/" /c:"https://winscp.net/download/" download.php'
) Do > winscp_link.txt Echo:%%A
set /p winscp_txt=<winscp_link.txt
set winscp_link=%winscp_txt:~0,44%-Portable.zip

echo %winscp_txt%
echo %winscp_link%
echo %winscp_zip%

echo %winscp_link:~-15,2%

if %winscp_link:~-15,2% == Re (
  echo Re Detected Fixing
  set winscp_link=%winscp_link:~0,-16%%winscp_link:~-13%
)

set winscp_zip=%winscp_link:~28%
echo %winscp_txt%
echo %winscp_link%
echo %winscp_zip%
pause
if exist winscp_link.txt del winscp_link.txt
if exist download.php* del download.php*

.\bin\wget.exe %winscp_link%
move %winscp_zip% .\extra\%winscp_zip%

echo. > .\bin\extractwinscp.vbs
echo 'The location of the zip file. >> .\bin\extractwinscp.vbs
echo ZipFile="%folder%\extra\%winscp_zip%" >> .\bin\extractwinscp.vbs
echo 'The folder the contents should be extracted to. >> .\bin\extractwinscp.vbs
echo ExtractTo="%folder%\bin\WinSCP\" >> .\bin\extractwinscp.vbs
echo. >> .\bin\extractwinscp.vbs
echo 'If the extraction location does not exist create it. >> .\bin\extractwinscp.vbs
echo Set fso = CreateObject("Scripting.FileSystemObject") >> .\bin\extractwinscp.vbs
echo If NOT fso.FolderExists(ExtractTo) Then >> .\bin\extractwinscp.vbs
echo    fso.CreateFolder(ExtractTo) >> .\bin\extractwinscp.vbs
echo End If >> .\bin\extractwinscp.vbs
echo. >> .\bin\extractwinscp.vbs
echo 'Extract the contants of the zip file. >> .\bin\extractwinscp.vbs
echo set objShell = CreateObject("Shell.Application") >> .\bin\extractwinscp.vbs
echo set FilesInZip=objShell.NameSpace(ZipFile).items >> .\bin\extractwinscp.vbs
echo objShell.NameSpace(ExtractTo).CopyHere(FilesInZip) >> .\bin\extractwinscp.vbs
echo Set fso = Nothing >> .\bin\extractwinscp.vbs
echo Set objShell = Nothing >> .\bin\extractwinscp.vbs
echo. >> .\bin\extractwinscp.vbs
cscript.exe .\bin\extractwinscp.vbs
goto mn

:l
cls
set "AppData=%folder%\data\AppData\Roaming"
cd .\bin\WinSCP\
start WinSCP.exe
cd ..\..\
goto mn

:wu
cls
.\bin\wget.exe https://bitbucket.org/knarf/winscppwd/downloads/winscppwd.exe
move winscppwd.exe .\bin\WinSCP\winscppwd.exe
goto mn

:wl
cls
cd .\bin\WinSCP\
winscppwd winscp.ini > password.txt
start notepad.exe password.txt
cd ..\..\
goto mn

:pu
.\bin\wget.exe https://winscp.net/download/putty.exe
move putty.exe .\bin\WinSCP\putty.exe
.\bin\wget.exe https://winscp.net/download/puttygen.exe
move puttygen.exe .\bin\WinSCP\puttygen.exe
.\bin\wget.exe https://winscp.net/download/pageant.exe
move pageant.exe .\bin\WinSCP\pageant.exe
goto mn

:pl
cls
set "AppData=%folder%\data\AppData\Roaming"
cd .\bin\WinSCP\
start Putty.exe
cd ..\..\
goto mn
