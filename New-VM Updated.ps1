$vmname = "S2D-N4"
$ISOFIle = 'C:\ISO FILES\winsvr2016.ISO'
New-VM -Name $vmname `
-MemoryStartupBytes 4GB `
-Generation 2 `
-NewVHDPath "C:\Users\Public\Documents\Hyper-V\Virtual Hard Disks\s2d-n4.VHDX" `
-NewVHDSizeBytes 50GB `
-SwitchName "InternalSwitch01"

#Customization

Set-VMMemory -VMName $vmname -DynamicMemoryEnabled $true -MinimumBytes 512MB -MaximumBytes 4GB
Set-VMProcessor -VMName $vmname -Count 2
Set-VM -Name $vmname -EnhancedSessionTransporType HvSocket

#OS Installation 

Add-VMDvdDrive -VMName $vmname -Path $ISOFIle
Set-VMFirmware -VMName $vmname -FirstBootDevice (Get-VMDvdDrive -VMName $vmname)

# start VM

Start-VM $vmname
vmconnect.exe localhost $vmname