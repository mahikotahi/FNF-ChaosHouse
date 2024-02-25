package states;

import lime.app.Application;

class OutdatedState extends MusicBeatState
{
	public static var leftState:Bool = false;

	
	var warnText:FlxText;
	var curVersion:String = Std.string(Application.current.meta.get('version'));


	override function create()
	{
		super.create();

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		var coolname:Dynamic = (FlxG.save.data.pussyName) ? Main.usrName : 'Stupid!';

		var changes:Dynamic = '';
		
		var http = new haxe.Http("https://raw.githubusercontent.com/mahikotahi/FNF-ChaosHouse/main/gitVersion.txt");

		http.onData = function (data:String)
		{
			trace(data);
			http = new haxe.Http("https://raw.githubusercontent.com/mahikotahi/FNF-ChaosHouse/main/gitLog.txt");

			http.onData = function (data:String)
			{
				changes = data;
			}

			http.onError = function (error) {
				trace('error: $error');
			}

			http.request();
		}

		http.onError = function (error) {
			trace('error: $error');
		}

		http.request();

		warnText = new FlxText(0, 0, FlxG.width,
			"Hey "+ coolname +',\n\nIts ${curVersion},\nLooks like you have not been keeping track of the github commits.\nI will List Them:\n\n'+changes,
			32);
		warnText.setFormat("VCR OSD Mono", 12, FlxColor.WHITE, CENTER);
		warnText.screenCenter();
		add(warnText);
	}

	override function update(elapsed:Float)
	{
		if(!leftState) {
			if (controls.ACCEPT) {
				leftState = true;
				CoolUtil.browserLoad("https://github.com/mahikotahi/FNF-ChaosHouse/releases");
			}
			else if(controls.BACK) {
				leftState = true;
			}

			if(leftState)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				FlxTween.tween(warnText, {alpha: 0}, 1, {
					onComplete: function (twn:FlxTween) {
						MusicBeatState.switchState(new MainMenuState());
					}
				});
			}
		}
		super.update(elapsed);
	}
}
