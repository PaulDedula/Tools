---
external help file: Tools.Utility-help.xml
Module Name: Tools.Utility
online version:
schema: 2.0.0
---

# ConvertTo-MarkDownTable

## SYNOPSIS
Basic way to output a markdown table.

## SYNTAX

```
ConvertTo-MarkDownTable [[-InputObject] <Object>] [<CommonParameters>]
```

## DESCRIPTION
Basic way to output a markdown table.
Doesn't support much and has
issues with constructing huge tables (get-process).
It relies mainly
on ConvertTo-Csv, then tweaks the output to turn it into a markdown
table.

## EXAMPLES

### EXAMPLE 1
```
Get-Item C:\temp | Select-Object mode,lastwritetime,length,name| ConvertTo-MarkDownTable
|Mode|LastWriteTime|length|Name|
|---|---|---|---|
|d----|4/30/2022 1:26:44 PM||Temp|
```

Converts the object to a MarkDownTable

### EXAMPLE 2
```
Get-Item C:\temp | Select-Object mode,lastwritetime,length,name| ConvertTo-MarkDownTable | clip
|Mode|LastWriteTime|length|Name|
|---|---|---|---|
|d----|4/30/2022 1:26:44 PM||Temp|
```

Converts the object to a MarkDownTable and places it on the clipboard.

### EXAMPLE 3
```
$output = Get-Item C:\temp | Select-Object mode,lastwritetime,length,name
PS C:\> ConvertTo-MarkDownTable $output
|Mode|LastWriteTime|length|Name|
|---|---|---|---|
|d----|4/30/2022 1:26:44 PM||Temp|
```

Converts the object to a MarkDownTable

## PARAMETERS

### -InputObject
Any Other Object

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Object[]
## OUTPUTS

### Table
## NOTES
Needed a quick way of copying PowerShell output to Markdown notes.
I found Markdown tables were a bit nicer than doing backtick
code blocks in some cases.
Will likely switch to Markdig Markdown at some point.

## RELATED LINKS
