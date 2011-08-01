package projectPages.view
{
	import asf.core.elements.Section;
	import asf.core.util.Sequence;
	import asf.events.NavigationEvent;
	import asf.interfaces.ISectionView;
	import asf.view.UIView;
	
	import asf.core.app.ASF;
	import asf.utils.Align;	
	import com.projeto.SiteCanvas;
	import projectPages.viewControllers.IndexViewController
	
	import flash.display.Sprite;
	
	public class IndexView extends UIView implements ISectionView
	{
		private var controller:IndexViewController;
		
		public function IndexView()
		{
			super( true );
		}
			
		public function init(p_section:Section, ...parameters):void
		{
			controller = new IndexViewController( new SiteCanvas(), p_section);
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