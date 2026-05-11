$vm = "S2D-N3"
New-VM -Name $vm `
-MemoryStartupBytes 2GB `
-Generation 2 `
#Must change the name of the virtual hardisk in next 
-NewVHD "C:\Users\Public\Documents\Hyper-V\Virtual Hard Disks\s2d-n3.VHDX" `
-NewVHDSizeBytes 40GB `
-SwitchName "InternalSwitch01" `

Add-VMDvdDrive -VMName $vm -Path 'C:\ISO FILES\winsvr2016.ISO'

Set-VMMemory -VMName $vm -DynamicMemoryEnabled $true -MinimumBytes 512MB -MaximumBytes 4GB
Set-VMProcessor -VMName $vm -Count 2


vmconnect localhost $vm


#Other Important Cmdlets
Install-WindowsFeature RSAT-AD-Tools
 