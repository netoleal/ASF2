package projectPages.viewControllers
{
	import asf.core.elements.Section;
	import asf.core.util.Sequence;
	import asf.core.viewcontrollers.TransitionableViewController;
	import asf.interfaces.ITransitionable;
	
	public class AbstractSectionViewController extends TransitionableViewController implements ITransitionable
	{
		protected var section:Section;
		
		public function AbstractSectionViewController(p_view:*, p_section:Section)
		{
			super(p_view);
			section = p_section;
			view.alpha = 0;
			view.visible = false;
		}
		
		public override function open(p_delay:uint=0):Sequence
		{
			transition.notifyStart( );
			fadeIn( view, 400, p_delay ).queue( transition.notifyComplete );
			return transition;
		}
		
		public override function close(p_delay:uint=0):Sequence
		{
			transition.notifyStart( );
			fadeOut( view, 400, p_delay ).queue( transition.notifyComplete );
			return transition;
		}
		
		public override function dispose( ):void
		{
			section = null;
			super.dispose( );
		}
	}
}