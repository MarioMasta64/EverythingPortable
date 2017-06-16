@echo off
cls
Color 0A

if not exist .\bin\discord\ mkdir .\bin\discord\
if not exist .\data\AppData\Roaming\ mkdir .\data\AppData\Roaming\
if not exist .\extra\ mkdir .\extra\

echo "l" to launch discord
echo "d" to download discord
:: echo "u" to update discord
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
.\bin\wget.exe "https://discordapp.com/api/download?platform=win" 
move 7-ZipPortable_16.04.paf.exe .\extra\7-ZipPortable_16.04.paf.exe
rename "download@platform=win" discord.exe
move discord.exe .\extra\discord.exe
.\extra\7-ZipPortable_16.04.paf.exe /destination="%CD%\bin\"
if not exist .\temp\ mkdir .\temp\
:: is not required to be set. will be set in release
.\bin\7-ZipPortable\App\7-Zip%arch%\7z.exe x .\extra\discord.exe * -o.\temp\
del .\temp\RELEASES
del .\temp\Update.exe
.\bin\7-ZipPortable\App\7-Zip%arch%\7z.exe x .\temp\%discord% * -o.\temp\
del .\temp\%discord%
xcopy .\temp\lib\net45\* .\bin\discord\ /e /i /y
rmdir /s /q .\temp\
del .\bin\discord\Squirrel.exe

:l
cls
set "AppData=%CD%\data\AppData\Roaming"
start .\bin\discord\Discord.exe
exit