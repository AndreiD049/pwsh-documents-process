using module "./src/Utils.psm1"

$TESSERACT_NOT_INSTALLED = @"
tesseract.exe is not installed.
For installation instructions, see: https://tesseract-ocr.github.io/tessdoc/Installation.html
"@

$XPDF_NOT_INSTALLED = @"
xpdf tools not installed. (Or not all installed)
Tools required are: pdftotext.exe, pdftopng.exe, pdfinfo.exe
For installation, see: https://www.xpdfreader.com/download.html
"@

# Check if all necessary software is intalled
function Start-Prechecks {
    $tesseract_installed = Test-Installed -Name "tesseract.exe"
    if (-not $tesseract_installed) {
	Write-Warning $TESSERACT_NOT_INSTALLED
	return $false
    }

    $pdftools_installed = (Test-Installed -Name "pdftotext.exe") -and `
      (Test-Installed -Name "pdfinfo.exe") -and `
      (Test-Installed -Name "pdftopng.exe");

    if (-not $pdftools_installed) {
	Write-Warning $XPDF_NOT_INSTALLED
	return $false
    }

    return $true
}

Export-ModuleMember -Function Start-Prechecks
