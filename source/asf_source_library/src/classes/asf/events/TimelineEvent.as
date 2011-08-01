/**
 * Class com.ford.focus.drive.events.TimelineEvent
 *
 * @author: Neto Leal
 * @created: Dec 3, 2010 12:15:51 PM
 *
 **/
package asf.events
{
	import flash.events.Event;
	
	public class TimelineEvent extends Event
	{
		public static const ENTER_FRAME:String = "enterFrame";
		public static const FIRST_FRAME:String = "firstFrame";
		public static const LAST_FRAME:String = "lastFrame";
		
		public function TimelineEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}