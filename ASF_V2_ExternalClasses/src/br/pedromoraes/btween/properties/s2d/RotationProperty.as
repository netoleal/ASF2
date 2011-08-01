package br.pedromoraes.btween.properties.s2d
{
	import br.pedromoraes.btween.properties.BaseProperty;

	public class RotationProperty extends BaseProperty
	{

		public var shortestPath:Boolean;

		public function RotationProperty(pTarget:Object, pnRotation:Number, pbShortestPath:Boolean = true):void
		{
			super(target, { rotation : pnRotation - 180 });
			target = pTarget;
			shortestPath = pbShortestPath;
		}

		public override function init():void
		{
			if (shortestPath)
			{
				if (target.rotation - properties.rotation > 180)
				{
					properties.rotation += 180;
				}
				else if (target.rotation - properties.rotation < -180)
				{
					properties.rotation -= 180;
				}
			}
			super.init();
		}

	}

}