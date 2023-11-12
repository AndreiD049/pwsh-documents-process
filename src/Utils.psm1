function Test-Installed {
    param([string]$Name)

    return $null -ne (Get-Command -Name $Name -ErrorAction SilentlyContinue)
}

function Assert-Condition {
    param(
	[Parameter(Mandatory=$true)]
	[boolean]$Condition,
	[Parameter(Mandatory=$false)]
	$Message
    )

    if (-not $Condition) {
	if ([String]::IsNullOrEmpty($Message)) {
	    $msg = "Assertion failure"
	} else {
	    $msg = $Message
	}

	throw "$msg"
    }
}

Export-ModuleMember -Function Test-Installed, Assert-Condition
