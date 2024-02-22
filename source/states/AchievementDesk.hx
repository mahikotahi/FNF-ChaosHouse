package states;

class AchievementDesk extends MusicBeatState
{
    override public function create() 
    {
        var bg:FlxSprite = new FlxSprite(0,0).loadGraphic(Paths.image('Achievementa'));
        bg.screenCenter();
        add(bg);

        super.create();
    }
}