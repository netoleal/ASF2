package br.pedromoraes.btween.properties.color
{
	import br.pedromoraes.btween.BTween;
	import br.pedromoraes.btween.properties.IProperty;
	
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	
	/*URGENT 
	//TODO: fix so that reversion works
	*/

	public class TintProperty implements IProperty
	{
		
		public var startValues:ColorTransform;
		public var tintColor:int;
		public var tintPercent:Number;

		public var finalTransform:ColorTransform;
		
		protected var _target:DisplayObject;
		public function get target():Object { return _target }
		public function set target(pTarget:Object):void { _target = pTarget as DisplayObject }
		
		public function TintProperty(pTarget:DisplayObject, piTintColor:int, pnTintPercent:Number = 100)
		{
			target = pTarget;
			tintColor = piTintColor;
			tintPercent = pnTintPercent;
			var ratio : Number = pnTintPercent/100;
			finalTransform = new ColorTransform(1-ratio,1-ratio,1-ratio,1,tintColor >> 16 * ratio,tintColor >> 8 & 0xFF * ratio,tintColor & 0xFF * ratio,0);
		}

		public function update( btween : BTween, elapsed : int ) : void
		{
			if (!startValues) init();

			var index : Number = btween.getValue( 0, 1, elapsed );
			
			if (index > 0)
			{
				var ct:ColorTransform = new ColorTransform();
				ct.redMultiplier = startValues.redMultiplier + (finalTransform.redMultiplier - startValues.redMultiplier) * index;
				ct.greenMultiplier = startValues.greenMultiplier + (finalTransform.greenMultiplier - startValues.greenMultiplier) * index;
				ct.blueMultiplier = startValues.blueMultiplier + (finalTransform.blueMultiplier - startValues.blueMultiplier) * index;
				ct.redOffset = startValues.redOffset + (finalTransform.redOffset - startValues.redOffset) * index;
				ct.greenOffset = startValues.greenOffset + (finalTransform.greenOffset - startValues.greenOffset) * index;
				ct.blueOffset = startValues.blueOffset + (finalTransform.blueOffset - startValues.blueOffset) * index;
				target.transform.colorTransform = ct;
			}
		}

		public function reverse():void
		{
			var f:ColorTransform = finalTransform;
			if ( startValues.redOffset + startValues.greenOffset + startValues.blueOffset > 0 )
			{
				finalTransform = startValues;
				trace("reversing");
			}
			startValues = f;
		}

		public function clone():IProperty
		{
			var copy : TintProperty = new TintProperty(_target, tintColor, tintPercent );
			copy.startValues = startValues;
			return copy;
		}

		private function init():void
		{
			if (target.transform.colorTransform)
			{
				startValues = target.transform.colorTransform;
			}
			else
			{
				startValues = new ColorTransform();
			}
		}

	}
}
