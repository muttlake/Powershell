#params
param (

    [string] $source,
    [string] $destination

)

#functions
function CheckFolder([string] $folder, [switch] $create) {
    
    $currentPath = (Get-Location).Path
    $folderPath = $currentPath + "\" + $folder
    $exists = Test-Path $folderPath

    if ((-not $exists) -and $create.IsPresent) {
        New-Item -ItemType "Directory" -Path $folderPath
        Write-Host "New folder is created: $folderPath"
    }

    return $exists
}

function DisplayFolderStatistics([string] $folder) {

    $currentPath = (Get-Location).Path
    $folderPath = $currentPath + "\" + $folder
    $results = Get-ChildItem $folderPath -Recurse | Measure-Object -Property Length -Sum

    $temp = New-Object System.Object
    $temp | Add-Member -MemberType NoteProperty -Name "PathName" -Value $folderPath
    $temp | Add-Member -MemberType NoteProperty -Name "NumberOfFiles" -Value $results.Count
    $temp | Add-Member -MemberType NoteProperty -Name "Size(B)" -Value $results.Sum

    return $temp 

}


#main processing
$sourceFolderExists = CheckFolder $source
CheckFolder $destination -create
$countFilesInSource = (Get-ChildItem $source -Recurse -Attributes !Directory).Count

if($sourceFolderExists -and ($countFilesInSource -gt 0))
{
    $allFilesInSource = Get-ChildItem $source -Recurse -Attributes !Directory | 
                       Select-Object Name, FullName, Extension, 
                       @{Name="ExtensionName"; Expression={$_.Extension.ToString().Substring(1)}}

    $allExtensions = $allFilesInSource | Select-Object ExtensionName | Get-Unique -AsString

    #Create a folder inside destination 
    #for each different extension in the list of files from the source
    $startPath = (Get-Location).Path
    $destinationPath = $startPath + "\" + $destination
    Set-Location $destinationPath
    for($i = 0; $i -lt $allExtensions.Count; $i++)
    {
        CheckFolder $allExtensions[$i].ExtensionName -create
    }
    Set-Location $startPath

    for($j = 0; $j -lt $allFilesInSource.Count; $j++)
    {
        $sourcelocation = $allFilesInSource[$j].FullName
        $destinationExtensionPath = $destinationPath + "\" +  $allFilesInSource[$j].ExtensionName

        Copy-Item $sourcelocation -Destination $destinationExtensionPath
    }
}
