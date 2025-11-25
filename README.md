Absolut! Hier ist die englische Version der vollständigen README.md-Vorlage.

📄 README.md (English Template)
Markdown

# Spicetify CLI Auto-Install for Windows

**An automated Batch script for Windows designed to recurrently install and update the Spicetify CLI every time a user logs into their system.**

This script is ideal for ensuring that your Spicetify installation is automatically corrected or brought up to date after any Spotify or major system update.

## 🚀 How It Works

The script automates the following steps to execute the official installation command (`iwr ... | iex`) **silently** on every system startup:

1.  **Script Folder Creation:** It creates a persistent directory at `C:\Scripts`.
2.  **PowerShell Script Creation:** The file `spicetify_install.ps1` containing the official install command is saved to `C:\Scripts`.
3.  **Wrapper Script Creation:** The file `spicetify_start.bat` is created to execute PowerShell **invisibly** (`start /min`).
4.  **Startup Shortcut:** A shortcut (`.lnk`) pointing to `spicetify_start.bat` is placed in the current user's Startup folder (`%APPDATA%...\Startup`).

## 🛠️ Usage

### Prerequisites

* Administrator rights for the initial setup.
* An active internet connection during the login process.

### Setup Instructions

1.  **Download:** Download the `setup_autostart.bat` file from this repository.
2.  **Run:** Right-click the `setup_autostart.bat` file and select **"Run as administrator"**.
3.  **Finished:** The routine is set up. The script will now execute automatically upon every subsequent user login.

---

## ⚠️ Important Notes

### Security

This script executes a command that downloads code from an external server and runs it immediately (`iwr -useb ... | iex`). Ensure you trust the source (Spicetify CLI) before running the automated script, and consider reviewing the contents of the official installation script periodically.

### Uninstallation

To stop the automatic execution, simply delete the created shortcut:

1.  Press `Win` + `R` and type `shell:startup` and press Enter.
2.  Delete the shortcut named **`Spicetify Autostart.lnk`**.
3.  Optionally, you can also delete the `C:\Scripts` folder to remove the script files.

---

## 📜 License

This project is licensed under the **[MIT License](LICENSE)**.
