#parameters
param([string] $dir="c:\")

#functions
function Get-DirInfo($dir)
{
    $results = Get-ChildItem $dir -Recurse | Measure-Object -Property Length -Sum
    return [math]::Round(($results).Sum/1GB, 2)
}

#main processing
Get-DirInfo $dir