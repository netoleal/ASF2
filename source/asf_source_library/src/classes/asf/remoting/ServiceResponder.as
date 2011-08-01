package asf.remoting
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.Responder;
	
	import asf.events.ServiceResponderEvent;

	[Event( type="asf.events.ServiceResponderEvent", name="result" )]
	[Event( type="asf.events.ServiceResponderEvent", name="status" )]

	public class ServiceResponder extends Responder implements IEventDispatcher
	{
		private var d:EventDispatcher;
		
		private var _data:*;
		private var _fault:*;
		
		private var gtw:Gateway;
		
		public function ServiceResponder( p_gateway:Gateway )
		{
			super( onResult, onStatus );
			
			gtw = p_gateway;
			
			d = new EventDispatcher( this );
		}
		
		public function dispose( ):void
		{
			gtw = null;
			d = null;
		}
		
		public function get gateway( ):Gateway
		{
			return gtw;
		}
		
		private function onResult( result:* ):void
		{
			_data = result; 
			
			this.dispatchEvent( new ServiceResponderEvent( ServiceResponderEvent.RESULT ) );
		}
		
		private function onStatus( fault:* = null ):void
		{
			_fault = fault;
			
			this.dispatchEvent( new ServiceResponderEvent( ServiceResponderEvent.STATUS ) );
		}
		
		public function get resultData( ):*
		{
			return _data;
		}
		
		public function get faultData( ):*
		{
			return _fault;
		}
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			d.addEventListener( type, listener, useCapture, priority, useWeakReference );
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			d.removeEventListener( type, listener, useCapture );
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			return d.dispatchEvent( event );
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return d.hasEventListener( type );
		}
		
		public function willTrigger(type:String):Boolean
		{
			return d.willTrigger( type );
		}
		
	}
}