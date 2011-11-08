package asf.debug
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	internal class ScrollBar extends Sprite
	{
		private var track:Sprite;
		private var tracker:Sprite;
		
		public function ScrollBar( p_height:uint )
		{
			track = new Sprite( );
			tracker = new Sprite( );
			
			track.graphics.beginFill( 0, 0.25 );
			track.graphics.drawRect( 0, 0, 7, p_height );
			track.graphics.endFill( );
			
			tracker.graphics.beginFill( 0, 0.5 );
			tracker.graphics.drawRect( 0, 0, 7, p_height );
			tracker.graphics.endFill( );
			
			addChild( track );
			addChild( tracker );
			
			tracker.addEventListener( MouseEvent.MOUSE_DOWN, startDragging );
		}
		
		private function startDragging( evt:MouseEvent ):void
		{
			tracker.addEventListener( MouseEvent.MOUSE_UP, stopDragging );
			tracker.addEventListener( MouseEvent.MOUSE_MOVE, update );
			
			tracker.stage.addEventListener( MouseEvent.MOUSE_UP, stopDragging );
			tracker.stage.addEventListener( MouseEvent.MOUSE_MOVE, update );
			
			tracker.startDrag( false, new Rectangle( 0, 0, 0, track.height - tracker.height ) );
		}
		
		private function stopDragging( evt:MouseEvent ):void
		{
			tracker.removeEventListener( MouseEvent.MOUSE_UP, stopDragging );
			tracker.removeEventListener( MouseEvent.MOUSE_MOVE, update );
			
			tracker.stage.removeEventListener( MouseEvent.MOUSE_UP, stopDragging );
			tracker.stage.removeEventListener( MouseEvent.MOUSE_MOVE, update );
			
			tracker.stopDrag( );
		}
		
		private function update( evt:MouseEvent ):void
		{
			this.dispatchEvent( new Event( Event.CHANGE ) );
		}
		
		public function getValue( ):Number
		{
			return tracker.y / ( track.height - tracker.height );
		}
		
		public function setValue( value:Number ):void
		{
			value = Math.max( 0, Math.min( 1, value ) );
			tracker.y = ( track.height - tracker.height ) * value;
			
			update( null );
		}
		
		public function setProportions( total:Number, partial:Number ):void
		{
			var v:Number = getValue( );
			var p:Number = Math.max( 0.2, partial / total );
			
			tracker.scaleY = p;
			
			tracker.y = ( track.height - tracker.height ) * v;
			
			visible = tracker.scaleY < 1;
			this.dispatchEvent( new Event( Event.CHANGE ) );
		}
	}
}