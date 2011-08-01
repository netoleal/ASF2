package projectPages.viewControllers
{
	import asf.core.elements.Section;
	import asf.interfaces.ITransitionable;
	
	public class HomeViewController extends AbstractSectionViewController implements ITransitionable
	{
	
		public function HomeViewController(p_view:*, p_section:Section)
		{
			super(p_view, p_section);
		}
	
	}
}