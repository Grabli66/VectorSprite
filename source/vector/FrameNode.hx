package vector;

/**
 * Command to create path
 */
enum PathCommand {
	MoveTo(x:Int, y:Int);
	LineTo(x:Int, y:Int);
	QuadricCurveTo(controlx:Int, controly:Int, anchorx:Int, anchory:Int);
	CubicCurveTo(controlx1:Int, controly1:Int, controlx2:Int, controly2:Int, anchorx:Int, anchory:Int);
}

/**
 * Frame item
 */
enum FrameItem {
	Circle(x:Int, y:Int, radius:Int, brush:String);
	Rect(x:Int, y:Int, width:Int, height:Int, brush:String);
	Ellipse(x:Int, y:Int, width:Int, height:Int, brush:String);
	Path(commands:Array<PathCommand>, brush:String);
	Text(x:Int, y:Int, text:String, color:Int, size:Int);
}

/**
 * Frame node
 */
typedef FrameNode = {
	var items:Array<FrameItem>;
}
