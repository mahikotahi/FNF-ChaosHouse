package states;

import flixel.FlxObject;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import states.editors.MasterEditorMenu;
import options.OptionsState;
import backend.Song;
import backend.Highscore;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.7.3'; // This is also used for Discord RPC
	public static var curSelected:Int = 0;
	public static var currentSelection:String = '';

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	
	var desktop:FlxSprite;
	var terminal:FlxSprite;
	
	var mouse:FlxSprite;

	var game:PlayState = PlayState.instance;

	override function create()
	{
		#if MODS_ALLOWED
		Mods.pushGlobalMods();
		#end
		Mods.loadTopMod();

		#if DISCORD_ALLOWED
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Desktop", null);
		#end

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;
		var bg:FlxSprite = new FlxSprite(0).loadGraphic(Paths.image('menuBG'));
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.scrollFactor.set(0, 0);
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
		//add(bg);

		magenta = new FlxSprite(0).loadGraphic(Paths.image('menuDesat'));
		magenta.antialiasing = ClientPrefs.data.antialiasing;
		magenta.scrollFactor.set(0, 0);
		magenta.setGraphicSize(Std.int(magenta.width * 1.175));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = true;
		magenta.color = 0xff21d9ee;
		add(magenta);

		terminal = new FlxSprite(80, 70);
		terminal.antialiasing = ClientPrefs.data.antialiasing;
		terminal.frames = Paths.getSparrowAtlas('mainmenu/MenuShit');
		terminal.animation.addByPrefix('termina', "Terminal", 24);
		terminal.animation.play('termina');
		add(terminal);

		desktop = new FlxSprite(terminal.x + terminal.width + 48, 60);
		desktop.antialiasing = ClientPrefs.data.antialiasing;
		desktop.frames = Paths.getSparrowAtlas('mainmenu/MenuShit');
		desktop.animation.addByPrefix('desktop', "Animate", 24);
		desktop.animation.play('desktop');
		add(desktop);


		var fnfVer:FlxText = new FlxText(12, FlxG.height - 24, 0, "Chaos House" + Application.current.meta.get('version'), 12);
		fnfVer.scrollFactor.set();
		fnfVer.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(fnfVer);

		#if ACHIEVEMENTS_ALLOWED
		// Unlocks "Freaky on a Friday Night" achievement if it's a Friday and between 18:00 PM and 23:59 PM
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18)
			Achievements.unlock('friday_night_play');

		#if MODS_ALLOWED
		Achievements.reloadList();
		#end
		#end
		
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
		mouse.animation.play(ClientPrefs.data.cursorColor);
		add(mouse);
		
		//FlxG.mouse.visible = true;

		super.create();

		//FlxG.camera.follow(camFollow, null, 9);
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		var realMouse:Dynamic = FlxG.mouse;
		
		mouse.setPosition(realMouse.x, realMouse.y);
		
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * elapsed;
			if (FreeplayState.vocals != null)
				FreeplayState.vocals.volume += 0.5 * elapsed;
		}

		if (mouse.overlaps(terminal))
		{
			currentSelection = 'terminal';
		}
		else if (mouse.overlaps(desktop))
		{
			currentSelection = 'desktop';
		}
		else
		{
			currentSelection = '';
		}

		if (FlxG.mouse.justReleased)
		{
			switch(currentSelection)
			{
				case 'terminal':
					trace('terminal');

					#if DISCORD_ALLOWED
					// Updating Discord Rich Presence
					DiscordClient.changePresence("Terminal", null);
					#end
				case 'desktop':
					trace('desktop');

					#if DISCORD_ALLOWED
					// Updating Discord Rich Presence
					DiscordClient.changePresence("Adobe Animate 2021", null);
					#end
					loadSong('Stick');
				default:
					trace('nun');
			}
		}

		if (!selectedSomethin)
		{
			/*if (controls.UI_UP_P)
				changeItem(-1);

			if (controls.UI_DOWN_P)
				changeItem(1);

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));
				if (optionShit[curSelected] == 'donate')
				{
					CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin');
				}
				else
				{
					selectedSomethin = true;

					if (ClientPrefs.data.flashing)
						FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					FlxFlicker.flicker(menuItems.members[curSelected], 1, 0.06, false, false, function(flick:FlxFlicker)
					{
						switch (optionShit[curSelected])
						{
							case 'story_mode':
								MusicBeatState.switchState(new StoryMenuState());
							case 'freeplay':
								MusicBeatState.switchState(new FreeplayState());

							#if MODS_ALLOWED
							case 'mods':
								MusicBeatState.switchState(new ModsMenuState());
							#end

							#if ACHIEVEMENTS_ALLOWED
							case 'awards':
								MusicBeatState.switchState(new AchievementsMenuState());
							#end

							case 'credits':
								MusicBeatState.switchState(new CreditsState());
							case 'options':
								MusicBeatState.switchState(new OptionsState());
								OptionsState.onPlayState = false;
								if (PlayState.SONG != null)
								{
									PlayState.SONG.arrowSkin = null;
									PlayState.SONG.splashSkin = null;
									PlayState.stageUI = 'normal';
								}
						}
					});

					for (i in 0...menuItems.members.length)
					{
						if (i == curSelected)
							continue;
						FlxTween.tween(menuItems.members[i], {alpha: 0}, 0.4, {
							ease: FlxEase.quadOut,
							onComplete: function(twn:FlxTween)
							{
								menuItems.members[i].kill();
							}
						});
					}
				}
			}*/
			
			#if desktop
			if (controls.justPressed('debug_1'))
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end

		}

		super.update(elapsed);
	}

	function loadSong(?name:String = null, ?difficultyNum:Int = 1) {
		
	
		var game:PlayState = PlayState.instance;
	
		if(name == null || name.length < 1)
			name = 'Sticks';
		if (difficultyNum == -1)
			difficultyNum = 1;

		var poop = Highscore.formatSong(name, 1);
		PlayState.SONG = Song.loadFromJson(poop, name);
		PlayState.storyDifficulty = 1;
		LoadingState.loadAndSwitchState(new PlayState());

		FlxG.sound.music.pause();
		FlxG.sound.music.volume = 0;
		if(game.vocals != null)
		{
			game.vocals.pause();
			game.vocals.volume = 0;
		}
		FlxG.camera.followLerp = 0;
	}
}
