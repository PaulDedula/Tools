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


function ConvertTo-MarkDownTable {
    <#
    .SYNOPSIS
        Basic way to output a markdown table.
    .DESCRIPTION
        Basic way to output a markdown table. Doesn't support much and has
        issues with constructing huge tables (get-process). It relies mainly
        on ConvertTo-Csv, then tweaks the output to turn it into a markdown
        table.
    .EXAMPLE
        PS C:\> Get-Item C:\temp | Select-Object mode,lastwritetime,length,name| ConvertTo-MarkDownTable
        |Mode|LastWriteTime|length|Name|
        |:----|:----|:----|:----|
        |d----|5/1/2022 1:15:02 PM||Temp|
        
        Converts the object to a MarkDownTable
    .EXAMPLE
        PS C:\> Get-Item C:\temp | Select-Object mode,lastwritetime,length,name| ConvertTo-MarkDownTable | clip
        |Mode|LastWriteTime|length|Name|
        |:----|:----|:----|:----|
        |d----|5/1/2022 1:15:02 PM||Temp|
        
        Converts the object to a MarkDownTable and places it on the clipboard.
    .EXAMPLE
        PS C:\> $output = Get-Item C:\temp | Select-Object mode,lastwritetime,length,name
        PS C:\> ConvertTo-MarkDownTable $output
        |Mode|LastWriteTime|length|Name|
        |:----|:----|:----|:----|
        |d----|5/1/2022 1:15:02 PM||Temp|
        
        Converts the object to a MarkDownTable
    .INPUTS
        Object[]
    .OUTPUTS
        String[]
    .NOTES
        Needed a quick way of copying PowerShell output to Markdown notes.
        I found Markdown tables were a bit nicer than doing backtick
        code blocks in some cases.
        Will likely switch to Markdig Markdown at some point.
    #>
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