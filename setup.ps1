# Requires -RunAsAdministrator
# ============================================================
# Dynamic Refresh - Setup Script
# (GaleGit Fork - Desktop Shortcut Included)
# ============================================================

try {
    # 1. Create install folder
    $ProgramFilesPath = ${env:ProgramFiles}
    $installPath = "$ProgramFilesPath\QRes"
    Write-Host "Creating folder at $installPath..."
    New-Item -ItemType Directory -Path $installPath -Force | Out-Null
    Start-Sleep -Seconds 1

    # 2. Download repo zip
    $tempZip = "$env:TEMP\dynamic-refresh.zip"
    $repoUrl = "https://github.com/GaleGit/dynamic-refresh/archive/refs/heads/main.zip"
    Write-Host "Downloading repository from $repoUrl ..."
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -Uri $repoUrl -OutFile $tempZip -UseBasicParsing -ErrorAction Stop
    if (!(Test-Path $tempZip)) {
        throw "Download failed — check internet connection or repo URL."
    }
    Start-Sleep -Seconds 1

    # 3. Extract repo
    $tempExtract = "$env:TEMP\dynamic-refresh"
    Write-Host "Extracting archive to $tempExtract ..."
    if (Test-Path $tempExtract) { Remove-Item $tempExtract -Recurse -Force -ErrorAction SilentlyContinue }
    Expand-Archive -Path $tempZip -DestinationPath $tempExtract -Force
    Start-Sleep -Seconds 1

    # 4. Move files to install folder
    $repoMain = Join-Path $tempExtract "dynamic-refresh-main"
    if (-not (Test-Path $repoMain)) {
        throw "Expected folder $repoMain not found. Extraction may have failed."
    }
    Write-Host "Copying files to $installPath ..."
    Copy-Item -Path "$repoMain\*" -Destination $installPath -Recurse -Force
    Start-Sleep -Seconds 1

    # 5. Import Task Scheduler XML
    $taskName = "dynamic-refresh"
    $taskXml = Join-Path $installPath "taskschd.xml"
    if (-not (Test-Path $taskXml)) {
        throw "Task XML not found at $taskXml. Aborting."
    }
    Write-Host "Registering scheduled task '$taskName' ..."
    Start-Sleep -Seconds 1

    if (Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue) {
        Write-Host "Existing task found. Removing old task ..."
        Unregister-ScheduledTask -TaskName $taskName -Confirm:$false -ErrorAction SilentlyContinue
    }

    $xmlText = Get-Content -Path $taskXml -Raw
    $TaskUser = "$env:UserDomain\$env:UserName"
    $xmlText = $xmlText -replace '\{\{ProgramFilesPath\}\}', $ProgramFilesPath
    Register-ScheduledTask -Xml $xmlText -TaskName $taskName -User $TaskUser -Force
    Start-Sleep -Seconds 1

    # 6. Create Shortcut in C:\Program Files\QRes and on Desktop
    Write-Host "Creating desktop shortcut..."
    $WshShell = New-Object -ComObject WScript.Shell;
    
    $FolderShortcut = Join-Path $installPath "Toggle Refresh Rate.lnk";
    $Shortcut = $WshShell.CreateShortcut($FolderShortcut);
    $Shortcut.TargetPath = "wscript.exe";
    $Shortcut.Arguments = "`"$installPath\qres.vbs`"";
    $Shortcut.WorkingDirectory = $installPath;
    $Shortcut.IconLocation = "$installPath\QRes.exe,0";
    $Shortcut.Save();

    $DesktopPath = [Environment]::GetFolderPath('Desktop');
    if (Test-Path $DesktopPath) {
        Copy-Item -Path $FolderShortcut -Destination "$DesktopPath\Toggle Refresh Rate.lnk" -Force;
    }

    # 7. Clean up temporary download files
    Write-Host "Cleaning up temporary download files..."
    Remove-Item $tempZip -Force -ErrorAction SilentlyContinue
    Remove-Item $tempExtract -Recurse -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 1

    Write-Host "------------------------------------------------------------------"
    Write-Host ""
    Write-Host "Setup complete!"
    Write-Host "Files installed at: $installPath"
    Write-Host "Scheduled task: '$taskName'"
    Write-Host "Desktop shortcut created: 'Toggle Refresh Rate'"
    Write-Host "Completed at: $(Get-Date -Format 'HH:mm:ss')"
}
catch {
    Write-Host ""
    Write-Host "Installation failed:"
    Write-Host $_.Exception.Message
    exit 1
}
