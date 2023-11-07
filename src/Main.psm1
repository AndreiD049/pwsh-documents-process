using module "./src/Prechecks.psm1"

# Main entrypoint
# Start checking folder in a loop
function Start-CheckingFolder {
    param(
	[Parameter(Mandatory=$true)]
	[string]$Folder,

	[Parameter(Mandatory=$false)]
	[int32]$Interval=30
    )

    $prechecks_passed = Start-Prechecks
    if (-not $prechecks_passed) {
	Write-Warning "Prechecks failed. Execution stopped."
	return
    }

    # Check if the path exists
    if (-not (Test-Path $Folder)) {
	# If not, create the folder
	New-Item -ItemType Directory -Path $Folder | Out-Null
    }

    # Start looping
    while ($true) {
	Write-Verbose "Checking '$Folder'..."
	$files = Get-ChildItem -Path $Folder
	if ($files.Count -gt 0) {
	    Write-Verbose "Found $($files.Count) files"
	    Write-Verbose $files
	}
	Start-Sleep -Seconds $Interval
    }
}

Export-ModuleMember -Function Start-CheckingFolder
