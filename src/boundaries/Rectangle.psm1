using module "./src/boundaries/Point.psm1"

class Rectangle {
    [Point]$p1
    [Point]$p2
    
    Rectangle([Point]$p1, [Point]$p2) {
	$this.p1 = $p1
	$this.p2 = $p2
    }
}
