package;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxState;

class QuickState extends FlxState
{
	override function create() 
	{
		super.create();
		FlxG.switchState(() -> new GameState("initState"));
	}	
}

class GameState extends FlxState
{
	var scriptFile:GameScript;

	public function new(stateFile:String) 
	{
		super();
		scriptFile = new GameScript('data/states/$stateFile', this);
		scriptFile.execute();
	}

	override public function create():Void
	{
		super.create();
		scriptFile.call("create", []);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		scriptFile.call("update", [elapsed]);
	}

	override public function destroy():Void
	{
		if (scriptFile != null) {
			scriptFile.destroy();
			scriptFile = null;
		}
		super.destroy();
	}
}