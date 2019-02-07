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
			<sprite width="100" height="100">
				<brush name="red" color="FFFF0033" />
				<brush name="blue" color="FFAA0033" />				
				<brush name="green" color="FF00FF33" />
				<brush name="grey" color="33000000" />
				<circle x="50" y="50" radius="50" brush="red" />
				<path data="m0,0 l10,10 l10,20 c20,20,100,80,80,80 l0,70, l0,0" brush="blue" />
				<ellipse x="31" y="53" width="50" height="30" brush="grey" />
				<ellipse x="30" y="50" width="50" height="30" brush="green" />
				<ellipse x="35" y="55" width="45" height="25" brush="grey" />			
				<text x="10" y="20" size="14" color="00FF33" text="Hello world" />
			</sprite>
		');
				
		// <rect x="0" y="0" width="100" height="100" brush="red" />
		// <circle x="50" y="50" radius="50" brush="blue" />

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
