package br.pedromoraes.btween.properties.filters
{
	import br.pedromoraes.btween.BTween;
	import br.pedromoraes.btween.properties.IProperty;
	
	import flash.filters.BitmapFilter;
	import flash.filters.GlowFilter;

	public class GlowProperty implements IProperty
	{
		
		public var startValues:Object;
		public var index:Number;

		public var color:int;
		public var alpha:Number;
		public var blurX:Number;
		public var blurY:Number;
		public var strength:Number;
		public var quality:int;
		public var inner:Boolean;
		public var knockout:Boolean;
		
		protected var _target:Object;
		public function get target():Object { return _target }
		public function set target(pTarget:Object):void { _target = pTarget }

		public function GlowProperty(pTarget:Object, piColor:int = 0, piAlpha:Number = 1, piBlurX:int = 10, piBlurY:int = 10, pnStrength:Number = 1, piQuality:int = 1, pbInner:Boolean = false, pbKnockout:Boolean = false)
		{
			_target = pTarget;
			color = piColor;
			alpha = piAlpha;
			blurX = piBlurX;
			blurY = piBlurY;
			strength = pnStrength;
			quality = piQuality;
			inner = pbInner;
			knockout = pbKnockout;
		}

		public function update(pTween:BTween, piElapsed:int):void
		{
			if (!_target) return;
			
			if (!startValues) init();
			index = pTween.getValue(0, 1, piElapsed);
			
			popFilter();
			
			if (index > 0)
			{
				var f:GlowFilter = new GlowFilter(color, alpha, blurX, blurY, startValues.strength+(strength-startValues.strength)*index, quality, inner, knockout);
				_target.filters = _target.filters.concat([f]);
			}
		}
		
		public function reverse():void
		{
			if (!startValues) init();
			var start:Object = {strength:strength};
			strength = startValues.strength;
			startValues = start;
		}
		
		public function clone():IProperty
		{
			return new GlowProperty(_target, color, alpha, blurX, blurY, strength, quality, inner, knockout);
		}

		private function init():void
		{
			startValues = new Object();
			var filter:GlowFilter = popFilter();
			startValues.strength = filter ? filter.strength : 0;
		}
		
		public function popFilter():GlowFilter
		{
			var res:GlowFilter = null;
			var clean:Array = new Array();
			for each (var f:BitmapFilter in _target.filters)
			{
				if (f is GlowFilter)
				{
					res = f as GlowFilter;
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