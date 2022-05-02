using namespace System
using namespace System.Collections.Generic

class RelativeDistinguishedName {
    [string]$type
    [string]$value
    [string]$RelativeDistinguishedName
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
        $this.Resolve($inputRDN)
        $this.RelativeDistinguishedName = $this.ToString()
    }
    hidden Resolve ($i) {
        $split = $i.split('=', [StringSplitOptions]::TrimEntries)
        if (-not($split.length -eq 2)) { throw "Invalid Relative Distinguished Name" }
        if ($null -eq [RelativeDistinguishedName]::dictRDN?.($split[0])) { throw "RDN type [$($split[0])] not implemented" }
        $this.type = $split[0]
        $this.value = $split[1]
    }
    [string] ToString () {
        return $this.type + '=' + $this.value
    }
}


class DistinguishedName {
    [string]$DistinguishedName
    [RelativeDistinguishedName[]]$RDNSequence
    DistinguishedName () {}
    DistinguishedName ([string]$inputDN) {
        $this.Resolve($inputDN)
        $this.DistinguishedName = $this.ToString()
    }
    hidden Resolve ($i) {
        [List[string]]$dnList = $i.split(',', [StringSplitOptions]::TrimEntries)
        $this.RDNSequence = $dnList.ToArray().foreach({ [RelativeDistinguishedName]::new($_) })
    }
    [string] ToString () {
        return [string]::Join(',', $this.RDNSequence)
    }
}

#.EXTERNALHELP Tools.ActiveDirectory-help.xml
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
