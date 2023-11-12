$location = Get-Item $PSScriptRoot

Push-Location $location.Parent.FullName

Write-Host $location.Parent.FullName

./Reload.ps1

$result = Read-Config -Path ./test/config.xml
Assert-Condition -Condition ($result.InFolder -match "test") -Message "In folder incorrect"
Assert-Condition -Condition ($result.PdfToTextOptions -match "test pdftotext options")
Assert-Condition -Condition ($result.PdfToPngOptions -match "test pdftopng options")
Assert-Condition -Condition ($result.TesseractOptions -match "test tesseract options")

Pop-Location

return $result
