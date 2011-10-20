/*
 * Class asf.controllers.TimelineController
 *
 * @author: Neto Leal
 * @created: Dec 3, 2010 12:17:07 PM
 *
 **/
package asf.core.viewcontrollers
{
	import asf.core.util.Sequence;
	import asf.events.TimelineEvent;
	import asf.interfaces.ISequence;
	import asf.utils.TimelineControl;
	
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.events.Event;
	
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
		protected var framesLabels:Array;
		protected var labels:Array;
		
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
			
			framesLabels = target.currentLabels;
			labels = new Array( );
			
			for each( var label:FrameLabel in framesLabels ) labels.push( label.name );
		}
		
		/**
		 * Para a timeline 
		 * 
		 */
		public function stop( ):void
		{
			timeline.stop( );
		}
		
		public function gotoAndStop( frame:* ):void
		{
			if( frame is String )
			{
				frame = getFrameNumberForLabel( frame );
			}
			
			timeline.gotoAndStop( frame );
		}
		
		public function gotoAndPlay( frame:* ):void
		{
			if( frame is String )
			{
				frame = getFrameNumberForLabel( frame );
			}
			
			timeline.gotoAndPlay( frame );
		}
		
		public function animateBetweenFrames( start:*, end:* ):ISequence
		{
			timeline.gotoAndStop( start );
			return animateToFrame( end );
		}
		
		public function animateToEnd( ):ISequence
		{
			return animateToFrame( timeline.totalframes );
		}
		
		public function animateToBegin( ):ISequence
		{
			return animateToFrame( 1 );
		}
		
		public function animateToFrame( frame:* ):ISequence
		{
			var seq:Sequence = new Sequence( );
			stop( );
			seq.notifyStart( );
			
			if( frame is String )
			{
				frame = getFrameNumberForLabel( frame );
			}
			
			timeline.animateToFrame( frame, seq.notifyComplete );
			
			return seq;
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
		
		public function getFrameNumberForLabel( label:String ):int
		{
			var index:int = labels.indexOf( label );
			var frameLabel:FrameLabel;
			
			if( index == -1 ) return index;
			
			frameLabel = framesLabels[ index ];
			
			return frameLabel.frame;
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