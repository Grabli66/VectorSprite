package vector;

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
	 * Create rect
	 */
	function createRect(elem:haxe.xml.Access) {
		var x = Std.parseInt(elem.att.x);
		var y = Std.parseInt(elem.att.y);
		var width = Std.parseInt(elem.att.width);
		var height = Std.parseInt(elem.att.height);
		applyBrush(elem.att.brush);

		DrawHelper.drawRect(x, y, width, height);
		DrawHelper.endFill();
		DrawHelper.commit(this);
	}

	/**
	 * Create circle
	 */
	function createCircle(elem:haxe.xml.Access) {
		var x = Std.parseInt(elem.att.x);
		var y = Std.parseInt(elem.att.y);
		var radius = Std.parseInt(elem.att.radius);
		applyBrush(elem.att.brush);

		DrawHelper.drawCircle(x, y, radius);
		DrawHelper.endFill();
		DrawHelper.commit(this);
	}

	/**
	 * Create ellipse
	 */
	function createEllipse(elem:haxe.xml.Access) {
		var x = Std.parseInt(elem.att.x);
		var y = Std.parseInt(elem.att.y);
		var width = Std.parseInt(elem.att.width);
		var height = Std.parseInt(elem.att.height);
		applyBrush(elem.att.brush);

		DrawHelper.drawEllipse(x, y, width, height);
		DrawHelper.endFill();
		DrawHelper.commit(this);
	}

	/**
	 * Create path
	 */
	function createPath(elem:haxe.xml.Access) {
		var data = elem.att.data;
		var items = data.split(" ");

		applyBrush(elem.att.brush);

		for (item in items) {
			var points = item.split(",");
			var first = points[0];
			var tp = first.charAt(0); // type of curve
			switch tp {
				case "m":
					var x = Std.parseInt(first.substr(1, first.length));
					var y = Std.parseInt(points[1]);
					DrawHelper.moveTo(x, y);
				case "l":
					var x = Std.parseInt(first.substr(1, first.length));
					var y = Std.parseInt(points[1]);
					DrawHelper.lineTo(x, y);
				case "q":
					var cx = Std.parseInt(first.substr(1, first.length));
					var cy = Std.parseInt(points[1]);
					var ax = Std.parseInt(points[2]);
					var ay = Std.parseInt(points[3]);
					DrawHelper.quadraticCurveTo(cx, cy, ax, ay);
				case "c":
					var cx = Std.parseInt(first.substr(1, first.length));
					var cy = Std.parseInt(points[1]);
					var cx1 = Std.parseInt(points[2]);
					var cy1 = Std.parseInt(points[3]);
					var ax = Std.parseInt(points[4]);
					var ay = Std.parseInt(points[5]);
					DrawHelper.cubicCurveTo(cx, cy, cx1, cy1, ax, ay);
			}
		}

		DrawHelper.endFill();
		DrawHelper.commit(this);
	}

	/**
	 * Create text element
	 */
	function createText(elem:haxe.xml.Access) {
		var x = Std.parseInt(elem.att.x);
		var y = Std.parseInt(elem.att.y);
		var size = 8;
		var color = 0xFFFFFF;

		if (elem.has.size)
			size = Std.parseInt(elem.att.size);

		if (elem.has.color)
			color = Std.parseInt("0x" + elem.att.color);

		var text = elem.att.text;
		var flText = new FlxText();
		flText.text = text;
		flText.setFormat(null, size, color);
		flText.drawFrame(true);
		var matrix = new FlxMatrix();
		matrix.identity();
		matrix.translate(x, y);
		pixels.draw(flText.pixels, matrix);
	}

	/**
	 * Create and append frame
	 * @param elem
	 */
	function createFrame(elem:haxe.xml.Access) {}

	/**
	 * Redraw sprite
	 */
	function redraw() {		
		makeGraphic(Math.round(width), Math.round(height), FlxColor.TRANSPARENT);
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
	 * Parse frame
	 */
	function parseFrame(elem:haxe.xml.Access) {
		for (nod in elem.elements) {
			switch nod.name {
				case "rect":
					createRect(elem);
				case "circle":
					createCircle(elem);
				case "ellipse":
					createEllipse(elem);
				case "path":
					createPath(elem);
				case "text":
					createText(elem); 
			}
		}

		var node:FrameNode = {
			items: []
		};
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
					parseFrame(elem);
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
