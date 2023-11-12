$location = Get-Item $PSScriptRoot

Push-Location $location.Parent.FullName

Write-Host $location.Parent.FullName

./Reload.ps1

$result = Read-Pdf -Path './test/Documents/LG COA.pdf'

Pop-Location

return $result
