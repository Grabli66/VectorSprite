package vector;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import haxe.xml.Access;

import flixel.util.FlxSpriteUtil;

class VectorSprite extends FlxSprite {
    /**
     * Alpha scale to recalculate it to 0..1
     */
    public inline static final ALPHA_SCALE = 255;

    /**
     * Sprite xml data
     */
    var xml:Access;

    /**
     * Registered brushes
     */
    var brushes = new Map<String, Brush>();

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
     * Create brush
     */
    function createBrush(elem:haxe.xml.Access) {
        var name = elem.att.name;
        var color = Std.parseInt("0x" + elem.att.color);
        var brush:Brush = {
            name: name,
            color: color & 0xFFFFFF,
            alpha: (color >> 24) & 0xFF
        };

        brushes[name] = brush;
    }

    function redraw() {
        var width = Std.parseInt(xml.node.sprite.att.width);
        var height = Std.parseInt(xml.node.sprite.att.height);
        makeGraphic(width, height, FlxColor.TRANSPARENT);

        for (elem in xml.node.sprite.elements) {
            switch elem.name {
                case "brush":
                    createBrush(elem);
                case "rect":
                    createRect(elem);
                case "circle":
                    createCircle(elem);
                case "ellipse":
                    createEllipse(elem);
                case "path":
                    createPath(elem);
            }
        }
    }

    /**
     * Constructor
     */
    public function new(text:String) {
        super();        
        xml = new haxe.xml.Access(Xml.parse(text));

        redraw();
    }
}