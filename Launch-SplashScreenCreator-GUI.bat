@echo off
REM Launch Splash Screen Creator GUI
REM Author: Gianpaolo Albanese
REM Date: 2025-12-23

echo.
echo ========================================
echo   Professional Splash Screen Creator
echo ========================================
echo.
echo Starting GUI interface...
echo.

REM Change to script directory
cd /d "%~dp0"

REM Launch the GUI
powershell.exe -ExecutionPolicy Bypass -File "SplashScreenCreatorGUI.ps1"

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo Error: Failed to launch Splash Screen Creator GUI
    echo Please ensure PowerShell is available and execution policy allows scripts
    echo.
    pause
)