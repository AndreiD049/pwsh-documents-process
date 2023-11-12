# Author: Dimitrascu Andrei
# Date: 11/11/23
# Simple class to represent a point (i.e. Line and Column on a text plane)

class Point {
    [int]$Line
    [int]$Column

    Point($Line, $Column) {
	$this.Line = $Line
	$this.Column = $Column
    }

    [Point]Clone() {
 	return [Point]::new($this.Line, $this.Column)
    }

    [void]Offset($Line, $Column) {
	$this.Line += $Line
	$this.Column += $Column
	$this._Normlize()
    }

    [void]OffsetX($Line) {
	$this.Line = $Line
	$this._Normlize()
    }

    [void]OffsetY($Column) {
	$this.Column = $Column
	$this._Normlize()
    }

    hidden [void]_Normlize() {
	if ($this.Line -lt 0) {
	    $this.Line = 0
	}
	if ($this.Column -lt 0) {
	    $this.Column = 0
	}
    }
}
