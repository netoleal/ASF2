package br.pedromoraes.btween.properties.filters
{
	import br.pedromoraes.btween.BTween;
	import br.pedromoraes.btween.properties.IProperty;
	
	import flash.display.DisplayObject;
	import flash.filters.BlurFilter;
	import flash.geom.Rectangle;

	public class MotionBlurProperty extends BlurProperty implements IProperty
	{
		
		public var useBounds:Boolean;
		public var xAxis:Boolean;
		public var yAxis:Boolean;
		public var blurRatio:Number;
		public var lastX:Number;
		public var lastY:Number;
		private var firstFrame:Boolean = true;
		
		public function MotionBlurProperty(pTarget:DisplayObject, pnBlurRatio:Number = 1, piQuality:int = 1, pbUseBounds:Boolean = false, pbXAxis:Boolean = true, pbYAxis:Boolean = true)
		{
			useBounds = pbUseBounds;
			blurRatio = pnBlurRatio;
			xAxis = pbXAxis;
			yAxis = pbYAxis;
			super(pTarget, undefined, undefined, piQuality);
		}

		public override function update(pTween:BTween, piElapsed:int):void
		{
			if (!target) return;
			
			if (!startValues) init();
			index = pTween.getValue(0, 1, piElapsed);

			popFilter();
		
			var x:int,y:int;
			
			if (useBounds)
			{
				var bounds:Rectangle = target.getBounds(target.stage);
				x = bounds.x; y = bounds.y;
			}
			else
			{
				x = target.x;
				y = target.y;
			}
			
			var lnBlurX:Number = xAxis ? blurRatio * (Math.abs(x - lastX)) : 0;
			var lnBlurY:Number = yAxis ? blurRatio * (Math.abs(y - lastY)) : 0;

			if (index % 1 != 0)
			{
				if (lnBlurX > 0 || lnBlurY > 0)
				{
					if (!firstFrame)
					{
						var f:BlurFilter = new BlurFilter(lnBlurX - lnBlurY * .5, lnBlurY - lnBlurX * .5, quality);
						target.filters = target.filters.concat(f);
					}
					else
					{
						firstFrame = false;
					}
					lastX = x;
					lastY = y;
				}
			}
			else
			{
				startValues = undefined;
			}
		}

		public override function reverse():void
		{
			startValues = undefined;
		}

		public override function clone():IProperty
		{
			return new MotionBlurProperty(_target, blurRatio, quality);
		}

		private function init():void
		{
			startValues = new Object();
			lastX = target.x;
			lastY = target.y;
		}
				
	}
}