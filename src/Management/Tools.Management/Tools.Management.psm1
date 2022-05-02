using namespace System.IO
using namespace System.Linq
# Testing way to find empty folders on large file system.

#.EXTERNALHELP Tools.Management-help.xml
function Get-EmptyDirectories {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$Path
    )
    $global:calls++
    $opt = [System.io.EnumerationOptions]::new()
    $opt.RecurseSubdirectories = $true
    $files = [system.io.Directory]::EnumerateFiles($Path, '*', $opt )

    if (-not([System.Linq.Enumerable]::Any($files))) {
        return $Path
    }
    else {
        [System.io.Directory]::GetDirectories($Path) | ForEach-Object {
            Get-EmptyDirectories -Path $_
        }
    }
}

#.EXTERNALHELP Tools.Management-help.xml
function Get-Files {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string[]]$Include = "*",
        [Parameter(Mandatory)]
        [string]$Path,
        [switch]$Recurse,
        [switch]$Parallel
    )
    $enumOptions = [System.IO.EnumerationOptions]::new()
    $enumOptions.IgnoreInaccessible = $true
    $enumOptions.RecurseSubdirectories = $Recurse
    if ($Parallel) {
        $Include | ForEach-Object -Parallel { [System.IO.Directory]::EnumerateFiles("$using:path", "$_", $using:enumOptions) }
    }
    else {
        $Include | ForEach-Object { [System.IO.Directory]::EnumerateFiles("$path", "$_", $enumOptions) }
    }
}

#.EXTERNALHELP Tools.Management-help.xml
function Get-Folders {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string[]]$Include = "*",
        [Parameter(Mandatory)]
        [string]$Path,
        [switch]$Recurse,
        [switch]$Parallel
    )
    $enumOptions = [System.IO.EnumerationOptions]::new()
    $enumOptions.IgnoreInaccessible = $true
    $enumOptions.RecurseSubdirectories = $Recurse
    if ($Parallel) {
        $Include | ForEach-Object -Parallel { [System.IO.Directory]::EnumerateDirectories("$using:path", "$_", $using:enumOptions) }
    }
    else {
        $Include | ForEach-Object { [System.IO.Directory]::EnumerateDirectories("$path", "$_", $enumOptions) }
    }
}
