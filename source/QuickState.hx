package;

import flixel.*;

class QuickState extends FlxState
{
	override function create() 
	{
		super.create();
		FlxG.switchState(() -> new GameState("initState"));
	}	
}