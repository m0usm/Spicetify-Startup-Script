echo off
setlocal

:: ----------------------------------------------------
:: 1. DEFINITIONS
:: ----------------------------------------------------
:: The permanent path where the script will be stored
set SCRIPT_DIR=C:\Scripts
:: Name of the PowerShell script containing the core command
set PS_SCRIPT_NAME=spicetify_install.ps1
:: Name of the Batch wrapper script that lands in Startup
set WRAPPER_SCRIPT_NAME=spicetify_start.bat
:: The path to the current user's Startup folder
set STARTUP_FOLDER="%%APPDATA%%\Microsoft\Windows\Start Menu\Programs\Startup"

:: ----------------------------------------------------
:: 2. CREATE SCRIPT DIRECTORY
:: ----------------------------------------------------
echo Creating script directory: %SCRIPT_DIR%
if not exist "%SCRIPT_DIR%" mkdir "%SCRIPT_DIR%"

:: ----------------------------------------------------
:: 3. CREATE POWERSHELL INSTALL FILE
:: ----------------------------------------------------
echo Writing PowerShell command to %SCRIPT_DIR%\%PS_SCRIPT_NAME%
(
    echo iwr -useb https://raw.githubusercontent.com/spicetify/cli/main/install.ps1 ^| iex
) > "%SCRIPT_DIR%\%PS_SCRIPT_NAME%"

:: ----------------------------------------------------
:: 4. CREATE WRAPPER BATCH FILE (for Autostart)
:: ----------------------------------------------------
echo Writing wrapper batch script to %SCRIPT_DIR%\%WRAPPER_SCRIPT_NAME%
(
    echo @echo off
    echo start /min powershell.exe -ExecutionPolicy Bypass -File "%SCRIPT_DIR%\%PS_SCRIPT_NAME%"
) > "%SCRIPT_DIR%\%WRAPPER_SCRIPT_NAME%"

:: ----------------------------------------------------
:: 5. CREATE SHORTCUT IN THE STARTUP FOLDER
:: ----------------------------------------------------
echo Creating shortcut in the Startup folder: %STARTUP_FOLDER%
:: The target is the wrapper script
set TARGET_PATH="%SCRIPT_DIR%\%WRAPPER_SCRIPT_NAME%"
:: The name of the shortcut
set LINK_NAME="Spicetify Autostart.lnk"

:: Use PowerShell to create the shortcut, as Batch cannot do this natively
powershell.exe -ExecutionPolicy Bypass -Command "$WshShell = New-Object -comObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut(%STARTUP_FOLDER%\%LINK_NAME%); $Shortcut.TargetPath = %TARGET_PATH%; $Shortcut.Save()"

:: ----------------------------------------------------
:: 6. COMPLETION
:: ----------------------------------------------------
echo.
echo The Spicetify autostart routine has been successfully set up.
echo It will execute on the next user login.
echo.
pause
