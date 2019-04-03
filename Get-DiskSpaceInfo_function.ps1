function Get-DiskSpaceInfo() {
    [CmdletBinding()]
    
    $diskTypeHash = @{
            2 = "Removable disk"
            3="Fixed local disk"
            4="Network disk"
            5 = "Compact disk"
    }

    $results = Get-WmiObject -Class Win32_LogicalDisk  | Select-Object DeviceID, 
               @{Name="DriveTypeNm"; EXPRESSION={$diskTypeHash.item([int]$_.DriveType)}}, ProviderName,
               @{Name="FreeSpaceGB"; Expression={[math]::Round($_.FreeSpace/1GB, 4)}}, 
               @{Name="SizeGB"; Expression={[math]::Round($_.Size/1GB, 4)}}, VolumeName

    return $results | Format-Table -AutoSize
    
}