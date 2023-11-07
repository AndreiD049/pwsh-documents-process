class DocumentDefinition {
    [string]$Name
    
    DocumentDefinition([string]$name){
	$this.Name = $name;
    }

    [string]GetName() {
	return $this.Name.ToUpper();
    }

    [void]SetName($NewName) {
	$this.Name = $NewName;
    }
}

function Get-Configuration {
    param($Path)

    [xml]$xml = Get-Content -Path $Path
    Write-Host $xml
}
