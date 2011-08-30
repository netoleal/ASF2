/*
* Class: asf.fx.BlurProperty
* @author: Neto Leal - netoleal@gmail.com
* Created: 2:24:41 PM Aug 29, 2011
*/
package asf.fx
{
	import asf.interfaces.ISpecialProperty;
	
	import flash.display.DisplayObject;
	import flash.filters.BlurFilter;
	
	public class BlurProperty implements ISpecialProperty
	{
		public function getValue( target:* ):Number
		{
			var blur:BlurFilter = popFilter( target );
			var f:Array = target.filters || new Array( )
			var r:Number;
			
			f.push( blur );
			target.filters = f;
			
			r = blur.blurX;
			
			return r;// + blur.blurY ) / 2;
		}
		
		public function setValue(target:*, value:Number, start:Number = 0, end:Number = 0):void
		{
			BlurProperty.setValue( target, value, start, end );
		}
		
		public static function setValue( target:*, value:Number, start:Number = 0, end:Number = 0 ):void
		{
			var filters:Array;
			var i:uint;
			var blur:BlurFilter;
			
			value = Math.round( value );
			
			blur = popFilter( target );
			
			filters = target.filters;
			
			blur.blurX = value;
			blur.blurY = value;
			
			if( value > 0 ) filters.push( blur );
			target.filters = filters;
		}
		
		private static function popFilter( target:* ):BlurFilter
		{
			var f:*, res:*, n:int = 0, t:uint;
			var ar:Array = target.filters || new Array( );
			var newFilters:Array = new Array( );
			
			for( n = 0, t = ar.length; n < t; n++ )
			{
				f = ar[ n ];
				if( f is BlurFilter )
				{
					res = f;
				}
				else
				{
					newFilters.push( f );
				}
			}
			
			target.filters = newFilters;
			
			return res || new BlurFilter( 0, 0 );
		}
		
		public function dispose():void
		{
		}
	}
}