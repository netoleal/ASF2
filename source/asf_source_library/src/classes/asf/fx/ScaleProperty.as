/*
* Class: asf.fx.ScaleProperty
* @author: Neto Leal - netoleal@gmail.com
* Created: 7:36:13 AM Aug 30, 2011
*/
package asf.fx
{
	import asf.interfaces.ISpecialProperty;
	
	public class ScaleProperty implements ISpecialProperty
	{
		public function ScaleProperty()
		{
		}
		
		public function getValue(target:*):Number
		{
			return target.scaleX;
		}
		
		public function setValue(target:*, value:Number):void
		{
			ScaleProperty.setValue( target, value );
		}
		
		public static function setValue(target:*, value:Number):void
		{
			target.scaleX = value;
			target.scaleY = value;
		}
		
		public function dispose():void
		{
		}
	}
}