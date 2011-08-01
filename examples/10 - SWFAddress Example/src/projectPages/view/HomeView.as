package projectPages.view
{
	import asf.core.app.ASF;
	import asf.core.elements.Section;
	import asf.core.util.Sequence;
	import asf.events.NavigationEvent;
	import asf.interfaces.ISectionView;
	import asf.view.UIView;
	import asf.utils.Align;	
	import com.LeonardoPinho.events.ResultEvents;
	import com.projeto.HomePage;
	
	import flash.display.Sprite;
	
	import projectPages.viewControllers.HomeViewController;
	
	public class HomeView extends UIView implements ISectionView
	{
		private var controller:HomeViewController;
		
		public function HomeView()
		{
			super( true );
		}
			
		public function init(p_section:Section, ...parameters):void
		{
			controller = new HomeViewController( new HomePage(), p_section);
			p_section.application.layers.sections.addChild( controller.view );	
			
			Align.add(controller.view, Align.CENTER);
		}
		
		public function open(p_delay:uint=0):Sequence
		{
			return controller.open( p_delay );
		}
		
		public function close(p_delay:uint=0):Sequence
		{
			return controller.close( p_delay );
		}
		
		public override function dispose( ):void
		{
			controller.dispose( );
			controller = null;
			super.dispose( );
		}
	}
}