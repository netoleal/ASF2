/*
 * Class asf.core.controllers.InOutController
 *
 * @author: Neto Leal
 * @created: Dec 3, 2010 11:50:55 AM
 *
 **/
package asf.core.viewcontrollers
{
	import asf.core.util.Sequence;
	import asf.events.InOutEvent;
	import asf.interfaces.ISequence;
	import asf.utils.Delay;
	import asf.utils.TimelineInOutLabels;
	
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	
	[Event( type="asf.events.InOutEvent", name="inStart" )]
	[Event( type="asf.events.InOutEvent", name="inEnd" )]
	[Event( type="asf.events.InOutEvent", name="outStart" )]
	[Event( type="asf.events.InOutEvent", name="outEnd" )]
	
	public class InOutViewController extends TimelineViewController
	{
		protected var framesLabels:Array;
		protected var labels:Array;
		protected var transition:Sequence;
		
		private var _target:MovieClip;
		
		private var sh:ShowHideViewController;
		private var isIn:Boolean = false;
		private var useFade:Boolean;
		
		public function InOutViewController( p_view:MovieClip, p_useFade:Boolean = true )
		{
			//log( p_target );
			
			super( p_view );
			
			transition = new Sequence( );
			
			useFade = p_useFade;
			_target = p_view;
			
			framesLabels = _target.currentLabels;
			labels = new Array( );
			
			for each( var label:FrameLabel in framesLabels ) labels.push( label.name );
			
			//target.stop( );
			target.gotoAndStop( 1 );
			
			//log( target.name, labels );
			
			if( !hasLabels && !hasInOutLabel && useFade )
			{
				sh = new ShowHideViewController( target, false );
			}
		}
		
		public function animateIn( preventRepetition:Boolean = false ):ISequence
		{
			//log( this.target, this.target.name );
			
			transition.notifyStart( );
			
			if( this.hasManualLabel ) 
			{
				transition.notifyComplete( );
				return transition;
			}
			
			if( preventRepetition && isIn ) 
			{
				transition.notifyComplete( );
				return transition;
			}
			
			isIn = true;
			
			this.dispatchEvent( new InOutEvent( InOutEvent.IN_START ) );
			
			if( sh )
			{
				sh.setVisible( true ).queue( dispatchAnimateInComplete );
			}
			else
			{
				if( hasLabels )
				{
					timeline.gotoAndStop( TimelineInOutLabels.IN );
					
					if( getFrameNumberForLabel( TimelineInOutLabels.IN_END ) != -1 )
					{
						timeline.animateToFrame( getFrameNumberForLabel( TimelineInOutLabels.IN_END ) );
						timeline.onReach = dispatchAnimateInComplete;
					}
				}
				else if( hasInOutLabel )
				{
					timeline.stop( );
					timeline.animateToFrame( timeline.totalframes );
					timeline.onReach = dispatchAnimateInComplete;
				}
			}
			
			return transition.queue( Delay.start, 0 );
		}
		
		public function animateOut( preventRepetition:Boolean = false ):ISequence
		{
			transition.notifyStart( );
			
			
			if( this.hasManualLabel ) 
			{
				transition.notifyComplete( );
				return transition;
			}
			
			if( preventRepetition && !isIn )
			{
				transition.notifyComplete( );
				return transition;
			}
			
			isIn = false;
			
			this.dispatchEvent( new InOutEvent( InOutEvent.OUT_START ) );
			
			if( sh )
			{
				sh.setVisible( false ).queue( dispatchAnimateOutComplete );
			}
			else
			{
				if( hasLabels )
				{
					timeline.gotoAndStop( TimelineInOutLabels.OUT );
					
					if( getFrameNumberForLabel( TimelineInOutLabels.OUT_END ) != -1 )
					{
						timeline.animateToFrame( getFrameNumberForLabel( TimelineInOutLabels.OUT_END ) );
						timeline.onReach = dispatchAnimateOutComplete;
					}
				}
				else if( hasInOutLabel )
				{
					timeline.stop( );
					timeline.animateToFrame( getFrameNumberForLabel( TimelineInOutLabels.IN_OUT ) );
					timeline.onReach = dispatchAnimateOutComplete;
				}
			}
			
			return transition.queue( Delay.start, 0 );
		}
		
		private function dispatchAnimateInComplete( ... a ):void
		{
			timeline.onReach = null;
			transition.notifyComplete( );
			dispatchEvent( new InOutEvent( InOutEvent.IN_END ) );
		}
		
		private function dispatchAnimateOutComplete( ... a ):void
		{
			timeline.onReach = null;
			transition.notifyComplete( );
			dispatchEvent( new InOutEvent( InOutEvent.OUT_END ) );
		}
		
		protected function get hasManualLabel( ):Boolean
		{
			return labels.indexOf( TimelineInOutLabels.MANUAL ) != -1;
		}
		
		protected function get hasLabels( ):Boolean
		{
			return labels.indexOf( TimelineInOutLabels.IN ) != -1 && labels.indexOf( TimelineInOutLabels.OUT ) != -1;
		}
		
		protected function get hasInOutLabel( ):Boolean
		{
			return labels.indexOf( TimelineInOutLabels.IN_OUT ) != -1;
		}
		
		public function getFrameNumberForLabel( label:String ):int
		{
			var index:int = labels.indexOf( label );
			var frameLabel:FrameLabel;
			
			if( index == -1 ) return index;
			
			frameLabel = framesLabels[ index ];
			
			return frameLabel.frame;
		}
		
		public function get target( ):MovieClip
		{
			return _target;
		}
		
		public override function dispose( ):void
		{
			stop( );
			super.dispose( );
			
			_target = null;
		}
	}
}