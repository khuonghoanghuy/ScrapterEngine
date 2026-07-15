package;

import flixel.FlxSubState;

class GameSubState extends FlxSubState
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