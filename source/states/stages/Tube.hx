package states.stages;

import states.stages.objects.*;
import objects.Character;

class Tube extends BaseStage
{
	override function create()
	{
		var bg:BGSprite = new BGSprite('Tube', 0, 0);
		bg.scale.set(4, 4);

		bg.screenCenter();
		add(bg);

        var epic:BGSprite = new BGSprite('EpicStickman', 0,0,1,1,['EpicStickman'], true);
		epic.scale.set(4, 4);

		epic.screenCenter();
		add(epic);
	}
}