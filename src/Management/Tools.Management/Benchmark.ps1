# Get-Childitem
## Include switch
$GetChildItem = Measure-Command { $res = Get-Childitem -Path C:\users\pauld\ -Include "*.csv", "*.txt", "*.ps1" -Recurse }
clear-variable -Name res


## Loop through several extensions with Foreach-object
$GetChildItem_Loop = Measure-Command { $res = "*.csv", "*.txt", "*.ps1" | ForEach-Object { Get-Childitem -Path C:\users\pauld\ -Filter $_ -Recurse } }
clear-variable -Name res


## Loop through several extensions with Foreach-object Parallel
$GetChildItem_Loop_Parallel = Measure-Command { $res = "*.csv", "*.txt", "*.ps1" | ForEach-Object -Parallel { Get-Childitem -Path C:\users\pauld\ -Filter $_ -Recurse } }
clear-variable -Name res


# Dir
## loop through several extensions with foreach-object
$dir_loop = Measure-Command { $res = "*.csv", "*.txt", "*.ps1" | ForEach-Object { C:\windows\system32\cmd.exe /c dir /s /b "C:\users\pauld\$_" } }
clear-variable -Name res


## loop through several extensions with foreach-Object parallel
$dir_loop_Parallel = Measure-Command { $res = "*.csv", "*.txt", "*.ps1" | ForEach-Object -parallel { C:\windows\system32\cmd.exe /c dir /s /b "C:\users\pauld\$_" } }
clear-variable -Name res

$dir_string = Measure-Command { Start-Process C:\windows\system32\cmd.exe -NoNewWindow -Wait -RedirectStandardOutput temp:\fileResults.txt -ArgumentList "/c dir /s /b C:\users\pauld\*.txt && dir /s /b C:\users\pauld\*.ps1 && dir /s /b C:\users\pauld\*.csv" }


# Get-Files
$GetFiles = measure-Command { $res = Get-Files -Path C:\users\pauld\ -Include "*.csv", "*.txt", "*.ps1" -Recurse }
$GetFiles_Parallel = measure-Command { $res = Get-Files -Path C:\users\pauld\ -Include "*.csv", "*.txt", "*.ps1" -Recurse -Parallel }



$output = {
    $GetChildItem               | Select-Object @{n = "Case"; e = { "Get-Childitem" } }         , Minutes, Seconds, Milliseconds, TotalMilliseconds
    $GetChildItem_Loop          | Select-Object @{n = "Case"; e = { "Get-ChildItem (Loop)" } }  , Minutes, Seconds, Milliseconds, TotalMilliseconds
    $GetChildItem_Loop_Parallel | Select-Object @{n = "Case"; e = { "Get-ChildItem (Loop Parallel)" } }, Minutes, Seconds, Milliseconds, TotalMilliseconds
    $dir_loop                   | Select-Object @{n = "Case"; e = { "dir (loop)" } }            , Minutes, Seconds, Milliseconds, TotalMilliseconds
    $dir_loop_Parallel          | Select-Object @{n = "Case"; e = { "dir (loop Parallel)" } }   , Minutes, Seconds, Milliseconds, TotalMilliseconds
    $dir_string                 | Select-Object @{n = "Case"; e = { "dir (&& cmd string)" } }   , Minutes, Seconds, Milliseconds, TotalMilliseconds
    $GetFiles                   | Select-Object @{n = "Case"; e = { "Get-Files" } }             , Minutes, Seconds, Milliseconds, TotalMilliseconds
    $GetFiles_Parallel          | Select-Object @{n = "Case"; e = { "Get-Files (Parallel)" } }  , Minutes, Seconds, Milliseconds, TotalMilliseconds
}

$SortedResults = & $output | Sort-Object TotalMilliseconds 
$Results = Foreach ($r in $SortedResults) {
    $r | Select-Object *, @{n = "Increase"; e = { "$([math]::Round($_.TotalMilliseconds / $SortedResults[0].TotalMilliseconds, 2))" + "x" } }
}
$results | format-table