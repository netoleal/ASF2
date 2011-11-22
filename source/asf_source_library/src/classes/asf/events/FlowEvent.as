package asf.events
{
	import flash.events.Event;
	
	public class FlowEvent extends Event
	{
		public static const SHOW_LOADING:String = "showLoading";
		public static const HIDE_LOADING:String = "hideLoading";
		
		public function FlowEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}