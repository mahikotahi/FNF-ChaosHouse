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
	var notepad:FlxSprite;
	var tubeyou:FlxSprite;
	var vsc:FlxSprite;

	var mouse:FlxSprite;

	var game:PlayState = PlayState.instance;
	var coolwindow:FlxSprite;

	var mouseClickAmount:Int = 0;

	public static var timePassedOnState:Float = 0;

	var appPos:Array<Array<Int>> = [[0, 0]];

	override function create()
	{
		attempts = 0;

		StatusShit.status = '';

		#if MODS_ALLOWED
		Mods.pushGlobalMods();
		#end
		Mods.loadTopMod();

		#if DISCORD_ALLOWED
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Desktop", null);
		#end

		// transIn = FlxTransitionableState.defaultTransIn;
		// transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;
		var bg:FlxSprite = new FlxSprite(0).loadGraphic(Paths.image('menuBG'));
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.scrollFactor.set(0, 0);
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
		// add(bg);

		// magenta = new FlxSprite(0).loadGraphic(Paths.image('menuDesat'));
		magenta = new FlxSprite(0).loadGraphic(Paths.image('mainmenu/background'));
		magenta.antialiasing = ClientPrefs.data.antialiasing;
		magenta.scrollFactor.set(0, 0);
		magenta.setGraphicSize(Std.int(magenta.width * 1.175));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = true;
		// magenta.color = 0xff21d9ee;
		add(magenta);

		createCoolIcons();

		var desktopIcon:FlxSprite = new FlxSprite(12, FlxG.height - 64);
		desktopIcon.frames = Paths.getSparrowAtlas('mainmenu/desktopIcon');
		desktopIcon.animation.addByPrefix('default', "windowLogo", 24, true);
		desktopIcon.animation.play('default');
		add(desktopIcon);

		var fnfVer:FlxText = new FlxText(0, 0, 0, "Chaos Desktop " + Application.current.meta.get('version'), 12);
		fnfVer.scrollFactor.set();
		fnfVer.setPosition(desktopIcon.x + desktopIcon.width + 8, FlxG.height - 32);
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
		// mouse.scale.set(0.85, 0.85);
		mouse.animation.play(ClientPrefs.data.cursorColor);
		add(mouse);

		// FlxG.mouse.visible = true;

		coolwindow = new FlxSprite(0, 0);
		coolwindow.loadGraphic(Paths.image('mainmenu/dawindow'));
		coolwindow.screenCenter(XY);
		coolwindow.alpha = 0;
		add(coolwindow);

		initVirusPIC();

		super.create();

		// FlxG.camera.follow(camFollow, null, 9);
	}

	var selectedSomethin:Bool = false;
	var division:Float = 3;

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

		var prevCurSel:String = currentSelection;

		currentSelection = '';

		if (mouse.overlaps(terminal))
		{
			currentSelection = 'terminal';
		}
		else if (mouse.overlaps(desktop))
		{
			currentSelection = 'desktop';
		}
		else if (mouse.overlaps(tubeyou))
		{
			currentSelection = 'youtube';
		}
		else if (mouse.overlaps(notepad))
		{
			currentSelection = 'notepad';
		}
		else if (mouse.overlaps(vsc))
		{
			currentSelection = 'visul';
		}

		if (prevCurSel != currentSelection)
			mouseClickAmount = 0;

		if (FlxG.mouse.justReleased && mouseClickAmount != 3 && virusPIC.alpha < 1)
			mouseClickAmount++;

		if (FlxG.keys.pressed.SHIFT && FlxG.mouse.pressed && virusPIC.alpha < 1)
		{
			switch (currentSelection)
			{
				case 'terminal':
					terminal.setPosition(realMouse.x - (terminal.width / division), realMouse.y - (terminal.height / division));

				case 'desktop':
					desktop.setPosition(realMouse.x - (desktop.width / division), realMouse.y - (desktop.height / division));

				case 'youtube':
					tubeyou.setPosition(realMouse.x - (tubeyou.width / division), realMouse.y - (tubeyou.height / division));

				case 'notepad':
					notepad.setPosition(realMouse.x - (notepad.width / division), realMouse.y - (notepad.height / division));

				case 'visul':
					vsc.setPosition(realMouse.x - (vsc.width / division), realMouse.y - (vsc.height / division));
			}
		}

		if (FlxG.mouse.justReleased && mouseClickAmount == 2 && virusPIC.alpha < 1)
		{
			StatusShit.status = '';
			var WindowAnimate:Bool = true;

			switch (currentSelection)
			{
				case 'terminal':
					trace('terminal');

					#if DISCORD_ALLOWED
					// Updating Discord Rich Presence
					DiscordClient.changePresence("Terminal", null);
					#end

					MusicBeatState.switchState(new OptionsState());
					if (ClientPrefs.data.pauseMusic != 'None')
					{
						FlxG.sound.playMusic(Paths.music(Paths.formatToSongPath(ClientPrefs.data.pauseMusic)), 0.5);
						FlxTween.tween(FlxG.sound.music, {volume: 1}, 0.8);
					}
					OptionsState.onPlayState = false;
				case 'notepad':
					trace('notepad');

					#if DISCORD_ALLOWED
					// Updating Discord Rich Presence
					DiscordClient.changePresence("Notepad", null);
					#end

					MusicBeatState.switchState(new CreditsState());

				case 'desktop':
					trace('adobe animate');

					#if DISCORD_ALLOWED
					// Updating Discord Rich Presence
					DiscordClient.changePresence("Adobe Animate 2021", null);
					#end
					StatusShit.status = 'Adobe Animate 2021';
					loadSong('Stick');

				case 'youtube':
					trace('youtube');
					if (Application.current.meta.get('version') == '[DEMO]')
					{
						WindowAnimate = false;
						virusPIC.animation.play('stop');
						attempts++;

						if (attempts >= 4)
							virusPIC.animation.play('warn');

						if (attempts >= 12 || FlxG.save.data.pissedDad)
						{
							FlxG.sound.music.stop();
							virusPIC.animation.play('ipaddress');
						}

						// virusTEXT

						FlxTween.tween(virusPIC, {alpha: 1}, 0.2, {
							onComplete: function(twn:FlxTween)
							{
								new FlxTimer().start(1, function(tmr:FlxTimer)
								{
									FlxTween.tween(virusPIC, {alpha: 0}, 0.2, {
										onUpdate: function(twn:FlxTween)
											{
												if (attempts >= 12 || FlxG.save.data.pissedDad)
												{
													FlxG.save.data.pissedDad = true;
													virusTEXT.alpha = virusPIC.alpha;
												}
											},onComplete: function(twn:FlxTween)
												{
													if (attempts >= 12 || FlxG.save.data.pissedDad)
													{
														FlxG.save.data.pissedDad = true;
														virusTEXT.alpha = virusPIC.alpha;
													}
												}
									});
								});
							},
							onUpdate: function(twn:FlxTween)
							{
								if (attempts >= 12 || FlxG.save.data.pissedDad)
								{
									FlxG.save.data.pissedDad = true;
									virusTEXT.alpha = virusPIC.alpha;
								}
							}
						});
					}

					#if DISCORD_ALLOWED
					// Updating Discord Rich Presence
					// DiscordClient.changePresence("Youtube", null);
					#end
					StatusShit.status = 'Youtube';
				// loadSong('Stick');

				case 'visul':
					trace('visual');

					#if DISCORD_ALLOWED
					// Updating Discord Rich Presence
					DiscordClient.changePresence("Visual Studio Code", null);
					#end

					coolwindow.loadGraphic(Paths.image('Achievementa'));
					coolwindow.screenCenter();

					MusicBeatState.switchState(new AchievementDesk());

				default:
					trace(currentSelection);
					WindowAnimate = false;
			}

			if (WindowAnimate)
			{
				FlxTween.tween(coolwindow, {alpha: 1}, 0.5, {
					onUpdate: function(twn:FlxTween)
					{
						coolwindow.scale.x = coolwindow.alpha * 2;
						coolwindow.scale.y = coolwindow.alpha * 2;
					}
				});
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

		if (controls.BACK)
		{
			//selectedSomethin = true;
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new TitleState());
		}


		super.update(elapsed);
	}

	function loadSong(?name:String = null, ?difficultyNum:Int = 1)
	{
		var game:PlayState = PlayState.instance;

		if (name == null || name.length < 1)
			name = 'Sticks';
		if (difficultyNum == -1)
			difficultyNum = 1;

		var poop = Highscore.formatSong(name, 1);
		PlayState.SONG = Song.loadFromJson(poop, name);
		PlayState.storyDifficulty = 1;
		LoadingState.loadAndSwitchState(new PlayState());

		FlxG.sound.music.pause();
		FlxG.sound.music.volume = 0;
		FlxG.camera.followLerp = 0;
	}

	function createCoolIcons()
	{
		terminal = new FlxSprite(20, 70);
		terminal.antialiasing = ClientPrefs.data.antialiasing;
		terminal.frames = Paths.getSparrowAtlas('mainmenu/MenuShit');
		terminal.animation.addByPrefix('termina', "Terminal", 24);
		terminal.animation.play('termina');
		add(terminal);

		notepad = new FlxSprite(20, 70 + terminal.height + 20);
		notepad.antialiasing = ClientPrefs.data.antialiasing;
		notepad.frames = Paths.getSparrowAtlas('mainmenu/MenuShit');
		notepad.animation.addByPrefix('nopa', "Notepad", 24);
		notepad.animation.play('nopa');
		add(notepad);

		desktop = new FlxSprite(terminal.x + terminal.width + 48, 60);
		desktop.antialiasing = ClientPrefs.data.antialiasing;
		desktop.frames = Paths.getSparrowAtlas('mainmenu/MenuShit');
		desktop.animation.addByPrefix('desktop', "Animate", 24);
		desktop.animation.play('desktop');
		add(desktop);

		tubeyou = new FlxSprite(desktop.x + desktop.width + 48, 80);
		tubeyou.antialiasing = ClientPrefs.data.antialiasing;
		tubeyou.frames = Paths.getSparrowAtlas('mainmenu/MenuShit');
		tubeyou.animation.addByPrefix('yout', "Youtube", 24);
		tubeyou.animation.play('yout');
		add(tubeyou);

		vsc = new FlxSprite(notepad.x + notepad.width + 60, notepad.y + 15);
		vsc.antialiasing = ClientPrefs.data.antialiasing;
		vsc.frames = Paths.getSparrowAtlas('mainmenu/MenuShit');
		vsc.animation.addByPrefix('vc', "VSC", 24);
		vsc.animation.play('vc');
		add(vsc);
	}

	var virusPIC:FlxSprite;
	var virusTEXT:FlxText;
	var attempts:Int = 0;

	public function initVirusPIC()
	{
		virusPIC = new FlxSprite(0, 0);
		virusPIC.frames = Paths.getSparrowAtlas('virus');
		virusPIC.animation.addByPrefix('stop', 'DadWarning', 24);
		virusPIC.animation.addByPrefix('warn', 'DadAnnoyed', 24);
		virusPIC.animation.addByPrefix('ipaddress', 'pinkBg', 24);

		virusPIC.antialiasing = ClientPrefs.data.antialiasing;
		virusPIC.screenCenter();
		virusPIC.alpha = 0;

		virusPIC.animation.play('stop');

		add(virusPIC);

		virusTEXT = new FlxText(0, 0, 0, Main.usrName + ".\n I'm not in the mood.", 16);
		virusTEXT.screenCenter();
		virusTEXT.alpha = 0;
		add(virusTEXT);
	}
}
