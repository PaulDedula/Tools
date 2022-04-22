---
external help file: Tools.ActiveDirectory-help.xml
Module Name: Tools.ActiveDirectory
online version:
schema: 2.0.0
---

# ConvertFrom-DistinguishedName

## SYNOPSIS
Converts a string distinguished name into a more usable object.

## SYNTAX

```
ConvertFrom-DistinguishedName [-InputObject] <String[]> [<CommonParameters>]
```

## DESCRIPTION
Converts a string distinguished name into a more usable object. Not yet compliant
with [RFC 4514](https://docs.ldap.com/specs/rfc4514.txt).

## EXAMPLES

### Example 1
```powershell
PS C:\> "CN=Test User, OU=My Users,CN=Users,DC=Example,DC=com",[pscustomobject]@{distinguishedname = "CN=Paul Dedula, OU=My Users,CN=Users,DC=Example,DC=com"}  | ConvertFrom-DistinguishedName

Name        : CN=Test User 
Parent      : OU=My Users
ParentPath  : OU=My Users,CN=Users,DC=Example,DC=com
DNString    : CN=Test User,OU=My Users,CN=Users,DC=Example,DC=com
RDNSequence : {CN=Test User, OU=My Users, CN=Users, DC=Example…}
DNRawString : CN=Test User, OU=My Users,CN=Users,DC=Example,DC=com

Name        : CN=Paul Dedula
Parent      : OU=My Users
ParentPath  : OU=My Users,CN=Users,DC=Example,DC=com
DNString    : CN=Paul Dedula,OU=My Users,CN=Users,DC=Example,DC=com
RDNSequence : {CN=Paul Dedula, OU=My Users, CN=Users, DC=Example…}
DNRawString : CN=Paul Dedula, OU=My Users,CN=Users,DC=Example,DC=com
```

Converts the input string or input object that has a distinguished name property to a distinguishedname object.

### Example 2
```powershell
PS C:\> import-module Tools.ActiveDirectory
PS C:\> ConvertFrom-DistinguishedName " CN = Paul Dedula, OU =   My Users,   CN   =    Users,   DC=Example,  DC  =com" | Select-Object -ExpandProperty RDNSequence | Format-Table

type value       typeString             RDNString      RDNRawString
---- -----       ----------             ---------      ------------
CN   Paul Dedula commonName             CN=Paul Dedula CN = Paul Dedula
OU   My Users    organizationalUnitName OU=My Users    OU =My Users
CN   Users       commonName             CN=Users       CN=Users
DC   Example     domainComponent        DC=Example     DC=Example
DC   com         domainComponent        DC=com         DC  =com
```

Access the entire relative distinguished name sequence array.

### Example 3
```powershell
PS C:\> using module Tools.ActiveDirectory
PS C:\> $DNObject = [DistinguishedName]"CN=Test User, OU=My Users,CN=Users,DC=Example,DC=com"
PS C:\> $DNObject.ParentPath

OU=My Users,CN=Users,DC=Example,DC=com
```

Optionally, import and use the custom class directly with a `using` statement.

### Example 4
```powershell
PS C:\> $DNObject = ConvertFrom-DistinguishedName "CN=Paul Dedula, OU=My Users,CN=Users,DC=Example,DC=com" 
PS C:\> switch ($DNObject.RDNSequence[-1].type) {
    OU { "I run when the RDN type is an organization unit" }
    DC { "I run when the RDN type is a domainComponent" }
    Default {}
}

"I run when the RDN type is a domainComponent"
```

Perform a specific action based on the relative name type.

## PARAMETERS

### -InputObject
The input string or input object that has a distinguished name property

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: DistinguishedName

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String[]

## OUTPUTS

### DistinguishedName[]
## NOTES
Special character support not tested.
Not yet compliant with [RFC 4514](https://docs.ldap.com/specs/rfc4514.txt)

## RELATED LINKS
