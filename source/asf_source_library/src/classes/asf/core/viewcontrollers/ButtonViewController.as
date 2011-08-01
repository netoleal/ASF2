package asf.core.viewcontrollers
{
	import asf.core.media.SoundItem;
	import asf.core.util.Sequence;
	import asf.interfaces.ISequence;
	import asf.utils.ButtonLabels;
	import asf.utils.TimelineInOutLabels;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	[Event( name="click", type="flash.events.MouseEvent" )]
	[Event( name="rollOver", type="flash.events.MouseEvent" )]
	[Event( name="rollOut", type="flash.events.MouseEvent" )]
	
	public class ButtonViewController extends InOutViewController
	{
		private var _enabled:Boolean = true;
		private var _interaction:Boolean = true;
		private var sounds:Object;
		
		/**
		 * Constructor 
		 * @param p_view The MovieClip containing the button animation
		 * @param p_sounds An Object with properties relative to the button states: { over, out, click } pointing to <code>SoundItem</code> instances
		 * 
		 */
		public function ButtonViewController( p_view:MovieClip, p_sounds:Object = null )
		{
			super( p_view, false );
			
			viewAsMovieClip.buttonMode = true;
			viewAsMovieClip.mouseChildren = false;
			
			sounds = p_sounds;
			
			enabled = true;
			
			viewAsMovieClip.addEventListener( MouseEvent.CLICK, onClick );
			viewAsMovieClip.addEventListener( MouseEvent.ROLL_OVER, over );
			viewAsMovieClip.addEventListener( MouseEvent.ROLL_OUT, out );
		}
		
		public function set interactionEnabled( value:Boolean ):void
		{
			_interaction = value;
		}
		
		public function get interactionEnabled( ):Boolean
		{
			return _interaction;
		}
		
		public function get alpha( ):Number
		{
			return view.alpha;
		}
		
		public function set alpha( value:Number ):void
		{
			view.alpha = value;
		}
		
		public function get visible( ):Boolean
		{
			return view.visible;
		}
		
		public function set visible( value:Boolean ):void
		{
			view.visible = value;
		}
		
		private function onClick( evt:MouseEvent ):void
		{
			if( this.interactionEnabled )
			{
				fx( "click" );
				
				this.animateClick( );
				this.dispatchEvent( evt );
			}
		}
		
		private function fx( id:String ):void
		{
			if( sounds )
			{
				var s:SoundItem = sounds[ id ];
				
				if( s )
				{
					s.play( true );
				}
			}
		}
		
		protected function over( evt:MouseEvent ):void
		{
			if( interactionEnabled )
			{
				fx( "over" );
				this.animateOver( );
				this.dispatchEvent( evt );
			}
		}
		
		protected function hasOverInLabels( ):Boolean
		{
			return labels.indexOf( ButtonLabels.OVER ) != -1 && labels.indexOf( ButtonLabels.OVER_END );
		}
		
		protected function hasOverOutLabels( ):Boolean
		{
			return labels.indexOf( ButtonLabels.OVER_OUT_END ) != -1;
		}
		
		protected function hasOverLabels( ):Boolean
		{
			return labels.indexOf( ButtonLabels.OVER ) != -1 && labels.indexOf( ButtonLabels.OVER_END ) != -1;
		}
		
		protected function hasClickLabels( ):Boolean
		{
			return labels.indexOf( ButtonLabels.CLICK ) != -1 && labels.indexOf( ButtonLabels.CLICK_END ) != -1;
		}
		
		protected function out( evt:MouseEvent ):void
		{
			if( interactionEnabled ) 
			{
				fx( "out" );
				animateOverOut( );
				this.dispatchEvent( evt );
			}
		}
		
		public function animateClick( ):ISequence
		{
			if( hasClickLabels( ) )
			{
				var clickNumber:Number = this.getFrameNumberForLabel( ButtonLabels.CLICK );
				var clickEndNumber:Number = this.getFrameNumberForLabel( ButtonLabels.CLICK_END );
				
				transition.notifyStart( );
				
				this.timeline.gotoAndStop( clickNumber );
				this.timeline.onReach =  function( ):void
				{
					timeline.onReach = null;
					timeline.gotoAndStop( getFrameNumberForLabel( ButtonLabels.OVER ) );
					transition.notifyComplete( );
				}
				this.timeline.animateToFrame( clickEndNumber);
				
				return transition;
			}
			
			return transition.notifyComplete( ); 
		}
		
		public function animateOver( ):ISequence
		{
			if( this.hasOverLabels( ) )
			{
				var overNumber:int = this.getFrameNumberForLabel( ButtonLabels.OVER );
				var endNumber:int = this.getFrameNumberForLabel( ButtonLabels.OVER_END );
				var cf:int = timeline.currentframe;
				
				transition.notifyStart( );
				
				if( !( cf >= overNumber && cf < endNumber ) )
				{
					this.timeline.gotoAndStop( overNumber );
				}
				
				if( endNumber != -1 && endNumber > overNumber )
				{
					this.timeline.animateToFrame( endNumber, transition.notifyComplete )
				}
				else
				{
					this.timeline.animateToFrame( this.timeline.totalframes, transition.notifyComplete );
				}
				
				return transition;
			}
			
			return this.animateIn( true );
		}
		
		public function animateOverOut( ):ISequence
		{
			if( this.hasOverLabels( ) )
			{
				var overNumber:int = this.getFrameNumberForLabel( ButtonLabels.OVER );
				var overEndNumber:int = this.getFrameNumberForLabel( ButtonLabels.OVER_END );
				var overOutEndNumber:int = this.getFrameNumberForLabel( ButtonLabels.OVER_OUT_END );
				var cf:int = timeline.currentframe;
				
				transition.notifyStart( );
				
				if( overOutEndNumber == -1 )
				{
					overOutEndNumber = overNumber;
				}
				
				timeline.animateToFrame( overOutEndNumber, function( ):void
				{
					timeline.gotoAndStop( Math.max( getFrameNumberForLabel( TimelineInOutLabels.IN_END ), 1 ) );
					transition.notifyComplete( );
				}, this );
				
				return transition;
			}
			
			return this.animateOut( true );
		}
		
		public function set enabled( value:Boolean ):void
		{
			viewAsMovieClip.mouseEnabled = value;
			_enabled = value;
			
			view.alpha = value? 1: 0.5;
		}
		
		public function get enabled( ):Boolean
		{
			return _enabled;
		}
		
		public override function dispose():void
		{
			sounds = null;
			
			viewAsMovieClip.removeEventListener( MouseEvent.CLICK, onClick );
			viewAsMovieClip.removeEventListener( MouseEvent.ROLL_OVER, over );
			viewAsMovieClip.removeEventListener( MouseEvent.ROLL_OUT, out );
			
			super.dispose( );
		}
	}
}