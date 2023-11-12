# Author: Dimitrascu Andrei
# Date: 11/11/23
# Main config file
# Contains main configurations like:
# - Where to look for documents,
# - what flags to apply to command line programs

class Config {
    [string]$InFolder
    [string]$PdfToTextOptions = "-layout -clip"
    [string]$PdfToPngOptions = "-r 400 -gray -aa yes"
    [string]$TesseractOptions = "--psm 11 -c preserve_interword_spaces=1"
}

function Read-XmlConfig {
    param([string]$Path)

    [xml]$xml = Get-Content -Path $Path

    $config = [Config]::new()

    $in_folder = $xml.SelectSingleNode("//in_folder")

    if ($null -eq $in_folder) {
	throw "Config invalid: missing <in_folder> tag"
    }
    $config.InFolder = $in_folder.'#text'

    $pdftptext_options = $xml.SelectSingleNode("//pdftotext_options")
    if ($null -ne $pdftptext_options) {
	$config.PdfToTextOptions = $pdftptext_options.'#text'
    }

    $pdftopng_options = $xml.SelectSingleNode("//pdftopng_options")
    if ($null -ne $pdftopng_options) {
	$config.PdfToPngOptions = $pdftopng_options.'#text'
    }

    $tesseract_options = $xml.SelectSingleNode("//tesseract_options")
    if ($null -ne $tesseract_options) {
	$config.TesseractOptions = $tesseract_options.'#text'
    }

    return $config
}

function Read-Config {
    param(
	[Parameter(Mandatory=$true)]
	[string]$Path
    )

    # Check if config exists
    $config_exists = Test-Path -Path $Path
    if (-not $config_exists) {
	throw "Configr '$Path' doesn't exist"
    }

    # Check if config has supported extension
    $config = Get-Item -Path $Path
    $extension = $config.Extension

    if ($extension -ine ".xml") {
	throw "Config has unsuported extension - '$extension'"
    }

    return Read-XmlConfig -Path $Path
}

Export-ModuleMember -Function Read-Config
