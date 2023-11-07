$root = $PSScriptRoot
# get all modules in current path
$modules = Get-Module -All | Where-Object {
    $module = $_
    $module.Path.StartsWith($root)
}

# remove old modules
$modules | ForEach-Object {
    Write-Host "Removing module $($_.Path)"
    Remove-Module -ModuleInfo $_ -Force
}

Import-Module ./Document.Attachments.psm1
