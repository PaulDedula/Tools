# Tools
## about_Tools

# SHORT DESCRIPTION
Supplemental tools for existing modules, applications, APIs, etc.

# LONG DESCRIPTION
Many common PowerShell modules need to be broadly implemented and occasionally 
lack support for niche items. This repository will be an organically growing 
collection of extensions to modules, applications, APIs, etc. Expect the 
organization of the repository to be overhauled occasionally.

## Structure
This repository is mainly PowerShell currently. Modules exist in: 
src/$Toolcategory/$moduleFolder

Documentation can be found in src/$toolcategory/$moduleFolder/en-US/*.md

# EXAMPLES
## Utility
### ConvertTo-MarkdownTable
Command line usage:
```PowerShell
Get-ChildItem .\src\Utility\Tools.Utility\ | Select-Object Name,Length,Mode | ConvertTo-MarkDownTable

|Name|Length|Mode|
|:---|:---|:---|
|en-US||d----|
|Tools.Utility.psm1|1531|-a---|
```
Rendered Examples:

|Name|Length|Mode|
|:---|:---|:---|
|en-US||d----|
|Tools.Utility.psm1|1531|-a---|

|type|value|RelativeDistinguishedName|
|:---|:---|:---|
|CN|John Smith|CN=John Smith|
|OU|My Users|OU=My Users|
|CN|Users|CN=Users|
|DC|Example|DC=Example|
|DC|com|DC=com|

## Active Directory
### ConvertFrom-DistinguishedName
Command line usage:
```PowerShell
PS> ConvertFrom-DistinguishedName "CN=Paul Dedula,OU =   My Users,CN  = Users  ,   DC=Example   ,DC=    com  "

DistinguishedName                                     RDNSequence
-----------------                                     -----------
CN=Paul Dedula,OU=My Users,CN=Users,DC=Example,DC=com {CN=Paul Dedula, OU=My Users, CN=Users, DC=Example…}

PS> $output.RDNSequence

type value       RelativeDistinguishedName
---- -----       -------------------------
CN   Paul Dedula CN=Paul Dedula
OU   My Users    OU=My Users
CN   Users       CN=Users
DC   Example     DC=Example
DC   com         DC=com
```
## Management
### Get-Files
```PowerShell
PS> Get-Files -Parallel -Recurse -Path C:\temp -Include "*.csv","*.txt","*.ps1"
C:\temp\file.txt
C:\temp\options.txt
C:\temp\API\license.txt
C:\temp\API2\license.txt
...

PS> measure-command {Get-Files -Path C:\ -Include "*.csv","*.txt","*.ps1" -Recurse -Parallel}

TotalSeconds      : 42.8621054 # 1TB nvme ssd ~90% full, 1.4 million files
```



# NOTE
{{ Note Placeholder - Additional information that a user needs to know.}}

# TROUBLESHOOTING NOTE
{{ Troubleshooting Placeholder - Warns users of bugs}}

{{ Explains behavior that is likely to change with fixes }}

# SEE ALSO
{{ See also placeholder }}

{{ You can also list related articles, blogs, and video URLs. }}

# KEYWORDS
{{List alternate names or titles for this topic that readers might use.}}

- {{ Keyword Placeholder }}
- {{ Keyword Placeholder }}
- {{ Keyword Placeholder }}
- {{ Keyword Placeholder }}

