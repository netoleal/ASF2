package projectPages.view
{
	import asf.core.app.ASF;
	import asf.core.elements.Section;
	import asf.core.util.Sequence;
	import asf.interfaces.ISectionView;
	import asf.view.UIView;
	import asf.utils.Align;
	
	import com.LeonardoPinho.events.ResultEvents;
	import com.projeto.NavPage;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import projectPages.viewControllers.NavViewController;
	
	public class NavView extends UIView implements ISectionView
	{
		private var controller:NavViewController;
		
		public function NavView()
		{
			super( true );
		}
		
		public function init(p_section:Section, ...parameters):void
		{
			controller = new NavViewController( new NavPage(), p_section);			
			p_section.application.layers.container.addChild( controller.view );
			
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