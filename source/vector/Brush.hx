package vector;

import flixel.util.FlxSpriteUtil.DrawStyle;

/**
 * Draw brush
 */
typedef Brush = {>DrawStyle,
    name: String,
    color: Int,
    alpha: Float
}