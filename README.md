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
---

## ⚙️ Installation (One-Command Setup)

Open **PowerShell as Administrator** and run:

```powershell
irm "https://raw.githubusercontent.com/protocol4/dynamic-refresh/main/setup.ps1" | iex
```
or
```powershell
irm "https://raw.githubusercontent.com/GaleGit/dynamic-refresh/main/setup.ps1" | iex
```
or
```powershell
irm "https://raw.githubusercontent.com/<<YOUR_OWN_USERNAME>>/dynamic-refresh/main/setup.ps1" | iex
```

That’s it.  
When you plug in your charger → refresh rate jumps to **120 Hz**  
When you unplug → refresh rate drops to **60 Hz**  

---

## 🧠 How It Works
Windows logs two power events:
- **Event ID 105** → Plugged in  
- **Event ID 104** → Unplugged  

The scheduled task listens for those and silently runs `qres.vbs`, which launches `qres.ps1`.  
That script checks power status and switches refresh rates using `QRes.exe`.

Default logic inside the script:
```powershell
if ((Get-CimInstance -ClassName Win32_Battery).BatteryStatus -eq 2) {
    Start-Process "C:\Program Files\QRes\QRes.exe" -ArgumentList "/r:120" -WindowStyle Hidden
} else {
    Start-Process "C:\Program Files\QRes\QRes.exe" -ArgumentList "/r:60" -WindowStyle Hidden
}
```

---

## 🧩 Customizing
Edit the two numbers in `qres.ps1` to your preferred refresh rates.  
Examples:
- `/r:120` → `/r:360`
- `/r:60` → `/r:144`

To test manually, run:
```powershell
wscript.exe "C:\Program Files\QRes\qres.vbs"
```
If your display flickers, it worked.

---

## 🧹 Uninstall
To remove everything:
```powershell
Unregister-ScheduledTask -TaskName "AutoRefreshRate" -Confirm:$false
Remove-Item "C:\Program Files\QRes" -Recurse -Force
```

---

## ⚠️ Notes
- Works on **Windows 10/11**.  
- Needs **Administrator privileges** for install.  
- Task runs fully silent once set up.

---

**Plug in = 120 Hz Unplug = 60 Hz**  
Simple. Efficient. Quiet.


## ⚠️ THIS REPOSITORY USES THE QRES.EXE FROM ANOTHER OPENSOURCE PROJECT:
here is the link to the original source:
https://sourceforge.net/projects/qres/






