package options;

import objects.Note;
import objects.StrumNote;
import objects.Alphabet;

class Desktop extends BaseOptionsMenu
{
	var noteOptionID:Int = -1;
	var notes:FlxTypedGroup<StrumNote>;
	var notesTween:Array<FlxTween> = [];
	var noteY:Float = 90;
	public function new()
	{
		title = 'Window';
		rpcTitle = 'Desktop Menu'; //for Discord Rich Presence

		var option:Option = new Option('Cursor Color',
			"Set your Cursor Color!",
			'cursorColor',
			'string',
			['red', 'orange', 'yellow', 'green', 'lime', 'cyan', 'blue', 'purple', 'pink', 'brown', 'gray', 'white', 'black']);
		addOption(option);

		super();
	}

	override function changeSelection(change:Int = 0)
	{
		super.changeSelection(change);
	}

	var changedMusic:Bool = false;
	function onChangePauseMusic()
	{
		if(ClientPrefs.data.pauseMusic == 'None')
			FlxG.sound.music.volume = 0;
		else
			FlxG.sound.playMusic(Paths.music(Paths.formatToSongPath(ClientPrefs.data.pauseMusic)));

		changedMusic = true;
	}

	override function destroy()
	{
		if(changedMusic && !OptionsState.onPlayState) FlxG.sound.playMusic(Paths.music('freakyMenu'), 1, true);
		super.destroy();
	}

	#if !mobile
	function onChangeFPSCounter()
	{
		if(Main.fpsVar != null)
			Main.fpsVar.visible = ClientPrefs.data.showFPS;
	}
	#end
}
