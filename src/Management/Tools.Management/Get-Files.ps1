using namespace System.IO


function Get-Files {
    <#
    .SYNOPSIS
        A faster way of getting a list of file fullnames
    .DESCRIPTION
        A faster way of getting a list of file fullnames.
        Get-ChildItem is an amazing multi-use cmdlet, however it's
        output datatype is far richer than required sometimes. This
        function will return a list of file fullnames without the 
        overhead of constructing [DirectoryInfo] and [FileInfo] objects.

        Based on the .NET System.Net.Directory.EnumerateFiles method.
        Optional multithreading available with -Parallel. Not reccomended for 
        small file system; it's just not necessary and slower in that scenario.
    .EXAMPLE
        PS C:\> Get-Files -Path C:\temp -Include "*.csv","*.txt","*.ps1"
        Get's the fullname for all files in the C:\temp directory that match the include filter.
    .NOTES
        Benchmarks:
        
        Scenario: Enumerate list of fullnames for "*.csv","*.txt","*.ps1" in $home
        Return: 3308 files (414 MB) 
        Scope of search: 77,000 files (13 GB)
        Seconds Command

        36      Get-Childitem -Path C:\users\pauld\ -Include "*.csv","*.txt","*.ps1" -Recurse
        8       "*.csv","*.txt","*.ps1" | ForEach-Object { Get-Childitem -Path C:\users\pauld\ -Filter $_ -Recurse}}
        4       Get-Files -Path C:\users\pauld\ -Include "*.csv","*.txt","*.ps1" -Recurse
        3       "*.csv","*.txt","*.ps1" | ForEach-Object -Parallel { Get-Childitem -Path C:\users\pauld\ -Filter $_ -Recurse} }
        1       Get-Files -Path C:\users\pauld\ -Include "*.csv","*.txt","*.ps1" -Recurse -Parallel

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
        $Include | ForEach-Object -Parallel { [System.IO.Directory]::EnumerateFiles("$using:path", "$_", $using:enumOptions) }
    }
    else {
        $Include | ForEach-Object { [System.IO.Directory]::EnumerateFiles("$path", "$_", $enumOptions) }
    }
}
