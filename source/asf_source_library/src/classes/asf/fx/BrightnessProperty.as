/*
* Class: asf.fx.BrightnessProperty
* @author: Neto Leal - netoleal@gmail.com
* Created: 12:09:58 PM Aug 29, 2011
*/
package asf.fx
{
	import asf.interfaces.ISpecialProperty;
	
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	
	public class BrightnessProperty implements ISpecialProperty
	{
		public function BrightnessProperty( )
		{
		}
		
		public function getValue( target:* ):Number
		{
			var t:DisplayObject = target as DisplayObject;
			if( !t ) return 0;
			
			var ct:ColorTransform = t.transform.colorTransform;
			if( !ct ) return 0;
			return clamp( avg( ct.redOffset, ct.greenOffset, ct.blueOffset ), -255, 255 );
		}
		
		private function avg( ... args ):Number
		{
			var sum:Number = 0, value:Number;
			for each( value in args ) sum += value;
			return ( args.length > 0 )? sum / args.length: 0;
		}
		
		private static function clamp( val:Number, min:Number, max:Number ):Number
		{
			return Math.max( Math.min( val, max ), min );
		}
		
		public function setValue( target:*, value:Number, start:Number = 0, end:Number = 0 ):void
		{
			BrightnessProperty.setValue( target, value, start, end );
		}
		
		public static function setValue( target:*, value:Number, start:Number = 0, end:Number = 0 ):void
		{
			var t:DisplayObject = target as DisplayObject;
			var ct:ColorTransform;
			if( !t ) return;
			
			ct = t.transform.colorTransform;
			if( !ct ) ct = new ColorTransform( );
			
			value = clamp( value, -255, 255 );
			
			ct.redOffset = value;
			ct.greenOffset = value;
			ct.blueOffset = value;
			
			t.transform.colorTransform = ct;
		}
		
		public function dispose():void
		{
			//nothing to do
		}
	}
}