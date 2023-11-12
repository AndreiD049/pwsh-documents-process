$location = Get-Item $PSScriptRoot

Push-Location $location.Parent.FullName

Write-Host $location.Parent.FullName

./Reload.ps1

$result = Get-PdfInfo -Path './test/Documents/Invoice - 2402965010.PDF'

Pop-Location

return $result
