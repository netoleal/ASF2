package asf.events
{
	import flash.events.Event;
	
	public class ServiceResponderEvent extends Event
	{
		public static const RESULT:String = "result";
		public static const STATUS:String = "status";
		
		public function ServiceResponderEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}