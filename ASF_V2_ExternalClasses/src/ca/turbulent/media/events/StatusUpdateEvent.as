package ca.turbulent.media.events
{
	import flash.events.Event;

	public class StatusUpdateEvent extends Event
	{	
		public static const STATUS_UPDATE						:String = "statusUpdateEvent";
		public var status										:String; 
		
		public function StatusUpdateEvent(type:String, _status:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			status = _status;
		}
		
		override public function clone():Event { return new StatusUpdateEvent(this.type, status, false, false); }
		
	}
}