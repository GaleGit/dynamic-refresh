@echo off
:: Ensure Administrative Privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrative privileges...
    powershell -Command "Start-Process '%~0' -Verb RunAs"
    exit /b
)

echo Removing scheduled task...
schtasks /delete /tn "dynamic-refresh" /F >nul 2>&1

echo Removing desktop shortcut...
del /f /q "%USERPROFILE%\Desktop\Toggle Refresh Rate.lnk" >nul 2>&1

echo.
echo Scheduled task and shortcut removed successfully!
echo.

:: Prompt user before deleting files
choice /C YN /M "Do you also want to delete the installation folder (C:\Program Files\QRes)?"
if errorlevel 2 goto KeepFiles
if errorlevel 1 goto DeleteFiles

:DeleteFiles
echo Removing installation files...
timeout /t 1 >nul
rmdir /s /q "C:\Program Files\QRes" >nul 2>&1
echo Folder deleted.
goto Done

:KeepFiles
echo.
echo Preserved installation files in C:\Program Files\QRes.

:Done
echo.
echo =========================================================
echo  Dynamic Refresh Rate Switcher Uninstalled Successfully!
echo =========================================================
pause
