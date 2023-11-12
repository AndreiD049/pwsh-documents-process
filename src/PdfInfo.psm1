$ConvertDict = @{
    "pages" = { param($v) [int]::Parse($v) };
    "moddate" = { param($v) Get-Date $v };
    "creationdate" = { param($v) Get-Date $v };
    "tagged" = { param($v) $v -ieq "yes" };
    "encrypted" = { param($v) $v -ieq "yes" };
    "optimized" = { param($v) $v -ieq "yes" };
}

function Convert-Value {
    param($Key, $Value)
    try {
	if ($ConvertDict.ContainsKey($key.ToLower())) {
	    return $ConvertDict[$key].invoke($value)
	}
	return $value
    } catch {
	return $value
    }
}

function Get-PdfInfo {
    param(
	[Parameter(Mandatory=$true)]
	[string]$Path
    )

    # Check if file exists
    $file_exists = Test-Path $Path
    if (-not $file_exists) {
	throw "File doesn't exis"
    }
    
    # Get the file extension
    $file = Get-ChildItem -Path $Path
    $file_extension = $file.Extension

    if ($file_extension -ne ".pdf") {
	throw "File is not a pdf"
    }

    $output_lines = Invoke-Expression "pdfinfo.exe -rawdates '$Path'"

    $result = @{};

    foreach ($line in $output_lines) {
	$elements = $line -split ":", 2
	# Only process if we have 2 elements in the list
	if ($elements.Count -eq 2) {
	    $key = $elements[0].ToLower() -replace " ", "_"
	    $value = $elements[1].Trim()
	    $value = Convert-Value -Key $key -Value $value
	    $result.Add($key, $value)
	}
    }

    return $result
}

Export-ModuleMember -Function Get-PdfInfo
