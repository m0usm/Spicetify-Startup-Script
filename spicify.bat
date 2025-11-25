@echo off
setlocal

:: ----------------------------------------------------
:: 1. DEFINITIONEN
:: ----------------------------------------------------
:: Der feste Pfad, wo das Skript gespeichert wird (muss existieren)
set SCRIPT_DIR=C:\Scripts
:: Name des PowerShell-Skripts mit dem eigentlichen Befehl
set PS_SCRIPT_NAME=spicetify_install.ps1
:: Name des Batch-Wrapper-Skripts, das im Autostart landet
set WRAPPER_SCRIPT_NAME=spicetify_start.bat
:: Der Speicherort für den aktuellen Benutzer-Autostart-Ordner
set STARTUP_FOLDER="%%APPDATA%%\Microsoft\Windows\Start Menu\Programs\Startup"

:: ----------------------------------------------------
:: 2. ERSTELLEN DES SKRIPT-ORDNERS
:: ----------------------------------------------------
echo Erstelle Skript-Ordner: %SCRIPT_DIR%
if not exist "%SCRIPT_DIR%" mkdir "%SCRIPT_DIR%"

:: ----------------------------------------------------
:: 3. ERSTELLEN DER POWERSHELL-INSTALLATIONSDATEI
:: ----------------------------------------------------
echo Schreibe PowerShell-Befehl nach %SCRIPT_DIR%\%PS_SCRIPT_NAME%
(
    echo iwr -useb https://raw.githubusercontent.com/spicetify/cli/main/install.ps1 ^| iex
) > "%SCRIPT_DIR%\%PS_SCRIPT_NAME%"

:: ----------------------------------------------------
:: 4. ERSTELLEN DER WRAPPER-BATCH-DATEI (fuer Autostart)
:: ----------------------------------------------------
echo Schreibe Wrapper-Batch-Skript nach %SCRIPT_DIR%\%WRAPPER_SCRIPT_NAME%
(
    echo @echo off
    echo start /min powershell.exe -ExecutionPolicy Bypass -File "%SCRIPT_DIR%\%PS_SCRIPT_NAME%"
) > "%SCRIPT_DIR%\%WRAPPER_SCRIPT_NAME%"

:: ----------------------------------------------------
:: 5. ERSTELLEN DER VERKNUEPFUNG IM AUTOSTART-ORDNER
:: ----------------------------------------------------
echo Erstelle Verknuepfung im Autostart-Ordner: %STARTUP_FOLDER%
:: Das Ziel ist das Wrapper-Skript
set TARGET_PATH="%SCRIPT_DIR%\%WRAPPER_SCRIPT_NAME%"
:: Der Name der Verknuepfung
set LINK_NAME="Spicetify Autostart.lnk"

:: Nutze PowerShell, um die Verknuepfung zu erstellen, da Batch das nicht nativ kann
powershell.exe -ExecutionPolicy Bypass -Command "$WshShell = New-Object -comObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut(%STARTUP_FOLDER%\%LINK_NAME%); $Shortcut.TargetPath = %TARGET_PATH%; $Shortcut.Save()"

:: ----------------------------------------------------
:: 6. ABSCHLUSS
:: ----------------------------------------------------
echo.
echo Die Spicetify Autostart-Routine wurde erfolgreich eingerichtet.
echo Sie wird beim naechsten Login ausgefuehrt.
echo.
pause