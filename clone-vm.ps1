$sourceVMName = "SourceVM"
$newVMName = "ClonedVM"
$exportPath = "C:\HyperV_Exports"
$vmDestination = "C:\HyperV_VMs\$newVMName"

# 1. Export the source VM
# This creates a folder containing the VHDX, configuration, and snapshots
Export-VM -Name $sourceVMName -Path $exportPath

# 2. Find the exported configuration file (.vmcx)
$exportFolder = Join-Path $exportPath $sourceVMName
$configFile = Get-ChildItem -Path "$exportFolder\Virtual Machines" -Filter *.vmcx | Select-Object -First 1

# 3. Import as a clone (Generating a new Unique ID)
# Use -Copy to create a new instance and -GenerateNewId to prevent SID/ID conflicts
Import-VM -Path $configFile.FullName -Copy -GenerateNewId -VirtualMachinePath $vmDestination -VhdDestinationPath "$vmDestination\Virtual Hard Disks"

# 4. Rename the imported VM (it defaults to the original name)
Rename-VM -Name $sourceVMName -NewName $newVMName

# 5. Cleanup export files
Remove-Item -Path $exportFolder -Recurse -Force
