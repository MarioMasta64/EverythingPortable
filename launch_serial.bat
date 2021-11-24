@echo off
cls
Color 0A

for /F "skip=1 tokens=5" %%a in ('vol %~D0') do echo %%a>serial.txt

setlocal enabledelayedexpansion
set /a count=1 
for /f "skip=1 delims=:" %%a in ('CertUtil -hashfile "serial.txt" sha1') do (
  if !count! equ 1 set "sha1=%%a"
  set/a count+=1
)
set "sha1=%sha1: =%
echo %sha1%

set program=%~n0
echo %program:~7%

echo https://mariomasta64.me/install/new_install.php?program=%program:~7%^&serial=%sha1%

pause

.\bin\wget -q --show-progress --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.115 Safari/537.36" https://mariomasta64.me/install/new_install.php?program=%program:~7%^&serial=%sha1%
pause

endlocal

if exist index.php* del index.php* >nul
if exist serial.txt del serial.txt >nul
