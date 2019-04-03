#Custom Cmdlets
. C:\Users\shepb\Documents\WindowsPowerShell\Get-ChildItemLong_function.ps1
. C:\Users\shepb\Documents\WindowsPowerShell\Get-ChildItemDir_function.ps1
. C:\Users\shepb\Documents\WindowsPowerShell\Get-DiskSpaceInfo_function.ps1

# Set Aliases
Set-Alias -Name gcl -Value Get-ChildItemLong
Set-Alias -Name gcd -Value Get-ChildItemDir
Set-Alias -Name diskinfo -Value Get-DiskSpaceInfo