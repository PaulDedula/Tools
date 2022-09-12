using namespace System.Collections.generic

class MarkDownTable {
    static [string[]] FromObject ($AnyObject) {
        return [MarkDownTable]::FromCSV(($AnyObject | ConvertTo-Csv -Delimiter "|" ))
    }
    static [string[]] FromCSV ($csv) {
        <#
        Must input pipe-delimited CSV
        Add | to begining and end of lines, then remove quotes.
        #>
        [System.Collections.Generic.List[string]]$output = $csv -replace "^|$", "|" -replace '"', ''     
        $pipeCount = ($output[0] | select-string -Pattern "\|" -AllMatches).Matches.Count
        $output.insert(1, [MarkDownTable]::dividerBuilder($pipeCount))
        return $output
    }
    static [string] dividerBuilder ($pipes) {
        <#
        The CSV header contains columns: Npipes-1.
        The output will always contain 1 column so: Npipes-2 will determine the number of
        adder sections needed.
        #>
        $numberOfColumns = $pipes - 2
        $divider = "|:---|"
        $adder = ":---|"        
        return $numberOfColumns -lt 1 ? $divider : $divider + ($adder * $numberOfColumns)
    }
}


#.EXTERNALHELP Tools.Utility-help.xml
function ConvertTo-MarkDownTable {
    [CmdletBinding()]
    param (
        # Any Other Object
        [Parameter(ValueFromPipeline)]
        [object]$InputObject
    )
    Begin {
        $buffer = [System.Collections.Generic.list[object]]::new()
    }
    Process {
        $Buffer.add($InputObject)
    }
    End {
        return [MarkDownTable]::FromObject($buffer.ToArray())
    }
}

function ConvertTo-Dictionary {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        [object[]]$InputObject,
        [Parameter()]
        [string]$KeyProperty
    )
    begin {
        $Dictionary = [Dictionary[string,[List[Object]]]]::new()
    }
    process {
        foreach ($obj in $InputObject) {
            $key = $obj.$KeyProperty
            if ($Dictionary.ContainsKey($key)) {
                $Dictionary[$key].Add($obj)
            } else {
                $value = [List[Object]]::new()
                $value.Add($obj)
                $Dictionary.Add($key,$value)
            }
        }
    }
    end {
        return $Dictionary
    }
}