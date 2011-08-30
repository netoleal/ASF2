/*
* Class: asf.fx.SimpleTweenProperties
* @author: Neto Leal - netoleal@gmail.com
* Created: 1:53:47 PM Aug 29, 2011
*/
package asf.fx
{
	public final class SimpleTweenProperties
	{
		public static const brightness:String = "brightness";
		public static const blur:String = "blur";
		
		public static function init( ):void
		{
			SimpleTween.registerSpecialProperty( brightness, new BrightnessProperty( ) );
			SimpleTween.registerSpecialProperty( blur, new BlurProperty( ) );
		}
	}
}
