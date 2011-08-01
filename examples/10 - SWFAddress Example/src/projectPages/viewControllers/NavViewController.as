package projectPages.viewControllers
{
	import asf.core.elements.Section;
	import asf.interfaces.ITransitionable;
	
	public class NavViewController extends AbstractSectionViewController implements ITransitionable
	{
	
		public function NavViewController(p_view:*, p_section:Section)
		{
			super(p_view, p_section);
		}		
	}
}