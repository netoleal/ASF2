package br.pedromoraes.btween.properties.color
{
	import br.pedromoraes.btween.BTween;
	import br.pedromoraes.btween.properties.IProperty;
	
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;

	public class BrightnessProperty implements IProperty
	{
		
		public var startValues:ColorTransform;
		public var index:Number;
		public var brightness:Number;

		private var finalTransform:ColorTransform;

		protected var _target:DisplayObject;
		public function get target():Object { return _target }
		public function set target(pTarget:Object):void { _target = pTarget as DisplayObject }
		
		public function BrightnessProperty(pTarget:DisplayObject, pnBrightness:Number)
		{
			_target = pTarget;
			brightness = pnBrightness;
			var offset:Number = (brightness > 0) ? brightness * (256/1) : 0;
			finalTransform = new ColorTransform(1 - Math.abs(brightness), 1 - Math.abs(brightness), 1 - Math.abs(brightness), 1, offset, offset, offset);
		}

		public function update(pTween:BTween, piElapsed:int):void
		{
			if (!startValues) init();
			index = pTween.getValue(0, 1, piElapsed);

			var ct:ColorTransform = new ColorTransform();
			ct.redMultiplier = startValues.redMultiplier + (finalTransform.redMultiplier - startValues.redMultiplier) * index;
			ct.greenMultiplier = startValues.greenMultiplier + (finalTransform.greenMultiplier - startValues.greenMultiplier) * index;
			ct.blueMultiplier = startValues.blueMultiplier + (finalTransform.blueMultiplier - startValues.blueMultiplier) * index;
			ct.redOffset = startValues.redOffset + (finalTransform.redOffset - startValues.redOffset) * index;
			ct.greenOffset = startValues.greenOffset + (finalTransform.greenOffset - startValues.greenOffset) * index;
			ct.blueOffset = startValues.blueOffset + (finalTransform.blueOffset - startValues.blueOffset) * index;
			_target.transform.colorTransform = ct;
		}

		public function reverse():void
		{
			if (!startValues) init();
			var f:ColorTransform = finalTransform;
			finalTransform = startValues;
			startValues = f;
		}

		public function clone():IProperty
		{
			return new BrightnessProperty(_target, brightness);
		}

		private function init():void
		{
			if (_target.transform.colorTransform)
			{
				startValues = _target.transform.colorTransform;
			}
			else
			{
				startValues = new ColorTransform();
			}
		}

	}
}