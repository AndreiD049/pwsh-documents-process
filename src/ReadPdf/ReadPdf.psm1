class PdfContent {
    [string[]]$Pages = [System.Collections.ArrayList]::new()

    [void]AddPage([string]$Page) {
	$this.Pages += $Page
    }
 }

# Transforms all pages of the pdf to png files and places them into the temp folder
function Invoke-PdfToPng {
    param(
	[Parameter(Mandatory=$true)]
	[string]$Path,
	
	[Parameter(Mandatory=$true)]
	[int]$Page,

	[Parameter(Mandatory=$false)]
	[string]$Options
    )

    if ([String]::IsNullOrEmpty($Options)) {
	$Options = "-r 300 -gray -aa yes"
    }
    
    $temp_folder = $env:TEMP
    $png_temp_folder = Join-Path $temp_folder "pdftopng"
    if ((Test-Path -Path $png_temp_folder)) {
	# Renove whatever old files you have there
	Get-ChildItem $png_temp_folder | Remove-Item -Force -ErrorAction Ignore
    } else {
	New-Item -ItemType Directory -Path $png_temp_folder
    }
    $random_prefix = (Get-Random).ToString()
    $png_path_and_prefix = Join-Path $png_temp_folder $random_prefix
    Invoke-Expression "pdftopng.exe -f $Page -l $Page $Options '$Path' '$png_path_and_prefix'" | Out-Null

    # Return the created files to the user
    return Get-ChildItem "$png_path_and_prefix*.png"
}

# Creates an editable pdf out of a png file
# By calling tessetact
# Example: tesseract.exe ./path/to/file.png ./path/to/file --psm 11 pdf
function Create-PdfWithTesseract {
    param(
	[Parameter(Mandatory=$true)]
	[string]$Path,

	[Parameter(Mandatory=$false)]
	[string]$Options
    )

    if ([String]::IsNullOrEmpty($Options)) {
	$Options = "--psm 11"
    }

    $png_item = Get-ChildItem -Path $Path

    $extension = $png_item.Extension
    if ($extension -ne ".png") {
	throw "File '$Path' not a png"
    }

    $pdf_base_name = Join-Path -Path $png_item.DirectoryName -ChildPath $png_item.BaseName
    $pdf_name = "$pdf_base_name.pdf"

    # try to create the pdf
    Invoke-Expression "tesseract.exe $Path $pdf_base_name $Options pdf"

    if (-not (Test-Path -Path $pdf_name)) {
	throw "Pdf '$pdf_name' not created"
    }

    return Get-ChildItem $pdf_name
}

function Invoke-PdfToText {
    param(
	[Parameter(Mandatory=$true)]
	[string]$Path,

	[Parameter(Mandatory=$true)]
	[int]$Page,

	[Parameter(Mandatory=$false)]
	[string]$Options
    )

    if ([String]::IsNullOrEmpty($Options)) {
	$Options = "-layout"
    }
    
    $text = Invoke-Expression "pdftotext.exe -f $Page -l $Page $Options '$Path' -"

    return $text -join "`n"
}

function Read-Pdf {
    param(
	[Parameter(Mandatory=$true)]
	[string]$Path,

	[Parameter(Mandatory=$false)]
	[string]$PdfToTextOptions,

	[Parameter(Mandatory=$false)]
	[string]$PdfToPngOptions,

	[Parameter(Mandatory=$false)]
	[string]$TesseractOptions
    )

    if (-not (Test-Path $Path)) {
	Write-Warning "PDF not found at path - '$Path'"
	return ""
    }

    $pdf_info = Get-PdfInfo -Path $Path

    $result = [PdfContent]::new()

    for ($page = 1; $page -le $pdf_info.pages; $page++) {
	$page_text = Invoke-PdfToText -Path $Path -Page $page -Options $PdfToTextOptions
	$pdf_is_editable = -not [String]::IsNullOrEmpty($page_text.Trim())

	if (-not $pdf_is_editable) {
	    # Pdf is not editable, read using tesseract
	    $png_file = Invoke-PdfToPng -Path $Path -Page $page -Options $PdfToPngOptions

	    $page_text = ""
	    $pdf_item = Create-PdfWithTesseract -Path $png_file.FullName -Options $TesseractOptions
	    $page_text = Invoke-PdfToText -Path $pdf_item -Page 1 -Options $PdfToTextOptions
	}
	$result.AddPage($page_text)
    }

    return $result
}

Export-ModuleMember -Function Read-Pdf, Invoke-PdfToPng
