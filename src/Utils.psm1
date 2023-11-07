function Test-Installed {
    param([string]$Name)

    return $null -ne (Get-Command -Name $Name -ErrorAction SilentlyContinue)
}

Export-ModuleMember -Function Test-Installed
