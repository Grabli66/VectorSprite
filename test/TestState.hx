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
			<sprite name="simple" width="100" height="40">
				<brush name="red" color="FFFF0033" />
				<brush name="blue" color="FF0033FF" />				
				<brush name="green" color="FF00AA33" />
				<brush name="green2" color="FF008800" />
				<brush name="grey" color="33000000" />
				<frame>
					<rect x="0" y="0" width="100" height="36" brush="green" />
					<rect x="0" y="36" width="100" height="4" brush="green2" />
					<text x="34" y="10" text="Click" color="FFFFFF" size="10" />
				</frame>	
				<frame>
					<rect x="0" y="2" width="100" height="36" brush="green" />
					<rect x="0" y="38" width="100" height="2" brush="green2" />
					<text x="34" y="12" text="Click" color="FFFFFF" size="10" />
				</frame>				
			</sprite>
		');		

		add(sprite);
		sprite.x = 300;
		sprite.y = 300;
		//sprite.antialiasing = true;
		
		//sprite.scale.set(2,2);		
	}

	/**
	 * On update
	 */
	override public function update(elapsed:Float):Void
	{		
		super.update(elapsed);
		//sprite.angle += 2 * elapsed;
	}
}
