Write-Host "This script is used to install available updates `nThe PSWindowsUpdate module queries standard update streams. 
Certain categories of patches—such as Feature Upgrades (e.g., upgrading from one version of Windows to another), 
proprietary driver packages, or optional quality rollouts—are strictly blocked from background installation APIs 
and can only be handled interactively via the Settings GUI. " -ForegroundColor DarkCyan


function func1 {
    # Check if the module is installed anywhere on the system
    if (Get-Module -Name PSWindowsUpdate -ListAvailable) {
        Write-Host "PSWindowsUpdate is already installed. Loading it now..." -ForegroundColor Cyan
        Import-Module PSWindowsUpdate
        Write-Host "Successfully loaded PSWindowsUpdate!" -ForegroundColor Green
    }
    else {
        Write-Host "PSWindowsUpdate not found. Installing..." -ForegroundColor Yellow
        try {
            Install-Module -Name PSWindowsUpdate -Force -Scope CurrentUser -AllowClobber
            Import-Module PSWindowsUpdate
            Write-Host "Successfully installed and loaded PSWindowsUpdate!" -ForegroundColor Green
        }
        catch {
            Write-Error "Failed to install the module: $_"
        }
    }
}
func1

# Stop Windows Update background services
Stop-Service -Name "wuauserv" -Force
Stop-Service -Name "cryptSvc" -Force
Stop-Service -Name "bits" -Force

# Delete the corrupted local update cache
Remove-Item -Path "C:\Windows\SoftwareDistribution" -Recurse -Force

# Restart the services to rebuild a clean cache database
Start-Service -Name "bits"
Start-Service -Name "cryptSvc"
Start-Service -Name "wuauserv"

Write-Host "Update cache successfully cleared! Please restart your computer." -ForegroundColor Green


Function func2 {
    try {
        # Keep looping as long as $true is met; we break out manually when done
        while ($true) {
            Write-Host "Checking for Windows updates..." -ForegroundColor Cyan
            $updates = Get-WindowsUpdate -MicrosoftUpdate -AcceptAll -IgnoreReboot
            
            # If no updates are found, exit the while loop entirely
            if (-not $updates) {
                Write-Host "No updates are currently available. System is up to date!" -ForegroundColor Green
                break
            }
            
            # Show the user what updates were found
            Write-Host "The following updates are available:" -ForegroundColor Green
            $updates | Format-Table -Property Title, Size -AutoSize
            
            # Ask the user if they want to proceed
            $confirmation = Read-Host "Do you want to proceed with installing these updates? (Y/N)"
            
            if ($confirmation -match '^[yY](es)?$') {
                Write-Host "Installing updates..." -ForegroundColor Green
                Get-WindowsUpdate -MicrosoftUpdate -AcceptAll -ForceDownload -ForceInstall -IgnoreReboot
                Write-Host "Installation cycle complete. Re-scanning for remaining updates...`n" -ForegroundColor Yellow
            }
            else {
                Write-Host "Installation cancelled by the user. Exiting script." -ForegroundColor Red
                break
            }
        }
    }
    catch {
        Write-Error "Failed to process updates: $_"
    }
}

func2

