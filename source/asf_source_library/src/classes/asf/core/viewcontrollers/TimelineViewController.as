/*
 * Class asf.controllers.TimelineController
 *
 * @author: Neto Leal
 * @created: Dec 3, 2010 12:17:07 PM
 *
 **/
package asf.core.viewcontrollers
{
	import asf.events.TimelineEvent;

	import flash.display.MovieClip;
	import flash.events.Event;
	import asf.utils.TimelineControl;
	
	[Event( type="asf.events.TimelineEvent", name="firstFrame" )]
	[Event( type="asf.events.TimelineEvent", name="lastFrame" )]
	[Event( type="flash.events.Event", name="enterFrame" )]
	
	/**
	 * ViewController útil para fazer e tratar animações de timeline
	 *  
	 * @author neto.leal
	 * 
	 */
	public class TimelineViewController extends AbstractViewController
	{
		private var _timeline:TimelineControl;
		
		/**
		 * Construtor 
		 * @param target Um MovieClip a ter sua timeline controlada por esse ViewController
		 * 
		 */
		public function TimelineViewController( target:MovieClip )
		{
			super( target );
			
			_timeline = new TimelineControl( target );
			
			_timeline.onFrame = onEnterFrame;
			_timeline.onFirstFrame = onFirstFrame;
			_timeline.onLastFrame = onLastFrame;
		}
		
		/**
		 * Para a timeline 
		 * 
		 */
		public function stop( ):void
		{
			_timeline.stop( );
		}
		
		private function onEnterFrame( frameNumber:uint ):void
		{
			this.dispatchEvent( new Event( Event.ENTER_FRAME ) );
		}
		
		private function onFirstFrame( ):void
		{
			this.dispatchEvent( new TimelineEvent( TimelineEvent.FIRST_FRAME ) );
		}
		
		private function onLastFrame( ):void
		{
			this.dispatchEvent( new TimelineEvent( TimelineEvent.LAST_FRAME ) );
		}
		
		/**
		 * Objeto TimelineControl 
		 * @return 
		 * 
		 */
		public function get timeline( ):TimelineControl
		{
			return _timeline;
		}
		
		public override function dispose( ):void
		{
			timeline.dispose( );
			super.dispose( );
		}
	}
}