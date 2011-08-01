package br.pedromoraes.btween.properties
{
	import br.pedromoraes.btween.BTween;
	
	public class BaseProperty implements IProperty
	{

		public var index:Number = 0;
		public var properties:Object;
		public var startValues:Object;

		protected var _target:Object;
		public function get target():Object { return _target }
		public function set target(pTarget:Object):void { _target = pTarget }

		public function BaseProperty(pTarget:Object, pProperties:Object)
		{
			_target = pTarget;
			properties = pProperties;
		}

		public function update(pTween:BTween, piElapsed:int):void
		{
			if (!startValues) init();
			index = pTween.getValue(0, 1, piElapsed);

			for (var lsProp:String in properties)
			{
				if (pTween.rounded)
					target[lsProp] = Math.round(startValues[lsProp] + (properties[lsProp] - startValues[lsProp]) * index);
				else
					target[lsProp] = startValues[lsProp] + (properties[lsProp] - startValues[lsProp]) * index;
			}
		}

		public function reverse():void
		{
			if (!startValues) init();
			for (var lsProp:String in properties)
			{
				properties[lsProp] = startValues[lsProp];
				startValues[lsProp] = target[lsProp];
			}
		}

		public function clone():IProperty
		{
			return new BaseProperty(target, cloneObj(properties));
		}

		public function cloneObj(pObj:Object):Object
		{
			var cloned:Object = new Object();
			for (var s:String in pObj) cloned[s] = pObj[s];
			return cloned;
		}

		public function init():void
		{
			startValues = new Object();
			for (var lsProp:String in properties)
			{
				startValues[lsProp] = _target[lsProp];
			}
		}

	}
}