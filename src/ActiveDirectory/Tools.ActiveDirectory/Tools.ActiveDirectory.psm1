class RelativeDistinguishedName {
    [string]$type
    [string]$value
    [string]$typeString
    [string]$RelativeDistinguishedName
    hidden [int]$depth = 0
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
        if (-not($split.length -eq 2)) {throw "Invalid Relative Distinguished Name"}
        if ($null -eq [RelativeDistinguishedName]::dictRDN?.($split[0])) {throw "RDN type [$($split[0])] not implemented"}
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
    [string]$DistinguishedName
    [RelativeDistinguishedName[]]$RDNSequence
    hidden [int]$LenRDNSequence
    hidden [int[]]$rangeRDNSequnce
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
        $this.LenRDNSequence = $this.RDNSequence.GetUpperBound(0)
        $this.rangeRDNSequnce = (0..$this.LenRDNSequence)
    }
    [string] SubPath ([int]$start) {
        if (-not($start -in $this.rangeRDNSequnce)) {throw "Starting position out of range"}
        return [string]::Join(',',$this.RDNSequence[$start..$this.LenRDNSequence])
    }
    [string] SubPath ([int]$start, [int]$Stop) {
        if (-not($start -in $this.rangeRDNSequnce)) {throw "Starting position out of range"}
        if (-not($Stop -in $this.rangeRDNSequnce)) {throw "Terminating position out of range"}
        return [string]::Join(',',$this.RDNSequence[$start..$Stop])
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
        foreach ($s in $InputObject) {
            [DistinguishedName]::new($s)
        }
    }
}

Export-ModuleMember -Function *
