/*
* Class: asf.fx.AutoAlphaProperty
* @author: Neto Leal - netoleal@gmail.com
* Created: 10:58:39 PM Aug 31, 2011
*/
package asf.fx
{
	import asf.interfaces.ISpecialProperty;
	
	public class AutoAlphaProperty implements ISpecialProperty
	{
		public function getValue(target:*):Number
		{
			return target.alpha;
		}
		
		public function setValue(target:*, value:Number, start:Number=0, end:Number=0):void
		{
			target.alpha = value;
			target.visible = value != 0;
		}
		
		public function dispose():void
		{
		}
	}
}