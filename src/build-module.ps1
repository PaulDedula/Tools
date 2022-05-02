Param (
    [string]$docsFolder = "en-US\"
)

$Modules = Get-ChildItem $PSScriptRoot -filter *.psm1 -Recurse


#region Build and update help
foreach ($m in $modules) {
    Import-module $m -Force
    $moduleRoot = Split-Path $m.FullName -Parent
    $docsPath = $(Join-Path -Path $moduleRoot -ChildPath $docsFolder)
    if (-not (test-path $docsPath)) {
        New-Item -ItemType directory -Path $docsPath
        New-MarkdownHelp -Module $m.BaseName -OutputPath $docsPath
        New-MarkdownAboutHelp -AboutName $m.BaseName -OutputFolder $docsPath
    }

    Update-MarkdownHelp -Path $docsPath
    New-ExternalHelp -Path $docsPath -OutputPath $docsPath -Force
}
#endregion


# Run tests
# Update MD docs
# Build ExternalHelp