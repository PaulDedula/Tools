---
external help file: Tools.Management-help.xml
Module Name: Tools.Management
online version:
schema: 2.0.0
---

# New-FileIndex

## SYNOPSIS
Builds an index of a filesystem for fast and efficient name-to-path lookups.

## SYNTAX

```
New-FileIndex [[-Include] <String>] [[-RegexMask] <String>] [[-Path] <String>] [<CommonParameters>]
```

## DESCRIPTION
This function converts the target filesystem into a hashtable of filename 
to fullname mappings. Helpful for when you have a known file name but not a known location.
By using a single recursive search, this may dramtically improve performance of the script.

IE: 
- invoices/files with a structured naming convention
- a list of filenames in application logs without the full path information
- general need for a list of leaf and fullnames for export

## EXAMPLES

### Example 1
```powershell
PS C:\> $invoiceIndex = New-FileIndex -Path C:\temp\test\invoices -Include '*.pdf'
PS C:\> $invoiceIndex['invoice_91.pdf']
C:\temp\test\invoice_91.pdf
```

The index is stored in the variable `$invoiceIndex`. After the initial building
of the index, the search for 'invoice_91.pdf' is nearly instantaneous.

### Example 2
```powershell
PS C:\> $invoiceIndex = New-FileIndex -Path C:\temp\test -Include '*.pdf' -RegexMask "invoice\D+"
PS C:\> $invoiceIndex['184.pdf'] -split ";"
C:\temp\test\invoice_184.pdf
C:\temp\test\invoice_reissued_184.pdf
```

The hash lookup for '184.pdf' returns a semicolon-delimited multivalue string.

## PARAMETERS

### -Include
Include only files that match the specified pattern. (non-regex).

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### -RegexMask
An optional mask to help cleanup `Keys` prior to adding to the hash table.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
The path at which to begin recusively building the index hash table.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: $pwd.path
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
