package projectPages.viewControllers
{
	import asf.core.viewcontrollers.InOutViewController;
	
	import flash.display.MovieClip;
	
	public class PreloadViewController extends InOutViewController
	{
		public function PreloadViewController(p_view:MovieClip)
		{
			super(p_view);
		}
		
		public function setProgress( value:Number ):void
		{
			view.$progress.$bar.scaleX = value;
		}
	}
}