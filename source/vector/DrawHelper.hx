package vector;

import flixel.util.FlxSpriteUtil;
import openfl.display.BlendMode;
import flixel.FlxSprite;
import flash.display.Sprite;
import flash.display.Graphics;

/**
 * For drawing vector graphics
 */
class DrawHelper {
	public static var flashGfxSprite(default, null):Sprite = new Sprite();
	public static var flashGfx(default, null):Graphics = flashGfxSprite.graphics;

	public static inline function beginFill(color:Int = 0, alpha:Float = 1):Void {
		flashGfx.clear();
		flashGfx.beginFill(color, alpha);
	}

	public static inline function endFill():Void {
		flashGfx.endFill();
	}

	public static inline function drawRect(x:Float, y:Float, width:Float, height:Float):Void {
		flashGfx.drawRect(x, y, width, height);
	}

	public static inline function drawCircle(x:Float, y:Float, radius:Float):Void {
		flashGfx.drawCircle(x, y, radius);
	}

	public static function drawEllipse(x:Float, y:Float, width:Float, height:Float):Void {
		flashGfx.drawEllipse(x, y, width, height);
	}

	public static inline function moveTo(x:Float, y:Float):Void {
		flashGfx.moveTo(x, y);
	}

	public static inline function lineTo(x:Float, y:Float):Void {
		flashGfx.lineTo(x, y);
	}

	public static function cubicCurveTo(controlX1:Float, controlY1:Float, controlX2:Float, controlY2:Float, anchorX:Float, anchorY:Float):Void {
		flashGfx.cubicCurveTo(controlX1, controlY1, controlX2, controlY2, anchorX, anchorY);
	}

	public static inline function quadraticCurveTo(controlX:Float, controlY:Float, anchorX:Float, anchorY:Float):Void {
		flashGfx.curveTo(controlX, controlY, anchorX, anchorY);
	}

	public static inline function commit(sprite:FlxSprite):Void {
		sprite.pixels.draw(flashGfxSprite);
	}
}
