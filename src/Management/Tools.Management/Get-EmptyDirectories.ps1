using namespace System.IO
using namespace System.Linq
# Testing way to find empty folders on large file system.

$global:Calls = 0
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

Get-EmptyDirectories C:\users\paul.dedula
$Calls
