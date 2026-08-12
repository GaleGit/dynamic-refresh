# ⚡ Auto Refresh Rate Switcher (Plug / Unplug)

Automatically switches your display refresh rate when you plug or unplug your laptop charger.  
No ugly PowerShell or CMD windows, no manual setup — just install once and forget about it.

---

## 📁 Included Files

Path: `C:\Program Files\QRes\`

| File | Description |
|------|--------------|
| **QRes.exe** | The tool that changes display refresh rate. |
| **qres.ps1** | Checks if your laptop is on AC or battery and triggers QRes. |
| **qres.vbs** | Runs the PowerShell script silently (no window). |
| **taskschd.xml** | Task Scheduler configuration file. |
| **install.bat** | Offline batch installer for USB backups. |
| **uninstall.bat** | Offline batch uninstaller. |
| **setup.ps1** | Complete PowerShell setup script. |

---

## ⚙️ Installation

### 🌐 One-Command Online Setup

Open **PowerShell as Administrator** and run:

```powershell
irm "https://raw.githubusercontent.com/GaleGit/dynamic-refresh/main/setup.ps1" | iex
```

*(Or use the original repository: `protocol4/dynamic-refresh`)*

---

### 💾 Offline Setup (USB Backup)

1. Copy the `C:\Program Files\QRes` folder to a USB drive or local backup.
2. On a new PC, right-click `install.bat` inside that folder and select **Run as administrator**.

---

## 🧠 How It Works

Windows logs two power events:
* **Event ID 105** → Plugged in  
* **Event ID 104** → Unplugged  

The scheduled task listens for those and silently runs `qres.vbs`, which launches `qres.ps1`.  
That script checks power status and switches refresh rates using `QRes.exe`.

Default logic inside `qres.ps1`:

```powershell
if ((Get-CimInstance -ClassName Win32_Battery).BatteryStatus -eq 2) {
    Start-Process "C:\Program Files\QRes\QRes.exe" -ArgumentList "/r:120" -WindowStyle Hidden
} else {
    Start-Process "C:\Program Files\QRes\QRes.exe" -ArgumentList "/r:60" -WindowStyle Hidden
}
```

---

## 🧩 Customizing

Edit the refresh rates in `qres.ps1` (`C:\Program Files\QRes\qres.ps1`) to your preferred target rates:
* `/r:120` → `/r:165` or `/r:240`
* `/r:60` → `/r:144`

To test manually, run:

```powershell
wscript.exe "C:\Program Files\QRes\qres.vbs"
```

If your display flickers momentarily, it worked.

---

## 🧹 Uninstall

### Option A: Via Batch File
Right-click `uninstall.bat` inside `C:\Program Files\QRes` and select **Run as administrator**.

### Option B: Via PowerShell Command
Open **PowerShell as Administrator** and run:

```powershell
Unregister-ScheduledTask -TaskName "dynamic-refresh" -Confirm:$false -ErrorAction SilentlyContinue; Remove-Item "C:\Program Files\QRes" -Recurse -Force
```

---

## ⚠️ Notes & Credits

* Works on **Windows 10 / 11**.  
* Requires **Administrator privileges** to install.  
* Runs completely silent in the background.

This repository uses **QRes.exe** from the open-source project hosted on [SourceForge](https://sourceforge.net/projects/qres/).
