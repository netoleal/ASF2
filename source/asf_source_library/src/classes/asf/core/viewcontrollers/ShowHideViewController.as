/*
 * Class asf.core.viewcontrollers.ShowHide
 *
 * @author: Neto Leal
 * @date: May 18, 2010 4:10:44 PM
 */
package asf.core.viewcontrollers
{
	
	import asf.core.util.Sequence;
	import asf.interfaces.ISequence;
	import asf.utils.Delay;
	
	import flash.display.DisplayObject;
	import flash.events.Event;

	public class ShowHideViewController extends AbstractViewController
	{
		private var _visible:Boolean;
		
		protected var transition:Sequence;
		
		public function ShowHideViewController( p_view:DisplayObject, p_visible:Boolean = true )
		{
			super( p_view );
			
			_visible = p_visible;
			view.alpha = p_visible ? 1 : 0;
			view.visible = p_visible;
			
			transition = new Sequence( );
		}
		
		public function getView( ):DisplayObject
		{
			return view;
		}

		public function get visible():Boolean
		{
			return _visible;
		}
		
		public function show( delay:uint = 0 ):ISequence
		{
			return Delay.execute( null, delay ).queue( setVisible, true );
		}
		
		public function hide( delay:uint = 0 ):ISequence
		{
			return Delay.execute( null, delay ).queue( setVisible, false );
		}

		public function set visible(value:Boolean ):void
		{
			setVisible( value );
		}
		
		public function setVisible( value:Boolean ):ISequence
		{
			notifyStart( );
			
			if( value )
			{
				if( visible )
				{
					notifyComplete( );
					return transition;
				}
				
				view.visible = true;
				stopEnterFrame( );
				view.addEventListener( Event.ENTER_FRAME, enterFrameIn );
			}
			else
			{
				if( !visible )
				{
					notifyComplete( );
					return transition;
				}
				
				stopEnterFrame( );
				view.addEventListener( Event.ENTER_FRAME, enterFrameOut );
			}
			
			_visible = value;
			return transition;
		}
		
		private function enterFrameIn( evt:Event ):void
		{
			view.alpha += 0.1;
			view.alpha = Math.min( 1, view.alpha );
			
			if( view.alpha == 1 )
			{
				stopEnterFrame( );
				
				notifyComplete( );
			}
		}
		
		private function stopEnterFrame( ):void
		{
			view.removeEventListener( Event.ENTER_FRAME, enterFrameIn );
			view.removeEventListener( Event.ENTER_FRAME, enterFrameOut );
		}
		
		private function enterFrameOut( evt:Event ):void
		{
			view.alpha -= 0.1;
			view.alpha = Math.max( 0, view.alpha );
			
			if( view.alpha == 0 )
			{
				view.visible = false;
				stopEnterFrame( );
				
				notifyComplete( );
			}
		}
		
		protected function notifyStart( ):void
		{
			transition.notifyStart( );
		}
		
		protected function notifyComplete( ):void
		{
			transition.notifyComplete( );
		}
		
		public override function dispose( ):void
		{
			transition = null;
			stopEnterFrame( );
			super.dispose( );
		}
	}
}