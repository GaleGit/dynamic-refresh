@echo off
:: Ensure Administrative Privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrative privileges...
    powershell -Command "Start-Process '%~0' -Verb RunAs"
    exit /b
)

:: Copy files to Program Files
mkdir "C:\Program Files\QRes" 2>nul
xcopy "%~dp0*" "C:\Program Files\QRes\" /Y /E /I

:: Import Task Scheduler XML directly into Windows
schtasks /create /tn "dynamic-refresh" /xml "C:\Program Files\QRes\taskschd.xml" /F

:: Create Desktop Shortcut
powershell -Command "$s=(New-Object -ComObject WScript.Shell).CreateShortcut('\%USERPROFILE\%\Desktop\Toggle Refresh Rate.lnk');$s.TargetPath='wscript.exe'; $s.Arguments='\"C:\Program Files\QRes\qres.vbs\"'; $s.WorkingDirectory='C:\Program Files\QRes'; $s.IconLocation='C:\Program Files\QRes\QRes.exe,0';$s.Save()"

echo.
echo =========================================================
echo  Dynamic Refresh Rate Switcher Installed Successfully!
echo =========================================================
pause
