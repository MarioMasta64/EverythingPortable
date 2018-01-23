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
echo "tu" to update text-reader
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
if exist history del history>nul:
if exist winscp_release.txt del winscp_release.txt>nul:
if exist winscp_beta.txt del winscp_beta.txt>nul:
.\bin\wget.exe -q --show-progress https://winscp.net/eng/docs/history
echo.> winscp_link.txt
for /f tokens^=2delims^=^> %%A in (
  'findstr /i /c:"h2 id=" /c:"h2 id=" history'
) Do >> winscp_link.txt Echo:%%A
if exist history del history>nul:

setlocal enabledelayedexpansion
set /a release=0
set /a beta=0
set /a rc=0
set /a hotfix=0
for /F "tokens=*" %%A in (winscp_link.txt) do (
  set "A=%%A"
  set "A=!A:~0,-4!"
  if "!A:~-18!" EQU "(not released yet)" (
    echo "!A:~0,-19! is not released"
  )
  if "!A:~-8!" EQU "(hotfix)" (
    echo "!A:~0,-9! is a hotfix"
  )
  if "!A:~-4!" EQU "beta" (
    echo "https://winscp.net/download/WinSCP-!A:~0,-5!.beta-Portable.zip"
    if !beta! EQU 0 (
      set /a beta+=1
      echo !A:~0,-5!>winscp_beta.txt
    )
  )
  if "!A:~-2!" EQU "RC" (
    echo "!A:~0,-3! is a release-candidate build"
  )

  if "!A:~-18!" NEQ "(not released yet)" (
    if "!A:~-8!" NEQ "(hotfix)" (
      if "!A:~-4!" NEQ "beta" (
        if "!A:~-2!" NEQ "RC" (
          echo "https://winscp.net/download/WinSCP-!A!-Portable.zip"
          if !release! EQU 0 (
            if exist winscp_beta.txt (
              set /a release+=1
              echo !A!>winscp_release.txt
            )
          )
        )
      )
    )
  )

)
endlocal

if exist winscp_link.txt del winscp_link.txt>nul:

echo.
set /p winscp_release=<winscp_release.txt
set /p winscp_beta=<winscp_beta.txt

if exist winscp_release.txt del winscp_release.txt>nul:
if exist winscp_beta.txt del winscp_beta.txt>nul:

set release_zip_link=https://winscp.net/download/WinSCP-%winscp_release%-Portable.zip
set beta_zip_link=https://winscp.net/download/WinSCP-%winscp_beta%.beta-Portable.zip

set release_txt_link=https://winscp.net/download/WinSCP-%winscp_release%-ReadMe.txt
set beta_txt_link=https://winscp.net/download/WinSCP-%winscp_beta%.beta-ReadMe.txt

set release_zip_file=WinSCP-%winscp_release%-Portable.zip
set beta_zip_file=WinSCP-%winscp_beta%.beta-Portable.zip

set release_txt_file=WinSCP-%winscp_release%-ReadMe.txt
set beta_txt_file=WinSCP-%winscp_beta%.beta-ReadMe.txt

echo release zip link: %release_zip_link%
echo beta zip link: %beta_zip_link%
:: echo rc zip link: [wip]
:: echo hotfix zip link: [wip]
echo release zip file: %release_zip_file%
echo beta zip file: %beta_zip_file%
:: echo rc zip file: [wip]
:: echo hotfix zip file: [wip]
echo release txt link: %release_txt_link%
echo beta txt link: %beta_txt_link%
:: echo rc txt link: [wip]
:: echo hotfix txt link: [wip]
echo release txt file: %release_txt_file%
echo beta txt file: %beta_txt_file%
:: echo rc txt file: [wip]
:: echo hotfix txt file: [wip]

:: text files are broke for now
:: if not exist ".\doc\%release_txt_file%" .\bin\wget.exe "%release_txt_link%" & move "%release_txt_file%" ".\doc\%release_txt_file%"
:: if exist batch-read.bat pause & call batch-read ".\doc\%release_txt_file%" 10 1
:: if not exist batch-read.bat pause
pause

.\bin\wget.exe -q --show-progress "%release_zip_link%"
move "%release_zip_file%" ".\extra\%release_zip_file%"

echo. > .\bin\extractwinscp.vbs
echo 'The location of the zip file. >> .\bin\extractwinscp.vbs
echo ZipFile="%folder%\extra\%release_zip_file%" >> .\bin\extractwinscp.vbs
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

:tu
.\bin\wget.exe https://old-school-gamer.tk/batch/text-reader/update-text-reader.bat
start update-text-reader.bat
goto mn