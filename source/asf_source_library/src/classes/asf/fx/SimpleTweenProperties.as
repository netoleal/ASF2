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
		public static const scale:String = "scale";
		public static const autoAlpha:String = "autoAlpha";
		public static const frame:String = "frame";
		
		public static function init( ):void
		{
			SimpleTween.registerSpecialProperty( frame, new FrameProperty( ) );
			SimpleTween.registerSpecialProperty( brightness, new BrightnessProperty( ) );
			SimpleTween.registerSpecialProperty( blur, new BlurProperty( ) );
			SimpleTween.registerSpecialProperty( scale, new ScaleProperty( ) );
			SimpleTween.registerSpecialProperty( autoAlpha, new AutoAlphaProperty( ) );
		}
	}
}
