package states.editors;

import openfl.net.FileFilter;
import flixel.addons.display.FlxBackdrop;
import flash.geom.Rectangle;
import haxe.Json;
import haxe.format.JsonParser;
import haxe.io.Bytes;
import flixel.FlxObject;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUIDropDownMenu;
import flixel.addons.ui.FlxUINumericStepper;
import flixel.addons.ui.FlxUISlider;
import flixel.addons.ui.FlxUITabMenu;
import flixel.group.FlxGroup;
import flixel.ui.FlxButton;
import flixel.util.FlxSort;
import lime.media.AudioBuffer;
import lime.utils.Assets;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.media.Sound;
import openfl.net.FileReference;
import openfl.utils.Assets as OpenFlAssets;
import backend.Song;
import backend.Section;
import backend.StageData;
import objects.Note;
import objects.StrumNote;
import objects.NoteSplash;
import objects.HealthIcon;
import objects.AttachedSprite;
import objects.Character;
import substates.Prompt;
#if sys
import flash.media.Sound;
#end

class NewChartingState extends MusicBeatState
{

    override public function create()
    {
        super.create();
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);
    }
    
}