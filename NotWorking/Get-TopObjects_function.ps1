function Get-TopObjects {
    [CmdletBinding()]
    Param (
        [parameter(Mandatory=$true)][ValidateRange(0, [int]::MaxValue)]
        [Int] $topnumber
    )
    Begin {
        Write-Output "Getting top $topnumber items.."
    }

    Process {
        $out = $input | Select-Object -First $topnumber 
    }

    End {
        Write-Output $out
    }
}