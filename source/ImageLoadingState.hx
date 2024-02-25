package;

import sys.io.File;
import sys.FileSystem;

using StringTools;

class ImageLoadingState extends MusicBeatState
{
	public static function readFiles()
	{
		var filesToRead:Array<String> = [];
		var filePaths:Array<String> = [];

		try
		{
			for (folder in FileSystem.readDirectory('assets'))
			{
				// trace('assets/' + FileSystem.readDirectory('assets/' + folder));

				try
				{
					for (otherfolder in FileSystem.readDirectory('assets/${folder}'))
					{
						if (FileSystem.readDirectory('assets/' + folder + '/' + otherfolder) != null)
						{
							if (FileSystem.readDirectory('assets/' + folder + '/' + otherfolder) != null)
								//trace('Loaded: ' + FileSystem.readDirectory('assets/' + folder + '/' + otherfolder));

							if (!otherfolder.contains('.'))
							{
								try
								{
									for (otherotherfolder in FileSystem.readDirectory('assets/${folder}/${otherfolder}'))
									{
										if (FileSystem.readDirectory('assets/' + folder + '/' + otherfolder + '/' + otherotherfolder) != null)
										{
											//trace('Loaded: ' + FileSystem.readDirectory('assets/' + folder + '/' + otherfolder + '/' + otherotherfolder));

											var coolfolder:Array<Dynamic> = FileSystem.readDirectory('${otherfolder}/'+otherotherfolder);

											for (i in 0...coolfolder.length)
											{
                                                //trace('Loaded: '+coolfolder[i]);
                                                //trace(coolfolder[i]);
												filesToRead.push(Std.string(coolfolder[i]));
                                                filePaths.push(Std.string('assets/${folder}/${otherfolder}/'+otherotherfolder));
											}
										}
									}
								}
								catch (e:Dynamic)
								{
									trace(e);
								}
							}
							else
							{
								var coolfolder:Array<Dynamic> = FileSystem.readDirectory('assets/${folder}/${otherfolder}');

								for (i in 0...coolfolder.length)
								{
                                   // trace('Loaded: '+coolfolder[i]);
									filesToRead.push(Std.string(coolfolder[i]));
                                    filePaths.push(Std.string('assets/${folder}/${otherfolder}'));
								}
							}
						}
					}
				}
				catch (e:Dynamic)
				{
					trace(e);
				}
			}
		}
		catch (e:Dynamic)
		{
			trace(e);
		}

        //trace(filesToRead);
        for (i in 0...filesToRead.length) {

            var cooltype:String = 'UFT';

            cooltype = checkFileEnding('.png', filesToRead[i], 'Image');
            cooltype = checkFileEnding('.json', filesToRead[i], 'JSON');
            cooltype = checkFileEnding('.lua', filesToRead[i], 'Lua');
            cooltype = checkFileEnding('.xml', filesToRead[i], 'XML');
            cooltype = checkFileEnding('.ogg', filesToRead[i], 'Sound');
            cooltype = checkFileEnding('.mp3', filesToRead[i], 'Sound');
            cooltype = checkFileEnding('.mp4', filesToRead[i], 'Video');
            cooltype = checkFileEnding('.txt', filesToRead[i], 'Text');
            cooltype = checkFileEnding('.ttf', filesToRead[i], 'Font');
            cooltype = checkFileEnding('.otf', filesToRead[i], 'Font');

            if (cooltype == null) cooltype = 'UFT';

            trace('File: '+filesToRead[i]);

            // rip caching code
        }
	}

    public static function checkFileEnding(ending:String = '.png', file:String = 'coolswag.png', returnType:String = 'image')
    {

        //trace(Std.string(file));
        
        if (Std.string(file).endsWith(ending)) return returnType;

        return null;
    }
}
