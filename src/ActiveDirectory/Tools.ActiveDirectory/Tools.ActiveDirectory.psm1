using namespace System
using namespace System.Collections.Generic

class RelativeDistinguishedName {
    [string]$type
    [string]$value
    [string]$typeString
    [string]$RDNString
    [string]$RDNRawString
    static [hashtable]$dictRDN = @{
        DC     = 'domainComponent'
        CN     = 'commonName'
        OU     = 'organizationalUnitName'
        O      = 'organizationName'
        STREET = 'streetAddress'
        L      = 'localityName'
        ST     = 'stateOrProvinceName'
        C      = 'countryName'
        UID    = 'userID'
    }
    RelativeDistinguishedName () {}
    RelativeDistinguishedName ([string]$inputRDN) {
        $this.RDNRawString = $inputRDN
        $this.Resolve()
        $this.RDNString = $this.ToString()
    }
    hidden Resolve () {
        $split = $this.RDNRawString.split('=', [StringSplitOptions]::TrimEntries)
        if (-not($split.length -eq 2)) { throw "Invalid Relative Distinguished Name" }
        if ($null -eq [RelativeDistinguishedName]::dictRDN?.($split[0])) { throw "RDN type [$($split[0])] not implemented" }
        $this.typeString = [RelativeDistinguishedName]::dictRDN.($split[0])
        $this.type = $split[0]
        $this.value = $split[1]
    }
    [string] ToString () {
        return $this.type + '=' + $this.value
    }
}


class DistinguishedName {
    [RelativeDistinguishedName]$Name
    [RelativeDistinguishedName]$Parent
    [string]$ParentPath
    [string]$DNString
    [RelativeDistinguishedName[]]$RDNSequence
    [string]$DNRawString
    DistinguishedName () {}
    DistinguishedName ([string]$inputDN) {
        $this.DNRawString = $inputDN
        $this.Resolve()
        $this.DNString = $this.ToString()
    }
    hidden Resolve () {
        [List[string]]$dnList = $this.DNRawString.split(',', [StringSplitOptions]::TrimEntries)
        $this.Name = $dnList[0]
        $this.RDNSequence = $dnList.ToArray().foreach({ [RelativeDistinguishedName]::new($_) })
        if ($dnlist.Count -gt 1) { 
            $dnList.RemoveAt(0)
            $this.Parent = $dnList[0]
            $this.ParentPath = [string]::Join(',', $dnList)
        }
    }
    [string] ToString () {
        return [string]::Join(',', $this.RDNSequence)
    }
}

function ConvertFrom-DistinguishedName {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, Mandatory)]
        [alias("DistinguishedName")]
        [string[]]$InputObject
    )
    Process {
        foreach ($s in $InputObject) {
            [DistinguishedName]::new($s)
        }
    }
}

Export-ModuleMember -Function *
