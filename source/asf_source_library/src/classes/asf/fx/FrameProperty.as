package asf.fx
{
	import asf.interfaces.ISpecialProperty;
	
	public class FrameProperty implements ISpecialProperty
	{
		public function FrameProperty()
		{
		}
		
		public function getValue(target:*):Number
		{
			return target.currentFrame;
		}
		
		public function setValue(target:*, value:Number, start:Number=0, end:Number=0):void
		{
			target.gotoAndStop( Math.round( value ) );
		}
		
		public function dispose():void
		{
		}
	}
}