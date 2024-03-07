package substates;

import states.MainMenuState;
import psychlua.LuaUtils;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;

using StringTools;

class RankSub extends MusicBeatSubstate
{	
	var bgcolor:Dynamic = 0xFF40EB9E;

	override public function create()
	{

		var bg:FlxSprite;
		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.color = bgcolor;
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.scrollFactor.set();
		bg.screenCenter();
		bg.alpha = 0.5;
		add(bg);

		trace('we funkin!');

		super.create();
	}

	override public function update(elapsed:Float)
	{
		if (controls.ACCEPT)
		{
			MusicBeatState.switchState(new MainMenuState());
			closeSubState();
		}

		super.update(elapsed);
	}
}
