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

echo Removing installation files...
timeout /t 1 >nul
rmdir /s /q "C:\Program Files\QRes" >nul 2>&1

echo.
echo =========================================================
echo  Dynamic Refresh Rate Switcher Uninstalled Successfully!
echo =========================================================
pause
