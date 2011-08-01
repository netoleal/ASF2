package br.pedromoraes.btween
{

	public class BTweenUtil
	{
		
		public static function stopTweens(... paFilters:Array):void
		{
			for each (var filter:Object in paFilters)
			{
				getTweens(filter).every( stop );
			}
		}

		public static function stopTweensByName(psName:String):void
		{
			trace(BTween.instances.length);
			var laResults:Array = BTween.instances.slice();
			for each (var instance:BTween in BTween.instances)
			{
				if (instance.name == psName)
					instance.stop();
			}
			trace(BTween.instances.length);
		}

		public static function getTweens(pFilter:Object):Array
		{
			var laResults:Array = BTween.instances.slice();
			for each (var instance:BTween in BTween.instances)
			{
				for each (var tween:* in instance.tweens)
				{
					var lbMatch:Boolean = false;
					for (var lsProp:String in pFilter)
					{
						if (tween.hasOwnProperty(lsProp))
						{
							if (tween[lsProp] === pFilter[lsProp])
							{
								lbMatch = true;
								continue;
							}
						}
						break;
					}
					if (!lbMatch) laResults.splice(laResults.indexOf(instance), 1);
				}
			}
			return laResults;
		}

		public static function stop(pInstance:BTween, ... paRest:Array):void
		{
			pInstance.stop();
		}

	}
}
