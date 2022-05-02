---
external help file: Tools.Management-help.xml
Module Name: Tools.Management
online version:
schema: 2.0.0
---

# Get-Folders

## SYNOPSIS
A faster way of getting a list of file fullnames

## SYNTAX

```
Get-Folders [[-Include] <String[]>] [-Path] <String> [-Recurse] [-Parallel] [<CommonParameters>]
```

## DESCRIPTION
A faster way of getting a list of file fullnames.
Get-ChildItem is an amazing multi-use cmdlet, however it's
output datatype is far richer than required sometimes.
This
function will return a list of file fullnames without the 
overhead of constructing \[DirectoryInfo\] and \[FileInfo\] objects.
Based on the .NET System.Net.Directory.EnumerateFiles method.
Optional multithreading available with -Parallel.
Not reccomended for 
small file system; it's just not necessary and slower in that scenario.

## EXAMPLES

### EXAMPLE 1
```
Get-Files -Path C:\temp -Include "*.csv","*.txt","*.ps1"
Get's the fullname for all files in the C:\temp directory that match the include filter.
```

## PARAMETERS

### -Include
{{ Fill Include Description }}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
{{ Fill Path Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Recurse
{{ Fill Recurse Description }}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Parallel
{{ Fill Parallel Description }}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Benchmarks:

Scenario: Enumerate list of fullnames for "*.csv","*.txt","*.ps1" in $home
Return: 3308 files (414 MB) 
Scope of search: 77,000 files (13 GB)
Seconds Command
36      Get-Childitem -Path C:\users\paul.dedula\ -Include "*.csv","*.txt","*.ps1" -Recurse
8       "*.csv","*.txt","*.ps1" | ForEach-Object { Get-Childitem -Path C:\users\paul.dedula\ -Filter $_ -Recurse}}
4       Get-Files -Path C:\users\paul.dedula\ -Include "*.csv","*.txt","*.ps1" -Recurse
3       "*.csv","*.txt","*.ps1" | ForEach-Object -Parallel { Get-Childitem -Path C:\users\paul.dedula\ -Filter $_ -Recurse} }
1       Get-Files -Path C:\users\paul.dedula\ -Include "*.csv","*.txt","*.ps1" -Recurse -Parallel
36      Get-Childitem -Path C:\users\pauld\ -Include "*.csv","*.txt","*.ps1" -Recurse
8       "*.csv","*.txt","*.ps1" | ForEach-Object { Get-Childitem -Path C:\users\pauld\ -Filter $_ -Recurse}}
4       Get-Files -Path C:\users\pauld\ -Include "*.csv","*.txt","*.ps1" -Recurse
3       "*.csv","*.txt","*.ps1" | ForEach-Object -Parallel { Get-Childitem -Path C:\users\pauld\ -Filter $_ -Recurse} }
1       Get-Files -Path C:\users\pauld\ -Include "*.csv","*.txt","*.ps1" -Recurse -Parallel

## RELATED LINKS
