<#
mohit | SkillLeading
This script can be used to find out the files by thair size 
#>
"Hello, with this script you can find out the files by thair size, Please entre folder path below where you want to find out files."
$folderPath = Read-Host "Entre folder path"
$size = Read-Host "Entre size"
$folder = Get-ChildItem -path $folderPath -Directory -Recurse
$files = Get-ChildItem -Path $folder.FullName -File -Recurse

# Filter files larger than 1MB and format output
$largeFiles = $files | Where-Object { $_.Length -gt $size } |
Select-Object @{Name="FullName";Expression={$_.FullName}},
                  @{Name="SizeMB";Expression={"{0:N2}" -f ($_.Length / 1MB)}}
              
# Display as table
$largeFiles | Format-Table -AutoSize

