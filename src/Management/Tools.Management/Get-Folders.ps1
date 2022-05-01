using namespace System.IO


function Get-Folders {
    <#
    .SYNOPSIS
        A faster way of getting a list of Directory fullnames
    .DESCRIPTION
        A faster way of getting a list of directory full names.
        Get-ChildItem is an amazing multi-use cmdlet, however it's
        output datatype is far richer than required sometimes. This
        function will return a list of directory full names without the 
        overhead of constructing [DirectoryInfo] and [FileInfo] objects.

        Based on the .NET System.Net.Directory.EnumerateDirectories method.
        Optional multithreading available with -Parallel. Not reccomended for 
        small file system; it's just not necessary and slower in that scenario.
    .EXAMPLE
        PS C:\> Get-Folders -Path C:\temp -Include "temp","profile",
        Get's the fullname for all directories in the temp directory that match the include filter.
    .NOTES
        Benchmarks:
        
        Scenario: Enumerate list of fullnames for "temp","profile", in $home
        Return: 4 Folders 
        Scope of search: 88,825 Folders
        Seconds Command
        114      Get-Childitem -Path C:\users\pauld\ -Include "temp","profile" -Recurse
        7        "temp","profile" | ForEach-Object { Get-Childitem -Path C:\users\pauld\ -Filter $_ -Recurse}}
        4.5      "temp","profile" | ForEach-Object -Parallel { Get-Childitem -Path C:\users\pauld\ -Filter $_ -Recurse} }
        1.7      Get-Folders -Path C:\users\pauld\ -Include "temp","profile" -Recurse
        0.9      Get-Folders -Path C:\users\pauld\ -Include "temp","profile" -Recurse -Parallel

    #>
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
