/*
 * Class asf.controllers.EnterFrameDispatcher
 *
 * @author: Neto Leal
 * @created: Mar 18, 2011 10:47:03 AM
 *
 **/
package asf.utils
{
	import flash.events.Event;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;

	public class EnterFrameDispatcher
	{
		private static var itv:Number = -1;
		private static var fr:uint = 31;
		private static var running:Boolean = false;
		
		private static var listeners:Object;
		
		public static function setFrameRate( value:uint ):void
		{
			fr = value;
		}
		
		private static function start( ):void
		{
			if( running ) return;
			
			running = true;
			stop( );
			
			itv = setInterval( enterFrame, 1000 / fr );
		}
		
		private static function stop( ):void
		{
			if( !running ) return;
			
			running = false;
			
			if( itv != -1 ) clearInterval( itv );
			itv = -1;
		}
		
		private static function enterFrame( ):void
		{
			dispatchEvent( new Event( Event.ENTER_FRAME ) );
		}
		
		public static function addEventListener( event:String, closure:Function ):void
		{
			if( !listeners ) listeners = new Object( );
			if( !listeners[ event ] ) listeners[ event ] = new Array( );
			
			if( listeners[ event ].indexOf( closure ) == -1 ) listeners[ event ].push( closure );
			
			if( listeners[ Event.ENTER_FRAME ] && listeners[ Event.ENTER_FRAME ].length > 0 )
			{
				start( );
			}
		}
		
		public static function removeEventListener( event:String, closure:Function ):void
		{
			if( listeners && listeners[ event ] )
			{
				var i:int = listeners[ event ].indexOf( closure );
				if( i != -1 ) listeners[ event ].splice( i, 1 );
				
				if( listeners[ event ].length == 0 )
				{
					listeners[ event ] = null;
					delete listeners[ event ];
				}
				
				if( !listeners[ Event.ENTER_FRAME ] )
				{
					stop( );
				}
			}
		}
		
		public static function dispatchEvent( event:Event ):void
		{
			if( listeners && listeners[ event.type ] )
			{
				( listeners[ event.type ] as Array ).forEach( function( closure:Function, index:uint, ar:Array ):void
				{
					if( closure != null ) closure.apply( null, [ event.clone( ) ] );
					else listeners[ event.type ].splice( index, 1 );
				} );
			}
		}
	}
}