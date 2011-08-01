package br.pedromoraes.btween.properties.filters
{
	import br.pedromoraes.btween.BTween;
	import br.pedromoraes.btween.properties.IProperty;
	
	import flash.display.DisplayObject;
	import flash.filters.BitmapFilter;
	import flash.filters.BlurFilter;

	public class BlurProperty implements IProperty
	{

		public var startValues:Object;
		public var index:Number;

		public var blurX:Number;
		public var blurY:Number;
		public var quality:int;

		protected var _target:DisplayObject;
		public function get target():Object { return _target }
		public function set target(pTarget:Object):void { _target = pTarget as DisplayObject }

		public function BlurProperty(pTarget:DisplayObject, pnBlurX:int = 10, pnBlurY:int = 10, piQuality:int = 1)
		{
			_target = pTarget;
			blurX = pnBlurX;
			blurY = pnBlurY;
			quality = piQuality;
		}

		public function update(pTween:BTween, piElapsed:int):void
		{
			if (!_target) return;

			if (!startValues) init();
			index = pTween.getValue(0, 1, piElapsed);
			
			popFilter();
			
			if (index > 0)
			{
				var f:BlurFilter = new BlurFilter();
				f.blurX = startValues.blurX + (blurX-startValues.blurX)*index;
				f.blurY = startValues.blurY + (blurY-startValues.blurY)*index;
				f.quality = quality;
				_target.filters = _target.filters.concat([f]);
			}
		}

		public function reverse():void
		{
			if (!startValues) init();
			var start:Object = {blurX:blurX,blurY:blurY};
			blurX = startValues.blurX;
			blurY = startValues.blurY;
			startValues = start;
		}

		public function clone():IProperty
		{
			return new BlurProperty(_target, blurX, blurY, quality);
		}

		private function init():void
		{
			startValues = new Object();
			var filter:BlurFilter = popFilter();
			startValues.blurX = filter ? filter.blurX : 0;
			startValues.blurY = filter ? filter.blurY : 0;
		}

		public function popFilter():BlurFilter
		{
			var res:BlurFilter = null;
			var clean:Array = new Array();
			for each (var f:BitmapFilter in _target.filters)
			{
				if (f is BlurFilter)
				{
					res = f as BlurFilter;
				}
				else
				{
					clean.push(f);
				}
			}
			_target.filters = clean;
			return res;
		}
	}
}