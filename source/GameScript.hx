package;

import openfl.filters.ShaderFilter;
import flixel.addons.display.FlxRuntimeShader;
import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.math.FlxRect;
import flixel.math.FlxMath;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.FlxG;
import crowplexus.iris.IrisConfig;
import crowplexus.iris.Iris;

class GameScript extends Iris
{
    public static var packVariable:Map<String, Dynamic> = new Map();
    private var parentObject:Dynamic;
    private var importedScripts:Array<GameScript> = [];

    public function new(scriptCode:String, ?parent:Dynamic) 
    {
        super(Paths.getFileContent('$scriptCode.${Paths.SCRIPT_EXT}'), new IrisConfig(scriptCode, false, true, ["Main"]));
    
        parentObject = parent != null ? parent : FlxG.state;
        
        // Flixel
        set("FlxG", FlxG);
        set("FlxSprite", FlxSprite);
        set("FlxCamera", FlxCamera);
        set("FlxText", FlxText);
        set("FlxGroup", FlxGroup);
        set("FlxSpriteGroup", FlxSpriteGroup);
        set("FlxTypedGroup", FlxTypedGroup);
        set("FlxMath", FlxMath);
        set("FlxRect", FlxRect);
        set("FlxObject", FlxObject);
        set("FlxBasic", FlxBasic);
        set("FlxRuntimeShader", FlxRuntimeShader);
        
        // OpenFL
        set("ShaderFilter", ShaderFilter);

        // Scrapter Engine
        set("Paths", Paths);
        set("GameState", GameState);
        set("GameSubState", GameSubState);
        
        // Variable
        set("game", parentObject);
        set("packVariable", packVariable);

        // Function
        set("setVariable", function (name:String, variable:Dynamic) packVariable.set(name, variable));
        set("getVariable", function (name:String) packVariable.get(name));
        set("hasVariable", function (name:String) packVariable.exists(name));
        set("removeVariable", function (name:String) packVariable.remove(name));
        set("keyJustPressed", function (name:String) return Reflect.getProperty(FlxG.keys.justPressed, name));
        set("keyJustReleased", function (name:String) return Reflect.getProperty(FlxG.keys.justReleased, name));
        set("keyPressed", function (name:String) return Reflect.getProperty(FlxG.keys.pressed, name));
        set("switchState", function (name:String) return FlxG.switchState(() -> new GameState(name)));
        set("openSubState", function (name:String) return FlxG.state.openSubState(new GameSubState(name)));
        set("closeSubState", function () return FlxG.state.subState.closeSubState());
        set("close", function () return FlxG.state.subState.close());
        set("importScript", importScript);
    }

    public function importScript(name:String):Void
    {
        var script:GameScript = new GameScript('data/states/$name', parentObject);
        importedScripts.push(script);
        script.execute();
        script.call("create", []);
    }

    override function execute():Dynamic 
    {
        trace('${config.name} is executed!');
        return super.execute();
    }
    
    override function call(fun:String, ?args:Array<Dynamic>):IrisCall 
    {
        if (fun == null || !exists(fun))
            return null;
        
        var result = super.call(fun, args);
        
        for (script in importedScripts) {
            if (script.exists(fun)) {
                script.call(fun, args);
            }
        }
        
        return result;
    }

    override function destroy():Void
    {
        for (script in importedScripts) {
            script.destroy();
        }
        importedScripts = null;
        super.destroy();
    }
}