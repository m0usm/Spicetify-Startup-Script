@echo off
setlocal enabledelayedexpansion

:: ====================================================================
:: 1. Initial User Confirmation (Y/N)
:: ====================================================================
ECHO ====================================================================
ECHO Spicetify Autostart Setup: Creating files and setting up autostart.
ECHO ====================================================================
CHOICE /C YN /M "Do you want to start the installation?"
IF ERRORLEVEL 2 GOTO end

:install
ECHO.
ECHO --- Starting Spicetify Autostart Setup ---

:: --------------------------------------------------------------------
:: 2. Setup Directory
:: --------------------------------------------------------------------
ECHO Creating C:\Scripts directory...
MD C:\Scripts 2>NUL

:: --------------------------------------------------------------------
:: 3. Create spicetify_install.ps1 (The Core Command)
::    This script executes the official Spicetify install/update command.
:: --------------------------------------------------------------------
ECHO Creating Core PowerShell script (spicetify_install.ps1)...
(
    ECHO iwr -useb https://raw.githubusercontent.com/spicetify/cli/main/install.ps1 ^| iex
) > C:\Scripts\spicetify_install.ps1

:: --------------------------------------------------------------------
:: 4. Create spicetify_start.bat (The Silent Wrapper)
::    This Batch script runs the PowerShell file invisibly every time.
:: --------------------------------------------------------------------
ECHO Creating Silent Wrapper script (spicetify_start.bat)...
(
    ECHO @echo off
    ECHO start /min powershell.exe -NoProfile -ExecutionPolicy Bypass -File "C:\Scripts\spicetify_install.ps1"
) > C:\Scripts\spicetify_start.bat

:: --------------------------------------------------------------------
:: 5. Create Autostart Shortcut (.lnk)
::    Using VBScript is the most reliable way to create a shortcut in Batch.
:: --------------------------------------------------------------------
ECHO Creating Startup shortcut...
(
    ECHO Set oWS = WScript.CreateObject("WScript.Shell")
    ECHO sLinkFile = "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\Spicetify Autostart.lnk"
    ECHO Set oLink = oWS.CreateShortcut(sLinkFile)
    ECHO oLink.TargetPath = "C:\Scripts\spicetify_start.bat"
    ECHO oLink.Save
) > "C:\Scripts\CreateShortcut.vbs"

CSCRIPT //Nologo "C:\Scripts\CreateShortcut.vbs"
DEL "C:\Scripts\CreateShortcut.vbs"

:: --------------------------------------------------------------------
:: 6. Initial Execution
::    This runs the core install process immediately for the first time.
::    This is where the user must type 'Y' for the PowerShell provider.
:: --------------------------------------------------------------------
ECHO.
ECHO --- Running initial Spicetify installation (Check for 'Y' prompt!) ---
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "C:\Scripts\spicetify_install.ps1"
ECHO Initial installation complete.

:: --------------------------------------------------------------------
:: 7. Finish
:: --------------------------------------------------------------------
ECHO.
ECHO Setup complete! The routine will start automatically upon next login.
PAUSE
EXIT /B 0

:: ====================================================================
:: END Labels
:: ====================================================================
:end
ECHO.
ECHO Installation cancelled by user.
PAUSE
EXIT /B 1

