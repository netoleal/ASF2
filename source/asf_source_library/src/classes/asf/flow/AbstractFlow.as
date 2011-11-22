package asf.flow
{
	import asf.core.elements.Navigation;
	import asf.events.NavigationEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class AbstractFlow extends EventDispatcher
	{
		protected var nav:Navigation;
		
		public function AbstractFlow( p_nav:Navigation )
		{
			super( null );
			
			nav = p_nav;
			nav.addEventListener( NavigationEvent.WILL_CHANGE, onNavigationWillChange );
		}
		
		protected function onNavigationWillChange( event:NavigationEvent ):void
		{
			
		}
		
		public function dispose( ):void
		{
			nav.removeEventListener( NavigationEvent.WILL_CHANGE, onNavigationWillChange );
			nav = null;
		}
	}
}