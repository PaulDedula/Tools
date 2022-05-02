Param (
    [string]$docsFolder = "docs\en-us"
)

$Modules = Get-ChildItem $PSScriptRoot -filter *.psm1 -Recurse

foreach ($m in $modules) {
    Import-module $m -Force
    $moduleRoot = Split-Path $m.FullName -Parent
    $docsPath = $(Join-Path -Path $moduleRoot -ChildPath $docsFolder)
    # Run tests
    # Update MD docs
    # Build ExternalHelp
    Update-MarkdownHelp -Path $docsPath
    New-ExternalHelp -Path $docsPath -OutputPath $moduleRoot -Force
}