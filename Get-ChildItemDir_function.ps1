function Get-ChildItemDir {
    [CmdletBinding()]

    param (
        
        [string] $pathString
        
    )
    Begin {
        $TotalSum = 0
    }
    Process {
        try {
            $dirs =  Get-ChildItem -Filter $pathString  -Attributes Directory | Select-Object Mode, CreationTime, Directory, Extension, LastWriteTime, Length, Name
            $files =  Get-ChildItem -Filter $pathString -Attributes !Directory | Select-Object Mode, CreationTime, Directory, Extension, LastWriteTime, Length, Name
            $TotalSum += (Get-ChildItem -Filter $pathString -Attributes !Directory | Measure-Object -Sum Length).Sum

            if($dirs.Count -gt 0)
            {
                For($i = 0; $i -lt $dirs.Count; $i++) {
                    $test = Get-ChildItem
                    $testForEmpty = $test.Count
                    if($testForEmpty -gt 0) {
                        $CurrentSum = (Get-ChildItem $dirs[$i].Name  -Recurse -Attributes !Directory | Measure-Object -Sum Length).Sum
                        $dirs[$i].Length = $CurrentSum
                        $TotalSum += $CurrentSum
                    } 
                    else {
                        $dirs[$i].Length = 0;
                    }
                }
            

                return $dirs + $files | Select-Object Mode, CreationTime, Directory, Extension, LastWriteTime, 
                                              Length, @{Name="LengthGB"; Expression={[math]::Round($_.Length / 1GB, 4)}}, 
                                              Name | Sort-Object -Property LastWriteTime| Format-Table -AutoSize
            }
            else {
                 return $files | Select-Object Mode, CreationTime, Directory, Extension, LastWriteTime, 
                                    Length, @{Name="LengthGB"; Expression={[math]::Round($_.Length / 1GB, 4)}}, 
                                    Name | Sort-Object -Property LastWriteTime| Format-Table -AutoSize
            }

        } 
        catch {
            Write-Host "Please use the command like this: Get-ChildItemDir <pattern>"
        }
    }

    End {
        $TotalSum = [math]::Round($TotalSum / 1GB, 4)
        Write-Host "The Total Size for this directory is $TotalSum GB"
    }
}