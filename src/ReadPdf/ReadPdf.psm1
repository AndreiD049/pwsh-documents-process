function Invoke-PdfToText {
    param([string]$Path)
    
    $text = Invoke-Expression "pdftotext.exe -layout '$Path' -"

    return $text -join "`n"
}

function Read-Pdf {
    param(
	[Parameter(Mandatory=$true)]
	[string]$Path
    )

    if (-not (Test-Path $Path)) {
	Write-Warning "PDF not found at path - '$Path'"
	return ""
    }

    $editable_text = Invoke-PdfToText -Path $Path

    Write-Host "Reading PDF at '$Path'`nResult $editable_text"
}

Export-ModuleMember -Function Read-Pdf
