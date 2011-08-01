package br.pedromoraes.btween.properties.color
{
	import br.pedromoraes.btween.BTween;
	import br.pedromoraes.btween.properties.IProperty;
	
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;

	public class BitmapBrightnessProperty implements IProperty
	{
		
		public var startValues:ColorTransform;
		public var index:Number;

		protected var _target:BitmapData;
		public function get target():Object { return _target }
		public function set target(pTarget:Object):void { _target = pTarget as BitmapData }

		public var brightness:Number;

		private var finalTransform:ColorTransform;
		private var ct:ColorTransform = new ColorTransform();
		
		public function BitmapBrightnessProperty(pTarget:BitmapData, pnBrightness:Number)
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

			ct.redMultiplier = startValues.redMultiplier + (finalTransform.redMultiplier - startValues.redMultiplier) * index;
			ct.greenMultiplier = startValues.greenMultiplier + (finalTransform.greenMultiplier - startValues.greenMultiplier) * index;
			ct.blueMultiplier = startValues.blueMultiplier + (finalTransform.blueMultiplier - startValues.blueMultiplier) * index;
			ct.redOffset = startValues.redOffset + (finalTransform.redOffset - startValues.redOffset) * index;
			ct.greenOffset = startValues.greenOffset + (finalTransform.greenOffset - startValues.greenOffset) * index;
			ct.blueOffset = startValues.blueOffset + (finalTransform.blueOffset - startValues.blueOffset) * index;
			_target.colorTransform(target.rect, ct);
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
			return new BitmapBrightnessProperty(_target, brightness);
		}

		private function init():void
		{
			startValues = ct;
		}

	}
}