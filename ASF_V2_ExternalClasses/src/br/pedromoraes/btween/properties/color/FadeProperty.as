package br.pedromoraes.btween.properties.color
{
	import br.pedromoraes.btween.BTween;
	import br.pedromoraes.btween.properties.IProperty;
	
	import flash.display.DisplayObject;

	public class FadeProperty implements IProperty
	{
		
		public var startValues:Object;
		public var index:Number;

		public var alpha:Number;

		protected var _target:DisplayObject;
		public function get target():Object { return _target }
		public function set target(pTarget:Object):void { _target = pTarget as DisplayObject }
		
		public function FadeProperty(pTarget:DisplayObject, pnAlpha:Number)
		{
			_target = pTarget;
			alpha = pnAlpha;
		}

		public function update(pTween:BTween, piElapsed:int):void
		{
			if (!startValues) init();
			index = pTween.getValue(0, 1, piElapsed);

			_target.alpha = startValues.alpha + (alpha - startValues.alpha) * index;
			if (_target.alpha == 0)
				_target.visible = false;
			else if (!target.visible)
				_target.visible = true;
		}

		public function reverse():void
		{
			if (!startValues) init();
			var rev:Object = {alpha:alpha};
			alpha = startValues.alpha;
			startValues = rev;
		}

		public function clone():IProperty
		{
			return new FadeProperty(_target, alpha);
		}

		private function init():void
		{
			startValues = {alpha:_target.alpha};
		}

	}
}