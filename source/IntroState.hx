package;

import flixel.system.FlxAssets;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;

class IntroState extends FlxState
{
    override public function create():Void
    {
        super.create();        
        
        var text = new FlxText(0, 0, 0, "Create with Scrapter Engine!", 48);
        text.setFormat(FlxAssets.FONT_DEFAULT, 48, FlxColor.WHITE, CENTER);
        text.screenCenter();
        text.alpha = 0;
        add(text);
        
        FlxTween.tween(text, {alpha: 1}, 1);
        FlxTween.tween(text, {alpha: 0}, 1, {startDelay: 2, onComplete: function(_) {
            FlxG.switchState(() -> new QuickState());
        }});
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
        if (FlxG.keys.justPressed.ENTER) {
            FlxG.switchState(() -> new QuickState());
        }
    }

    override public function destroy():Void
    {
        super.destroy();
    }
}