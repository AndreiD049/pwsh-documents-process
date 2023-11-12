# Author: Dimitrascu Andrei
# Date: 11/11/23
# The context of a single found file
# This is the object that customs scripts have access to
# All behavior customizations should be done via this object
using module "./src/ReadPdf/ReadPdf.psm1"


class FileContext {
    [string]$Path
    [PdfContent]$Content
    
    FileContext([string]$Path) {
	$this.Path = $Path
	$this.Content = Read-Pdf -Path $this.Path
    }
}
