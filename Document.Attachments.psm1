Set-Location $PSScriptRoot

Get-ChildItem -Recurse -Path "./src" -Filter "*.psm1" | ForEach-Object {
    Write-Host "Loading module $($_.FullName)"
    Import-Module $_.FullName
}
