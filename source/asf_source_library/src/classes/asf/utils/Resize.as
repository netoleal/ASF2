/**
 * Class asf.utils.Resize
 *
 * @author: Neto Leal
 * @created: Sep 8, 2010 11:08:52 AM
 *
 **/
package asf.utils
{
	import flash.display.DisplayObject;

	public class Resize
	{
		public static function fit( target:DisplayObject, width:Number, height:Number ):void
		{
			var tw:Number = target.width, th:Number = target.height;
			var w:Number = width, h:Number = height;
			
			if( w > h )
			{
				target.height = h;
				target.scaleX = target.scaleY;
			}	
			else
			{
				target.width = w;
				target.scaleY = target.scaleX;
			}
		}
		
		public static function fill( target:DisplayObject, width:Number, height:Number ):void
		{
			var tw:Number = target.width, th:Number = target.height;
			var w:Number = width, h:Number = height;
			
			if( w < h )
			{
				target.height = h;
				target.scaleX = target.scaleY;
			}
			else
			{
				target.width = w;
				target.scaleY = target.scaleX;
			}
		}
	}
}