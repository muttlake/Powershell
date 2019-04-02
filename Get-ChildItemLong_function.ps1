function Get-ChildItemLong {
    [CmdletBinding()]

    param (
        
        [string] $pathString
        
    )

    try {
        $files = Get-ChildItem -Filter $pathString | Select-Object Mode, CreationTime, Directory, Extension, LastWriteTime, Length, Name  
        $out = $files | Sort-Object lastWriteTime  | Format-Table
        return $out
    } 
    catch {
        Write-Host "Please use the command like this: Get-ChildItemLong <pattern>"
    }
}