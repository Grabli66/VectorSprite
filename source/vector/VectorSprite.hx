package vector;

import flixel.util.FlxSpriteUtil;
import openfl.display.BlendMode;
import flixel.graphics.frames.FlxTileFrames;
import flixel.math.FlxPoint;
import openfl.geom.Point;
import vector.FrameNode.PathCommand;
import vector.FrameNode.FrameItem;
import flixel.math.FlxMatrix;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import haxe.xml.Access;

class VectorSprite extends FlxSprite {
	/**
	 * Alpha scale to recalculate it to 0..1
	 */
	public inline static final ALPHA_SCALE = 255;

	/**
	 * Registered brushes
	 */
	var brushes = new Map<String, Brush>();

	/**
	 * Parsed frame nodes
	 */
	var frameNodes = new Array<FrameNode>();

	/**
	 * Name of sprite
	 */
	public var name(default, null):String;

	/**
	 * Apply brush for drawing if it exists and is not current (TODO)
	 */
	function applyBrush(name:String) {
		var brush = brushes[name];
		var color = FlxColor.fromInt(brush.color);
		var alpha = brush.alpha / ALPHA_SCALE;
		DrawHelper.beginFill(color, alpha);
	}

	/**
	 * Draw rect
	 */
	function drawRect(x:Int, y:Int, width:Int, height:Int) {		
		DrawHelper.drawRect(x, y, width, height);
		DrawHelper.endFill();
		DrawHelper.commit(this);
	}

	/**
	 * Draw circle
	 */
	function drawCircle(x:Int, y:Int, radius:Int) {
		DrawHelper.drawCircle(x, y, radius);
		DrawHelper.endFill();
		DrawHelper.commit(this);
	}

	/**
	 * Draw ellipse
	 */
	function drawEllipse(x:Int, y:Int, width:Int, height:Int) {
		DrawHelper.drawEllipse(x, y, width, height);
		DrawHelper.endFill();
		DrawHelper.commit(this);
	}

	/**
	 * Draw path
	 */
	function drawPath(items:Array<PathCommand>) {
		for (item in items) {
			switch item {
				case MoveTo(x, y):
					DrawHelper.moveTo(x, y);
				case LineTo(x, y):
					DrawHelper.lineTo(x, y);
				case QuadricCurveTo(cx, cy, ax, ay):
					DrawHelper.quadraticCurveTo(cx, cy, ax, ay);
				case CubicCurveTo(cx1, cy1, cx2, cy2, ax, ay):
					DrawHelper.cubicCurveTo(cx1, cy1, cx2, cy2, ax, ay);
			}
		}

		DrawHelper.endFill();
		DrawHelper.commit(this);
	}

	/**
	 * Draw text element
	 */
	function drawText(x:Int, y:Int, text:String, color:Int, size:Int) {
		var flText = new FlxText();
		flText.text = text;

		flText.setFormat(null, size, color);
		flText.drawFrame(false);
		var matrix = new FlxMatrix();		
		matrix.identity();
		matrix.translate(x, y);
		pixels.draw(flText.graphic.bitmap, matrix);
	}

	/**
	 * Draw frame node
	 */
	function drawFrameNode(node:FrameNode, offset:Point) {
		for (item in node.items) {
			switch item {
				case Rect(x, y, width, height, brush):
					applyBrush(brush);
					var ox = Math.round(x + offset.x);
					var oy = Math.round(y + offset.y);					
					drawRect(ox, oy, width, height);
				case Circle(x, y, radius, brush):				
					applyBrush(brush);
					var ox = Math.round(x + offset.x);
					var oy = Math.round(y + offset.y);
					drawCircle(ox, oy, radius);
				case Ellipse(x, y, width, height, brush):
					applyBrush(brush);
					drawEllipse(x, y, width, height);
				case Path(items, brush):
					applyBrush(brush);
					drawPath(items);
				case Text(x, y, text, color, size):
					drawText(Math.round(x + offset.x), Math.round(y + offset.y), text, color, size);
			}
		}
	}

	/**
	 * Redraw sprite
	 */
	function redraw() {
		var pwidth = width;
		var pheight = height;

		// Create graphic for frames
		var w = frameNodes.length * Math.round(width);
		makeGraphic(w, Math.round(height), FlxColor.TRANSPARENT, true);

		for (i in 0...frameNodes.length) {
			var frm = frameNodes[i];
			drawFrameNode(frm, new Point(i * (pwidth), 0));
		}
		
		frames = FlxTileFrames.fromGraphic(graphic, FlxPoint.get(pwidth, pheight));
		width = pwidth;
		height = pheight;
	}

