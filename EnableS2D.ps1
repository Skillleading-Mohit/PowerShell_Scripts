# Implement Storage Spaces Direct by using Windows PowerShell
#
#
# Before everything provision virtual machines with names defined in the script.
# configure network settings to ensure all VMs are connected each other
# and add all VMs into a "server manager colsole" on another 4th server "managing server".
#
#
#
#
#Step 1. Install the windows server roles and features
#
Invoke-Command -ComputerName S2D-NODE-1,S2D-NODE-2,S2D-NODE-3 -ScriptBlock {Install-WindowsFeature -Name File-services}
Invoke-Command -ComputerName S2D-NODE-1,S2D-NODE-2,S2D-NODE-3 -ScriptBlock {Restart-Computer -Force}
Install-WindowsFeature RSAT-Clustering-MGMT
#
# Step 2. Validate Cluster
#
Test-Cluster -Node SEA-SVR1,SEA-SVR2,SEA-SVR3 -Include "Storage Spaces Direct",Inventory,Network,"System Configuration"
#this command is not complete please search online and complete it
#
# Step 3. Create Cluster
#
New-Cluster -Name S2DCluster -Node SEA-SVR1,SEA-SVR2,SEA-SVR3 -NoStorage -StaticAddress 172.16.0.40
#
# After enabled cluster goback to server manager colsole, > Failover Cluster Manager, now connect to the 
# cluster you just created "S2DCluster"
#
# Step 4. Enable Storage Spaces Direct.
Invoke-Command -ComputerName SEA-SVR1 -ScriptBlock {Enable-ClusterS2d -CacheState Disabled -AutoConfig:0 -SkipEligibilityChecks -Confirm:$false}
#
#
#
# Step 5. Create storage pools
Invoke-Command -ComputerName SEA-SVR1 -ScriptBlock {New-StoragePool -StorageSubSystemName S2dCluster.yourdomain.com -FriendlyName S2Dstoragepool -ProvisioningTypeDefault Fixed -ResiliencySettingNameDefault Mirror -PhysicalDisk (Get-StorageSubSystem -Name S2DCluster.yourdomain.com | Get-PhysicalDisk)}
#
# you can go back to Failover cluster manager and check under storage option that storage pool is created.
#
#
# Step 6. Create Virtal Disks
#
Invoke-Command -ComputerName SEA-SVR1 -ScriptBlock {New-Volume -StoragePoolFriendlyName S2DStoragePool -FriendlyName "CSV" -FileSystem CSVFS_ReFS -Size 5GB}
#
#now you can goback to Failover cluster manager and check sotrage> disks that a CSV disk is created.
#
# Step 7. Create File Server
#
Invoke-Command -ComputerName SEA-SVR1 -ScriptBlock {New-StorageFileServer -StorageSubSystemName S2DCluster.yourdomain.com -FriendlyName S2D-SOFS -Protocols SMB}

#
# Step 8. Create File Shares
#Administrator: Windows PowerShell ISE
Invoke-Command -ComputerName SEA-SVR1 -ScriptBlock {md "C:\ClusterStorage\CSV\VM01"}
Invoke-Command -ComputerName SEA-SVR1 -ScriptBlock {New-SmbShare -Name VM01 -Path "C:\ClusterStorage\CSV\VM01" -FullAccess}
Invoke-Command -ComputerName SEA-SVR1 -ScriptBlock {Set-SmbPathAcl -ShareName VM01}
#
# your can goback to Failover cluster manager and check under roles "you will see Scale-Out File Server" Under this below you see an option for shares
# you will see here the smb share your just created.
# 
#
#Now try to access this smbshare \\S2D-SoFS\VM01
#Now to check the smb share works if any out of 3 cluster node is turned off run powershell cmdlet stop-Computer -computername SEA-SVR3
#now go back to smbshare and create another subfolder here, it should allow you to create
#and if you check disk status under failover cluster manager it's status will shows as "Warning"
#Congratulations you have created a SOFS (Scale-out File Server using S2D "Storage Space Direct")
#
# 
# Video link
# http://learn.microsoft.com/en-us/training/modules/implement-storage-spaces-storage-spaces-direct/6-implement-storage-spaces-direct