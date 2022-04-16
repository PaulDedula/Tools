class RelativeDistinguishedName {
    [string]$type
    [string]$value
    [string]$typeString
    [string]$RelativeDistinguishedName
    hidden [int]$depth = 0
    hidden [hashtable]$dictRDN = @{
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
        $this.RelativeDistinguishedName = $inputRDN
        $this.Resolve()
    }
    RelativeDistinguishedName ([string]$inputRDN, [int]$depth) {
        $this.RelativeDistinguishedName = $inputRDN
        $this.depth = $depth ?? 0
        $this.Resolve()
    }
    hidden Resolve () {
        $split = $this.RelativeDistinguishedName.split('=')
        $this.typeString = $this.dictRDN.($split[0])
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
    [string]$DistinguishedName
    [RelativeDistinguishedName[]]$RDNSequence
    DistinguishedName () {}
    DistinguishedName ([string]$inputDN) {
        $this.DistinguishedName = $inputDN
        $this.Resolve()
    }
    hidden Resolve () {
        [System.Collections.Generic.List[string]]$dnList = $This.DistinguishedName.split(',').trim()
        $this.Name = $dnList[0]
        $this.RDNSequence = $dnList.ToArray().Trim().foreach({ [RelativeDistinguishedName]::new($_, $depth) ; $depth ++ })
        if ($dnlist.Count -gt 1) { 
            $dnList.RemoveAt(0)
            $this.Parent = $dnList[0]
            $this.ParentPath = [string]::Join(',', $dnList)
        }

    }
    [string] ToString () {
        return $this.DistinguishedName
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
        foreach ($s in $String) {
            [DistinguishedName]::new($s)
        }
    }
}

Export-ModuleMember -Function *
