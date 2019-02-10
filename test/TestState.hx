import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class TestState extends FlxState
{
	var sprite:vector.VectorSprite;

	/**
	 * On create
	 */
	override public function create():Void
	{
		super.create();

		sprite = new vector.VectorSprite('
			<sprite name="simple" width="100" height="100">			
				<brush name="red" color="FFFF0033" />
				<brush name="blue" color="FFAA0033" />				
				<brush name="green" color="FF00FF33" />
				<brush name="grey" color="33000000" />
				<frame>
					<circle x="50" y="50" radius="50" brush="red" />
				</frame>
				<frame>
					<circle x="50" y="50" radius="50" brush="blue" />
				</frame>
			</sprite>
		');

		add(sprite);
		sprite.x = 300;
		sprite.y = 300;
		sprite.antialiasing = true;
		
		sprite.scale.set(2,2);		
	}

	/**
	 * On update
	 */
	override public function update(elapsed:Float):Void
	{		
		super.update(elapsed);
		sprite.angle += 2 * elapsed;
	}
}
