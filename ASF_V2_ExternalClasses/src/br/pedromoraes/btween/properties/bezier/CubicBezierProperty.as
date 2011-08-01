package br.pedromoraes.btween.properties.bezier
{
	import br.pedromoraes.btween.BTween;
	import br.pedromoraes.btween.properties.IProperty;

	public class CubicBezierProperty implements IProperty
	{

		public var properties:Object;
		public var startValues:Object;

		private var bezierValues:Array;
		private var index:Number;

		protected var _target:Object;
		public function get target():Object { return _target }
		public function set target(pTarget:Object):void { _target = pTarget }

		public function CubicBezierProperty(pTarget:Object, ... rest:Array):void
		{			
			target = pTarget;
			bezierValues = rest;

			super();
		}

		/*Adapted from Robert Penner.*/
		public function update(pTween:BTween, piElapsed:int):void
		{			
			if (!startValues) init();
			index = pTween.getValue(0, 1, piElapsed);

			var a:Number,b:Number,c:Number;
			for (var prop:String in properties)
			{
				var bezier:Array = properties[prop];
				a = startValues[prop];
				b = bezier[0];
				c = bezier[1];
				target[prop] = a + index * (2 * (1-index) * (b-a) + index * (c-a));
			}
		}

		public function reverse():void
		{
			if (!properties) init();
			for (var lsProp:String in properties)
			{
				properties[lsProp] = startValues[lsProp];
				startValues[lsProp] = target[lsProp];
			}
		}
		
		private function init():void
		{
			properties = new Object();
			startValues = new Object();
			var prop:String;
			for each (var bezier:Array in bezierValues)
			{
				prop = bezier[0];
				startValues[prop] = target[prop];
				properties[prop] = bezier.slice(1);
			}
		}

		public function clone():IProperty
		{
			return new CubicBezierProperty(this);
		}
	}
}