	/**
	 * Parse brush
	 */
	function parseBrush(elem:haxe.xml.Access) {
		var name = elem.att.name;
		var color = Std.parseInt("0x" + elem.att.color);
		var brush:Brush = {
			name: name,
			color: color & 0xFFFFFF,
			alpha: (color >> 24) & 0xFF
		};

		brushes[name] = brush;
	}

	/**
	 * Parse rect
	 */
	function parseRect(elem:haxe.xml.Access):FrameItem {
		var x = Std.parseInt(elem.att.x);
		var y = Std.parseInt(elem.att.y);
		var width = Std.parseInt(elem.att.width);
		var height = Std.parseInt(elem.att.height);
		var brush = elem.att.brush;
		return FrameItem.Rect(x, y, width, height, brush);
	}

	/**
	 * Parse circle
	 */
	function parseCircle(elem:haxe.xml.Access):FrameItem {
		var x = Std.parseInt(elem.att.x);
		var y = Std.parseInt(elem.att.y);
		var radius = Std.parseInt(elem.att.radius);
		var brush = elem.att.brush;
		return FrameItem.Circle(x, y, radius, brush);
	}

	/**
	 * Parse ellipse
	 */
	function parseEllipse(elem:haxe.xml.Access):FrameItem {
		var x = Std.parseInt(elem.att.x);
		var y = Std.parseInt(elem.att.y);
		var width = Std.parseInt(elem.att.width);
		var height = Std.parseInt(elem.att.height);
		var brush = elem.att.brush;
		return FrameItem.Ellipse(x, y, width, height, brush);
	}

	/**
	 * Create path
	 */
	function parsePath(elem:haxe.xml.Access):FrameItem {
		var data = elem.att.data;
		var items = data.split(" ");

		var commands:Array<PathCommand> = [];

		for (item in items) {
			var points = item.split(",");
			var first = points[0];
			var tp = first.charAt(0); // type of curve
			switch tp {
				case "m":
					var x = Std.parseInt(first.substr(1, first.length));
					var y = Std.parseInt(points[1]);
					commands.push(PathCommand.MoveTo(x, y));
				case "l":
					var x = Std.parseInt(first.substr(1, first.length));
					var y = Std.parseInt(points[1]);
					commands.push(PathCommand.LineTo(x, y));
				case "q":
					var cx = Std.parseInt(first.substr(1, first.length));
					var cy = Std.parseInt(points[1]);
					var ax = Std.parseInt(points[2]);
					var ay = Std.parseInt(points[3]);
					commands.push(PathCommand.QuadricCurveTo(cx, cy, ax, ay));
				case "c":
					var cx = Std.parseInt(first.substr(1, first.length));
					var cy = Std.parseInt(points[1]);
					var cx1 = Std.parseInt(points[2]);
					var cy1 = Std.parseInt(points[3]);
					var ax = Std.parseInt(points[4]);
					var ay = Std.parseInt(points[5]);
					commands.push(PathCommand.CubicCurveTo(cx, cy, cx1, cy1, ax, ay));
			}
		}

		var brush = elem.att.brush;

		return FrameItem.Path(commands, brush);
	}

	/**
	 * Parse text
	 */
	function parseText(elem:haxe.xml.Access) {
		var x = Std.parseInt(elem.att.x);
		var y = Std.parseInt(elem.att.y);
		var text = elem.att.text;
		var size = 8;
		var color = 0xFFFFFF;

		if (elem.has.size)
			size = Std.parseInt(elem.att.size);

		if (elem.has.color)
			color = Std.parseInt("0x" + elem.att.color);

		return FrameItem.Text(x, y, text, color, size);
	}

	/**
	 * Parse frame
	 */
	function parseFrame(elem:haxe.xml.Access) {
		var items:Array<FrameItem> = [];
		for (nod in elem.elements) {
			switch nod.name {
				case "rect":
					items.push(parseRect(nod));
				case "circle":
					items.push(parseCircle(nod));
				case "ellipse":
					items.push(parseEllipse(nod));
				case "path":
					items.push(parsePath(nod));
				case "text":
					items.push(parseText(nod));
			}
		}

		var node:FrameNode = {
			items: items
		};

		return node;
	}

	/**
	 * Parse xml to nodes
	 */
	function parseXml(xml:Access) {
		width = Std.parseInt(xml.node.sprite.att.width);
		height = Std.parseInt(xml.node.sprite.att.height);
		if (xml.node.sprite.has.name)
			name = xml.node.sprite.att.name;

		for (elem in xml.node.sprite.elements) {
			switch elem.name {
				case "brush":
					parseBrush(elem);
				case "frame":
					frameNodes.push(parseFrame(elem));
			}
		}
	}

	/**
	 * Constructor
	 */
	public function new(text:String) {
		super();
		var xml = new haxe.xml.Access(Xml.parse(text));		
		parseXml(xml);
		redraw();
	}
}
