package options;

import objects.Note;
import objects.StrumNote;
import objects.Alphabet;
import flixel.FlxSprite;

class Desktop extends BaseOptionsMenu
{
	var cursor:FlxTypedGroup<FlxSprite>;

	var mouse:FlxSprite;

	public function new()
	{
		title = 'Window';
		rpcTitle = 'Desktop Menu'; // for Discord Rich Presence

		// desktopbg

		var option:Option = new Option('Cursor Color', "Set your Cursor Color!", 'cursorColor', 'string', [
			'red', 'orange', 'yellow', 'green', 'lime', 'cyan', 'blue', 'purple', 'pink', 'brown', 'gray', 'white', 'black'
		]);
		addOption(option);

		var option:Option = new Option('Desktop Background', "Set your Desktop Background", 'desktopbg', 'string', ['hill', 'the table']);
		addOption(option);

		var option:Option = new Option('Cursor Size', "Set your Cursor Size", 'cursorsize', 'float');
		option.minValue = 0.5;
		option.maxValue = 2;
		option.changeValue = 0.1;
		addOption(option);

		cursor = new FlxTypedGroup<FlxSprite>();

		mouse = new FlxSprite(0, 0);
		mouse.frames = Paths.getSparrowAtlas('mainmenu/cursor');
		mouse.animation.addByPrefix('white', "white", 24);
		mouse.animation.addByPrefix('gray', "gray", 24);
		mouse.animation.addByPrefix('black', "black", 24);
		mouse.animation.addByPrefix('red', "red", 24);
		mouse.animation.addByPrefix('orange', "orange", 24);
		mouse.animation.addByPrefix('yellow', "yellow", 24);
		mouse.animation.addByPrefix('green', "green", 24);
		mouse.animation.addByPrefix('lime', "lime", 24);
		mouse.animation.addByPrefix('cyan', "cyan", 24);
		mouse.animation.addByPrefix('blue', "blue", 24);
		mouse.animation.addByPrefix('purple', "purple", 24);
		mouse.animation.addByPrefix('pink', "pink", 24);
		mouse.animation.addByPrefix('brown', "brown", 24);
		mouse.scale.set(ClientPrefs.data.cursorsize, ClientPrefs.data.cursorsize);
		mouse.animation.play(ClientPrefs.data.cursorColor);
		cursor.add(mouse);

		super();
	}

	override function create()
	{
		add(cursor);
		super.create();
	}

	override function update(elapsed:Float)
	{
		var realMouse:Dynamic = FlxG.mouse;

		cursor.members[0].scale.set(ClientPrefs.data.cursorsize, ClientPrefs.data.cursorsize);
		cursor.members[0].animation.play(ClientPrefs.data.cursorColor);
		cursor.members[0].setPosition(realMouse.x, realMouse.y);

		if (ClientPrefs.data.desktopbg == 'the table')
			FlxG.sound.music.stop();

		super.update(elapsed);
	}

	override function changeSelection(change:Int = 0)
	{
		super.changeSelection(change);
	}

	var changedMusic:Bool = false;

	function onChangePauseMusic()
	{
		if (ClientPrefs.data.pauseMusic == 'None')
			FlxG.sound.music.volume = 0;
		else
			FlxG.sound.playMusic(Paths.music(Paths.formatToSongPath(ClientPrefs.data.pauseMusic)));

		if (ClientPrefs.data.desktopbg == 'the table')
			FlxG.sound.music.stop();

		changedMusic = true;
	}

	override function destroy()
	{
		if (changedMusic && !OptionsState.onPlayState)
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 1, true);

		if (ClientPrefs.data.desktopbg == 'the table')
			FlxG.sound.music.stop();
		super.destroy();
	}

	#if !mobile
	function onChangeFPSCounter()
	{
		if (Main.fpsVar != null)
			Main.fpsVar.visible = ClientPrefs.data.showFPS;
	}
	#end
}
